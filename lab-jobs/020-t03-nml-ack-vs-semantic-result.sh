#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-t03-nml"

printf '== T03-020 NML acknowledgement versus semantic result ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Frozen negative prediction: AUTO_STEP while independently confirmed ESTOP is assigned/echoed a serial but has matching aggregate ERROR and independent operator-error evidence.'
printf '%s\n' 'Boundary: command echo is transport/order evidence, not semantic, physical, or safety success.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
ACTUAL_COMMIT="$(git rev-parse HEAD)"
printf 'checked-out-commit=%s\n' "$ACTUAL_COMMIT"
[[ "$ACTUAL_COMMIT" == "$LINUXCNC_COMMIT" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 20; }
./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)"
cd ..
set +u
source scripts/rip-environment
set -u
LINUXCNC_BIN="$(command -v linuxcnc)"
PYMOD_PATH="$(python3 - <<'PY'
import linuxcnc
print(linuxcnc.__file__)
PY
)"
printf 'linuxcnc-bin=%s\nlinuxcnc-python-module=%s\n' "$LINUXCNC_BIN" "$PYMOD_PATH"
case "$(readlink -f "$LINUXCNC_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: linuxcnc executable not from pinned tree' >&2; exit 21;; esac
case "$(readlink -f "$PYMOD_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: python module not from pinned tree' >&2; exit 22;; esac
printf 'gate-A=PASS\n'

cd tests/linuxcncrsh
INI=linuxcncrsh-test.ini
TRACE="$PWD/t03-020-trace.csv"
rm -f /tmp/linuxcnc.lock t03-linuxcnc.stdout t03-linuxcnc.stderr "$TRACE"
linuxcnc -r "$INI" >t03-linuxcnc.stdout 2>t03-linuxcnc.stderr &
LCNC_PID=$!
rsh_shutdown() {
  { printf '%s\n' 'set timestamp off' 'hello EMC t03shutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep 0.2; } | timeout 8s nc localhost 5007 >/tmp/t03-shutdown.txt 2>/tmp/t03-shutdown.err || true
}
cleanup() {
  if kill -0 "$LCNC_PID" 2>/dev/null; then rsh_shutdown; sleep 0.5; kill -TERM "$LCNC_PID" 2>/dev/null || true; fi
  wait "$LCNC_PID" 2>/dev/null || true
}
trap cleanup EXIT
READY=0
for i in $(seq 1 160); do
  if nc -z localhost 5007 >/dev/null 2>&1 && timeout 3s halcmd getp joint.0.homed >/dev/null 2>&1; then READY=1; printf 'runtime-ready-probe=%s\n' "$i"; break; fi
  sleep 0.25
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: LinuxCNC fixture did not become ready' >&2; cat t03-linuxcnc.stderr >&2 || true; exit 23; }

TRACE="$TRACE" python3 - <<'PY'
import csv, os, sys, time
import linuxcnc
trace_path=os.environ['TRACE']
for n in ['STATE_ESTOP','STATE_ESTOP_RESET','AUTO_STEP','RCS_DONE','RCS_ERROR']:
    if not hasattr(linuxcnc,n):
        print('HARNESS_INVALID: missing constant '+n, file=sys.stderr); sys.exit(24)
    print(f'constant-{n}={getattr(linuxcnc,n)}')

c=linuxcnc.command(); s=linuxcnc.stat(); e=linuxcnc.error_channel()
rows=[]; errors=[]
fields=['t','case','phase','client_serial','echo_serial','status','task_state','task_mode','exec_state','interp_state','wait_return','error_type','error_text']
t0=time.monotonic()

def drain_errors(label):
    out=[]
    while True:
        x=e.poll()
        if not x: break
        out.append(x); print(f'{label}-drained-error={x}')
    return out

def snap(case,phase,wait_return='',err=None):
    s.poll(); now=time.monotonic()-t0
    row={'t':f'{now:.6f}','case':case,'phase':phase,'client_serial':int(c.serial),'echo_serial':int(s.echo_serial_number),'status':int(s.state),'task_state':int(s.task_state),'task_mode':int(s.task_mode),'exec_state':int(s.exec_state),'interp_state':int(s.interp_state),'wait_return':wait_return,'error_type':'','error_text':''}
    if err:
        row['error_type']=str(err[0]); row['error_text']=str(err[1]).replace('\n',' ')
    rows.append(row); return row

def wait_task_state(target,label,timeout=5.0):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        r=snap(label,'state-wait')
        if int(r['task_state'])==int(target): return True
        x=e.poll()
        if x: errors.append((label,time.monotonic()-t0,x)); snap(label,'error-during-state-wait',err=x)
        time.sleep(0.01)
    return False

def finish_trace():
    with open(trace_path,'w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=fields); w.writeheader(); w.writerows(rows)

def fail(msg,code):
    finish_trace(); print(msg,file=sys.stderr); sys.exit(code)

# Establish frozen baseline: ESTOP.
drain_errors('baseline')
snap('baseline','initial')
if int(s.task_state)!=int(linuxcnc.STATE_ESTOP):
    c.state(linuxcnc.STATE_ESTOP)
    rc=c.wait_complete(5.0); snap('baseline','force-estop-complete',rc)
    if not wait_task_state(linuxcnc.STATE_ESTOP,'baseline',3.0): fail('HARNESS_INVALID: could not establish initial ESTOP',25)
drain_errors('post-baseline')
snap('case1','pre-send')
base_serial=int(c.serial); base_echo=int(s.echo_serial_number)
if int(s.task_state)!=int(linuxcnc.STATE_ESTOP): fail('HARNESS_INVALID: Case1 did not begin in ESTOP',26)

# Case 1 healthy ESTOP_RESET.
c.state(linuxcnc.STATE_ESTOP_RESET)
case1_serial=int(c.serial); r=snap('case1','send-return')
print(f'case1-base-serial={base_serial} case1-serial={case1_serial} case1-echo-after-send={r["echo_serial"]}')
if case1_serial==base_serial: fail('HARNESS_INVALID: Case1 did not obtain a new serial',27)
if int(r['echo_serial']) < case1_serial: fail('HARNESS_INVALID: Case1 send returned before echo reached serial',28)
rc1=c.wait_complete(5.0); snap('case1','wait-complete',rc1)
print(f'case1-wait-complete={rc1}')
if int(rc1)!=int(linuxcnc.RCS_DONE): fail('PREDICTION_FALSIFIED: Case1 wait_complete was not RCS_DONE',40)
if not wait_task_state(linuxcnc.STATE_ESTOP_RESET,'case1',3.0): fail('PREDICTION_FALSIFIED: ESTOP_RESET state not independently observed',41)
case1_errors=drain_errors('case1-post')
for x in case1_errors: errors.append(('case1',time.monotonic()-t0,x)); snap('case1','post-error',err=x)
if case1_errors: fail('PREDICTION_FALSIFIED: valid Case1 produced operator error',42)
print('gate-B=PASS'); print('gate-C=PASS')

# Restore ESTOP and preserve completion before negative command.
c.state(linuxcnc.STATE_ESTOP); rc_restore=c.wait_complete(5.0); snap('restore','wait-complete',rc_restore)
if not wait_task_state(linuxcnc.STATE_ESTOP,'restore',3.0): fail('HARNESS_INVALID: could not independently restore ESTOP',29)
drain_errors('case2-baseline')
snap('case2','pre-send')
if int(s.task_state)!=int(linuxcnc.STATE_ESTOP): fail('HARNESS_INVALID: Case2 did not begin in ESTOP',30)
pre2_serial=int(c.serial)

# Case 2: no later command is allowed until matching ERROR + error text are preserved.
c.auto(linuxcnc.AUTO_STEP)
case2_serial=int(c.serial); r2=snap('case2','send-return')
print(f'case2-pre-serial={pre2_serial} case2-serial={case2_serial} case2-echo-after-send={r2["echo_serial"]}')
if case2_serial==pre2_serial: fail('HARNESS_INVALID: Case2 did not obtain a new serial',31)
if int(r2['echo_serial']) < case2_serial: fail('HARNESS_INVALID: Case2 serial was not echoed by send return',32)
print('gate-D=PASS')

# Capture matching semantic status before any later command.
rc2=c.wait_complete(5.0); rwait=snap('case2','wait-complete',rc2)
print(f'case2-wait-complete={rc2} matching-status={rwait["status"]} matching-echo={rwait["echo_serial"]}')
semantic_error=(int(rc2)==int(linuxcnc.RCS_ERROR) and int(rwait['echo_serial'])==case2_serial and int(rwait['status'])==int(linuxcnc.RCS_ERROR))
if not semantic_error: fail('PREDICTION_FALSIFIED: Case2 lacked matching RCS_ERROR evidence before later command',43)
print('gate-E=PASS')

# Independently consume bounded operator-error stream, still without issuing a command.
neg_errors=[]; deadline=time.monotonic()+2.0
while time.monotonic()<deadline:
    x=e.poll()
    if x:
        neg_errors.append(x); errors.append(('case2',time.monotonic()-t0,x)); snap('case2','error-channel',err=x); print(f'case2-error={x}')
    else:
        snap('case2','error-poll-empty'); time.sleep(0.01)
texts=' '.join(str(x[1]) for x in neg_errors).lower()
semantic_text=(('e-stop' in texts or 'estop' in texts) and ('turned on' in texts or 'turn' in texts or 'machine' in texts))
if not neg_errors or not semantic_text: fail('PREDICTION_FALSIFIED: independent operator error with ESTOP/machine-state cause not observed',44)
print('gate-F=PASS')

# Confirm no false success and only now issue benign recovery command.
snap('case2','pre-recovery')
if int(s.task_state)!=int(linuxcnc.STATE_ESTOP): fail('PREDICTION_FALSIFIED: negative case unexpectedly left ESTOP',45)
print('case2-echoed=true'); print('case2-semantic_success=false')
c.state(linuxcnc.STATE_ESTOP_RESET); rc3=c.wait_complete(5.0); snap('recovery','wait-complete',rc3)
if int(rc3)!=int(linuxcnc.RCS_DONE) or not wait_task_state(linuxcnc.STATE_ESTOP_RESET,'recovery',3.0): fail('PREDICTION_FALSIFIED: bounded recovery command failed',46)
print('gate-G=PASS')
finish_trace()
print(f'trace-rows={len(rows)} error-events={len(errors)}')
print('T03-020 overall=PASS')
PY

printf '%s\n' '=== BEGIN T03-020 FULL RAW TRACE CSV ==='
cat "$TRACE"
printf '%s\n' '=== END T03-020 FULL RAW TRACE CSV ==='
printf '\nT03-020 shell-harness=PASS\n'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
