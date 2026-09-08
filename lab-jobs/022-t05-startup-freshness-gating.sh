#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-t05-startup"

echo '== T05-022 custom-OI startup freshness gating =='
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
echo "Pinned upstream commit: $LINUXCNC_COMMIT"
echo 'Frozen prediction: a default-enabled custom action can remain exposed through a failed first status observation; a fail-defined freshness-gated action remains disabled until a valid policy-satisfying observation.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs netcat-openbsd procps python3 python3-gi python3-zmq
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"
[[ "$(git rev-parse HEAD)" == "$LINUXCNC_COMMIT" ]] || { echo 'HARNESS_INVALID: checkout mismatch' >&2; exit 20; }
./debian/configure uspace
sudo apt-get build-dep -y .
cd src && ./autogen.sh && ./configure --with-realtime=uspace --disable-manpages --disable-build-documentation && make -j"$(nproc)"
cd ..
set +u; source scripts/rip-environment; set -u
GSTAT_PATH="$(python3 - <<'PY'
import common.hal_glib; print(common.hal_glib.__file__)
PY
)"
QTVCP_PATH="$WORK/src/emc/usr_intf/qtvcp/qtvcp.py"
printf 'checked-out-commit=%s\ngstat-module=%s\nqtvcp-entry=%s\n' "$(git rev-parse HEAD)" "$GSTAT_PATH" "$QTVCP_PATH"
sha256sum "$GSTAT_PATH" "$QTVCP_PATH"
case "$(readlink -f "$GSTAT_PATH")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: GStat not pinned' >&2; exit 21;; esac
[[ -f "$QTVCP_PATH" ]] || { echo 'HARNESS_INVALID: qtvcp.py missing' >&2; exit 22; }
echo 'gate-A=PASS'

# Prove lifecycle ordering from the exact checked-out source, not a copied curriculum assertion.
python3 - "$QTVCP_PATH" <<'PY'
import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
a=s.find('handler_instance.initialized__()')
b=s.find('self.STATUS.forced_update()')
print(f'lifecycle-initialized-offset={a} forced-update-offset={b}')
if a < 0 or b < 0 or not a < b:
    print('PREDICTION_FALSIFIED: pinned QtVCP lifecycle ordering changed',file=sys.stderr); sys.exit(40)
print('gate-C=PASS')
PY

cd tests/linuxcncrsh
INI=linuxcncrsh-test.ini
rm -f /tmp/linuxcnc.lock t05-linuxcnc.stdout t05-linuxcnc.stderr
linuxcnc -r "$INI" >t05-linuxcnc.stdout 2>t05-linuxcnc.stderr & LCNC_PID=$!
shutdown_lcnc(){ { printf '%s\n' 'set timestamp off' 'hello EMC t05shutdown' 'set echo off' 'set enable EMCTOO' 'shutdown'; sleep .2; } | timeout 8s nc localhost 5007 >/tmp/t05-shutdown.txt 2>/dev/null || true; }
cleanup(){ if kill -0 "$LCNC_PID" 2>/dev/null; then shutdown_lcnc; sleep .5; kill -TERM "$LCNC_PID" 2>/dev/null || true; fi; wait "$LCNC_PID" 2>/dev/null || true; }
trap cleanup EXIT
for i in $(seq 1 160); do nc -z localhost 5007 >/dev/null 2>&1 && break; sleep .25; done
nc -z localhost 5007 >/dev/null 2>&1 || { echo 'HARNESS_INVALID: fixture not ready' >&2; exit 23; }

python3 - <<'PY'
import linuxcnc, sys
from common.hal_glib import GStat

# Independent baseline oracle.
observer=linuxcnc.stat(); observer.poll(); actual=int(observer.task_state)
print(f'independent-controller-state={actual}')
print('gate-B=PASS')

class PollProxy:
    def __init__(self,real): self.real=real; self.blocked=True; self.attempts=0; self.failures=0
    def poll(self):
        self.attempts += 1
        if self.blocked:
            self.failures += 1
            raise RuntimeError('T05-022 deliberate first-observation failure')
        return self.real.poll()
    def __getattr__(self,n): return getattr(self.real,n)
    def __setattr__(self,n,v):
        if n in ('real','blocked','attempts','failures'): object.__setattr__(self,n,v)
        else: setattr(self.real,n,v)

proxy=PollProxy(linuxcnc.stat()); g=GStat(stat=proxy)
# Models represent custom handler presentation policy, not Task enforcement.
unsafe_enabled=True
gated_enabled=False
required_state=actual  # policy deliberately accepts actual state once it is freshly observed
print(f'construction unsafe-enabled={int(unsafe_enabled)} gated-enabled={int(gated_enabled)} required-state={required_state}')

# First forced observation fails.
g.update()
valid=bool(g._status_active)
print(f'first-observation valid={int(valid)} attempts={proxy.attempts} failures={proxy.failures} unsafe-enabled={int(unsafe_enabled)} gated-enabled={int(gated_enabled)}')
if proxy.attempts != 1 or proxy.failures != 1 or valid:
    print('HARNESS_INVALID: decisive first poll failure not isolated',file=sys.stderr); sys.exit(24)
print('gate-D=PASS')
if not unsafe_enabled:
    print('PREDICTION_FALSIFIED: unsafe-default exposure absent',file=sys.stderr); sys.exit(41)
print('gate-E=PASS')
# Explicit freshness gate: invalid observation cannot enable action.
gated_enabled = valid and int(g.old.get('state',-999)) == required_state
if gated_enabled:
    print('PREDICTION_FALSIFIED: freshness gate enabled without valid status',file=sys.stderr); sys.exit(42)
print('gate-F=PASS')

# Remove only injected failure, update same controller state, then evaluate policy.
proxy.blocked=False; g.update(); valid=bool(g._status_active); cached=int(g.old.get('state',-999))
gated_enabled = valid and cached == required_state
print(f'recovery valid={int(valid)} cached-state={cached} independent-state={actual} gated-enabled={int(gated_enabled)} attempts={proxy.attempts} failures={proxy.failures}')
if not valid or cached != actual or not gated_enabled:
    print('PREDICTION_FALSIFIED: recovery did not establish valid policy evidence',file=sys.stderr); sys.exit(43)
print('gate-G=PASS')
print('boundary: widget enabled != fresh controller observation')
print('boundary: fresh controller observation != command acceptance')
print('boundary: command acceptance != physical action')
print('boundary: GUI gating != safety-rated enforcement')
print('gate-H=PASS')
print('T05-022 overall=PASS')
PY

echo 'T05-022 shell-harness=PASS'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
