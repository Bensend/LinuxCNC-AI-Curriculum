# 3800 — Pick-and-place feeder: supervisory versus realtime authority

Date: 2026-09-14
Status: COMMUNITY-REPORTED + CONFIG INSPECTION

## Why inspect this implementation

The 3800 track is broader than saws. A pick-and-place feeder is a useful comparison because it repeats a discrete material-advance operation many times while geometric motion, feeder selection and actuator sequencing are owned by different layers.

Primary source:

- LinuxCNC forum: **Using M2## For Part Pickup and Feeder Advance**, 2022-08-02 through 2022-08-14.
- Attached artifacts inspected directly: `M161.txt`, `feeder_advancer_V2.2.txt`, and `simple_pnp.hal`.

## 1. Field architecture

The operator/program calls a remapped M201 with a P feeder number. The described supervisory sequence is:

1. switch to machine coordinates;
2. travel to the selected feeder location;
3. lower Z to pickup height;
4. energize vacuum and dwell;
5. retract with the part;
6. invoke M161 P# to advance that feeder;
7. return to normal placement flow.

The uploaded HAL uses Mesa hardware and places `classicladder.0.refresh` in the servo thread between motion/PID calculations and the HostMot2 write.

The feeder-advance implementation itself is intentionally split:

`M201 / program intent`
→ `M161 P feeder selection`
→ userspace `halcmd setp classicladder.0.in-N true/false`
→ ClassicLadder logic
→ feeder output logic.

Thus M-code/program selection is supervisory request authority; ClassicLadder is the realtime-ish feeder logic layer.

## 2. M161 is an event injection, not a completion handshake

The uploaded `M161.txt` shell script selects one of 48 feeders. For each feeder it:

- sets two rack-select bits as appropriate;
- sets one ClassicLadder input pin TRUE;
- immediately sets that input FALSE;
- exits with status 0.

The script contains no `M66`, no wait for ClassicLadder output, no feeder-position witness and no explicit acknowledgement returned from the feeder mechanism.

Therefore `M161 completed` means only that the userspace request pulse was issued successfully. It does **not** prove:

- feeder motion completed;
- the next part is actually at pickup position;
- tape/reel advance did not jam;
- the correct rack physically shifted;
- a sensor became valid;
- ClassicLadder consumed a fresh request rather than missing the pulse.

This is a field implementation pattern, not a recommendation that production automation omit acknowledgement.

## 3. Pulse-width / scan-boundary consequence

Pinned LinuxCNC ClassicLadder source from the companion 3800 source trace shows that physical ClassicLadder inputs are sampled only during a ladder scan, at no faster than 1 ms.

`M161.txt` performs two separate userspace `halcmd setp` processes/commands, first TRUE and then FALSE. In practice that likely creates a pulse long enough to be observed on the original system, but the script itself establishes no minimum hold time and obtains no acknowledgement that the realtime scan sampled TRUE.

For a reusable 3800 design this should be upgraded from an implicit pulse into one of:

- request/acknowledge handshake;
- toggling generation bit/counter with consumed-generation feedback;
- latch-until-consumed semantics;
- another explicit event transport whose loss behavior is bounded.

The key rule is **userspace command completion != realtime event consumption**.

## 4. Reset path is command-state cleanup only

`M161 P0` explicitly writes every feeder request input low and clears the rack-select bits. That is useful logical cleanup, but there is no physical reconciliation in the script. It does not establish whether a feeder is mid-stroke, tape is advanced, a part is present, or a rack actuator is physically home.

This mirrors the automatic-saw lesson: a software reset must not be confused with a reconciled material-handling state.

## 5. Transfer to saws/feeders/indexers

The PnP implementation gives a clean three-layer model that generalizes well:

### Supervisory/program layer

Owns:

- job/cut/placement list;
- requested station/feeder/part;
- geometric moves between stations;
- high-level cycle progression.

### Realtime sequence layer

Owns:

- valve/solenoid/motor sequencing;
- request latching;
- timers;
- sensor qualification;
- actuator interlocks;
- acknowledgement/fault generation.

### Physical evidence layer

Owns observable truth such as:

- feeder indexed;
- clamp closed/open;
- stock/part present;
- actuator home/end;
- pressure/tension/ready;
- jam/fault.

A production implementation can collapse layers where justified, but should not collapse their **semantics**. An M-code request is not itself a physical witness.

## 6. Comparison with Marvel saw chronology

The two machines expose complementary failure modes:

- **Marvel saw:** physical hydraulic motion can continue after encoder target is reached due to leakage/creep.
- **PnP feeder:** a userspace request pulse can complete without any demonstrated physical completion acknowledgement.

Together they establish that 3800 requires both sides of a transaction:

`fresh request -> actuator sequence -> physical completion/stability -> fresh acknowledgement`

A position value alone or a completed command alone is insufficient.

## 7. Adversarial review

1. Does M161 exit 0 prove the feeder advanced? **No.**
2. Does toggling a ClassicLadder input TRUE then FALSE prove the realtime scan observed TRUE? **Not from this script alone.**
3. Does P0 physically home every feeder? **No; it clears software request/select state.**
4. Does placing ClassicLadder in the servo thread make M161 synchronous with the G-code caller? **No.** The userspace shell command and realtime scan remain distinct execution contexts.
5. Is the forum implementation evidence that all feeder mechanisms need feedback? **No.** It demonstrates an open-loop pattern; a production risk decision depends on the mechanism/consequence.
6. Can the same three-layer model apply to a saw clamp/feed cycle? **Yes as architecture, but exact states/witnesses remain machine-specific.**
7. Is LinuxCNC HAL/ClassicLadder thereby safety-rated? **No.**

Result: **7/7 boundaries preserved.**

## 8. Next work

The highest-value 3800 evidence gap is now a field implementation with **explicit completion feedback and partial-cycle recovery**, not another open-loop request example. Search priorities:

- automatic saw/cutoff line with clamp proof and feeder stable/complete;
- transfer/index station with request/ack/fault generation;
- bar feeder with stock-end detection and recovery;
- miter/indexer with lock proof;
- blade/tension/break witness integrated into cut authorization.

If public field evidence remains thin, freeze a 3800 first-pass playbook from these bounded patterns and rotate to 3900 or 3100 rather than inventing machinery behavior.
