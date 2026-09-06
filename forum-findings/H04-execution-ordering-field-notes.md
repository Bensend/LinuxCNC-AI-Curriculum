# H04 community findings — execution ordering

Module: H04 HAL execution ordering  
Course level: 1000  
Primary implementation revision for reconciliation: `8bf4605ae81042248add031e94c77300406e0413`

Community material is used as an investigation lead and debugging-practice source, not as automatic implementation truth.

## 1. Execution order is `addf` order, not `loadrt` order

LinuxCNC forum thread **Component Execution Order** (2017):

https://forum.linuxcnc.org/24-hal-components/32491-component-execution-order

Experienced contributors, including Andy Pugh, explain that realtime component functions execute in `addf` order and point out that the optional numeric position can make ordering explicit across multiple HAL files.

**Reconciliation:** SOURCE-CONFIRMED at the pinned revision. `hal_add_funct_to_thread()` constructs an ordered `thread->funct_list`, and `thread_task()` traverses that list in next-link order. `loadrt` order only determines when functions become available; it is not the periodic execution ordering structure.

## 2. Field failures can be data-age/order failures

Forum thread **Rookie: Ethercat Servos wont budge...** (2021):

https://forum.linuxcnc.org/49-basic-configuration/41831-rookie-ethercat-servos-wont-budge

A field recommendation was to place the EtherCAT read function before motion command/controller functions so motion consumes data read in the same servo cycle. The discussion explicitly distinguishes the ordered realtime function loop from HAL `net` statements, which establish connectivity rather than execution.

**Reconciliation:** the general ordering mechanism is SOURCE-CONFIRMED. The particular EtherCAT configuration is not adopted here as a universal prescription; later EtherCAT/HostMot2 modules must trace their own exact read/compute/write requirements.

## 3. Keep ordering declarations auditable

Forum thread **Debounce** (2017):

https://forum.linuxcnc.org/24-hal-components/32319-debounce

An experienced user recommends keeping `loadrt` and `addf` declarations together because execution order becomes easier to audit and maintain.

**Curriculum implication:** this is configuration/debugging practice rather than an implementation guarantee. H04 should teach that explicit positions are valuable when order has semantic meaning and that scattered `addf` declarations can obscure the actual list order.

## 4. Debugging realtime functions by controlled invocation

Forum thread **How to debug a real-time component?** (2019):

https://www.forum.linuxcnc.org/10-advanced-configuration/36786-how-to-debug-a-real-time-component

PCW describes realtime component functions as periodically called according to the HAL thread to which `addf` binds them, and suggests instrumenting component state for observation/single-step-like debugging.

**Curriculum implication:** observable pins/counters are preferable to assuming scheduling from configuration text alone. The H04 lab uses both `show thread`, `threadbeat`, and order-sensitive dataflow so the test does not rely on one observation channel.

## 5. Non-reentrant duplicate-add error occurs in the field

A latency-histogram forum report includes the diagnostic:

`HAL: ERROR: function 'base' may only be added to one thread`

https://www.forum.linuxcnc.org/18-computer/39371-results-of-latency-test-list-of-computers-tested-for-use-with-linuxcnc?start=310

**Reconciliation:** SOURCE-CONFIRMED mechanism. `hal_add_funct_to_thread()` checks `funct->users > 0 && funct->reentrant == 0` and rejects another scheduling entry. The H04 lab deliberately exercises this failure path.

## Community-derived misconceptions to test adversarially

- "Functions execute in the order their components were loaded." — false; execution order is the thread function list built by `addf`.
- "The order of `net` statements determines runtime dataflow order." — false; nets define signal connectivity, while realtime functions read/write pins when their thread calls them.
- "If A is before B in one thread, A is therefore before C in every other thread." — unsupported/false premise; list order is local to one thread.
- "`stop` destroys or suspends the RTAPI task itself." — source trace does not support this at the pinned revision; it gates function dispatch.

## Open field questions promoted beyond H04 1000 level

- Whether live `addf`/`delf` mutation while threads are running is officially supported and race-free across all supported realtime backends.
- How ordering mistakes manifest for specific hardware-driver cycles (HostMot2, hm2_eth, EtherCAT) under packet delay or overruns.
- Cross-thread memory visibility/timing when a signal producer and consumer execute on different HAL threads.
