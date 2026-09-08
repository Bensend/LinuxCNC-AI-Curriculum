# Latest LinuxCNC Lab Result

- Job: `031-c06-watchdog-layout-preflight`
- Job file: `lab-jobs/031-c06-watchdog-layout-preflight.sh`
- Workflow run ID: `34284571175`
- Attempt: `1`
- Source commit: `e50c45212ae88a8270b903b82628f91469ac14ae`
- Exit code: `0`
- Finished UTC: `2026-09-08T22:12:03Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-08T22:11:13Z
Repository commit: e50c45212ae88a8270b903b82628f91469ac14ae
Workflow run: 34284571175 attempt 1
Job file: lab-jobs/031-c06-watchdog-layout-preflight.sh
Runner: Linux runnervmejwal 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-08T22:12:03Z
```

## Standard output
```text
C06 watchdog fixture layout preflight
Pinned checkout: 8bf4605ae81042248add031e94c77300406e0413
--- PATTERN 11 ---
        case 11: {
            set32(me, HM2_ADDR_IOCOOKIE, HM2_IOCOOKIE);
            set8(me, HM2_ADDR_CONFIGNAME+0, 'H');
            set8(me, HM2_ADDR_CONFIGNAME+1, 'O');
            set8(me, HM2_ADDR_CONFIGNAME+2, 'S');
            set8(me, HM2_ADDR_CONFIGNAME+3, 'T');
            set8(me, HM2_ADDR_CONFIGNAME+4, 'M');
            set8(me, HM2_ADDR_CONFIGNAME+5, 'O');
            set8(me, HM2_ADDR_CONFIGNAME+6, 'T');
            set8(me, HM2_ADDR_CONFIGNAME+7, '2');
            set32(me, HM2_ADDR_IDROM_OFFSET, 0x400); // put the IDROM at 0x400, where it usually lives
            set32(me, 0x400, 2); // standard idrom type

            // normal offset to Module Descriptors
            set32(me, 0x404, 64);

            // unusual offset to PinDescriptors
            set32(me, 0x408, 0x1C0);

            // IOPorts
            set32(me, 0x41c, 6);

            // IOWidth
            set32(me, 0x420, 6*24);

            // PortWidth
            set32(me, 0x424, 24);

            // ClockLow = 2e6
            set32(me, 0x428, 2e6);

            // ClockHigh = 2e7
            set32(me, 0x42c, 2e7);

            me->llio.num_ioport_connectors = 6;
            me->llio.ioport_connector_name[0] = "P4";
            me->llio.ioport_connector_name[1] = "P5";
            me->llio.ioport_connector_name[2] = "P6";
            me->llio.ioport_connector_name[3] = "P9";
            me->llio.ioport_connector_name[4] = "P8";
            me->llio.ioport_connector_name[5] = "P7";

            break;
        }


        //
        // good IO Cookie, Config Name, and IDROM Type
        // the IDROM offset is the usual, 0x400, and there's a good IDROM type there
        // good PortWidth, IOWidth, and clocks
        // but there are no IOPorts instances according to the MDs
        // (this is the case with a firmware Jeff made for testing an RNG circuit)
        //

--- PATTERN 12 ---
        case 12: {
            int num_io_pins = 24;
            int pd_index;

            set32(me, HM2_ADDR_IOCOOKIE, HM2_IOCOOKIE);
            set8(me, HM2_ADDR_CONFIGNAME+0, 'H');
            set8(me, HM2_ADDR_CONFIGNAME+1, 'O');
            set8(me, HM2_ADDR_CONFIGNAME+2, 'S');
            set8(me, HM2_ADDR_CONFIGNAME+3, 'T');
            set8(me, HM2_ADDR_CONFIGNAME+4, 'M');
            set8(me, HM2_ADDR_CONFIGNAME+5, 'O');
            set8(me, HM2_ADDR_CONFIGNAME+6, 'T');
            set8(me, HM2_ADDR_CONFIGNAME+7, '2');
            set32(me, HM2_ADDR_IDROM_OFFSET, 0x400); // put the IDROM at 0x400, where it usually lives
            set32(me, 0x400, 2); // standard idrom type

            // normal offset to Module Descriptors
            set32(me, 0x404, 64);

            // normal offset to PinDescriptors
            set32(me, 0x408, 0x200);

            // IOPorts
            set32(me, 0x41c, 1);

            // IOWidth
            set32(me, 0x420, num_io_pins);

            // PortWidth
            set32(me, 0x424, 24);

            // ClockLow = 2e6
            set32(me, 0x428, 2e6);

            // ClockHigh = 2e7
            set32(me, 0x42c, 2e7);

            me->llio.num_ioport_connectors = 1;
            me->llio.ioport_connector_name[0] = "P3";

            // make a bunch of valid Pin Descriptors
            for (pd_index = 0; pd_index < num_io_pins; pd_index ++) {
                set8(me, 0x600 + (pd_index * 4) + 0, 0);               // SecPin (byte) = Which pin of secondary function connects here eg: A,B,IDX.  Output pins have bit 7 = '1'
                set8(me, 0x600 + (pd_index * 4) + 1, 0);               // SecTag (byte) = Secondary function type (PWM,QCTR etc).  Same as module GTag
                set8(me, 0x600 + (pd_index * 4) + 2, 0);               // SecUnit (byte) = Which secondary unit or channel connects here
                set8(me, 0x600 + (pd_index * 4) + 3, HM2_GTAG_IOPORT); // PrimaryTag (byte) = Primary function tag (normally I/O port)
            }

            break;
        }


        // this board has a non-standard (ie, non-24) number of pins per connector, but the idrom does not match that
--- PATTERN 13 ---
        case 13: {
            set32(me, HM2_ADDR_IOCOOKIE, HM2_IOCOOKIE);
            set8(me, HM2_ADDR_CONFIGNAME+0, 'H');
            set8(me, HM2_ADDR_CONFIGNAME+1, 'O');
            set8(me, HM2_ADDR_CONFIGNAME+2, 'S');
            set8(me, HM2_ADDR_CONFIGNAME+3, 'T');
            set8(me, HM2_ADDR_CONFIGNAME+4, 'M');
            set8(me, HM2_ADDR_CONFIGNAME+5, 'O');
            set8(me, HM2_ADDR_CONFIGNAME+6, 'T');
            set8(me, HM2_ADDR_CONFIGNAME+7, '2');
            set32(me, HM2_ADDR_IDROM_OFFSET, 0x400); // put the IDROM at 0x400, where it usually lives
            set32(me, 0x400, 2); // standard idrom type

            // default PortWidth
            set32(me, 0x424, 24);

            // unusual number of pins per connector
            me->llio.pins_per_connector = 5;

            break;
        }


        // 
        // good IO Cookie, Config Name, and IDROM Type
        // the IDROM offset is the usual, 0x400, and there's a good IDROM type there
        // good but unusual (non-24) PortWidth
        // 

--- IDROM parser fields ---
661-    rtapi_u32 read_data;
662-
663-    //
664-    // find the idrom offset
665-    //
666-
667-    if (!hm2->llio->read(hm2->llio, HM2_ADDR_IDROM_OFFSET, &read_data, 4)) {
668-        HM2_ERR("error reading IDROM Offset\n");
669-        return -EIO;
670-    }
671:    hm2->idrom_offset = read_data & 0xFFFF;
672-
673-    //
674-    // first read in the idrom type to make sure we know how to deal with it
675-    //
676-
677-
678:    if (!hm2->llio->read(hm2->llio, hm2->idrom_offset, &hm2->idrom.idrom_type, sizeof(hm2->idrom.idrom_type))) {
679-        HM2_ERR("error reading IDROM type\n");
680-        return -EIO;
681-    }
682-    if (
683-        (hm2->idrom.idrom_type != 2) 
684-        && (hm2->idrom.idrom_type != 3)
685-    ) {
686-        HM2_ERR("invalid IDROM type %d, expected 2 or 3, aborting load\n", hm2->idrom.idrom_type);
687-        return -EINVAL;
688-    }
689-
690-
691-    //
692-    // ok, read in the whole thing
693-    //
694-
695-
696:    if (!hm2->llio->read(hm2->llio, hm2->idrom_offset, &hm2->idrom, sizeof(hm2->idrom))) {
697-        HM2_ERR("error reading IDROM\n");
698-        return -EIO;
699-    }
700-
701-
702-    //
703-    // verify the idrom we read
704-    //
705-
706-    if (hm2->idrom.port_width != hm2->llio->pins_per_connector) {
707-        HM2_ERR("invalid IDROM PortWidth %d, this board has %d pins per connector, aborting load\n", hm2->idrom.port_width, hm2->llio->pins_per_connector);
708-        hm2_print_idrom(hm2);
709-        return -EINVAL;
710-    }
711-
712-    if (hm2->idrom.io_width != (hm2->idrom.io_ports * hm2->idrom.port_width)) {
713-        HM2_ERR(
714-            "IDROM IOWidth is %d, but IDROM IOPorts is %d and IDROM PortWidth is %d (inconsistent firmware), aborting driver load\n",
715-            hm2->idrom.io_width,
716-            hm2->idrom.io_ports,
717-            hm2->idrom.port_width
718-        );
719-        return -EINVAL;
720-    }
721-
722-    if (hm2->idrom.io_ports != hm2->llio->num_ioport_connectors) {
723-        HM2_ERR(
724-            "IDROM IOPorts is %d but llio num_ioport_connectors is %d, driver and firmware are inconsistent, aborting driver load\n",
725-            hm2->idrom.io_ports,
726-            hm2->llio->num_ioport_connectors
727-        );
728-        return -EINVAL;
729-    }
730-
731-    if (hm2->idrom.io_width > HM2_MAX_PIN_DESCRIPTORS) {
732-        HM2_ERR(
733-            "IDROM IOWidth is %d but max is %d, aborting driver load\n",
734-            hm2->idrom.io_width,
735-            HM2_MAX_PIN_DESCRIPTORS
736-        );
737-        return -EINVAL;
738-    }
739-
740-    if (hm2->idrom.clock_low < 1e6) {
741-        HM2_ERR(
742-            "IDROM ClockLow is %d, that's too low, aborting driver load\n",
743-            hm2->idrom.clock_low
744-        );
745-        return -EINVAL;
746-    }
747-
748-    if (hm2->idrom.clock_high < 1e6) {
749-        HM2_ERR(
750-            "IDROM ClockHigh is %d, that's too low, aborting driver load\n",
751-            hm2->idrom.clock_high
752-        );
753-        return -EINVAL;
754-    }
755-
756-    if (debug_idrom) {
757-        hm2_print_idrom(hm2);
758-    }
759-
760-    return 0;
761-}
762-
763-
764-
765-
766-// reads the Module Descriptors
767-// doesn't do any validation or parsing or anything, that's in hm2_parse_module_descriptors(), which comes next
768-static int hm2_read_module_descriptors(hostmot2_t *hm2) {
769:    int addr = hm2->idrom_offset + hm2->idrom.offset_to_modules;
770-
771-    for (
772-        hm2->num_mds = 0;
773-        hm2->num_mds < HM2_MAX_MODULE_DESCRIPTORS;
774-        hm2->num_mds ++, addr += 12
775-    ) {
776-        rtapi_u32 d[3];
777-        hm2_module_descriptor_t *md = &hm2->md[hm2->num_mds];
778-
779-        if (!hm2->llio->read(hm2->llio, addr, d, 12)) {
780-            HM2_ERR("error reading Module Descriptor %d (at 0x%04x)\n", hm2->num_mds, addr);
781-            return -EIO;
782-        }
783-
784-        md->gtag = d[0] & 0x000000FF;
785-        if (md->gtag == 0) {
786-            // done
787-            return 0;
788-        }
789-
790-        md->version   = (d[0] >>  8) & 0x000000FF;
791-        md->clock_tag = (d[0] >> 16) & 0x000000FF;
792-        md->instances = (d[0] >> 24) & 0x000000FF;
793-
794-        if (md->clock_tag == 1) {
795-            md->clock_freq = hm2->idrom.clock_low;
796-        } else if (md->clock_tag == 2) {
797-            md->clock_freq = hm2->idrom.clock_high;
798-        } else {
799-            HM2_ERR("Module Descriptor %d (at 0x%04x) has invalid ClockTag %d\n", hm2->num_mds, addr, md->clock_tag);
800-            return -EINVAL;
801-        }
802-
803-        md->base_address = (d[1] >> 00) & 0x0000FFFF;
804-        md->num_registers = (d[1] >> 16) & 0x000000FF;
805-
806-        md->register_stride = (d[1] >> 24) & 0x0000000F;
807-        if (md->register_stride == 0) {
808-            md->register_stride = hm2->idrom.register_stride_0;
809-        } else if (md->register_stride == 1) {
810-            md->register_stride = hm2->idrom.register_stride_1;
811-        } else {
812-            HM2_ERR("Module Descriptor %d (at 0x%04x) has invalid RegisterStride %d\n", hm2->num_mds, addr, md->register_stride);
813-            return -EINVAL;
814-        }
815-
816-        md->instance_stride = (d[1] >> 28) & 0x0000000F;
817-        if (md->instance_stride == 0) {
818-            md->instance_stride = hm2->idrom.instance_stride_0;
819-        } else if (md->instance_stride == 1) {
820-            md->instance_stride = hm2->idrom.instance_stride_1;
821-        } else {
822-            HM2_ERR("Module Descriptor %d (at 0x%04x) has invalid InstanceStride %d\n", hm2->num_mds, addr, md->instance_stride);
823-            return -EINVAL;
824-        }
825-
826-        md->multiple_registers = d[2];
827-
828-        if (debug_module_descriptors) {
829-            HM2_PRINT("Module Descriptor %d at 0x%04X:\n", hm2->num_mds, addr);
830-            HM2_PRINT("    General Function Tag: %d (%s)\n", md->gtag, hm2_get_general_function_name(md->gtag));
831-            HM2_PRINT("    Version: %d\n", md->version);
832-            HM2_PRINT("    Clock Tag: %d (%s MHz)\n", md->clock_tag, hm2_hz_to_mhz(md->clock_freq));
833-            HM2_PRINT("    Instances: %d\n", md->instances);
834-            HM2_PRINT("    Base Address: 0x%04X\n", md->base_address);
835-            HM2_PRINT("    -- Num Registers: %d\n", md->num_registers);
836-            HM2_PRINT("    Register Stride: 0x%08X\n", md->register_stride);
837-            HM2_PRINT("    -- Instance Stride: 0x%08X\n", md->instance_stride);
838-            HM2_PRINT("    -- Multiple Registers: 0x%08X\n", md->multiple_registers);
839-        }
840-    }
--- watchdog register setup ---
45-    // last time we were here, everything was fine
46-    // see if the watchdog has bit since then
47-    if (hm2->watchdog.status_reg[0] & 0x1) {
48-        HM2_ERR("Watchdog has bit! (set the .has-bit pin to False to resume)\n");
49-        hal_set_bool(hm2->watchdog.instance[0].hal.pin.has_bit, 1);
50-        hm2->llio->needs_reset = 1;
51-    }
52-}
53-
54-
55:int hm2_watchdog_parse_md(hostmot2_t *hm2, int md_index) {
56-    hm2_module_descriptor_t *md = &hm2->md[md_index];
57-    int r;
58-
59-
60-    // 
61-    // some standard sanity checks
62-    //
63-
64-    if (!hm2_md_is_consistent_or_complain(hm2, md_index, 0, 3, 4, 0)) {
65-        HM2_ERR("inconsistent Module Descriptor!\n");
66-        return -EINVAL;
67-    }
68-
69-    if (hm2->watchdog.num_instances != 0) {
70-        HM2_ERR(
71-            "found duplicate Module Descriptor for %s (inconsistent firmware), not loading driver\n",
72-            hm2_get_general_function_name(md->gtag)
73-        );
74-        return -EINVAL;
75-    }
76-
77-
78-    // 
79-    // special sanity checks for watchdog
80-    //
81-
82-    if (md->instances != 1) {
83-        HM2_PRINT("MD declares %d watchdogs!  only using the first one...\n", md->instances);
84-    }
85-
86-
87-    // 
88-    // looks good, start initializing
89-    // 
90-
91-
92-    hm2->watchdog.num_instances = 1;
93-
94-    hm2->watchdog.instance = hal_malloc(hm2->watchdog.num_instances * sizeof(*hm2->watchdog.instance));
95-    if (hm2->watchdog.instance == NULL) {
96-        HM2_ERR("out of memory!\n");
97-        r = -ENOMEM;
98-        goto fail0;
99-    }
100-
101-    hm2->watchdog.clock_frequency = md->clock_freq;
102-    hm2->watchdog.version = md->version;
103-
104-    hm2->watchdog.timer_addr = md->base_address + (0 * md->register_stride);
105-    hm2->watchdog.status_addr = md->base_address + (1 * md->register_stride);
106-    hm2->watchdog.reset_addr = md->base_address + (2 * md->register_stride);
107-
108-
109-    r = hm2_register_tram_read_region(hm2, hm2->watchdog.status_addr, (hm2->watchdog.num_instances * sizeof(rtapi_u32)), &hm2->watchdog.status_reg);
110-    if (r < 0) {
111-        HM2_ERR("error registering tram read region for watchdog (%d)\n", r);
112-        goto fail0;
113-    }
114-
115-    r = hm2_register_tram_write_region(hm2, hm2->watchdog.reset_addr, sizeof(rtapi_u32), &hm2->watchdog.reset_reg);
116-    if (r < 0) {
117-        HM2_ERR("error registering tram write region for watchdog (%d)!\n", r);
118-        goto fail0;
119-    }
120-
121-    // 
122-    // allocate memory for register buffers
123-    //
124-
125-    hm2->watchdog.timer_reg = (rtapi_u32 *)rtapi_kmalloc(hm2->watchdog.num_instances * sizeof(rtapi_u32), RTAPI_GFP_KERNEL);
126-    if (hm2->watchdog.timer_reg == NULL) {
127-        HM2_ERR("out of memory!\n");
128-        r = -ENOMEM;
129-        goto fail0;
130-    }
131-
132-
133-    //
134-    // export to HAL
135-    //
136-
137-    // pins
138-    r = hal_pin_new_bool(
139-        hm2->llio->comp_id,
140-        HAL_IO,
141-        &(hm2->watchdog.instance[0].hal.pin.has_bit),
142-        0,
143-        "%s.watchdog.has_bit",
144-        hm2->llio->name
145-    );
146-    if (r < 0) {
147-        HM2_ERR("error adding pin, aborting\n");
148-        r = -EINVAL;
149-        goto fail1;
150-    }
151-
152-    // params
153-    // default timeout is 5 milliseconds (5*1000*1000 nanoseconds)
154-    r = hal_param_new_ui32(
155-        hm2->llio->comp_id,
156-        HAL_RW,
157-        &(hm2->watchdog.instance[0].hal.param.timeout_ns),
158-        5 * 1000 * 1000,
159-        "%s.watchdog.timeout_ns",
160-        hm2->llio->name
161-    );
162-    if (r < 0) {
163-        HM2_ERR("error adding param, aborting\n");
164-        r = -EINVAL;
165-        goto fail1;
166-    }
167-
168-    //
169-    // initialize the watchdog
170-    //
171-
172-    hm2->watchdog.instance[0].enable = 0;  // the first pet_watchdog will turn it on
173-
174-    return hm2->watchdog.num_instances;
175-
176-
177-fail1:
178-    rtapi_kfree(hm2->watchdog.timer_reg);
179-
180-fail0:
181-    hm2->watchdog.num_instances = 0;
182-    return r;
183-}
184-
185-
--- MD consistency helper ---
854-// each MD in turn, and there's a special function to parse each GTag
855-// (aka Function)
856-//
857-// The per-Module parsers return the number of instances accepted, which
858-// may be less than the number of instances available, or even 0, if the
859-// user has disabled some instances using modparams.  The per-Module
860-// parsers return -1 on error, which causes the module load to fail.
861-//
862-
863-
864:int hm2_md_is_consistent_or_complain(
865-    hostmot2_t *hm2,
866-    int md_index,
867-    rtapi_u8 version,
868-    rtapi_u8 num_registers,
869-    rtapi_u32 instance_stride,
870-    rtapi_u32 multiple_registers
871-) {
872-    hm2_module_descriptor_t *md = &hm2->md[md_index];
873-
874-    if (hm2_md_is_consistent(hm2, md_index, version, num_registers, instance_stride, multiple_registers)) return 1;
875-
876-    HM2_ERR(
877-        "inconsistent Module Descriptor for %s, not loading driver\n",
878-        hm2_get_general_function_name(md->gtag)
879-    );
880-
881-    HM2_ERR(
882-        "    Version = %d, expected %d\n",
883-        md->version,
884-        version
885-    );
886-
887-    HM2_ERR(
888-        "    NumRegisters = %d, expected %d\n",
889-        md->num_registers,
890-        num_registers
891-    );
892-
893-    HM2_ERR(
894-        "    InstanceStride = 0x%08X, expected 0x%08X\n",
895-        md->instance_stride,
896-        instance_stride
897-    );
898-
899-    HM2_ERR(
900-        "    MultipleRegisters = 0x%08X, expected 0x%08X\n",
901-        md->multiple_registers,
902-        multiple_registers
903-    );
904-
905-    return 0;
906-}
907-
908-
909-int hm2_md_is_consistent(
910-    hostmot2_t *hm2,
911-    int md_index,
912-    rtapi_u8 version,
913-    rtapi_u8 num_registers,
914-    rtapi_u32 instance_stride,
915-    rtapi_u32 multiple_registers
916-) {
917-    hm2_module_descriptor_t *md = &hm2->md[md_index];
918-
919-    if (
920-        (md->num_registers == num_registers)
921-        && (md->version == version)
922-        && (md->instance_stride == instance_stride)
923-        && (md->multiple_registers == multiple_registers)
924-    ) {
925-        return 1;
926-    }
927-
928-    return 0;
929-}
930-
931-
932-
933-
934-static int hm2_parse_module_descriptors(hostmot2_t *hm2) {
935-    int md_index, md_accepted;
936-    
937-    hm2->dpll_module_present = 0;
938-    for (md_index = 0; md_index < hm2->num_mds; md_index ++) {
939-        hm2_module_descriptor_t *md = &hm2->md[md_index];
940-
941-        if (md->gtag == HM2_GTAG_HM2DPLL) {
942-            hm2->dpll_module_present = 1;
943-            break;
944-        } else if (md->gtag == 0) {
945-            break;
946-        }
947-    }
948-
949-    // Run through once looking for IO Ports in case other modules
950-    // need them
951-    for (md_index = 0; md_index < hm2->num_mds; md_index ++) {
952-        hm2_module_descriptor_t *md = &hm2->md[md_index];
953-
954-        if (md->gtag != HM2_GTAG_IOPORT) {
955-            continue;
956-        }
957-
958-        md_accepted = hm2_ioport_parse_md(hm2, md_index);
959-
960-        if (hal_get_bool(*hm2->llio->io_error)) {
961-            HM2_ERR("IO error while parsing Module Descriptor %d\n", md_index);
962-            return -EIO;
963-        }
964-
LAYOUT_PREFLIGHT_PASS
```

## Standard error
```text
```
