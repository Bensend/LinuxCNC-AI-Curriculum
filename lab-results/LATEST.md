# Latest LinuxCNC Lab Result

- Job: `019-t02-task-motion-gated-delay`
- Job file: `lab-jobs/019-t02-task-motion-gated-delay.sh`
- Workflow run ID: `34179865160`
- Attempt: `1`
- Source commit: `e5db5e66c5c8be3a44cd47b9b6066fae51677b24`
- Exit code: `0`
- Finished UTC: `2026-09-08T02:26:32Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-08T02:23:09Z
Repository commit: e5db5e66c5c8be3a44cd47b9b6066fae51677b24
Workflow run: 34179865160 attempt 1
Job file: lab-jobs/019-t02-task-motion-gated-delay.sh
Runner: Linux runnervmejwal 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
Inner lab timeout: 70 minutes (job ceiling: 75 minutes)

UTC finish: 2026-09-08T02:26:32Z
```

## Standard output
```text
== T02-019 Task motion-gated dwell experiment ==
UTC start: 2026-09-08T02:23:09Z
Pinned upstream commit: 8bf4605ae81042248add031e94c77300406e0413
Frozen prediction: a queued G4 dwell remains behind WAITING_FOR_MOTION_AND_IO until prior motion/I/O are complete, then Task enters WAITING_FOR_DELAY for the dwell interval.
Anti-circular boundary: program/read-line progress is logged but is never accepted as the motion-completion oracle.
Simulation boundary: this verifies Task/motion state-machine behavior in the stock loopback simulator; it does not prove physical actuator, transport, feedback-device, or safety behavior.
Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [144 B]
Hit:2 http://azure.archive.ubuntu.com/ubuntu noble InRelease
Get:3 http://azure.archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Get:6 https://packages.microsoft.com/ubuntu/24.04/prod noble InRelease [3600 B]
Get:4 http://azure.archive.ubuntu.com/ubuntu noble-backports InRelease [126 kB]
Get:5 http://azure.archive.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:7 https://dl.google.com/linux/chrome-stable/deb stable InRelease [2548 B]
Get:8 https://packages.microsoft.com/ubuntu/24.04/prod noble/main arm64 Packages [394 kB]
Get:9 https://packages.microsoft.com/ubuntu/24.04/prod noble/main amd64 Packages [441 kB]
Get:10 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages [1260 kB]
Get:11 http://azure.archive.ubuntu.com/ubuntu noble-updates/main Translation-en [292 kB]
Get:12 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 Components [180 kB]
Get:13 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 Packages [1691 kB]
Get:14 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe Translation-en [339 kB]
Get:15 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 Components [388 kB]
Get:16 http://azure.archive.ubuntu.com/ubuntu noble-updates/restricted amd64 Packages [1536 kB]
Get:17 http://azure.archive.ubuntu.com/ubuntu noble-updates/restricted Translation-en [352 kB]
Get:18 http://azure.archive.ubuntu.com/ubuntu noble-updates/multiverse amd64 Components [940 B]
Get:19 http://azure.archive.ubuntu.com/ubuntu noble-backports/main amd64 Components [5760 B]
Get:20 http://azure.archive.ubuntu.com/ubuntu noble-backports/universe amd64 Components [12.6 kB]
Get:21 http://azure.archive.ubuntu.com/ubuntu noble-security/main amd64 Packages [1002 kB]
Get:22 http://azure.archive.ubuntu.com/ubuntu noble-security/main Translation-en [212 kB]
Get:23 http://azure.archive.ubuntu.com/ubuntu noble-security/main amd64 Components [46.3 kB]
Get:24 http://azure.archive.ubuntu.com/ubuntu noble-security/universe amd64 Packages [1206 kB]
Get:25 http://azure.archive.ubuntu.com/ubuntu noble-security/universe Translation-en [241 kB]
Get:26 http://azure.archive.ubuntu.com/ubuntu noble-security/universe amd64 Components [76.2 kB]
Get:27 http://azure.archive.ubuntu.com/ubuntu noble-security/restricted amd64 Packages [1437 kB]
Get:28 http://azure.archive.ubuntu.com/ubuntu noble-security/restricted Translation-en [334 kB]
Get:29 https://dl.google.com/linux/chrome-stable/deb stable/main amd64 Packages [1403 B]
Fetched 11.8 MB in 1s (8893 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
git is already the newest version (1:2.55.0-0ppa1~ubuntu24.04.2).
git set to manually installed.
netcat-openbsd is already the newest version (1.226-1ubuntu2).
netcat-openbsd set to manually installed.
procps is already the newest version (2:4.0.4-4ubuntu3.3).
procps set to manually installed.
python3 is already the newest version (3.12.3-0ubuntu2.1).
The following additional packages will be installed:
  autopoint dctrl-tools debhelper dh-autoreconf dh-strip-nondeterminism
  diffstat dput dwz gettext intltool-debian libaliased-perl libapt-pkg-perl
  libarchive-cpio-perl libarchive-zip-perl libarray-intspan-perl
  libauthen-sasl-perl libb-hooks-endofscope-perl libb-hooks-op-check-perl
  libberkeleydb-perl libcapture-tiny-perl libclass-data-inheritable-perl
  libclass-method-modifiers-perl libclass-xsaccessor-perl libconfig-tiny-perl
  libconst-fast-perl libcpanel-json-xs-perl libdata-dpath-perl
  libdata-dump-perl libdata-messagepack-perl libdata-optlist-perl
  libdata-validate-domain-perl libdata-validate-ip-perl
  libdata-validate-uri-perl libdebhelper-perl libdevel-callchecker-perl
  libdevel-size-perl libdevel-stacktrace-perl libdistro-info-perl
  libdynaloader-functions-perl libemail-address-xs-perl
  libexception-class-perl libexporter-tiny-perl libfile-basedir-perl
  libfile-chdir-perl libfile-dirlist-perl libfile-find-rule-perl
  libfile-homedir-perl libfile-listing-perl libfile-stripnondeterminism-perl
  libfile-touch-perl libfile-which-perl libfont-afm-perl libfont-ttf-perl
  libfreezethaw-perl libgit-wrapper-perl libhtml-form-perl libhtml-format-perl
  libhtml-html5-entities-perl libhtml-tokeparser-simple-perl libhtml-tree-perl
  libhttp-cookies-perl libhttp-daemon-perl libhttp-negotiate-perl
  libimport-into-perl libindirect-perl libio-interactive-perl libio-pty-perl
  libio-socket-ssl-perl libio-string-perl libipc-run-perl libipc-run3-perl
  libipc-system-simple-perl libiterator-perl libiterator-util-perl
  libjson-maybexs-perl liblist-compare-perl liblist-someutils-perl
  liblist-someutils-xs-perl liblist-utilsby-perl
  liblog-any-adapter-screen-perl liblog-any-perl liblwp-protocol-https-perl
  libmail-sendmail-perl libmailtools-perl libmarkdown2 libmath-base85-perl
  libmldbm-perl libmodule-implementation-perl libmodule-runtime-perl
  libmoo-perl libmoox-aliases-perl libmouse-perl libnamespace-clean-perl
  libnet-domain-tld-perl libnet-http-perl libnet-ipv6addr-perl
  libnet-netmask-perl libnet-smtp-ssl-perl libnet-ssleay-perl
  libnetaddr-ip-perl libnumber-compare-perl libobject-pad-perl
  libpackage-stash-perl libpackage-stash-xs-perl libparams-classify-perl
  libparams-util-perl libpath-iterator-rule-perl libpath-tiny-perl
  libperlio-gzip-perl libperlio-utf8-strict-perl libpod-constants-perl
  libpod-parser-perl libre-engine-re2-perl libregexp-pattern-license-perl
  libregexp-pattern-perl libregexp-wildcards-perl librole-tiny-perl
  libsereal-decoder-perl libsereal-encoder-perl libset-intspan-perl
  libsocket6-perl libsort-versions-perl libstrictures-perl
  libstring-copyright-perl libstring-escape-perl libstring-license-perl
  libstring-shellquote-perl libsub-exporter-perl
  libsub-exporter-progressive-perl libsub-identify-perl libsub-install-perl
  libsub-name-perl libsub-override-perl libsub-quote-perl
  libsyntax-keyword-try-perl libsys-hostname-long-perl libtext-glob-perl
  libtext-levenshteinxs-perl libtext-markdown-discount-perl
  libtext-xslate-perl libtime-duration-perl libtime-moment-perl
  libtry-tiny-perl libunicode-utf8-perl libvariable-magic-perl
  libwww-mechanize-perl libwww-perl libwww-robotrules-perl
  libxs-parse-keyword-perl libxs-parse-sublike-perl libyaml-libyaml-perl
  licensecheck lintian lzip lzop patchutils perl-openssl-defaults po-debconf
  python3-gpg python3-nacl python3-paramiko python3-unidiff python3-xdg
  t1utils wdiff
Suggested packages:
  debtags dh-make adequate at autopkgtest bls-standalone bsd-mailx | mailx
  check-all-the-things cvs-buildpackage diffoscope disorderfs dose-extra duck
  elpa-devscripts faketime gnuplot how-can-i-help libdbd-pg-perl
  libfile-desktopentry-perl libterm-size-perl libyaml-syck-perl mmdebstrap
  mutt piuparts pristine-lfs quilt ratt reprotest svn-buildpackage w3m
  debian-keyring libgitlab-api-v4-perl libsoap-lite-perl pristine-tar
  mini-dinstall gettext-doc libasprintf-dev libgettextpo-dev
  libdigest-hmac-perl libgssapi-perl libxml-parser-perl libcrypt-ssleay-perl
  libscalar-number-perl libbareword-filehandles-perl libmultidimensional-perl
  libxstring-perl libauthen-ntlm-perl binutils-multiarch libtext-template-perl
  libmail-box-perl python-nacl-doc python3-gssapi python3-invoke
  python-pyxdg-doc wdiff-doc
The following NEW packages will be installed:
  autopoint build-essential dctrl-tools debhelper devscripts dh-autoreconf
  dh-strip-nondeterminism diffstat dput dwz equivs gettext intltool-debian
  libaliased-perl libapt-pkg-perl libarchive-cpio-perl libarchive-zip-perl
  libarray-intspan-perl libauthen-sasl-perl libb-hooks-endofscope-perl
  libb-hooks-op-check-perl libberkeleydb-perl libcapture-tiny-perl
  libclass-data-inheritable-perl libclass-method-modifiers-perl
  libclass-xsaccessor-perl libconfig-tiny-perl libconst-fast-perl
  libcpanel-json-xs-perl libdata-dpath-perl libdata-dump-perl
  libdata-messagepack-perl libdata-optlist-perl libdata-validate-domain-perl
  libdata-validate-ip-perl libdata-validate-uri-perl libdebhelper-perl
  libdevel-callchecker-perl libdevel-size-perl libdevel-stacktrace-perl
  libdistro-info-perl libdynaloader-functions-perl libemail-address-xs-perl
  libexception-class-perl libexporter-tiny-perl libfile-basedir-perl
  libfile-chdir-perl libfile-dirlist-perl libfile-find-rule-perl
  libfile-homedir-perl libfile-listing-perl libfile-stripnondeterminism-perl
  libfile-touch-perl libfile-which-perl libfont-afm-perl libfont-ttf-perl
  libfreezethaw-perl libgit-wrapper-perl libhtml-form-perl libhtml-format-perl
  libhtml-html5-entities-perl libhtml-tokeparser-simple-perl libhtml-tree-perl
  libhttp-cookies-perl libhttp-daemon-perl libhttp-negotiate-perl
  libimport-into-perl libindirect-perl libio-interactive-perl libio-pty-perl
  libio-socket-ssl-perl libio-string-perl libipc-run-perl libipc-run3-perl
  libipc-system-simple-perl libiterator-perl libiterator-util-perl
  libjson-maybexs-perl liblist-compare-perl liblist-someutils-perl
  liblist-someutils-xs-perl liblist-utilsby-perl
  liblog-any-adapter-screen-perl liblog-any-perl liblwp-protocol-https-perl
  libmail-sendmail-perl libmailtools-perl libmarkdown2 libmath-base85-perl
  libmldbm-perl libmodule-implementation-perl libmodule-runtime-perl
  libmoo-perl libmoox-aliases-perl libmouse-perl libnamespace-clean-perl
  libnet-domain-tld-perl libnet-http-perl libnet-ipv6addr-perl
  libnet-netmask-perl libnet-smtp-ssl-perl libnet-ssleay-perl
  libnetaddr-ip-perl libnumber-compare-perl libobject-pad-perl
  libpackage-stash-perl libpackage-stash-xs-perl libparams-classify-perl
  libparams-util-perl libpath-iterator-rule-perl libpath-tiny-perl
  libperlio-gzip-perl libperlio-utf8-strict-perl libpod-constants-perl
  libpod-parser-perl libre-engine-re2-perl libregexp-pattern-license-perl
  libregexp-pattern-perl libregexp-wildcards-perl librole-tiny-perl
  libsereal-decoder-perl libsereal-encoder-perl libset-intspan-perl
  libsocket6-perl libsort-versions-perl libstrictures-perl
  libstring-copyright-perl libstring-escape-perl libstring-license-perl
  libstring-shellquote-perl libsub-exporter-perl
  libsub-exporter-progressive-perl libsub-identify-perl libsub-install-perl
  libsub-name-perl libsub-override-perl libsub-quote-perl
  libsyntax-keyword-try-perl libsys-hostname-long-perl libtext-glob-perl
  libtext-levenshteinxs-perl libtext-markdown-discount-perl
  libtext-xslate-perl libtime-duration-perl libtime-moment-perl
  libtry-tiny-perl libunicode-utf8-perl libvariable-magic-perl
  libwww-mechanize-perl libwww-perl libwww-robotrules-perl
  libxs-parse-keyword-perl libxs-parse-sublike-perl libyaml-libyaml-perl
  licensecheck lintian lzip lzop patchutils perl-openssl-defaults po-debconf
  python3-gpg python3-nacl python3-paramiko python3-unidiff python3-xdg
  t1utils wdiff
0 upgraded, 168 newly installed, 0 to remove and 44 not upgraded.
Need to get 11.0 MB of archives.
After this operation, 36.7 MB of additional disk space will be used.
Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [144 B]
Get:2 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 autopoint all 0.21-14ubuntu2 [422 kB]
Get:3 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 build-essential amd64 12.10ubuntu1 [4928 B]
Get:4 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 dctrl-tools amd64 2.24-3build3 [106 kB]
Get:5 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdebhelper-perl all 13.14.1ubuntu5 [89.8 kB]
Get:6 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 dh-autoreconf all 20 [16.1 kB]
Get:7 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libarchive-zip-perl all 1.68-1 [90.2 kB]
Get:8 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsub-override-perl all 0.10-1 [10.0 kB]
Get:9 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-stripnondeterminism-perl all 1.13.1-1 [18.1 kB]
Get:10 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 dh-strip-nondeterminism all 1.13.1-1 [5362 B]
Get:11 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 dwz amd64 0.15-1build6 [115 kB]
Get:12 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gettext amd64 0.21-14ubuntu2 [864 kB]
Get:13 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 intltool-debian all 0.35.0+20060710.6 [23.2 kB]
Get:14 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 po-debconf all 1.0.21+nmu1 [233 kB]
Get:15 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 debhelper all 13.14.1ubuntu5 [869 kB]
Get:16 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-dirlist-perl all 0.05-3 [7286 B]
Get:17 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-which-perl all 1.27-2 [12.5 kB]
Get:18 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-homedir-perl all 1.006-2 [37.0 kB]
Get:19 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-touch-perl all 0.12-2 [7498 B]
Get:20 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libio-pty-perl amd64 1:1.20-1build2 [31.2 kB]
Get:21 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libipc-run-perl all 20231003.0-1 [92.1 kB]
Get:22 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libclass-method-modifiers-perl all 2.15-1 [16.1 kB]
Get:23 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libclass-xsaccessor-perl amd64 1.19-4build4 [33.1 kB]
Get:24 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libb-hooks-op-check-perl amd64 0.22-3build1 [9518 B]
Get:25 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdynaloader-functions-perl all 0.003-3 [12.1 kB]
Get:26 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdevel-callchecker-perl amd64 0.008-2build3 [13.2 kB]
Get:27 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libparams-classify-perl amd64 0.015-2build5 [20.1 kB]
Get:28 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmodule-runtime-perl all 0.016-2 [16.4 kB]
Get:29 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libimport-into-perl all 1.002005-2 [10.7 kB]
Get:30 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 librole-tiny-perl all 2.002004-1 [16.3 kB]
Get:31 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsub-quote-perl all 2.006008-1ubuntu1 [20.7 kB]
Get:32 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmoo-perl all 2.005005-1 [47.4 kB]
Get:33 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-listing-perl all 6.16-1 [11.3 kB]
Get:34 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhtml-tree-perl all 5.07-3 [200 kB]
Get:35 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhttp-cookies-perl all 6.11-1 [18.2 kB]
Get:36 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhttp-negotiate-perl all 6.01-2 [12.4 kB]
Get:37 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 perl-openssl-defaults amd64 7build3 [6626 B]
Get:38 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnet-ssleay-perl amd64 1.94-1build4 [316 kB]
Get:39 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libio-socket-ssl-perl all 2.085-1 [195 kB]
Get:40 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnet-http-perl all 6.23-1 [22.3 kB]
Get:41 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblwp-protocol-https-perl all 6.13-1 [9006 B]
Get:42 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtry-tiny-perl all 0.31-2 [20.8 kB]
Get:43 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwww-robotrules-perl all 6.02-1 [12.6 kB]
Get:44 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libwww-perl all 6.76-1ubuntu0.1 [139 kB]
Get:45 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 patchutils amd64 0.4.2-1build3 [77.0 kB]
Get:46 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 wdiff amd64 1.2.2-6build1 [29.1 kB]
Get:47 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 devscripts all 2.23.7ubuntu0.2 [1048 kB]
Get:48 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 diffstat amd64 1.66-1build1 [29.7 kB]
Get:49 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-gpg amd64 1.18.0-4.1ubuntu4 [209 kB]
Get:50 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-xdg all 0.28-2 [38.3 kB]
Get:51 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 dput all 1.1.3ubuntu3 [46.5 kB]
Get:52 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libaliased-perl all 0.34-3 [12.8 kB]
Get:53 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libapt-pkg-perl amd64 0.1.40build7 [68.4 kB]
Get:54 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libarchive-cpio-perl all 0.10-3 [10.3 kB]
Get:55 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libarray-intspan-perl all 2.004-2 [25.0 kB]
Get:56 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmodule-implementation-perl all 0.09-2 [12.0 kB]
Get:57 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsub-exporter-progressive-perl all 0.001013-3 [6718 B]
Get:58 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libvariable-magic-perl amd64 0.63-1build3 [35.1 kB]
Get:59 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libb-hooks-endofscope-perl all 0.28-1 [15.8 kB]
Get:60 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libberkeleydb-perl amd64 0.64-2build4 [120 kB]
Get:61 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libcapture-tiny-perl all 0.48-2 [20.2 kB]
Get:62 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libclass-data-inheritable-perl all 0.08-3 [8084 B]
Get:63 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libconfig-tiny-perl all 2.30-1 [14.7 kB]
Get:64 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libparams-util-perl amd64 1.102-2build3 [21.2 kB]
Get:65 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsub-install-perl all 0.929-1 [9764 B]
Get:66 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdata-optlist-perl all 0.114-1 [9708 B]
Get:67 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsub-exporter-perl all 0.990-1 [49.0 kB]
Get:68 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libconst-fast-perl all 0.014-2 [8034 B]
Get:69 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libcpanel-json-xs-perl amd64 4.37-1ubuntu0.1 [114 kB]
Get:70 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdevel-stacktrace-perl all 2.0500-1 [22.1 kB]
Get:71 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libexception-class-perl all 1.45-1 [28.6 kB]
Get:72 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libiterator-perl all 0.03+ds1-2 [18.8 kB]
Get:73 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libiterator-util-perl all 0.02+ds1-2 [14.1 kB]
Get:74 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdata-dpath-perl all 0.59-1 [39.2 kB]
Get:75 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdata-dump-perl all 1.25-1 [25.9 kB]
Get:76 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdata-messagepack-perl amd64 1.02-1build4 [31.1 kB]
Get:77 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnet-domain-tld-perl all 1.75-3 [29.4 kB]
Get:78 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdata-validate-domain-perl all 0.10-1.1 [9992 B]
Get:79 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnet-ipv6addr-perl all 1.02-1 [21.0 kB]
Get:80 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnet-netmask-perl all 2.0002-2 [24.8 kB]
Get:81 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnetaddr-ip-perl amd64 4.079+dfsg-2build4 [79.9 kB]
Get:82 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdata-validate-ip-perl all 0.31-1 [17.2 kB]
Get:83 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdata-validate-uri-perl all 0.07-3 [10.8 kB]
Get:84 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdistro-info-perl all 1.7build1 [5616 B]
Get:85 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libemail-address-xs-perl amd64 1.05-1build4 [29.1 kB]
Get:86 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libexporter-tiny-perl all 1.006002-1 [36.8 kB]
Get:87 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libipc-system-simple-perl all 1.30-2 [22.3 kB]
Get:88 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-basedir-perl all 0.09-2 [14.4 kB]
Get:89 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfile-chdir-perl all 0.1008-1.1 [10.6 kB]
Get:90 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnumber-compare-perl all 0.03-3 [5974 B]
Get:91 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtext-glob-perl all 0.11-3 [6780 B]
Get:92 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libfile-find-rule-perl all 0.34-3ubuntu0.24.04.1 [23.8 kB]
Get:93 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfont-afm-perl all 1.20-4 [13.0 kB]
Get:94 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libio-string-perl all 1.08-4 [11.1 kB]
Get:95 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfont-ttf-perl all 1.06-2 [323 kB]
Get:96 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfreezethaw-perl all 0.5001-3 [14.6 kB]
Get:97 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsort-versions-perl all 1.62-3 [7378 B]
Get:98 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgit-wrapper-perl all 0.048-2 [29.5 kB]
Get:99 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhtml-form-perl all 6.11-1 [32.1 kB]
Get:100 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhtml-format-perl all 2.16-2 [36.9 kB]
Get:101 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhtml-html5-entities-perl all 0.004-3 [21.6 kB]
Get:102 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhtml-tokeparser-simple-perl all 3.16-4 [38.0 kB]
Get:103 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libhttp-daemon-perl all 6.16-1ubuntu0.24.04.1 [22.8 kB]
Get:104 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libindirect-perl amd64 0.39-2build4 [22.1 kB]
Get:105 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libio-interactive-perl all 1.025-1 [10.4 kB]
Get:106 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libjson-maybexs-perl all 1.004005-1 [11.3 kB]
Get:107 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblist-compare-perl all 0.55-2 [62.9 kB]
Get:108 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblist-someutils-perl all 0.59-1 [30.4 kB]
Get:109 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblist-someutils-xs-perl amd64 0.58-3build4 [35.0 kB]
Get:110 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblist-utilsby-perl all 0.12-2 [14.9 kB]
Get:111 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblog-any-perl all 1.717-1 [73.2 kB]
Get:112 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblog-any-adapter-screen-perl all 0.140-2 [12.4 kB]
Get:113 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsys-hostname-long-perl all 1.5-3 [10.6 kB]
Get:114 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmail-sendmail-perl all 0.80-3 [21.7 kB]
Get:115 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnet-smtp-ssl-perl all 1.04-2 [6218 B]
Get:116 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmailtools-perl all 2.21-2 [80.4 kB]
Get:117 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmarkdown2 amd64 2.2.7-2build1 [37.5 kB]
Get:118 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmath-base85-perl all 0.5+dfsg-2 [6124 B]
Get:119 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmldbm-perl all 2.05-4 [16.0 kB]
Get:120 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libstrictures-perl all 2.000006-1 [16.3 kB]
Get:121 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmoox-aliases-perl all 0.001006-2 [6796 B]
Get:122 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmouse-perl amd64 2.5.10-1build8 [133 kB]
Get:123 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpackage-stash-perl all 0.40-1 [19.5 kB]
Get:124 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsub-identify-perl amd64 0.14-3build3 [9786 B]
Get:125 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsub-name-perl amd64 0.27-1build3 [10.8 kB]
Get:126 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libnamespace-clean-perl all 0.27-2 [14.0 kB]
Get:127 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxs-parse-keyword-perl amd64 0.39-1build3 [54.7 kB]
Get:128 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxs-parse-sublike-perl amd64 0.21-2build3 [39.9 kB]
Get:129 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libobject-pad-perl amd64 0.808-1build3 [108 kB]
Get:130 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpackage-stash-xs-perl amd64 0.30-1build4 [18.7 kB]
Get:131 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpath-iterator-rule-perl all 1.015-2 [39.9 kB]
Get:132 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpath-tiny-perl all 0.144-1 [47.7 kB]
Get:133 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libperlio-gzip-perl amd64 0.20-1build4 [14.6 kB]
Get:134 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libperlio-utf8-strict-perl amd64 0.010-1build3 [11.1 kB]
Get:135 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpod-parser-perl all 1.67-1 [80.6 kB]
Get:136 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpod-constants-perl all 0.19-2 [16.3 kB]
Get:137 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libre-engine-re2-perl amd64 0.18+ds-1build3 [18.6 kB]
Get:138 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libregexp-pattern-license-perl all 3.11.0-1 [85.8 kB]
Get:139 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libregexp-pattern-perl all 0.2.14-2 [17.6 kB]
Get:140 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libregexp-wildcards-perl all 1.05-3 [12.9 kB]
Get:141 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsereal-decoder-perl amd64 5.004+ds-1build3 [99.5 kB]
Get:142 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsereal-encoder-perl amd64 5.004+ds-1build3 [103 kB]
Get:143 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libset-intspan-perl all 1.19-3 [24.8 kB]
Get:144 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsocket6-perl amd64 0.29-3build3 [17.5 kB]
Get:145 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libstring-copyright-perl all 0.003014-1 [20.5 kB]
Get:146 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libstring-escape-perl all 2010.002-3 [16.1 kB]
Get:147 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libstring-license-perl all 0.0.9-2ubuntu1 [35.0 kB]
Get:148 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libstring-shellquote-perl all 1.04-3 [11.3 kB]
Get:149 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsyntax-keyword-try-perl amd64 0.29-1build3 [24.3 kB]
Get:150 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtext-levenshteinxs-perl amd64 0.03-5build4 [7966 B]
Get:151 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtext-markdown-discount-perl amd64 0.16-1build3 [12.1 kB]
Get:152 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtext-xslate-perl amd64 3.5.9-1build5 [161 kB]
Get:153 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtime-duration-perl all 1.21-2 [12.3 kB]
Get:154 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtime-moment-perl amd64 0.44-2build4 [70.9 kB]
Get:155 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libunicode-utf8-perl amd64 0.62-2build3 [18.1 kB]
Get:156 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwww-mechanize-perl all 2.18-1ubuntu1 [93.1 kB]
Get:157 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libyaml-libyaml-perl amd64 0.89+ds-1ubuntu0.24.04.1 [30.7 kB]
Get:158 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 licensecheck all 3.3.9-1ubuntu1 [37.7 kB]
Get:159 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdevel-size-perl amd64 0.83-2build4 [19.6 kB]
Get:160 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libipc-run3-perl all 0.049-1 [28.8 kB]
Get:161 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 lzip amd64 1.24.1-1build1 [83.1 kB]
Get:162 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 lzop amd64 1.04-2build3 [82.2 kB]
Get:163 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 t1utils amd64 1.41-4build3 [61.3 kB]
Get:164 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 lintian all 2.117.0ubuntu1.5 [1063 kB]
Get:165 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-nacl amd64 1.5.0-4build1 [57.9 kB]
Get:166 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 python3-paramiko all 2.12.0-2ubuntu4.1 [137 kB]
Get:167 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-unidiff all 0.7.3-1 [11.0 kB]
Get:168 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 equivs all 2.3.1 [19.0 kB]
Get:169 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libauthen-sasl-perl all 2.1700-1 [42.9 kB]
Fetched 11.0 MB in 5s (2358 kB/s)
Selecting previously unselected package autopoint.
(Reading database ... (Reading database ... 5%(Reading database ... 10%(Reading database ... 15%(Reading database ... 20%(Reading database ... 25%(Reading database ... 30%(Reading database ... 35%(Reading database ... 40%(Reading database ... 45%(Reading database ... 50%(Reading database ... 55%(Reading database ... 60%(Reading database ... 65%(Reading database ... 70%(Reading database ... 75%(Reading database ... 80%(Reading database ... 85%(Reading database ... 90%(Reading database ... 95%(Reading database ... 100%(Reading database ... 201676 files and directories currently installed.)
Preparing to unpack .../000-autopoint_0.21-14ubuntu2_all.deb ...
Unpacking autopoint (0.21-14ubuntu2) ...
Selecting previously unselected package build-essential.
Preparing to unpack .../001-build-essential_12.10ubuntu1_amd64.deb ...
Unpacking build-essential (12.10ubuntu1) ...
Selecting previously unselected package dctrl-tools.
Preparing to unpack .../002-dctrl-tools_2.24-3build3_amd64.deb ...
Unpacking dctrl-tools (2.24-3build3) ...
Selecting previously unselected package libdebhelper-perl.
Preparing to unpack .../003-libdebhelper-perl_13.14.1ubuntu5_all.deb ...
Unpacking libdebhelper-perl (13.14.1ubuntu5) ...
Selecting previously unselected package dh-autoreconf.
Preparing to unpack .../004-dh-autoreconf_20_all.deb ...
Unpacking dh-autoreconf (20) ...
Selecting previously unselected package libarchive-zip-perl.
Preparing to unpack .../005-libarchive-zip-perl_1.68-1_all.deb ...
Unpacking libarchive-zip-perl (1.68-1) ...
Selecting previously unselected package libsub-override-perl.
Preparing to unpack .../006-libsub-override-perl_0.10-1_all.deb ...
Unpacking libsub-override-perl (0.10-1) ...
Selecting previously unselected package libfile-stripnondeterminism-perl.
Preparing to unpack .../007-libfile-stripnondeterminism-perl_1.13.1-1_all.deb ...
Unpacking libfile-stripnondeterminism-perl (1.13.1-1) ...
Selecting previously unselected package dh-strip-nondeterminism.
Preparing to unpack .../008-dh-strip-nondeterminism_1.13.1-1_all.deb ...
Unpacking dh-strip-nondeterminism (1.13.1-1) ...
Selecting previously unselected package dwz.
Preparing to unpack .../009-dwz_0.15-1build6_amd64.deb ...
Unpacking dwz (0.15-1build6) ...
Selecting previously unselected package gettext.
Preparing to unpack .../010-gettext_0.21-14ubuntu2_amd64.deb ...
Unpacking gettext (0.21-14ubuntu2) ...
Selecting previously unselected package intltool-debian.
Preparing to unpack .../011-intltool-debian_0.35.0+20060710.6_all.deb ...
Unpacking intltool-debian (0.35.0+20060710.6) ...
Selecting previously unselected package po-debconf.
Preparing to unpack .../012-po-debconf_1.0.21+nmu1_all.deb ...
Unpacking po-debconf (1.0.21+nmu1) ...
Selecting previously unselected package debhelper.
Preparing to unpack .../013-debhelper_13.14.1ubuntu5_all.deb ...
Unpacking debhelper (13.14.1ubuntu5) ...
Selecting previously unselected package libfile-dirlist-perl.
Preparing to unpack .../014-libfile-dirlist-perl_0.05-3_all.deb ...
Unpacking libfile-dirlist-perl (0.05-3) ...
Selecting previously unselected package libfile-which-perl.
Preparing to unpack .../015-libfile-which-perl_1.27-2_all.deb ...
Unpacking libfile-which-perl (1.27-2) ...
Selecting previously unselected package libfile-homedir-perl.
Preparing to unpack .../016-libfile-homedir-perl_1.006-2_all.deb ...
Unpacking libfile-homedir-perl (1.006-2) ...
Selecting previously unselected package libfile-touch-perl.
Preparing to unpack .../017-libfile-touch-perl_0.12-2_all.deb ...
Unpacking libfile-touch-perl (0.12-2) ...
Selecting previously unselected package libio-pty-perl.
Preparing to unpack .../018-libio-pty-perl_1%3a1.20-1build2_amd64.deb ...
Unpacking libio-pty-perl (1:1.20-1build2) ...
Selecting previously unselected package libipc-run-perl.
Preparing to unpack .../019-libipc-run-perl_20231003.0-1_all.deb ...
Unpacking libipc-run-perl (20231003.0-1) ...
Selecting previously unselected package libclass-method-modifiers-perl.
Preparing to unpack .../020-libclass-method-modifiers-perl_2.15-1_all.deb ...
Unpacking libclass-method-modifiers-perl (2.15-1) ...
Selecting previously unselected package libclass-xsaccessor-perl.
Preparing to unpack .../021-libclass-xsaccessor-perl_1.19-4build4_amd64.deb ...
Unpacking libclass-xsaccessor-perl (1.19-4build4) ...
Selecting previously unselected package libb-hooks-op-check-perl:amd64.
Preparing to unpack .../022-libb-hooks-op-check-perl_0.22-3build1_amd64.deb ...
Unpacking libb-hooks-op-check-perl:amd64 (0.22-3build1) ...
Selecting previously unselected package libdynaloader-functions-perl.
Preparing to unpack .../023-libdynaloader-functions-perl_0.003-3_all.deb ...
Unpacking libdynaloader-functions-perl (0.003-3) ...
Selecting previously unselected package libdevel-callchecker-perl:amd64.
Preparing to unpack .../024-libdevel-callchecker-perl_0.008-2build3_amd64.deb ...
Unpacking libdevel-callchecker-perl:amd64 (0.008-2build3) ...
Selecting previously unselected package libparams-classify-perl:amd64.
Preparing to unpack .../025-libparams-classify-perl_0.015-2build5_amd64.deb ...
Unpacking libparams-classify-perl:amd64 (0.015-2build5) ...
Selecting previously unselected package libmodule-runtime-perl.
Preparing to unpack .../026-libmodule-runtime-perl_0.016-2_all.deb ...
Unpacking libmodule-runtime-perl (0.016-2) ...
Selecting previously unselected package libimport-into-perl.
Preparing to unpack .../027-libimport-into-perl_1.002005-2_all.deb ...
Unpacking libimport-into-perl (1.002005-2) ...
Selecting previously unselected package librole-tiny-perl.
Preparing to unpack .../028-librole-tiny-perl_2.002004-1_all.deb ...
Unpacking librole-tiny-perl (2.002004-1) ...
Selecting previously unselected package libsub-quote-perl.
Preparing to unpack .../029-libsub-quote-perl_2.006008-1ubuntu1_all.deb ...
Unpacking libsub-quote-perl (2.006008-1ubuntu1) ...
Selecting previously unselected package libmoo-perl.
Preparing to unpack .../030-libmoo-perl_2.005005-1_all.deb ...
Unpacking libmoo-perl (2.005005-1) ...
Selecting previously unselected package libfile-listing-perl.
Preparing to unpack .../031-libfile-listing-perl_6.16-1_all.deb ...
Unpacking libfile-listing-perl (6.16-1) ...
Selecting previously unselected package libhtml-tree-perl.
Preparing to unpack .../032-libhtml-tree-perl_5.07-3_all.deb ...
Unpacking libhtml-tree-perl (5.07-3) ...
Selecting previously unselected package libhttp-cookies-perl.
Preparing to unpack .../033-libhttp-cookies-perl_6.11-1_all.deb ...
Unpacking libhttp-cookies-perl (6.11-1) ...
Selecting previously unselected package libhttp-negotiate-perl.
Preparing to unpack .../034-libhttp-negotiate-perl_6.01-2_all.deb ...
Unpacking libhttp-negotiate-perl (6.01-2) ...
Selecting previously unselected package perl-openssl-defaults:amd64.
Preparing to unpack .../035-perl-openssl-defaults_7build3_amd64.deb ...
Unpacking perl-openssl-defaults:amd64 (7build3) ...
Selecting previously unselected package libnet-ssleay-perl:amd64.
Preparing to unpack .../036-libnet-ssleay-perl_1.94-1build4_amd64.deb ...
Unpacking libnet-ssleay-perl:amd64 (1.94-1build4) ...
Selecting previously unselected package libio-socket-ssl-perl.
Preparing to unpack .../037-libio-socket-ssl-perl_2.085-1_all.deb ...
Unpacking libio-socket-ssl-perl (2.085-1) ...
Selecting previously unselected package libnet-http-perl.
Preparing to unpack .../038-libnet-http-perl_6.23-1_all.deb ...
Unpacking libnet-http-perl (6.23-1) ...
Selecting previously unselected package liblwp-protocol-https-perl.
Preparing to unpack .../039-liblwp-protocol-https-perl_6.13-1_all.deb ...
Unpacking liblwp-protocol-https-perl (6.13-1) ...
Selecting previously unselected package libtry-tiny-perl.
Preparing to unpack .../040-libtry-tiny-perl_0.31-2_all.deb ...
Unpacking libtry-tiny-perl (0.31-2) ...
Selecting previously unselected package libwww-robotrules-perl.
Preparing to unpack .../041-libwww-robotrules-perl_6.02-1_all.deb ...
Unpacking libwww-robotrules-perl (6.02-1) ...
Selecting previously unselected package libwww-perl.
Preparing to unpack .../042-libwww-perl_6.76-1ubuntu0.1_all.deb ...
Unpacking libwww-perl (6.76-1ubuntu0.1) ...
Selecting previously unselected package patchutils.
Preparing to unpack .../043-patchutils_0.4.2-1build3_amd64.deb ...
Unpacking patchutils (0.4.2-1build3) ...
Selecting previously unselected package wdiff.
Preparing to unpack .../044-wdiff_1.2.2-6build1_amd64.deb ...
Unpacking wdiff (1.2.2-6build1) ...
Selecting previously unselected package devscripts.
Preparing to unpack .../045-devscripts_2.23.7ubuntu0.2_all.deb ...
Unpacking devscripts (2.23.7ubuntu0.2) ...
Selecting previously unselected package diffstat.
Preparing to unpack .../046-diffstat_1.66-1build1_amd64.deb ...
Unpacking diffstat (1.66-1build1) ...
Selecting previously unselected package python3-gpg.
Preparing to unpack .../047-python3-gpg_1.18.0-4.1ubuntu4_amd64.deb ...
Unpacking python3-gpg (1.18.0-4.1ubuntu4) ...
Selecting previously unselected package python3-xdg.
Preparing to unpack .../048-python3-xdg_0.28-2_all.deb ...
Unpacking python3-xdg (0.28-2) ...
Selecting previously unselected package dput.
Preparing to unpack .../049-dput_1.1.3ubuntu3_all.deb ...
Unpacking dput (1.1.3ubuntu3) ...
Selecting previously unselected package libaliased-perl.
Preparing to unpack .../050-libaliased-perl_0.34-3_all.deb ...
Unpacking libaliased-perl (0.34-3) ...
Selecting previously unselected package libapt-pkg-perl.
Preparing to unpack .../051-libapt-pkg-perl_0.1.40build7_amd64.deb ...
Unpacking libapt-pkg-perl (0.1.40build7) ...
Selecting previously unselected package libarchive-cpio-perl.
Preparing to unpack .../052-libarchive-cpio-perl_0.10-3_all.deb ...
Unpacking libarchive-cpio-perl (0.10-3) ...
Selecting previously unselected package libarray-intspan-perl.
Preparing to unpack .../053-libarray-intspan-perl_2.004-2_all.deb ...
Unpacking libarray-intspan-perl (2.004-2) ...
Selecting previously unselected package libmodule-implementation-perl.
Preparing to unpack .../054-libmodule-implementation-perl_0.09-2_all.deb ...
Unpacking libmodule-implementation-perl (0.09-2) ...
Selecting previously unselected package libsub-exporter-progressive-perl.
Preparing to unpack .../055-libsub-exporter-progressive-perl_0.001013-3_all.deb ...
Unpacking libsub-exporter-progressive-perl (0.001013-3) ...
Selecting previously unselected package libvariable-magic-perl.
Preparing to unpack .../056-libvariable-magic-perl_0.63-1build3_amd64.deb ...
Unpacking libvariable-magic-perl (0.63-1build3) ...
Selecting previously unselected package libb-hooks-endofscope-perl.
Preparing to unpack .../057-libb-hooks-endofscope-perl_0.28-1_all.deb ...
Unpacking libb-hooks-endofscope-perl (0.28-1) ...
Selecting previously unselected package libberkeleydb-perl:amd64.
Preparing to unpack .../058-libberkeleydb-perl_0.64-2build4_amd64.deb ...
Unpacking libberkeleydb-perl:amd64 (0.64-2build4) ...
Selecting previously unselected package libcapture-tiny-perl.
Preparing to unpack .../059-libcapture-tiny-perl_0.48-2_all.deb ...
Unpacking libcapture-tiny-perl (0.48-2) ...
Selecting previously unselected package libclass-data-inheritable-perl.
Preparing to unpack .../060-libclass-data-inheritable-perl_0.08-3_all.deb ...
Unpacking libclass-data-inheritable-perl (0.08-3) ...
Selecting previously unselected package libconfig-tiny-perl.
Preparing to unpack .../061-libconfig-tiny-perl_2.30-1_all.deb ...
Unpacking libconfig-tiny-perl (2.30-1) ...
Selecting previously unselected package libparams-util-perl.
Preparing to unpack .../062-libparams-util-perl_1.102-2build3_amd64.deb ...
Unpacking libparams-util-perl (1.102-2build3) ...
Selecting previously unselected package libsub-install-perl.
Preparing to unpack .../063-libsub-install-perl_0.929-1_all.deb ...
Unpacking libsub-install-perl (0.929-1) ...
Selecting previously unselected package libdata-optlist-perl.
Preparing to unpack .../064-libdata-optlist-perl_0.114-1_all.deb ...
Unpacking libdata-optlist-perl (0.114-1) ...
Selecting previously unselected package libsub-exporter-perl.
Preparing to unpack .../065-libsub-exporter-perl_0.990-1_all.deb ...
Unpacking libsub-exporter-perl (0.990-1) ...
Selecting previously unselected package libconst-fast-perl.
Preparing to unpack .../066-libconst-fast-perl_0.014-2_all.deb ...
Unpacking libconst-fast-perl (0.014-2) ...
Selecting previously unselected package libcpanel-json-xs-perl:amd64.
Preparing to unpack .../067-libcpanel-json-xs-perl_4.37-1ubuntu0.1_amd64.deb ...
Unpacking libcpanel-json-xs-perl:amd64 (4.37-1ubuntu0.1) ...
Selecting previously unselected package libdevel-stacktrace-perl.
Preparing to unpack .../068-libdevel-stacktrace-perl_2.0500-1_all.deb ...
Unpacking libdevel-stacktrace-perl (2.0500-1) ...
Selecting previously unselected package libexception-class-perl.
Preparing to unpack .../069-libexception-class-perl_1.45-1_all.deb ...
Unpacking libexception-class-perl (1.45-1) ...
Selecting previously unselected package libiterator-perl.
Preparing to unpack .../070-libiterator-perl_0.03+ds1-2_all.deb ...
Unpacking libiterator-perl (0.03+ds1-2) ...
Selecting previously unselected package libiterator-util-perl.
Preparing to unpack .../071-libiterator-util-perl_0.02+ds1-2_all.deb ...
Unpacking libiterator-util-perl (0.02+ds1-2) ...
Selecting previously unselected package libdata-dpath-perl.
Preparing to unpack .../072-libdata-dpath-perl_0.59-1_all.deb ...
Unpacking libdata-dpath-perl (0.59-1) ...
Selecting previously unselected package libdata-dump-perl.
Preparing to unpack .../073-libdata-dump-perl_1.25-1_all.deb ...
Unpacking libdata-dump-perl (1.25-1) ...
Selecting previously unselected package libdata-messagepack-perl.
Preparing to unpack .../074-libdata-messagepack-perl_1.02-1build4_amd64.deb ...
Unpacking libdata-messagepack-perl (1.02-1build4) ...
Selecting previously unselected package libnet-domain-tld-perl.
Preparing to unpack .../075-libnet-domain-tld-perl_1.75-3_all.deb ...
Unpacking libnet-domain-tld-perl (1.75-3) ...
Selecting previously unselected package libdata-validate-domain-perl.
Preparing to unpack .../076-libdata-validate-domain-perl_0.10-1.1_all.deb ...
Unpacking libdata-validate-domain-perl (0.10-1.1) ...
Selecting previously unselected package libnet-ipv6addr-perl.
Preparing to unpack .../077-libnet-ipv6addr-perl_1.02-1_all.deb ...
Unpacking libnet-ipv6addr-perl (1.02-1) ...
Selecting previously unselected package libnet-netmask-perl.
Preparing to unpack .../078-libnet-netmask-perl_2.0002-2_all.deb ...
Unpacking libnet-netmask-perl (2.0002-2) ...
Selecting previously unselected package libnetaddr-ip-perl.
Preparing to unpack .../079-libnetaddr-ip-perl_4.079+dfsg-2build4_amd64.deb ...
Unpacking libnetaddr-ip-perl (4.079+dfsg-2build4) ...
Selecting previously unselected package libdata-validate-ip-perl.
Preparing to unpack .../080-libdata-validate-ip-perl_0.31-1_all.deb ...
Unpacking libdata-validate-ip-perl (0.31-1) ...
Selecting previously unselected package libdata-validate-uri-perl.
Preparing to unpack .../081-libdata-validate-uri-perl_0.07-3_all.deb ...
Unpacking libdata-validate-uri-perl (0.07-3) ...
Selecting previously unselected package libdistro-info-perl.
Preparing to unpack .../082-libdistro-info-perl_1.7build1_all.deb ...
Unpacking libdistro-info-perl (1.7build1) ...
Selecting previously unselected package libemail-address-xs-perl.
Preparing to unpack .../083-libemail-address-xs-perl_1.05-1build4_amd64.deb ...
Unpacking libemail-address-xs-perl (1.05-1build4) ...
Selecting previously unselected package libexporter-tiny-perl.
Preparing to unpack .../084-libexporter-tiny-perl_1.006002-1_all.deb ...
Unpacking libexporter-tiny-perl (1.006002-1) ...
Selecting previously unselected package libipc-system-simple-perl.
Preparing to unpack .../085-libipc-system-simple-perl_1.30-2_all.deb ...
Unpacking libipc-system-simple-perl (1.30-2) ...
Selecting previously unselected package libfile-basedir-perl.
Preparing to unpack .../086-libfile-basedir-perl_0.09-2_all.deb ...
Unpacking libfile-basedir-perl (0.09-2) ...
Selecting previously unselected package libfile-chdir-perl.
Preparing to unpack .../087-libfile-chdir-perl_0.1008-1.1_all.deb ...
Unpacking libfile-chdir-perl (0.1008-1.1) ...
Selecting previously unselected package libnumber-compare-perl.
Preparing to unpack .../088-libnumber-compare-perl_0.03-3_all.deb ...
Unpacking libnumber-compare-perl (0.03-3) ...
Selecting previously unselected package libtext-glob-perl.
Preparing to unpack .../089-libtext-glob-perl_0.11-3_all.deb ...
Unpacking libtext-glob-perl (0.11-3) ...
Selecting previously unselected package libfile-find-rule-perl.
Preparing to unpack .../090-libfile-find-rule-perl_0.34-3ubuntu0.24.04.1_all.deb ...
Unpacking libfile-find-rule-perl (0.34-3ubuntu0.24.04.1) ...
Selecting previously unselected package libfont-afm-perl.
Preparing to unpack .../091-libfont-afm-perl_1.20-4_all.deb ...
Unpacking libfont-afm-perl (1.20-4) ...
Selecting previously unselected package libio-string-perl.
Preparing to unpack .../092-libio-string-perl_1.08-4_all.deb ...
Unpacking libio-string-perl (1.08-4) ...
Selecting previously unselected package libfont-ttf-perl.
Preparing to unpack .../093-libfont-ttf-perl_1.06-2_all.deb ...
Unpacking libfont-ttf-perl (1.06-2) ...
Selecting previously unselected package libfreezethaw-perl.
Preparing to unpack .../094-libfreezethaw-perl_0.5001-3_all.deb ...
Unpacking libfreezethaw-perl (0.5001-3) ...
Selecting previously unselected package libsort-versions-perl.
Preparing to unpack .../095-libsort-versions-perl_1.62-3_all.deb ...
Unpacking libsort-versions-perl (1.62-3) ...
Selecting previously unselected package libgit-wrapper-perl.
Preparing to unpack .../096-libgit-wrapper-perl_0.048-2_all.deb ...
Unpacking libgit-wrapper-perl (0.048-2) ...
Selecting previously unselected package libhtml-form-perl.
Preparing to unpack .../097-libhtml-form-perl_6.11-1_all.deb ...
Unpacking libhtml-form-perl (6.11-1) ...
Selecting previously unselected package libhtml-format-perl.
Preparing to unpack .../098-libhtml-format-perl_2.16-2_all.deb ...
Unpacking libhtml-format-perl (2.16-2) ...
Selecting previously unselected package libhtml-html5-entities-perl.
Preparing to unpack .../099-libhtml-html5-entities-perl_0.004-3_all.deb ...
Unpacking libhtml-html5-entities-perl (0.004-3) ...
Selecting previously unselected package libhtml-tokeparser-simple-perl.
Preparing to unpack .../100-libhtml-tokeparser-simple-perl_3.16-4_all.deb ...
Unpacking libhtml-tokeparser-simple-perl (3.16-4) ...
Selecting previously unselected package libhttp-daemon-perl.
Preparing to unpack .../101-libhttp-daemon-perl_6.16-1ubuntu0.24.04.1_all.deb ...
Unpacking libhttp-daemon-perl (6.16-1ubuntu0.24.04.1) ...
Selecting previously unselected package libindirect-perl.
Preparing to unpack .../102-libindirect-perl_0.39-2build4_amd64.deb ...
Unpacking libindirect-perl (0.39-2build4) ...
Selecting previously unselected package libio-interactive-perl.
Preparing to unpack .../103-libio-interactive-perl_1.025-1_all.deb ...
Unpacking libio-interactive-perl (1.025-1) ...
Selecting previously unselected package libjson-maybexs-perl.
Preparing to unpack .../104-libjson-maybexs-perl_1.004005-1_all.deb ...
Unpacking libjson-maybexs-perl (1.004005-1) ...
Selecting previously unselected package liblist-compare-perl.
Preparing to unpack .../105-liblist-compare-perl_0.55-2_all.deb ...
Unpacking liblist-compare-perl (0.55-2) ...
Selecting previously unselected package liblist-someutils-perl.
Preparing to unpack .../106-liblist-someutils-perl_0.59-1_all.deb ...
Unpacking liblist-someutils-perl (0.59-1) ...
Selecting previously unselected package liblist-someutils-xs-perl:amd64.
Preparing to unpack .../107-liblist-someutils-xs-perl_0.58-3build4_amd64.deb ...
Unpacking liblist-someutils-xs-perl:amd64 (0.58-3build4) ...
Selecting previously unselected package liblist-utilsby-perl.
Preparing to unpack .../108-liblist-utilsby-perl_0.12-2_all.deb ...
Unpacking liblist-utilsby-perl (0.12-2) ...
Selecting previously unselected package liblog-any-perl.
Preparing to unpack .../109-liblog-any-perl_1.717-1_all.deb ...
Unpacking liblog-any-perl (1.717-1) ...
Selecting previously unselected package liblog-any-adapter-screen-perl.
Preparing to unpack .../110-liblog-any-adapter-screen-perl_0.140-2_all.deb ...
Unpacking liblog-any-adapter-screen-perl (0.140-2) ...
Selecting previously unselected package libsys-hostname-long-perl.
Preparing to unpack .../111-libsys-hostname-long-perl_1.5-3_all.deb ...
Unpacking libsys-hostname-long-perl (1.5-3) ...
Selecting previously unselected package libmail-sendmail-perl.
Preparing to unpack .../112-libmail-sendmail-perl_0.80-3_all.deb ...
Unpacking libmail-sendmail-perl (0.80-3) ...
Selecting previously unselected package libnet-smtp-ssl-perl.
Preparing to unpack .../113-libnet-smtp-ssl-perl_1.04-2_all.deb ...
Unpacking libnet-smtp-ssl-perl (1.04-2) ...
Selecting previously unselected package libmailtools-perl.
Preparing to unpack .../114-libmailtools-perl_2.21-2_all.deb ...
Unpacking libmailtools-perl (2.21-2) ...
Selecting previously unselected package libmarkdown2:amd64.
Preparing to unpack .../115-libmarkdown2_2.2.7-2build1_amd64.deb ...
Unpacking libmarkdown2:amd64 (2.2.7-2build1) ...
Selecting previously unselected package libmath-base85-perl.
Preparing to unpack .../116-libmath-base85-perl_0.5+dfsg-2_all.deb ...
Unpacking libmath-base85-perl (0.5+dfsg-2) ...
Selecting previously unselected package libmldbm-perl.
Preparing to unpack .../117-libmldbm-perl_2.05-4_all.deb ...
Unpacking libmldbm-perl (2.05-4) ...
Selecting previously unselected package libstrictures-perl.
Preparing to unpack .../118-libstrictures-perl_2.000006-1_all.deb ...
Unpacking libstrictures-perl (2.000006-1) ...
Selecting previously unselected package libmoox-aliases-perl.
Preparing to unpack .../119-libmoox-aliases-perl_0.001006-2_all.deb ...
Unpacking libmoox-aliases-perl (0.001006-2) ...
Selecting previously unselected package libmouse-perl.
Preparing to unpack .../120-libmouse-perl_2.5.10-1build8_amd64.deb ...
Unpacking libmouse-perl (2.5.10-1build8) ...
Selecting previously unselected package libpackage-stash-perl.
Preparing to unpack .../121-libpackage-stash-perl_0.40-1_all.deb ...
Unpacking libpackage-stash-perl (0.40-1) ...
Selecting previously unselected package libsub-identify-perl.
Preparing to unpack .../122-libsub-identify-perl_0.14-3build3_amd64.deb ...
Unpacking libsub-identify-perl (0.14-3build3) ...
Selecting previously unselected package libsub-name-perl:amd64.
Preparing to unpack .../123-libsub-name-perl_0.27-1build3_amd64.deb ...
Unpacking libsub-name-perl:amd64 (0.27-1build3) ...
Selecting previously unselected package libnamespace-clean-perl.
Preparing to unpack .../124-libnamespace-clean-perl_0.27-2_all.deb ...
Unpacking libnamespace-clean-perl (0.27-2) ...
Selecting previously unselected package libxs-parse-keyword-perl.
Preparing to unpack .../125-libxs-parse-keyword-perl_0.39-1build3_amd64.deb ...
Unpacking libxs-parse-keyword-perl (0.39-1build3) ...
Selecting previously unselected package libxs-parse-sublike-perl:amd64.
Preparing to unpack .../126-libxs-parse-sublike-perl_0.21-2build3_amd64.deb ...
Unpacking libxs-parse-sublike-perl:amd64 (0.21-2build3) ...
Selecting previously unselected package libobject-pad-perl.
Preparing to unpack .../127-libobject-pad-perl_0.808-1build3_amd64.deb ...
Unpacking libobject-pad-perl (0.808-1build3) ...
Selecting previously unselected package libpackage-stash-xs-perl:amd64.
Preparing to unpack .../128-libpackage-stash-xs-perl_0.30-1build4_amd64.deb ...
Unpacking libpackage-stash-xs-perl:amd64 (0.30-1build4) ...
Selecting previously unselected package libpath-iterator-rule-perl.
Preparing to unpack .../129-libpath-iterator-rule-perl_1.015-2_all.deb ...
Unpacking libpath-iterator-rule-perl (1.015-2) ...
Selecting previously unselected package libpath-tiny-perl.
Preparing to unpack .../130-libpath-tiny-perl_0.144-1_all.deb ...
Unpacking libpath-tiny-perl (0.144-1) ...
Selecting previously unselected package libperlio-gzip-perl.
Preparing to unpack .../131-libperlio-gzip-perl_0.20-1build4_amd64.deb ...
Unpacking libperlio-gzip-perl (0.20-1build4) ...
Selecting previously unselected package libperlio-utf8-strict-perl.
Preparing to unpack .../132-libperlio-utf8-strict-perl_0.010-1build3_amd64.deb ...
Unpacking libperlio-utf8-strict-perl (0.010-1build3) ...
Selecting previously unselected package libpod-parser-perl.
Preparing to unpack .../133-libpod-parser-perl_1.67-1_all.deb ...
Adding 'diversion of /usr/bin/podselect to /usr/bin/podselect.bundled by libpod-parser-perl'
Adding 'diversion of /usr/share/man/man1/podselect.1.gz to /usr/share/man/man1/podselect.bundled.1.gz by libpod-parser-perl'
Unpacking libpod-parser-perl (1.67-1) ...
Selecting previously unselected package libpod-constants-perl.
Preparing to unpack .../134-libpod-constants-perl_0.19-2_all.deb ...
Unpacking libpod-constants-perl (0.19-2) ...
Selecting previously unselected package libre-engine-re2-perl:amd64.
Preparing to unpack .../135-libre-engine-re2-perl_0.18+ds-1build3_amd64.deb ...
Unpacking libre-engine-re2-perl:amd64 (0.18+ds-1build3) ...
Selecting previously unselected package libregexp-pattern-license-perl.
Preparing to unpack .../136-libregexp-pattern-license-perl_3.11.0-1_all.deb ...
Unpacking libregexp-pattern-license-perl (3.11.0-1) ...
Selecting previously unselected package libregexp-pattern-perl.
Preparing to unpack .../137-libregexp-pattern-perl_0.2.14-2_all.deb ...
Unpacking libregexp-pattern-perl (0.2.14-2) ...
Selecting previously unselected package libregexp-wildcards-perl.
Preparing to unpack .../138-libregexp-wildcards-perl_1.05-3_all.deb ...
Unpacking libregexp-wildcards-perl (1.05-3) ...
Selecting previously unselected package libsereal-decoder-perl.
Preparing to unpack .../139-libsereal-decoder-perl_5.004+ds-1build3_amd64.deb ...
Unpacking libsereal-decoder-perl (5.004+ds-1build3) ...
Selecting previously unselected package libsereal-encoder-perl.
Preparing to unpack .../140-libsereal-encoder-perl_5.004+ds-1build3_amd64.deb ...
Unpacking libsereal-encoder-perl (5.004+ds-1build3) ...
Selecting previously unselected package libset-intspan-perl.
Preparing to unpack .../141-libset-intspan-perl_1.19-3_all.deb ...
Unpacking libset-intspan-perl (1.19-3) ...
Selecting previously unselected package libsocket6-perl.
Preparing to unpack .../142-libsocket6-perl_0.29-3build3_amd64.deb ...
Unpacking libsocket6-perl (0.29-3build3) ...
Selecting previously unselected package libstring-copyright-perl.
Preparing to unpack .../143-libstring-copyright-perl_0.003014-1_all.deb ...
Unpacking libstring-copyright-perl (0.003014-1) ...
Selecting previously unselected package libstring-escape-perl.
Preparing to unpack .../144-libstring-escape-perl_2010.002-3_all.deb ...
Unpacking libstring-escape-perl (2010.002-3) ...
Selecting previously unselected package libstring-license-perl.
Preparing to unpack .../145-libstring-license-perl_0.0.9-2ubuntu1_all.deb ...
Unpacking libstring-license-perl (0.0.9-2ubuntu1) ...
Selecting previously unselected package libstring-shellquote-perl.
Preparing to unpack .../146-libstring-shellquote-perl_1.04-3_all.deb ...
Unpacking libstring-shellquote-perl (1.04-3) ...
Selecting previously unselected package libsyntax-keyword-try-perl.
Preparing to unpack .../147-libsyntax-keyword-try-perl_0.29-1build3_amd64.deb ...
Unpacking libsyntax-keyword-try-perl (0.29-1build3) ...
Selecting previously unselected package libtext-levenshteinxs-perl.
Preparing to unpack .../148-libtext-levenshteinxs-perl_0.03-5build4_amd64.deb ...
Unpacking libtext-levenshteinxs-perl (0.03-5build4) ...
Selecting previously unselected package libtext-markdown-discount-perl.
Preparing to unpack .../149-libtext-markdown-discount-perl_0.16-1build3_amd64.deb ...
Unpacking libtext-markdown-discount-perl (0.16-1build3) ...
Selecting previously unselected package libtext-xslate-perl:amd64.
Preparing to unpack .../150-libtext-xslate-perl_3.5.9-1build5_amd64.deb ...
Unpacking libtext-xslate-perl:amd64 (3.5.9-1build5) ...
Selecting previously unselected package libtime-duration-perl.
Preparing to unpack .../151-libtime-duration-perl_1.21-2_all.deb ...
Unpacking libtime-duration-perl (1.21-2) ...
Selecting previously unselected package libtime-moment-perl.
Preparing to unpack .../152-libtime-moment-perl_0.44-2build4_amd64.deb ...
Unpacking libtime-moment-perl (0.44-2build4) ...
Selecting previously unselected package libunicode-utf8-perl.
Preparing to unpack .../153-libunicode-utf8-perl_0.62-2build3_amd64.deb ...
Unpacking libunicode-utf8-perl (0.62-2build3) ...
Selecting previously unselected package libwww-mechanize-perl.
Preparing to unpack .../154-libwww-mechanize-perl_2.18-1ubuntu1_all.deb ...
Unpacking libwww-mechanize-perl (2.18-1ubuntu1) ...
Selecting previously unselected package libyaml-libyaml-perl.
Preparing to unpack .../155-libyaml-libyaml-perl_0.89+ds-1ubuntu0.24.04.1_amd64.deb ...
Unpacking libyaml-libyaml-perl (0.89+ds-1ubuntu0.24.04.1) ...
Selecting previously unselected package licensecheck.
Preparing to unpack .../156-licensecheck_3.3.9-1ubuntu1_all.deb ...
Unpacking licensecheck (3.3.9-1ubuntu1) ...
Selecting previously unselected package libdevel-size-perl.
Preparing to unpack .../157-libdevel-size-perl_0.83-2build4_amd64.deb ...
Unpacking libdevel-size-perl (0.83-2build4) ...
Selecting previously unselected package libipc-run3-perl.
Preparing to unpack .../158-libipc-run3-perl_0.049-1_all.deb ...
Unpacking libipc-run3-perl (0.049-1) ...
Selecting previously unselected package lzip.
Preparing to unpack .../159-lzip_1.24.1-1build1_amd64.deb ...
Unpacking lzip (1.24.1-1build1) ...
Selecting previously unselected package lzop.
Preparing to unpack .../160-lzop_1.04-2build3_amd64.deb ...
Unpacking lzop (1.04-2build3) ...
Selecting previously unselected package t1utils.
Preparing to unpack .../161-t1utils_1.41-4build3_amd64.deb ...
Unpacking t1utils (1.41-4build3) ...
Selecting previously unselected package lintian.
Preparing to unpack .../162-lintian_2.117.0ubuntu1.5_all.deb ...
Unpacking lintian (2.117.0ubuntu1.5) ...
Selecting previously unselected package python3-nacl.
Preparing to unpack .../163-python3-nacl_1.5.0-4build1_amd64.deb ...
Unpacking python3-nacl (1.5.0-4build1) ...
Selecting previously unselected package python3-paramiko.
Preparing to unpack .../164-python3-paramiko_2.12.0-2ubuntu4.1_all.deb ...
Unpacking python3-paramiko (2.12.0-2ubuntu4.1) ...
Selecting previously unselected package python3-unidiff.
Preparing to unpack .../165-python3-unidiff_0.7.3-1_all.deb ...
Unpacking python3-unidiff (0.7.3-1) ...
Selecting previously unselected package equivs.
Preparing to unpack .../166-equivs_2.3.1_all.deb ...
Unpacking equivs (2.3.1) ...
Selecting previously unselected package libauthen-sasl-perl.
Preparing to unpack .../167-libauthen-sasl-perl_2.1700-1_all.deb ...
Unpacking libauthen-sasl-perl (2.1700-1) ...
Setting up libapt-pkg-perl (0.1.40build7) ...
Setting up libstring-escape-perl (2010.002-3) ...
Setting up libberkeleydb-perl:amd64 (0.64-2build4) ...
Setting up wdiff (1.2.2-6build1) ...
Setting up libhttp-negotiate-perl (6.01-2) ...
Setting up libfile-which-perl (1.27-2) ...
Setting up gettext (0.21-14ubuntu2) ...
Setting up libunicode-utf8-perl (0.62-2build3) ...
Setting up libset-intspan-perl (1.19-3) ...
Setting up libmouse-perl (2.5.10-1build8) ...
Setting up libfile-listing-perl (6.16-1) ...
Setting up libregexp-pattern-perl (0.2.14-2) ...
Setting up libdata-messagepack-perl (1.02-1build4) ...
Setting up libfont-afm-perl (1.20-4) ...
Setting up libdynaloader-functions-perl (0.003-3) ...
Setting up libtext-glob-perl (0.11-3) ...
Setting up libclass-method-modifiers-perl (2.15-1) ...
Setting up liblist-compare-perl (0.55-2) ...
Setting up libio-pty-perl (1:1.20-1build2) ...
Setting up libhttp-cookies-perl (6.11-1) ...
Setting up libarchive-zip-perl (1.68-1) ...
Setting up libsub-identify-perl (0.14-3build3) ...
Setting up libdistro-info-perl (1.7build1) ...
Setting up libcpanel-json-xs-perl:amd64 (4.37-1ubuntu0.1) ...
Setting up liblog-any-perl (1.717-1) ...
Setting up libauthen-sasl-perl (2.1700-1) ...
Setting up libhtml-tree-perl (5.07-3) ...
Setting up libdevel-size-perl (0.83-2build4) ...
Setting up libdebhelper-perl (13.14.1ubuntu5) ...
Setting up libregexp-pattern-license-perl (3.11.0-1) ...
Setting up libyaml-libyaml-perl (0.89+ds-1ubuntu0.24.04.1) ...
Setting up libio-interactive-perl (1.025-1) ...
Setting up libtry-tiny-perl (0.31-2) ...
Setting up perl-openssl-defaults:amd64 (7build3) ...
Setting up libmldbm-perl (2.05-4) ...
Setting up libnet-http-perl (6.23-1) ...
Setting up libtime-moment-perl (0.44-2build4) ...
Setting up libhtml-format-perl (2.16-2) ...
Setting up libmath-base85-perl (0.5+dfsg-2) ...
Setting up python3-xdg (0.28-2) ...
Setting up libconfig-tiny-perl (2.30-1) ...
Setting up libsereal-encoder-perl (5.004+ds-1build3) ...
Setting up liblist-utilsby-perl (0.12-2) ...
Setting up libstring-shellquote-perl (1.04-3) ...
Setting up libnet-netmask-perl (2.0002-2) ...
Setting up libsub-install-perl (0.929-1) ...
Setting up libindirect-perl (0.39-2build4) ...
Setting up libxs-parse-sublike-perl:amd64 (0.21-2build3) ...
Setting up libnumber-compare-perl (0.03-3) ...
Setting up intltool-debian (0.35.0+20060710.6) ...
Setting up libfreezethaw-perl (0.5001-3) ...
Setting up patchutils (0.4.2-1build3) ...
Setting up libjson-maybexs-perl (1.004005-1) ...
Setting up libio-string-perl (1.08-4) ...
Setting up libnetaddr-ip-perl (4.079+dfsg-2build4) ...
Setting up libpackage-stash-xs-perl:amd64 (0.30-1build4) ...
Setting up libclass-data-inheritable-perl (0.08-3) ...
Setting up libxs-parse-keyword-perl (0.39-1build3) ...
Setting up python3-gpg (1.18.0-4.1ubuntu4) ...
Setting up libdata-dump-perl (1.25-1) ...
Setting up libfile-find-rule-perl (0.34-3ubuntu0.24.04.1) ...
Setting up libipc-system-simple-perl (1.30-2) ...
Setting up libnet-domain-tld-perl (1.75-3) ...
Setting up libperlio-utf8-strict-perl (0.010-1build3) ...
Setting up libsocket6-perl (0.29-3build3) ...
Setting up lzip (1.24.1-1build1) ...
update-alternatives: using /usr/bin/lzip.lzip to provide /usr/bin/lzip (lzip) in auto mode
update-alternatives: using /usr/bin/lzip.lzip to provide /usr/bin/lzip-compressor (lzip-compressor) in auto mode
update-alternatives: using /usr/bin/lzip.lzip to provide /usr/bin/lzip-decompressor (lzip-decompressor) in auto mode
Setting up t1utils (1.41-4build3) ...
Setting up diffstat (1.66-1build1) ...
Setting up libvariable-magic-perl (0.63-1build3) ...
Setting up libpod-parser-perl (1.67-1) ...
Setting up autopoint (0.21-14ubuntu2) ...
Setting up libb-hooks-op-check-perl:amd64 (0.22-3build1) ...
Setting up libipc-run-perl (20231003.0-1) ...
Setting up libparams-util-perl (1.102-2build3) ...
Setting up libtime-duration-perl (1.21-2) ...
Setting up libtext-xslate-perl:amd64 (3.5.9-1build5) ...
Setting up libsub-exporter-progressive-perl (0.001013-3) ...
Setting up libarray-intspan-perl (2.004-2) ...
Setting up libcapture-tiny-perl (0.48-2) ...
Setting up libsub-name-perl:amd64 (0.27-1build3) ...
Setting up libwww-robotrules-perl (6.02-1) ...
Setting up libsyntax-keyword-try-perl (0.29-1build3) ...
Setting up dwz (0.15-1build6) ...
Setting up libdata-validate-domain-perl (0.10-1.1) ...
Setting up libhttp-daemon-perl (6.16-1ubuntu0.24.04.1) ...
Setting up libfile-chdir-perl (0.1008-1.1) ...
Setting up libpath-tiny-perl (0.144-1) ...
Setting up libarchive-cpio-perl (0.10-3) ...
Setting up lzop (1.04-2build3) ...
Setting up liblog-any-adapter-screen-perl (0.140-2) ...
Setting up librole-tiny-perl (2.002004-1) ...
Setting up libipc-run3-perl (0.049-1) ...
Setting up libregexp-wildcards-perl (1.05-3) ...
Setting up build-essential (12.10ubuntu1) ...
Setting up libsub-override-perl (0.10-1) ...
Setting up libaliased-perl (0.34-3) ...
Setting up python3-unidiff (0.7.3-1) ...
Setting up libstrictures-perl (2.000006-1) ...
Setting up libsub-quote-perl (2.006008-1ubuntu1) ...
Setting up libdevel-stacktrace-perl (2.0500-1) ...
Setting up libclass-xsaccessor-perl (1.19-4build4) ...
Setting up libsort-versions-perl (1.62-3) ...
Setting up libexporter-tiny-perl (1.006002-1) ...
Setting up libre-engine-re2-perl:amd64 (0.18+ds-1build3) ...
Setting up libfile-dirlist-perl (0.05-3) ...
Setting up libfont-ttf-perl (1.06-2) ...
Setting up libfile-homedir-perl (1.006-2) ...
Setting up libtext-levenshteinxs-perl (0.03-5build4) ...
Setting up libperlio-gzip-perl (0.20-1build4) ...
Setting up libsys-hostname-long-perl (1.5-3) ...
Setting up libhtml-html5-entities-perl (0.004-3) ...
Setting up libsereal-decoder-perl (5.004+ds-1build3) ...
Setting up libmarkdown2:amd64 (2.2.7-2build1) ...
Setting up libnet-ipv6addr-perl (1.02-1) ...
Setting up libfile-touch-perl (0.12-2) ...
Setting up python3-nacl (1.5.0-4build1) ...
Setting up dctrl-tools (2.24-3build3) ...
Setting up libdata-validate-ip-perl (0.31-1) ...
Setting up libhtml-form-perl (6.11-1) ...
Setting up libemail-address-xs-perl (1.05-1build4) ...
Setting up libnet-ssleay-perl:amd64 (1.94-1build4) ...
Setting up libfile-stripnondeterminism-perl (1.13.1-1) ...
Setting up libfile-basedir-perl (0.09-2) ...
Setting up po-debconf (1.0.21+nmu1) ...
Setting up libpod-constants-perl (0.19-2) ...
Setting up libpath-iterator-rule-perl (1.015-2) ...
Setting up libtext-markdown-discount-perl (0.16-1build3) ...
Setting up libexception-class-perl (1.45-1) ...
Setting up libdevel-callchecker-perl:amd64 (0.008-2build3) ...
Setting up dput (1.1.3ubuntu3) ...
Setting up libobject-pad-perl (0.808-1build3) ...
Setting up dh-autoreconf (20) ...
Setting up libmail-sendmail-perl (0.80-3) ...
Setting up libdata-validate-uri-perl (0.07-3) ...
Setting up libstring-copyright-perl (0.003014-1) ...
Setting up libdata-optlist-perl (0.114-1) ...
Setting up dh-strip-nondeterminism (1.13.1-1) ...
Setting up libgit-wrapper-perl (0.048-2) ...
Setting up python3-paramiko (2.12.0-2ubuntu4.1) ...
Setting up libio-socket-ssl-perl (2.085-1) ...
Setting up libsub-exporter-perl (0.990-1) ...
Setting up libiterator-perl (0.03+ds1-2) ...
Setting up libiterator-util-perl (0.02+ds1-2) ...
Setting up libparams-classify-perl:amd64 (0.015-2build5) ...
Setting up debhelper (13.14.1ubuntu5) ...
Setting up libnet-smtp-ssl-perl (1.04-2) ...
Setting up libmodule-runtime-perl (0.016-2) ...
Setting up libmailtools-perl (2.21-2) ...
Setting up equivs (2.3.1) ...
Setting up libconst-fast-perl (0.014-2) ...
Setting up libdata-dpath-perl (0.59-1) ...
Setting up libmodule-implementation-perl (0.09-2) ...
Setting up libpackage-stash-perl (0.40-1) ...
Setting up libimport-into-perl (1.002005-2) ...
Setting up libmoo-perl (2.005005-1) ...
Setting up liblist-someutils-perl (0.59-1) ...
Setting up liblist-someutils-xs-perl:amd64 (0.58-3build4) ...
Setting up libmoox-aliases-perl (0.001006-2) ...
Setting up libb-hooks-endofscope-perl (0.28-1) ...
Setting up libnamespace-clean-perl (0.27-2) ...
Setting up libstring-license-perl (0.0.9-2ubuntu1) ...
Setting up licensecheck (3.3.9-1ubuntu1) ...
Setting up liblwp-protocol-https-perl (6.13-1) ...
Setting up libwww-perl (6.76-1ubuntu0.1) ...
Setting up libhtml-tokeparser-simple-perl (3.16-4) ...
Setting up libwww-mechanize-perl (2.18-1ubuntu1) ...
Setting up devscripts (2.23.7ubuntu0.2) ...
Setting up lintian (2.117.0ubuntu1.5) ...
Processing triggers for man-db (2.12.0-4build2) ...
Not building database; man-db/auto-update is not 'true'.
Processing triggers for install-info (7.1-3build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.8) ...
checked-out-commit=8bf4605ae81042248add031e94c77300406e0413
D: Found operating system 'linux-gnu'.
I: Argument uspace is accepted for compatibility, but ignored
I: Successfully configured for 'uspace-Ubuntu-24.04'.
I: You can now start the build of LinuxCNC Debian packages.
   To build and test everything: fakeroot debian/rules binary
   To build the executables and man pages only: fakeroot debian/rules binary-arch
   To avoid tests: DEB_BUILD_OPTIONS=nocheck debian/rules binary
   To avoid documentation: DEB_BUILD_OPTIONS=nodocs fakeroot debian/rules binary
   The DEB_BUILD_OPTIONS environment variable also works with dpkg-buildpackage.
W: To successfully build all of LinuxCNC, install the following build dependencies are mising:
     dh-python libudev-dev imagemagick asciidoctor libunicode-linebreak-perl bwidget (>= 1.7) desktop-file-utils intltool libboost-python-dev libepoxy-dev libgl-dev | libgl1-mesa-dev libglu1-mesa-dev libgtk-3-dev libcap-dev libmodbus-dev (>= 3.0) libgpiod-dev libeditreadline-dev libtirpc-dev libusb-1.0-0-dev libxmu-dev netpbm po4a python3-pybind11 python3-tk python3-xlib tcl8.6-dev tclx tk8.6-dev x11-xserver-utils x11-utils gdb python3-opengl python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtsvg python3-pyqt5.qtopengl python3-pyqt5.qtwebengine pyqt5-dev-tools python3-dbus.mainloop.pyqt5 python3-qtpy python3-zmq python3-cairo python3-gi-cairo gir1.2-gtk-3.0 gir1.2-gtksource-4 python3-numpy libfmt-dev yapps2 asciidoctor-pdf | ruby-asciidoctor-pdf fonts-noto-cjk ghostscript graphviz librsvg2-bin python3-fonttools ruby-rouge w3c-linkchecker
   The missing packages are auto-installed by
     sudo apt build-dep .
Note, using directory '.' to get the build dependencies
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  asciidoctor blt bwidget desktop-file-utils dh-python fonts-noto-cjk
  fonts-urw-base35 gdb ghostscript gir1.2-atk-1.0 gir1.2-atspi-2.0
  gir1.2-freedesktop gir1.2-freedesktop-dev gir1.2-gdkpixbuf-2.0
  gir1.2-glib-2.0-dev gir1.2-gtk-3.0 gir1.2-gtksource-4 gir1.2-harfbuzz-0.0
  gir1.2-pango-1.0 graphviz imagemagick imagemagick-6.q16 intltool libann0
  libasyncns0 libatk-bridge2.0-dev libatk1.0-dev libatspi2.0-dev
  libbabeltrace1 libblas3 libblkid-dev libboost-python-dev
  libboost-python1.83-dev libboost-python1.83.0 libboost1.83-dev libbrotli-dev
  libbsd-dev libbz2-dev libcairo-script-interpreter2 libcairo2-dev libcap-dev
  libcdt5 libcgraph6 libconfig-general-perl libcss-dom-perl libdatrie-dev
  libdbus-1-dev libdebuginfod-common libdebuginfod1t64 libdeflate-dev
  libdouble-conversion3 libedit-dev libeditreadline-dev libegl-dev
  libegl-mesa0 libegl1 libegl1-mesa-dev libepoxy-dev libevent-2.1-7t64
  libflac12t64 libfmt-dev libfmt9 libfontconfig-dev libfreetype-dev
  libfribidi-dev libgdk-pixbuf-2.0-dev libgdk-pixbuf2.0-bin
  libgirepository-2.0-0 libgl-dev libgles-dev libgles1 libgles2 libglib2.0-dev
  libglib2.0-dev-bin libglu1-mesa libglu1-mesa-dev libglvnd-core-dev
  libglvnd-dev libglx-dev libgpiod-dev libgpiod2t64 libgraphite2-dev
  libgs-common libgs10 libgs10-common libgstreamer-plugins-base1.0-0
  libgtk-3-dev libgtksourceview-4-0 libgtksourceview-4-common libgts-0.7-5t64
  libgvc6 libgvpr2 libharfbuzz-cairo0 libharfbuzz-dev libharfbuzz-gobject0
  libharfbuzz-icu0 libharfbuzz-subset0 libhyphen0 libice-dev libidn12
  libijs-0.35 libinput-bin libinput10 libipt2 libjbig-dev libjbig2dec0
  libjpeg-turbo8-dev liblab-gamut1 liblapack3 liblbfgsb0 liblerc-dev
  liblocale-codes-perl liblzma-dev libmd-dev libmd4c0 libmime-charset-perl
  libminizip1t64 libmodbus-dev libmodbus5 libmount-dev libmp3lame0
  libmpg123-0t64 libmtdev1t64 libnet-ip-perl libnetpbm11t64 libopengl-dev
  libopengl0 libopus0 liborc-0.4-0t64 libosp5 libpango1.0-dev
  libpangoxft-1.0-0 libpaper1 libpathplan4 libpixman-1-dev libpng-dev
  libpthread-stubs0-dev libpulse0 libqscintilla2-qt5-15
  libqscintilla2-qt5-l10n libqt5charts5 libqt5core5t64 libqt5dbus5t64
  libqt5designer5 libqt5gui5t64 libqt5help5 libqt5location5 libqt5multimedia5
  libqt5multimediawidgets5 libqt5network5t64 libqt5opengl5t64
  libqt5positioning5 libqt5positioningquick5 libqt5printsupport5t64 libqt5qml5
  libqt5qmlmodels5 libqt5quick5 libqt5quickwidgets5 libqt5remoteobjects5
  libqt5sensors5 libqt5serialport5 libqt5sql5t64 libqt5svg5 libqt5test5t64
  libqt5texttospeech5 libqt5webchannel5 libqt5webengine-data libqt5webengine5
  libqt5webenginecore5 libqt5webenginewidgets5 libqt5webkit5 libqt5websockets5
  libqt5widgets5t64 libqt5xml5t64 libqt5xmlpatterns5 librsvg2-2 librsvg2-bin
  libselinux1-dev libsepol-dev libsgmls-perl libsharpyuv-dev libsm-dev
  libsndfile1 libsombok3 libsource-highlight-common libsource-highlight4t64
  libthai-dev libtiff-dev libtiffxx6 libtirpc-dev libudev-dev
  libunicode-linebreak-perl libusb-1.0-0-dev libvorbisenc2 libvpx9
  libwacom-common libwacom9 libwayland-bin libwayland-dev libwayland-server0
  libwebp-dev libwebpdecoder3 libwoff1 libx11-dev libxau-dev libxcb-icccm4
  libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-render0-dev
  libxcb-shape0 libxcb-shm0-dev libxcb-util1 libxcb-xinerama0 libxcb-xinput0
  libxcb-xkb1 libxcb1-dev libxcomposite-dev libxcursor-dev libxdamage-dev
  libxdmcp-dev libxext-dev libxfixes-dev libxft-dev libxi-dev libxinerama-dev
  libxkbcommon-dev libxkbcommon-x11-0 libxml-parser-perl libxmu-dev
  libxmu-headers libxrandr-dev libxrender-dev libxss-dev libxt-dev libxtst-dev
  libxv1 libxxf86dga1 libyaml-tiny-perl netpbm opensp pango1.0-tools po4a
  poppler-data pybind11-dev pyqt5-dev-tools python3-appdirs python3-brotli
  python3-cairo python3-dbus.mainloop.pyqt5 python3-decorator
  python3-fonttools python3-fs python3-gi-cairo python3-lxml python3-lz4
  python3-mpmath python3-numpy python3-opengl python3-py python3-pybind11
  python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtchart
  python3-pyqt5.qtmultimedia python3-pyqt5.qtopengl
  python3-pyqt5.qtpositioning python3-pyqt5.qtquick
  python3-pyqt5.qtremoteobjects python3-pyqt5.qtsensors
  python3-pyqt5.qtserialport python3-pyqt5.qtsql python3-pyqt5.qtsvg
  python3-pyqt5.qttexttospeech python3-pyqt5.qtwebchannel
  python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit python3-pyqt5.qtwebsockets
  python3-pyqt5.qtxmlpatterns python3-pyqt5.sip python3-qtpy python3-scipy
  python3-sympy python3-tk python3-ufolib2 python3-unicodedata2 python3-xlib
  python3-yapps python3-zmq ruby-addressable ruby-afm ruby-ascii85
  ruby-asciidoctor ruby-asciidoctor-pdf ruby-concurrent ruby-css-parser
  ruby-hashery ruby-pdf-core ruby-pdf-reader ruby-polyglot ruby-prawn
  ruby-prawn-icon ruby-prawn-svg ruby-prawn-table ruby-prawn-templates
  ruby-public-suffix ruby-rc4 ruby-rouge ruby-treetop ruby-ttfunk tcl8.6-dev
  tclx8.4 tk8.6-blt2.5 tk8.6-dev unicode-data uuid-dev w3c-linkchecker
  wayland-protocols x11-utils x11-xserver-utils x11proto-dev xfonts-encodings
  xfonts-utils xorg-sgml-doctools xtrans-dev yapps2
The following packages will be upgraded:
  libevent-core-2.1-7t64 libevent-pthreads-2.1-7t64
2 upgraded, 326 newly installed, 0 to remove and 42 not upgraded.
Need to get 270 MB of archives.
After this operation, 1015 MB of additional disk space will be used.
Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [144 B]
Get:2 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdebuginfod-common all 0.190-1.1ubuntu0.1 [14.6 kB]
Get:3 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 liborc-0.4-0t64 amd64 1:0.4.38-1ubuntu0.1 [207 kB]
Get:4 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgstreamer-plugins-base1.0-0 amd64 1.24.2-1ubuntu0.4 [862 kB]
Get:5 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libhyphen0 amd64 2.8.8-7build3 [26.5 kB]
Get:6 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libdouble-conversion3 amd64 3.3.0-1build1 [40.3 kB]
Get:7 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5core5t64 amd64 5.15.13+dfsg-1ubuntu1 [2011 kB]
Get:8 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libegl-mesa0 amd64 25.2.8-0ubuntu0.24.04.2 [117 kB]
Get:9 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libegl1 amd64 1.7.0-1build1 [28.7 kB]
Get:10 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmtdev1t64 amd64 1.1.6-1.1build1 [14.4 kB]
Get:11 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwacom-common all 2.10.0-2 [63.4 kB]
Get:12 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwacom9 amd64 2.10.0-2 [23.9 kB]
Get:13 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libinput-bin amd64 1.25.0-1ubuntu3.6 [23.2 kB]
Get:14 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libinput10 amd64 1.25.0-1ubuntu3.6 [133 kB]
Get:15 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmd4c0 amd64 0.4.8-1build1 [42.3 kB]
Get:16 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5dbus5t64 amd64 5.15.13+dfsg-1ubuntu1 [220 kB]
Get:17 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5network5t64 amd64 5.15.13+dfsg-1ubuntu1 [723 kB]
Get:18 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-icccm4 amd64 0.4.1-1.1build3 [10.8 kB]
Get:19 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-util1 amd64 0.4.0-1build3 [10.7 kB]
Get:20 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-image0 amd64 0.4.0-2build1 [10.8 kB]
Get:21 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-keysyms1 amd64 0.4.0-1build4 [7956 B]
Get:22 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-render-util0 amd64 0.3.9-1build4 [9608 B]
Get:23 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-shape0 amd64 1.15-1ubuntu2 [6100 B]
Get:24 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-xinerama0 amd64 1.15-1ubuntu2 [5410 B]
Get:25 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-xinput0 amd64 1.15-1ubuntu2 [33.2 kB]
Get:26 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-xkb1 amd64 1.15-1ubuntu2 [32.3 kB]
Get:27 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxkbcommon-x11-0 amd64 1.6.0-1build1 [14.5 kB]
Get:28 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5gui5t64 amd64 5.15.13+dfsg-1ubuntu1 [3748 kB]
Get:29 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5positioning5 amd64 5.15.13+dfsg-1 [222 kB]
Get:30 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5widgets5t64 amd64 5.15.13+dfsg-1ubuntu1 [2561 kB]
Get:31 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5printsupport5t64 amd64 5.15.13+dfsg-1ubuntu1 [208 kB]
Get:32 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5qml5 amd64 5.15.13+dfsg-1ubuntu0.1 [1482 kB]
Get:33 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5qmlmodels5 amd64 5.15.13+dfsg-1ubuntu0.1 [203 kB]
Get:34 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5quick5 amd64 5.15.13+dfsg-1ubuntu0.1 [1733 kB]
Get:35 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5sensors5 amd64 5.15.13-1 [122 kB]
Get:36 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webchannel5 amd64 5.15.13-1 [61.9 kB]
Get:37 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwoff1 amd64 1.0.2-2build1 [45.3 kB]
Get:38 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webkit5 amd64 5.212.0~alpha4-36 [12.8 MB]
Get:39 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 poppler-data all 0.4.12-1 [2060 kB]
Get:40 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-asciidoctor all 2.0.20-1 [174 kB]
Get:41 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 asciidoctor all 2.0.20-1 [44.2 kB]
Get:42 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 tk8.6-blt2.5 amd64 2.5.3+dfsg-7build1 [630 kB]
Get:43 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 blt amd64 2.5.3+dfsg-7build1 [4840 B]
Get:44 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 bwidget all 1.9.16-1 [178 kB]
Get:45 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 desktop-file-utils amd64 0.27-2build1 [53.8 kB]
Get:46 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 dh-python all 6.20240401 [110 kB]
Get:47 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 fonts-noto-cjk all 1:20230817+repack1-3 [61.2 MB]
Get:48 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xfonts-encodings all 1:1.0.5-0ubuntu2 [578 kB]
Get:49 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xfonts-utils amd64 1:7.7+6build3 [94.4 kB]
Get:50 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 fonts-urw-base35 all 20200910-8 [11.0 MB]
Get:51 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libbabeltrace1 amd64 1.5.11-3build3 [164 kB]
Get:52 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdebuginfod1t64 amd64 0.190-1.1ubuntu0.1 [17.1 kB]
Get:53 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libipt2 amd64 2.0.6-1build1 [45.7 kB]
Get:54 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsource-highlight-common all 3.1.9-4.3build1 [64.2 kB]
Get:55 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsource-highlight4t64 amd64 3.1.9-4.3build1 [258 kB]
Get:56 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gdb amd64 15.1-1ubuntu1~24.04.1 [4083 kB]
Get:57 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgs-common all 10.02.1~dfsg1-0ubuntu7.8 [176 kB]
Get:58 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgs10-common all 10.02.1~dfsg1-0ubuntu7.8 [488 kB]
Get:59 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libidn12 amd64 1.42-1ubuntu0.1 [56.1 kB]
Get:60 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libijs-0.35 amd64 0.35-15.1build1 [15.3 kB]
Get:61 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libjbig2dec0 amd64 0.20-1ubuntu0.24.04.1 [65.2 kB]
Get:62 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpaper1 amd64 1.1.29build1 [13.4 kB]
Get:63 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgs10 amd64 10.02.1~dfsg1-0ubuntu7.8 [3897 kB]
Get:64 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 ghostscript amd64 10.02.1~dfsg1-0ubuntu7.8 [43.4 kB]
Get:65 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-atk-1.0 amd64 2.52.0-1build1 [23.1 kB]
Get:66 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-freedesktop amd64 1.80.1-1 [49.7 kB]
Get:67 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-atspi-2.0 amd64 2.52.0-1build1 [19.8 kB]
Get:68 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gir1.2-glib-2.0-dev amd64 2.80.0-6ubuntu3.8 [848 kB]
Get:69 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-freedesktop-dev amd64 1.80.1-1 [28.8 kB]
Get:70 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gir1.2-gdkpixbuf-2.0 amd64 2.42.10+dfsg-3ubuntu3.3 [9482 B]
Get:71 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-gobject0 amd64 8.3.0-2build2 [34.3 kB]
Get:72 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-harfbuzz-0.0 amd64 8.3.0-2build2 [44.5 kB]
Get:73 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpangoxft-1.0-0 amd64 1.52.1+ds-1build1 [20.3 kB]
Get:74 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-pango-1.0 amd64 1.52.1+ds-1build1 [34.8 kB]
Get:75 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gir1.2-gtk-3.0 amd64 3.24.41-4ubuntu1.3 [245 kB]
Get:76 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgtksourceview-4-common all 4.8.4-5build4 [590 kB]
Get:77 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgtksourceview-4-0 amd64 4.8.4-5build4 [233 kB]
Get:78 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 gir1.2-gtksource-4 amd64 4.8.4-5build4 [20.3 kB]
Get:79 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libann0 amd64 1.1.2+doc-9build1 [25.5 kB]
Get:80 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libcdt5 amd64 2.42.2-9ubuntu0.1 [21.6 kB]
Get:81 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libcgraph6 amd64 2.42.2-9ubuntu0.1 [44.6 kB]
Get:82 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgts-0.7-5t64 amd64 0.7.6+darcs121130-5.2build1 [161 kB]
Get:83 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libpathplan4 amd64 2.42.2-9ubuntu0.1 [24.0 kB]
Get:84 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libgvc6 amd64 2.42.2-9ubuntu0.1 [716 kB]
Get:85 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libgvpr2 amd64 2.42.2-9ubuntu0.1 [187 kB]
Get:86 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 liblab-gamut1 amd64 2.42.2-9ubuntu0.1 [1886 kB]
Get:87 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 graphviz amd64 2.42.2-9ubuntu0.1 [642 kB]
Get:88 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 imagemagick-6.q16 amd64 8:6.9.12.98+dfsg1-5.2build2 [254 kB]
Get:89 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 imagemagick amd64 8:6.9.12.98+dfsg1-5.2build2 [14.2 kB]
Get:90 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libxml-parser-perl amd64 2.47-1ubuntu0.24.04.1 [204 kB]
Get:91 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 intltool all 0.51.0-6 [44.6 kB]
Get:92 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libasyncns0 amd64 0.8-6build4 [11.3 kB]
Get:93 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libglib2.0-dev-bin amd64 2.80.0-6ubuntu3.8 [138 kB]
Get:94 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 uuid-dev amd64 2.39.3-9ubuntu6.6 [33.5 kB]
Get:95 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libblkid-dev amd64 2.39.3-9ubuntu6.6 [205 kB]
Get:96 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsepol-dev amd64 3.5-2build1 [384 kB]
Get:97 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libselinux1-dev amd64 3.5-2ubuntu2.1 [164 kB]
Get:98 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libmount-dev amd64 2.39.3-9ubuntu6.6 [14.9 kB]
Get:99 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgirepository-2.0-0 amd64 2.80.0-6ubuntu3.8 [73.6 kB]
Get:100 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libglib2.0-dev amd64 2.80.0-6ubuntu3.8 [1860 kB]
Get:101 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libatk1.0-dev amd64 2.52.0-1build1 [100 kB]
Get:102 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdbus-1-dev amd64 1.14.10-4ubuntu4.1 [190 kB]
Get:103 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xorg-sgml-doctools all 1:1.11-1.1 [10.9 kB]
Get:104 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 x11proto-dev all 2023.2-1 [602 kB]
Get:105 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxau-dev amd64 1:1.0.9-1build6 [9570 B]
Get:106 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxdmcp-dev amd64 1:1.1.3-0ubuntu6 [26.5 kB]
Get:107 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xtrans-dev all 1.4.0-1 [68.9 kB]
Get:108 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpthread-stubs0-dev amd64 0.4-1build3 [4746 B]
Get:109 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb1-dev amd64 1.15-1ubuntu2 [85.8 kB]
Get:110 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libx11-dev amd64 2:1.8.7-1build1 [732 kB]
Get:111 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxext-dev amd64 2:1.3.4-1build2 [83.5 kB]
Get:112 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxfixes-dev amd64 1:6.0.0-2build1 [12.1 kB]
Get:113 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxi-dev amd64 2:1.8.1-1build1 [194 kB]
Get:114 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxtst-dev amd64 2:1.2.3-1.1build1 [15.9 kB]
Get:115 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libatspi2.0-dev amd64 2.52.0-1build1 [76.2 kB]
Get:116 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libatk-bridge2.0-dev amd64 2.52.0-1build1 [4284 B]
Get:117 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libblas3 amd64 3.12.0-3build1.1 [238 kB]
Get:118 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libboost1.83-dev amd64 1.83.0-2.1ubuntu3.2 [10.7 MB]
Get:119 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libboost-python1.83.0 amd64 1.83.0-2.1ubuntu3.2 [312 kB]
Get:120 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libboost-python1.83-dev amd64 1.83.0-2.1ubuntu3.2 [337 kB]
Get:121 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libboost-python-dev amd64 1.83.0.1ubuntu2 [4344 B]
Get:122 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libbrotli-dev amd64 1.1.0-2build2 [353 kB]
Get:123 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libmd-dev amd64 1.1.0-2build1.1 [45.5 kB]
Get:124 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libbsd-dev amd64 0.12.1-1build1.1 [169 kB]
Get:125 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libbz2-dev amd64 1.0.8-5.1ubuntu0.1 [33.6 kB]
Get:126 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libcairo-script-interpreter2 amd64 1.18.0-3build1 [60.3 kB]
Get:127 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libpng-dev amd64 1.6.43-5ubuntu0.6 [265 kB]
Get:128 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libfreetype-dev amd64 2.13.2+dfsg-1ubuntu0.1 [575 kB]
Get:129 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfontconfig-dev amd64 2.15.0-1.1ubuntu2 [161 kB]
Get:130 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpixman-1-dev amd64 0.42.2-1build1 [296 kB]
Get:131 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libice-dev amd64 2:1.0.10-1build3 [51.0 kB]
Get:132 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsm-dev amd64 2:1.2.3-1build3 [17.8 kB]
Get:133 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-render0-dev amd64 1.15-1ubuntu2 [19.6 kB]
Get:134 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-shm0-dev amd64 1.15-1ubuntu2 [8246 B]
Get:135 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxrender-dev amd64 1:0.9.10-1.1build1 [26.3 kB]
Get:136 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libcairo2-dev amd64 1.18.0-3build1 [41.1 kB]
Get:137 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libcap-dev amd64 1:2.66-5ubuntu2.4 [596 kB]
Get:138 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libconfig-general-perl all 2.65-2 [57.1 kB]
Get:139 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libcss-dom-perl all 0.17-3 [108 kB]
Get:140 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdatrie-dev amd64 0.2.13-3build1 [19.4 kB]
Get:141 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdeflate-dev amd64 1.19-1build1.1 [50.9 kB]
Get:142 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libedit-dev amd64 3.1-20230828-1build1 [119 kB]
Get:143 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libeditreadline-dev amd64 3.1-20230828-1build1 [2220 B]
Get:144 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglx-dev amd64 1.7.0-1build1 [14.2 kB]
Get:145 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgl-dev amd64 1.7.0-1build1 [102 kB]
Get:146 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libegl-dev amd64 1.7.0-1build1 [18.2 kB]
Get:147 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglvnd-core-dev amd64 1.7.0-1build1 [13.6 kB]
Get:148 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgles1 amd64 1.7.0-1build1 [11.6 kB]
Get:149 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgles2 amd64 1.7.0-1build1 [17.1 kB]
Get:150 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgles-dev amd64 1.7.0-1build1 [50.5 kB]
Get:151 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libopengl0 amd64 1.7.0-1build1 [32.8 kB]
Get:152 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libopengl-dev amd64 1.7.0-1build1 [3454 B]
Get:153 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglvnd-dev amd64 1.7.0-1build1 [3198 B]
Get:154 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libegl1-mesa-dev amd64 25.2.8-0ubuntu0.24.04.2 [26.7 kB]
Get:155 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libepoxy-dev amd64 1.5.10-1build1 [132 kB]
Get:156 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libevent-2.1-7t64 amd64 2.1.12-stable-9ubuntu2.1 [146 kB]
Get:157 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libevent-pthreads-2.1-7t64 amd64 2.1.12-stable-9ubuntu2.1 [7984 B]
Get:158 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libevent-core-2.1-7t64 amd64 2.1.12-stable-9ubuntu2.1 [91.8 kB]
Get:159 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libflac12t64 amd64 1.4.3+ds-2.1ubuntu2 [197 kB]
Get:160 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libfmt9 amd64 9.1.0+ds1-2 [63.0 kB]
Get:161 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfribidi-dev amd64 1.0.13-3build1 [64.8 kB]
Get:162 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgdk-pixbuf2.0-bin amd64 2.42.10+dfsg-3ubuntu3.3 [13.9 kB]
Get:163 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libjpeg-turbo8-dev amd64 2.1.5-2ubuntu2 [295 kB]
Get:164 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libjbig-dev amd64 2.1-6.1ubuntu2 [27.9 kB]
Get:165 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 liblzma-dev amd64 5.6.1+really5.4.5-1ubuntu0.3 [176 kB]
Get:166 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwebpdecoder3 amd64 1.3.2-0.4build3 [114 kB]
Get:167 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsharpyuv-dev amd64 1.3.2-0.4build3 [16.0 kB]
Get:168 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwebp-dev amd64 1.3.2-0.4build3 [367 kB]
Get:169 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libtiffxx6 amd64 4.5.1+git230720-4ubuntu2.5 [5642 B]
Get:170 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblerc-dev amd64 4.0.0+ds-4ubuntu2 [182 kB]
Get:171 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libtiff-dev amd64 4.5.1+git230720-4ubuntu2.5 [338 kB]
Get:172 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgdk-pixbuf-2.0-dev amd64 2.42.10+dfsg-3ubuntu3.3 [47.9 kB]
Get:173 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglu1-mesa amd64 9.0.2-1.1build1 [152 kB]
Get:174 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglu1-mesa-dev amd64 9.0.2-1.1build1 [237 kB]
Get:175 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgpiod2t64 amd64 1.6.3-1.1build1 [41.9 kB]
Get:176 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgpiod-dev amd64 1.6.3-1.1build1 [60.2 kB]
Get:177 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgraphite2-dev amd64 1.3.14-2ubuntu0.24.04.1 [14.7 kB]
Get:178 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-icu0 amd64 8.3.0-2build2 [13.3 kB]
Get:179 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-subset0 amd64 8.3.0-2build2 [448 kB]
Get:180 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-cairo0 amd64 8.3.0-2build2 [26.2 kB]
Get:181 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-dev amd64 8.3.0-2build2 [142 kB]
Get:182 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libthai-dev amd64 0.1.29-2build1 [26.6 kB]
Get:183 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxft-dev amd64 2.3.6-1build1 [64.3 kB]
Get:184 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 pango1.0-tools amd64 1.52.1+ds-1build1 [36.7 kB]
Get:185 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpango1.0-dev amd64 1.52.1+ds-1build1 [147 kB]
Get:186 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwayland-server0 amd64 1.22.0-2.1build1 [33.9 kB]
Get:187 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwayland-bin amd64 1.22.0-2.1build1 [20.6 kB]
Get:188 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwayland-dev amd64 1.22.0-2.1build1 [71.3 kB]
Get:189 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcomposite-dev amd64 1:0.4.5-1build3 [9374 B]
Get:190 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcursor-dev amd64 1:1.2.1-1build1 [31.8 kB]
Get:191 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxdamage-dev amd64 1:1.1.6-1build1 [5270 B]
Get:192 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxinerama-dev amd64 2:1.1.4-3build1 [7988 B]
Get:193 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxkbcommon-dev amd64 1.6.0-1build1 [56.3 kB]
Get:194 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxrandr-dev amd64 2:1.5.2-2build1 [26.4 kB]
Get:195 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 wayland-protocols all 1.45-1~ubuntu0.24.04.2 [114 kB]
Get:196 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgtk-3-dev amd64 3.24.41-4ubuntu1.3 [1096 kB]
Get:197 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 liblapack3 amd64 3.12.0-3build1.1 [2646 kB]
Get:198 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 liblbfgsb0 amd64 3.0+dfsg.4-1build1 [29.9 kB]
Get:199 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 liblocale-codes-perl all 3.77-1 [303 kB]
Get:200 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmime-charset-perl all 1.013.1-2 [31.0 kB]
Get:201 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libminizip1t64 amd64 1:1.3.dfsg-3.1ubuntu2.2 [22.2 kB]
Get:202 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmp3lame0 amd64 3.100-6build1 [142 kB]
Get:203 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libmpg123-0t64 amd64 1.32.5-1ubuntu1.1 [169 kB]
Get:204 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libnet-ip-perl all 1.26-3ubuntu0.24.04.1 [27.4 kB]
Get:205 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libnetpbm11t64 amd64 2:11.05.02-1.1build1 [114 kB]
Get:206 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libopus0 amd64 1.4-1build1 [208 kB]
Get:207 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libosp5 amd64 1.5.2-15ubuntu2 [683 kB]
Get:208 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libvorbisenc2 amd64 1.3.7-1build3 [80.8 kB]
Get:209 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libsndfile1 amd64 1.2.2-1ubuntu5.24.04.1 [209 kB]
Get:210 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libpulse0 amd64 1:16.1+dfsg1-2ubuntu10.1 [292 kB]
Get:211 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqscintilla2-qt5-l10n all 2.14.1+dfsg-1build3 [56.4 kB]
Get:212 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqscintilla2-qt5-15 amd64 2.14.1+dfsg-1build3 [1154 kB]
Get:213 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5charts5 amd64 5.15.13-1 [482 kB]
Get:214 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5xml5t64 amd64 5.15.13+dfsg-1ubuntu1 [124 kB]
Get:215 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5designer5 amd64 5.15.13-1 [2824 kB]
Get:216 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5sql5t64 amd64 5.15.13+dfsg-1ubuntu1 [122 kB]
Get:217 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5help5 amd64 5.15.13-1 [161 kB]
Get:218 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5positioningquick5 amd64 5.15.13+dfsg-1 [43.6 kB]
Get:219 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5location5 amd64 5.15.13+dfsg-1 [745 kB]
Get:220 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5multimedia5 amd64 5.15.13-1 [310 kB]
Get:221 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5multimediawidgets5 amd64 5.15.13-1 [40.7 kB]
Get:222 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5opengl5t64 amd64 5.15.13+dfsg-1ubuntu1 [150 kB]
Get:223 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5quickwidgets5 amd64 5.15.13+dfsg-1ubuntu0.1 [38.4 kB]
Get:224 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5remoteobjects5 amd64 5.15.13-1 [198 kB]
Get:225 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5serialport5 amd64 5.15.13-1 [34.3 kB]
Get:226 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5svg5 amd64 5.15.13-1 [146 kB]
Get:227 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5test5t64 amd64 5.15.13+dfsg-1ubuntu1 [148 kB]
Get:228 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5texttospeech5 amd64 5.15.13-1 [21.1 kB]
Get:229 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webengine-data all 5.15.16+dfsg-3 [7622 kB]
Get:230 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libvpx9 amd64 1.14.0-1ubuntu2.3 [1143 kB]
Get:231 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webenginecore5 amd64 5.15.16+dfsg-3 [42.6 MB]
Get:232 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webengine5 amd64 5.15.16+dfsg-3 [169 kB]
Get:233 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webenginewidgets5 amd64 5.15.16+dfsg-3 [121 kB]
Get:234 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5websockets5 amd64 5.15.13-1 [60.1 kB]
Get:235 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5xmlpatterns5 amd64 5.15.13-1 [899 kB]
Get:236 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 librsvg2-2 amd64 2.58.0+dfsg-1build1 [2135 kB]
Get:237 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 librsvg2-bin amd64 2.58.0+dfsg-1build1 [2299 kB]
Get:238 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libsgmls-perl all 1.03ii-38 [22.1 kB]
Get:239 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libsombok3 amd64 2.4.0-2build1 [29.4 kB]
Get:240 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libudev-dev amd64 255.4-1ubuntu8.17 [22.0 kB]
Get:241 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libunicode-linebreak-perl amd64 0.0.20190101-1build7 [92.6 kB]
Get:242 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libusb-1.0-0-dev amd64 2:1.0.27-1 [77.7 kB]
Get:243 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxt-dev amd64 1:1.2.1-1.2build1 [394 kB]
Get:244 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxmu-headers all 2:1.1.3-3build2 [53.0 kB]
Get:245 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxmu-dev amd64 2:1.1.3-3build2 [55.4 kB]
Get:246 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxss-dev amd64 1:1.2.3-1build3 [12.1 kB]
Get:247 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxv1 amd64 2:1.0.11-1.1build1 [10.7 kB]
Get:248 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxxf86dga1 amd64 2:1.1.5-1build1 [11.6 kB]
Get:249 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libyaml-tiny-perl all 1.74-1 [25.3 kB]
Get:250 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 netpbm amd64 2:11.05.02-1.1build1 [2054 kB]
Get:251 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 opensp amd64 1.5.2-15ubuntu2 [147 kB]
Get:252 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 po4a all 0.69-1 [2184 kB]
Get:253 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 pybind11-dev all 2.11.1-2 [159 kB]
Get:254 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.sip amd64 12.13.0-1build3 [61.3 kB]
Get:255 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5 amd64 5.15.10+dfsg-1build6 [2753 kB]
Get:256 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 pyqt5-dev-tools amd64 5.15.10+dfsg-1build6 [70.0 kB]
Get:257 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-appdirs all 1.4.4-4 [10.9 kB]
Get:258 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-brotli amd64 1.1.0-2build2 [332 kB]
Get:259 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-cairo amd64 1.25.1-2build2 [119 kB]
Get:260 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-dbus.mainloop.pyqt5 amd64 5.15.10+dfsg-1build6 [20.8 kB]
Get:261 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-decorator all 5.1.1-5 [10.1 kB]
Get:262 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-numpy amd64 1:1.26.4+ds-6ubuntu1 [4437 kB]
Get:263 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-scipy amd64 1.11.4-6build1 [15.5 MB]
Get:264 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-ufolib2 all 0.16.0+dfsg1-1 [33.5 kB]
Get:265 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-mpmath all 1.2.1-3 [421 kB]
Get:266 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-sympy all 1.12-7 [3966 kB]
Get:267 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-fs all 2.4.16-3 [91.1 kB]
Get:268 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-lxml amd64 5.2.1-1 [1243 kB]
Get:269 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-lz4 amd64 4.0.2+dfsg-1build4 [26.2 kB]
Get:270 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-unicodedata2 amd64 15.1.0+ds-1build1 [362 kB]
Get:271 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 unicode-data all 15.1.0-1 [8878 kB]
Get:272 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-fonttools amd64 4.46.0-1build2 [1436 kB]
Get:273 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-gi-cairo amd64 3.48.2-1 [8132 B]
Get:274 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-opengl all 3.1.7+dfsg-1 [612 kB]
Get:275 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-py all 1.11.0-2 [72.7 kB]
Get:276 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pybind11 all 2.11.1-2 [167 kB]
Get:277 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qsci amd64 2.14.1+dfsg-1build3 [272 kB]
Get:278 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtchart amd64 5.15.6+dfsg-1build2 [148 kB]
Get:279 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtmultimedia amd64 5.15.10+dfsg-1build6 [231 kB]
Get:280 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtopengl amd64 5.15.10+dfsg-1build6 [128 kB]
Get:281 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtpositioning amd64 5.15.10+dfsg-1build6 [154 kB]
Get:282 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtquick amd64 5.15.10+dfsg-1build6 [398 kB]
Get:283 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtremoteobjects amd64 5.15.10+dfsg-1build6 [32.6 kB]
Get:284 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtsensors amd64 5.15.10+dfsg-1build6 [56.4 kB]
Get:285 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtserialport amd64 5.15.10+dfsg-1build6 [28.4 kB]
Get:286 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtsql amd64 5.15.10+dfsg-1build6 [90.1 kB]
Get:287 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtsvg amd64 5.15.10+dfsg-1build6 [30.1 kB]
Get:288 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qttexttospeech amd64 5.15.10+dfsg-1build6 [17.8 kB]
Get:289 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtwebchannel amd64 5.15.10+dfsg-1build6 [15.1 kB]
Get:290 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtwebengine amd64 5.15.6-1build2 [119 kB]
Get:291 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtwebkit amd64 5.15.10+dfsg-1build6 [111 kB]
Get:292 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtwebsockets amd64 5.15.10+dfsg-1build6 [27.2 kB]
Get:293 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtxmlpatterns amd64 5.15.10+dfsg-1build6 [44.8 kB]
Get:294 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-qtpy all 2.4.1-2 [51.4 kB]
Get:295 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-tk amd64 3.12.3-0ubuntu1 [102 kB]
Get:296 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-yapps all 2.2.1-3.2 [16.2 kB]
Get:297 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-zmq amd64 24.0.1-5build1 [286 kB]
Get:298 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-public-suffix all 4.0.6+ds-2 [14.1 kB]
Get:299 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-addressable all 2.8.5-1 [55.3 kB]
Get:300 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-afm all 0.2.2-3 [5954 B]
Get:301 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-ascii85 all 1.0.3-1 [9208 B]
Get:302 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-concurrent all 1.2.3-2build1 [282 kB]
Get:303 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-pdf-core all 0.9.0-1 [19.6 kB]
Get:304 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-ttfunk all 1.7.0-1 [44.9 kB]
Get:305 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-prawn all 2.4.0+dfsg-1~ [1026 kB]
Get:306 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-rc4 all 0.1.5-3.1 [4240 B]
Get:307 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-hashery all 2.1.2-1.1 [30.7 kB]
Get:308 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-pdf-reader all 2.11.0-1 [149 kB]
Get:309 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-prawn-templates all 0.1.2-3 [8588 B]
Get:310 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-prawn-icon all 3.1.0-1 [1136 kB]
Get:311 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-css-parser all 1.16.0-1 [20.2 kB]
Get:312 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-prawn-svg all 0.32.0-1 [37.8 kB]
Get:313 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-prawn-table all 0.2.2-1.1 [94.2 kB]
Get:314 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-polyglot all 0.3.4-1.1 [5380 B]
Get:315 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-treetop all 1.6.12-1 [69.1 kB]
Get:316 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-asciidoctor-pdf all 2.3.4-3 [1631 kB]
Get:317 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 ruby-rouge all 4.2.0-1 [558 kB]
Get:318 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 tcl8.6-dev amd64 8.6.14+dfsg-1build1 [1000 kB]
Get:319 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 tclx8.4 amd64 8.4.1-4 [82.6 kB]
Get:320 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 tk8.6-dev amd64 8.6.14-1build1 [788 kB]
Get:321 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 w3c-linkchecker all 5.0.0-2 [58.5 kB]
Get:322 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 x11-utils amd64 7.7+6build2 [189 kB]
Get:323 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 x11-xserver-utils amd64 7.7+10build2 [169 kB]
Get:324 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 yapps2 all 2.2.1-3.2 [41.4 kB]
Get:325 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libfmt-dev amd64 9.1.0+ds1-2 [122 kB]
Get:326 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmodbus5 amd64 3.1.10-1ubuntu1 [34.4 kB]
Get:327 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmodbus-dev amd64 3.1.10-1ubuntu1 [18.6 kB]
Get:328 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtirpc-dev amd64 1.3.4+ds-1.1build1 [193 kB]
Get:329 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-xlib all 0.33-2 [120 kB]
Preconfiguring packages ...
Fetched 270 MB in 12s (22.7 MB/s)
Selecting previously unselected package libdebuginfod-common.
(Reading database ... (Reading database ... 5%(Reading database ... 10%(Reading database ... 15%(Reading database ... 20%(Reading database ... 25%(Reading database ... 30%(Reading database ... 35%(Reading database ... 40%(Reading database ... 45%(Reading database ... 50%(Reading database ... 55%(Reading database ... 60%(Reading database ... 65%(Reading database ... 70%(Reading database ... 75%(Reading database ... 80%(Reading database ... 85%(Reading database ... 90%(Reading database ... 95%(Reading database ... 100%(Reading database ... 208197 files and directories currently installed.)
Preparing to unpack .../000-libdebuginfod-common_0.190-1.1ubuntu0.1_all.deb ...
Unpacking libdebuginfod-common (0.190-1.1ubuntu0.1) ...
Selecting previously unselected package liborc-0.4-0t64:amd64.
Preparing to unpack .../001-liborc-0.4-0t64_1%3a0.4.38-1ubuntu0.1_amd64.deb ...
Unpacking liborc-0.4-0t64:amd64 (1:0.4.38-1ubuntu0.1) ...
Selecting previously unselected package libgstreamer-plugins-base1.0-0:amd64.
Preparing to unpack .../002-libgstreamer-plugins-base1.0-0_1.24.2-1ubuntu0.4_amd64.deb ...
Unpacking libgstreamer-plugins-base1.0-0:amd64 (1.24.2-1ubuntu0.4) ...
Selecting previously unselected package libhyphen0:amd64.
Preparing to unpack .../003-libhyphen0_2.8.8-7build3_amd64.deb ...
Unpacking libhyphen0:amd64 (2.8.8-7build3) ...
Selecting previously unselected package libdouble-conversion3:amd64.
Preparing to unpack .../004-libdouble-conversion3_3.3.0-1build1_amd64.deb ...
Unpacking libdouble-conversion3:amd64 (3.3.0-1build1) ...
Selecting previously unselected package libqt5core5t64:amd64.
Preparing to unpack .../005-libqt5core5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5core5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libegl-mesa0:amd64.
Preparing to unpack .../006-libegl-mesa0_25.2.8-0ubuntu0.24.04.2_amd64.deb ...
Unpacking libegl-mesa0:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Selecting previously unselected package libegl1:amd64.
Preparing to unpack .../007-libegl1_1.7.0-1build1_amd64.deb ...
Unpacking libegl1:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libmtdev1t64:amd64.
Preparing to unpack .../008-libmtdev1t64_1.1.6-1.1build1_amd64.deb ...
Unpacking libmtdev1t64:amd64 (1.1.6-1.1build1) ...
Selecting previously unselected package libwacom-common.
Preparing to unpack .../009-libwacom-common_2.10.0-2_all.deb ...
Unpacking libwacom-common (2.10.0-2) ...
Selecting previously unselected package libwacom9:amd64.
Preparing to unpack .../010-libwacom9_2.10.0-2_amd64.deb ...
Unpacking libwacom9:amd64 (2.10.0-2) ...
Selecting previously unselected package libinput-bin.
Preparing to unpack .../011-libinput-bin_1.25.0-1ubuntu3.6_amd64.deb ...
Unpacking libinput-bin (1.25.0-1ubuntu3.6) ...
Selecting previously unselected package libinput10:amd64.
Preparing to unpack .../012-libinput10_1.25.0-1ubuntu3.6_amd64.deb ...
Unpacking libinput10:amd64 (1.25.0-1ubuntu3.6) ...
Selecting previously unselected package libmd4c0:amd64.
Preparing to unpack .../013-libmd4c0_0.4.8-1build1_amd64.deb ...
Unpacking libmd4c0:amd64 (0.4.8-1build1) ...
Selecting previously unselected package libqt5dbus5t64:amd64.
Preparing to unpack .../014-libqt5dbus5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5dbus5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5network5t64:amd64.
Preparing to unpack .../015-libqt5network5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5network5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libxcb-icccm4:amd64.
Preparing to unpack .../016-libxcb-icccm4_0.4.1-1.1build3_amd64.deb ...
Unpacking libxcb-icccm4:amd64 (0.4.1-1.1build3) ...
Selecting previously unselected package libxcb-util1:amd64.
Preparing to unpack .../017-libxcb-util1_0.4.0-1build3_amd64.deb ...
Unpacking libxcb-util1:amd64 (0.4.0-1build3) ...
Selecting previously unselected package libxcb-image0:amd64.
Preparing to unpack .../018-libxcb-image0_0.4.0-2build1_amd64.deb ...
Unpacking libxcb-image0:amd64 (0.4.0-2build1) ...
Selecting previously unselected package libxcb-keysyms1:amd64.
Preparing to unpack .../019-libxcb-keysyms1_0.4.0-1build4_amd64.deb ...
Unpacking libxcb-keysyms1:amd64 (0.4.0-1build4) ...
Selecting previously unselected package libxcb-render-util0:amd64.
Preparing to unpack .../020-libxcb-render-util0_0.3.9-1build4_amd64.deb ...
Unpacking libxcb-render-util0:amd64 (0.3.9-1build4) ...
Selecting previously unselected package libxcb-shape0:amd64.
Preparing to unpack .../021-libxcb-shape0_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-shape0:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-xinerama0:amd64.
Preparing to unpack .../022-libxcb-xinerama0_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-xinerama0:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-xinput0:amd64.
Preparing to unpack .../023-libxcb-xinput0_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-xinput0:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-xkb1:amd64.
Preparing to unpack .../024-libxcb-xkb1_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-xkb1:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxkbcommon-x11-0:amd64.
Preparing to unpack .../025-libxkbcommon-x11-0_1.6.0-1build1_amd64.deb ...
Unpacking libxkbcommon-x11-0:amd64 (1.6.0-1build1) ...
Selecting previously unselected package libqt5gui5t64:amd64.
Preparing to unpack .../026-libqt5gui5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5gui5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5positioning5:amd64.
Preparing to unpack .../027-libqt5positioning5_5.15.13+dfsg-1_amd64.deb ...
Unpacking libqt5positioning5:amd64 (5.15.13+dfsg-1) ...
Selecting previously unselected package libqt5widgets5t64:amd64.
Preparing to unpack .../028-libqt5widgets5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5widgets5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5printsupport5t64:amd64.
Preparing to unpack .../029-libqt5printsupport5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5printsupport5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5qml5:amd64.
Preparing to unpack .../030-libqt5qml5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5qml5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5qmlmodels5:amd64.
Preparing to unpack .../031-libqt5qmlmodels5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5qmlmodels5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5quick5:amd64.
Preparing to unpack .../032-libqt5quick5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5quick5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5sensors5:amd64.
Preparing to unpack .../033-libqt5sensors5_5.15.13-1_amd64.deb ...
Unpacking libqt5sensors5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5webchannel5:amd64.
Preparing to unpack .../034-libqt5webchannel5_5.15.13-1_amd64.deb ...
Unpacking libqt5webchannel5:amd64 (5.15.13-1) ...
Selecting previously unselected package libwoff1:amd64.
Preparing to unpack .../035-libwoff1_1.0.2-2build1_amd64.deb ...
Unpacking libwoff1:amd64 (1.0.2-2build1) ...
Selecting previously unselected package libqt5webkit5:amd64.
Preparing to unpack .../036-libqt5webkit5_5.212.0~alpha4-36_amd64.deb ...
Unpacking libqt5webkit5:amd64 (5.212.0~alpha4-36) ...
Selecting previously unselected package poppler-data.
Preparing to unpack .../037-poppler-data_0.4.12-1_all.deb ...
Unpacking poppler-data (0.4.12-1) ...
Selecting previously unselected package ruby-asciidoctor.
Preparing to unpack .../038-ruby-asciidoctor_2.0.20-1_all.deb ...
Unpacking ruby-asciidoctor (2.0.20-1) ...
Selecting previously unselected package asciidoctor.
Preparing to unpack .../039-asciidoctor_2.0.20-1_all.deb ...
Unpacking asciidoctor (2.0.20-1) ...
Selecting previously unselected package tk8.6-blt2.5.
Preparing to unpack .../040-tk8.6-blt2.5_2.5.3+dfsg-7build1_amd64.deb ...
Unpacking tk8.6-blt2.5 (2.5.3+dfsg-7build1) ...
Selecting previously unselected package blt.
Preparing to unpack .../041-blt_2.5.3+dfsg-7build1_amd64.deb ...
Unpacking blt (2.5.3+dfsg-7build1) ...
Selecting previously unselected package bwidget.
Preparing to unpack .../042-bwidget_1.9.16-1_all.deb ...
Unpacking bwidget (1.9.16-1) ...
Selecting previously unselected package desktop-file-utils.
Preparing to unpack .../043-desktop-file-utils_0.27-2build1_amd64.deb ...
Unpacking desktop-file-utils (0.27-2build1) ...
Selecting previously unselected package dh-python.
Preparing to unpack .../044-dh-python_6.20240401_all.deb ...
Unpacking dh-python (6.20240401) ...
Selecting previously unselected package fonts-noto-cjk.
Preparing to unpack .../045-fonts-noto-cjk_1%3a20230817+repack1-3_all.deb ...
Unpacking fonts-noto-cjk (1:20230817+repack1-3) ...
Selecting previously unselected package xfonts-encodings.
Preparing to unpack .../046-xfonts-encodings_1%3a1.0.5-0ubuntu2_all.deb ...
Unpacking xfonts-encodings (1:1.0.5-0ubuntu2) ...
Selecting previously unselected package xfonts-utils.
Preparing to unpack .../047-xfonts-utils_1%3a7.7+6build3_amd64.deb ...
Unpacking xfonts-utils (1:7.7+6build3) ...
Selecting previously unselected package fonts-urw-base35.
Preparing to unpack .../048-fonts-urw-base35_20200910-8_all.deb ...
Unpacking fonts-urw-base35 (20200910-8) ...
Selecting previously unselected package libbabeltrace1:amd64.
Preparing to unpack .../049-libbabeltrace1_1.5.11-3build3_amd64.deb ...
Unpacking libbabeltrace1:amd64 (1.5.11-3build3) ...
Selecting previously unselected package libdebuginfod1t64:amd64.
Preparing to unpack .../050-libdebuginfod1t64_0.190-1.1ubuntu0.1_amd64.deb ...
Unpacking libdebuginfod1t64:amd64 (0.190-1.1ubuntu0.1) ...
Selecting previously unselected package libipt2.
Preparing to unpack .../051-libipt2_2.0.6-1build1_amd64.deb ...
Unpacking libipt2 (2.0.6-1build1) ...
Selecting previously unselected package libsource-highlight-common.
Preparing to unpack .../052-libsource-highlight-common_3.1.9-4.3build1_all.deb ...
Unpacking libsource-highlight-common (3.1.9-4.3build1) ...
Selecting previously unselected package libsource-highlight4t64:amd64.
Preparing to unpack .../053-libsource-highlight4t64_3.1.9-4.3build1_amd64.deb ...
Unpacking libsource-highlight4t64:amd64 (3.1.9-4.3build1) ...
Selecting previously unselected package gdb.
Preparing to unpack .../054-gdb_15.1-1ubuntu1~24.04.1_amd64.deb ...
Unpacking gdb (15.1-1ubuntu1~24.04.1) ...
Selecting previously unselected package libgs-common.
Preparing to unpack .../055-libgs-common_10.02.1~dfsg1-0ubuntu7.8_all.deb ...
Unpacking libgs-common (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package libgs10-common.
Preparing to unpack .../056-libgs10-common_10.02.1~dfsg1-0ubuntu7.8_all.deb ...
Unpacking libgs10-common (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package libidn12:amd64.
Preparing to unpack .../057-libidn12_1.42-1ubuntu0.1_amd64.deb ...
Unpacking libidn12:amd64 (1.42-1ubuntu0.1) ...
Selecting previously unselected package libijs-0.35:amd64.
Preparing to unpack .../058-libijs-0.35_0.35-15.1build1_amd64.deb ...
Unpacking libijs-0.35:amd64 (0.35-15.1build1) ...
Selecting previously unselected package libjbig2dec0:amd64.
Preparing to unpack .../059-libjbig2dec0_0.20-1ubuntu0.24.04.1_amd64.deb ...
Unpacking libjbig2dec0:amd64 (0.20-1ubuntu0.24.04.1) ...
Selecting previously unselected package libpaper1:amd64.
Preparing to unpack .../060-libpaper1_1.1.29build1_amd64.deb ...
Unpacking libpaper1:amd64 (1.1.29build1) ...
Selecting previously unselected package libgs10:amd64.
Preparing to unpack .../061-libgs10_10.02.1~dfsg1-0ubuntu7.8_amd64.deb ...
Unpacking libgs10:amd64 (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package ghostscript.
Preparing to unpack .../062-ghostscript_10.02.1~dfsg1-0ubuntu7.8_amd64.deb ...
Unpacking ghostscript (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package gir1.2-atk-1.0:amd64.
Preparing to unpack .../063-gir1.2-atk-1.0_2.52.0-1build1_amd64.deb ...
Unpacking gir1.2-atk-1.0:amd64 (2.52.0-1build1) ...
Selecting previously unselected package gir1.2-freedesktop:amd64.
Preparing to unpack .../064-gir1.2-freedesktop_1.80.1-1_amd64.deb ...
Unpacking gir1.2-freedesktop:amd64 (1.80.1-1) ...
Selecting previously unselected package gir1.2-atspi-2.0:amd64.
Preparing to unpack .../065-gir1.2-atspi-2.0_2.52.0-1build1_amd64.deb ...
Unpacking gir1.2-atspi-2.0:amd64 (2.52.0-1build1) ...
Selecting previously unselected package gir1.2-glib-2.0-dev:amd64.
Preparing to unpack .../066-gir1.2-glib-2.0-dev_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking gir1.2-glib-2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package gir1.2-freedesktop-dev:amd64.
Preparing to unpack .../067-gir1.2-freedesktop-dev_1.80.1-1_amd64.deb ...
Unpacking gir1.2-freedesktop-dev:amd64 (1.80.1-1) ...
Selecting previously unselected package gir1.2-gdkpixbuf-2.0:amd64.
Preparing to unpack .../068-gir1.2-gdkpixbuf-2.0_2.42.10+dfsg-3ubuntu3.3_amd64.deb ...
Unpacking gir1.2-gdkpixbuf-2.0:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Selecting previously unselected package libharfbuzz-gobject0:amd64.
Preparing to unpack .../069-libharfbuzz-gobject0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-gobject0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package gir1.2-harfbuzz-0.0:amd64.
Preparing to unpack .../070-gir1.2-harfbuzz-0.0_8.3.0-2build2_amd64.deb ...
Unpacking gir1.2-harfbuzz-0.0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libpangoxft-1.0-0:amd64.
Preparing to unpack .../071-libpangoxft-1.0-0_1.52.1+ds-1build1_amd64.deb ...
Unpacking libpangoxft-1.0-0:amd64 (1.52.1+ds-1build1) ...
Selecting previously unselected package gir1.2-pango-1.0:amd64.
Preparing to unpack .../072-gir1.2-pango-1.0_1.52.1+ds-1build1_amd64.deb ...
Unpacking gir1.2-pango-1.0:amd64 (1.52.1+ds-1build1) ...
Selecting previously unselected package gir1.2-gtk-3.0:amd64.
Preparing to unpack .../073-gir1.2-gtk-3.0_3.24.41-4ubuntu1.3_amd64.deb ...
Unpacking gir1.2-gtk-3.0:amd64 (3.24.41-4ubuntu1.3) ...
Selecting previously unselected package libgtksourceview-4-common.
Preparing to unpack .../074-libgtksourceview-4-common_4.8.4-5build4_all.deb ...
Unpacking libgtksourceview-4-common (4.8.4-5build4) ...
Selecting previously unselected package libgtksourceview-4-0:amd64.
Preparing to unpack .../075-libgtksourceview-4-0_4.8.4-5build4_amd64.deb ...
Unpacking libgtksourceview-4-0:amd64 (4.8.4-5build4) ...
Selecting previously unselected package gir1.2-gtksource-4:amd64.
Preparing to unpack .../076-gir1.2-gtksource-4_4.8.4-5build4_amd64.deb ...
Unpacking gir1.2-gtksource-4:amd64 (4.8.4-5build4) ...
Selecting previously unselected package libann0.
Preparing to unpack .../077-libann0_1.1.2+doc-9build1_amd64.deb ...
Unpacking libann0 (1.1.2+doc-9build1) ...
Selecting previously unselected package libcdt5:amd64.
Preparing to unpack .../078-libcdt5_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libcdt5:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libcgraph6:amd64.
Preparing to unpack .../079-libcgraph6_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libcgraph6:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libgts-0.7-5t64:amd64.
Preparing to unpack .../080-libgts-0.7-5t64_0.7.6+darcs121130-5.2build1_amd64.deb ...
Unpacking libgts-0.7-5t64:amd64 (0.7.6+darcs121130-5.2build1) ...
Selecting previously unselected package libpathplan4:amd64.
Preparing to unpack .../081-libpathplan4_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libpathplan4:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libgvc6.
Preparing to unpack .../082-libgvc6_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libgvc6 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libgvpr2:amd64.
Preparing to unpack .../083-libgvpr2_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libgvpr2:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package liblab-gamut1:amd64.
Preparing to unpack .../084-liblab-gamut1_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking liblab-gamut1:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package graphviz.
Preparing to unpack .../085-graphviz_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking graphviz (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package imagemagick-6.q16.
Preparing to unpack .../086-imagemagick-6.q16_8%3a6.9.12.98+dfsg1-5.2build2_amd64.deb ...
Unpacking imagemagick-6.q16 (8:6.9.12.98+dfsg1-5.2build2) ...
Selecting previously unselected package imagemagick.
Preparing to unpack .../087-imagemagick_8%3a6.9.12.98+dfsg1-5.2build2_amd64.deb ...
Unpacking imagemagick (8:6.9.12.98+dfsg1-5.2build2) ...
Selecting previously unselected package libxml-parser-perl.
Preparing to unpack .../088-libxml-parser-perl_2.47-1ubuntu0.24.04.1_amd64.deb ...
Unpacking libxml-parser-perl (2.47-1ubuntu0.24.04.1) ...
Selecting previously unselected package intltool.
Preparing to unpack .../089-intltool_0.51.0-6_all.deb ...
Unpacking intltool (0.51.0-6) ...
Selecting previously unselected package libasyncns0:amd64.
Preparing to unpack .../090-libasyncns0_0.8-6build4_amd64.deb ...
Unpacking libasyncns0:amd64 (0.8-6build4) ...
Selecting previously unselected package libglib2.0-dev-bin.
Preparing to unpack .../091-libglib2.0-dev-bin_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking libglib2.0-dev-bin (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package uuid-dev:amd64.
Preparing to unpack .../092-uuid-dev_2.39.3-9ubuntu6.6_amd64.deb ...
Unpacking uuid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Selecting previously unselected package libblkid-dev:amd64.
Preparing to unpack .../093-libblkid-dev_2.39.3-9ubuntu6.6_amd64.deb ...
Unpacking libblkid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Selecting previously unselected package libsepol-dev:amd64.
Preparing to unpack .../094-libsepol-dev_3.5-2build1_amd64.deb ...
Unpacking libsepol-dev:amd64 (3.5-2build1) ...
Selecting previously unselected package libselinux1-dev:amd64.
Preparing to unpack .../095-libselinux1-dev_3.5-2ubuntu2.1_amd64.deb ...
Unpacking libselinux1-dev:amd64 (3.5-2ubuntu2.1) ...
Selecting previously unselected package libmount-dev:amd64.
Preparing to unpack .../096-libmount-dev_2.39.3-9ubuntu6.6_amd64.deb ...
Unpacking libmount-dev:amd64 (2.39.3-9ubuntu6.6) ...
Selecting previously unselected package libgirepository-2.0-0:amd64.
Preparing to unpack .../097-libgirepository-2.0-0_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking libgirepository-2.0-0:amd64 (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package libglib2.0-dev:amd64.
Preparing to unpack .../098-libglib2.0-dev_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking libglib2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package libatk1.0-dev:amd64.
Preparing to unpack .../099-libatk1.0-dev_2.52.0-1build1_amd64.deb ...
Unpacking libatk1.0-dev:amd64 (2.52.0-1build1) ...
Selecting previously unselected package libdbus-1-dev:amd64.
Preparing to unpack .../100-libdbus-1-dev_1.14.10-4ubuntu4.1_amd64.deb ...
Unpacking libdbus-1-dev:amd64 (1.14.10-4ubuntu4.1) ...
Selecting previously unselected package xorg-sgml-doctools.
Preparing to unpack .../101-xorg-sgml-doctools_1%3a1.11-1.1_all.deb ...
Unpacking xorg-sgml-doctools (1:1.11-1.1) ...
Selecting previously unselected package x11proto-dev.
Preparing to unpack .../102-x11proto-dev_2023.2-1_all.deb ...
Unpacking x11proto-dev (2023.2-1) ...
Selecting previously unselected package libxau-dev:amd64.
Preparing to unpack .../103-libxau-dev_1%3a1.0.9-1build6_amd64.deb ...
Unpacking libxau-dev:amd64 (1:1.0.9-1build6) ...
Selecting previously unselected package libxdmcp-dev:amd64.
Preparing to unpack .../104-libxdmcp-dev_1%3a1.1.3-0ubuntu6_amd64.deb ...
Unpacking libxdmcp-dev:amd64 (1:1.1.3-0ubuntu6) ...
Selecting previously unselected package xtrans-dev.
Preparing to unpack .../105-xtrans-dev_1.4.0-1_all.deb ...
Unpacking xtrans-dev (1.4.0-1) ...
Selecting previously unselected package libpthread-stubs0-dev:amd64.
Preparing to unpack .../106-libpthread-stubs0-dev_0.4-1build3_amd64.deb ...
Unpacking libpthread-stubs0-dev:amd64 (0.4-1build3) ...
Selecting previously unselected package libxcb1-dev:amd64.
Preparing to unpack .../107-libxcb1-dev_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb1-dev:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libx11-dev:amd64.
Preparing to unpack .../108-libx11-dev_2%3a1.8.7-1build1_amd64.deb ...
Unpacking libx11-dev:amd64 (2:1.8.7-1build1) ...
Selecting previously unselected package libxext-dev:amd64.
Preparing to unpack .../109-libxext-dev_2%3a1.3.4-1build2_amd64.deb ...
Unpacking libxext-dev:amd64 (2:1.3.4-1build2) ...
Selecting previously unselected package libxfixes-dev:amd64.
Preparing to unpack .../110-libxfixes-dev_1%3a6.0.0-2build1_amd64.deb ...
Unpacking libxfixes-dev:amd64 (1:6.0.0-2build1) ...
Selecting previously unselected package libxi-dev:amd64.
Preparing to unpack .../111-libxi-dev_2%3a1.8.1-1build1_amd64.deb ...
Unpacking libxi-dev:amd64 (2:1.8.1-1build1) ...
Selecting previously unselected package libxtst-dev:amd64.
Preparing to unpack .../112-libxtst-dev_2%3a1.2.3-1.1build1_amd64.deb ...
Unpacking libxtst-dev:amd64 (2:1.2.3-1.1build1) ...
Selecting previously unselected package libatspi2.0-dev:amd64.
Preparing to unpack .../113-libatspi2.0-dev_2.52.0-1build1_amd64.deb ...
Unpacking libatspi2.0-dev:amd64 (2.52.0-1build1) ...
Selecting previously unselected package libatk-bridge2.0-dev:amd64.
Preparing to unpack .../114-libatk-bridge2.0-dev_2.52.0-1build1_amd64.deb ...
Unpacking libatk-bridge2.0-dev:amd64 (2.52.0-1build1) ...
Selecting previously unselected package libblas3:amd64.
Preparing to unpack .../115-libblas3_3.12.0-3build1.1_amd64.deb ...
Unpacking libblas3:amd64 (3.12.0-3build1.1) ...
Selecting previously unselected package libboost1.83-dev:amd64.
Preparing to unpack .../116-libboost1.83-dev_1.83.0-2.1ubuntu3.2_amd64.deb ...
Unpacking libboost1.83-dev:amd64 (1.83.0-2.1ubuntu3.2) ...
Selecting previously unselected package libboost-python1.83.0.
Preparing to unpack .../117-libboost-python1.83.0_1.83.0-2.1ubuntu3.2_amd64.deb ...
Unpacking libboost-python1.83.0 (1.83.0-2.1ubuntu3.2) ...
Selecting previously unselected package libboost-python1.83-dev.
Preparing to unpack .../118-libboost-python1.83-dev_1.83.0-2.1ubuntu3.2_amd64.deb ...
Unpacking libboost-python1.83-dev (1.83.0-2.1ubuntu3.2) ...
Selecting previously unselected package libboost-python-dev.
Preparing to unpack .../119-libboost-python-dev_1.83.0.1ubuntu2_amd64.deb ...
Unpacking libboost-python-dev (1.83.0.1ubuntu2) ...
Selecting previously unselected package libbrotli-dev:amd64.
Preparing to unpack .../120-libbrotli-dev_1.1.0-2build2_amd64.deb ...
Unpacking libbrotli-dev:amd64 (1.1.0-2build2) ...
Selecting previously unselected package libmd-dev:amd64.
Preparing to unpack .../121-libmd-dev_1.1.0-2build1.1_amd64.deb ...
Unpacking libmd-dev:amd64 (1.1.0-2build1.1) ...
Selecting previously unselected package libbsd-dev:amd64.
Preparing to unpack .../122-libbsd-dev_0.12.1-1build1.1_amd64.deb ...
Unpacking libbsd-dev:amd64 (0.12.1-1build1.1) ...
Selecting previously unselected package libbz2-dev:amd64.
Preparing to unpack .../123-libbz2-dev_1.0.8-5.1ubuntu0.1_amd64.deb ...
Unpacking libbz2-dev:amd64 (1.0.8-5.1ubuntu0.1) ...
Selecting previously unselected package libcairo-script-interpreter2:amd64.
Preparing to unpack .../124-libcairo-script-interpreter2_1.18.0-3build1_amd64.deb ...
Unpacking libcairo-script-interpreter2:amd64 (1.18.0-3build1) ...
Selecting previously unselected package libpng-dev:amd64.
Preparing to unpack .../125-libpng-dev_1.6.43-5ubuntu0.6_amd64.deb ...
Unpacking libpng-dev:amd64 (1.6.43-5ubuntu0.6) ...
Selecting previously unselected package libfreetype-dev:amd64.
Preparing to unpack .../126-libfreetype-dev_2.13.2+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libfreetype-dev:amd64 (2.13.2+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libfontconfig-dev:amd64.
Preparing to unpack .../127-libfontconfig-dev_2.15.0-1.1ubuntu2_amd64.deb ...
Unpacking libfontconfig-dev:amd64 (2.15.0-1.1ubuntu2) ...
Selecting previously unselected package libpixman-1-dev:amd64.
Preparing to unpack .../128-libpixman-1-dev_0.42.2-1build1_amd64.deb ...
Unpacking libpixman-1-dev:amd64 (0.42.2-1build1) ...
Selecting previously unselected package libice-dev:amd64.
Preparing to unpack .../129-libice-dev_2%3a1.0.10-1build3_amd64.deb ...
Unpacking libice-dev:amd64 (2:1.0.10-1build3) ...
Selecting previously unselected package libsm-dev:amd64.
Preparing to unpack .../130-libsm-dev_2%3a1.2.3-1build3_amd64.deb ...
Unpacking libsm-dev:amd64 (2:1.2.3-1build3) ...
Selecting previously unselected package libxcb-render0-dev:amd64.
Preparing to unpack .../131-libxcb-render0-dev_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-render0-dev:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-shm0-dev:amd64.
Preparing to unpack .../132-libxcb-shm0-dev_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-shm0-dev:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxrender-dev:amd64.
Preparing to unpack .../133-libxrender-dev_1%3a0.9.10-1.1build1_amd64.deb ...
Unpacking libxrender-dev:amd64 (1:0.9.10-1.1build1) ...
Selecting previously unselected package libcairo2-dev:amd64.
Preparing to unpack .../134-libcairo2-dev_1.18.0-3build1_amd64.deb ...
Unpacking libcairo2-dev:amd64 (1.18.0-3build1) ...
Selecting previously unselected package libcap-dev:amd64.
Preparing to unpack .../135-libcap-dev_1%3a2.66-5ubuntu2.4_amd64.deb ...
Unpacking libcap-dev:amd64 (1:2.66-5ubuntu2.4) ...
Selecting previously unselected package libconfig-general-perl.
Preparing to unpack .../136-libconfig-general-perl_2.65-2_all.deb ...
Unpacking libconfig-general-perl (2.65-2) ...
Selecting previously unselected package libcss-dom-perl.
Preparing to unpack .../137-libcss-dom-perl_0.17-3_all.deb ...
Unpacking libcss-dom-perl (0.17-3) ...
Selecting previously unselected package libdatrie-dev:amd64.
Preparing to unpack .../138-libdatrie-dev_0.2.13-3build1_amd64.deb ...
Unpacking libdatrie-dev:amd64 (0.2.13-3build1) ...
Selecting previously unselected package libdeflate-dev:amd64.
Preparing to unpack .../139-libdeflate-dev_1.19-1build1.1_amd64.deb ...
Unpacking libdeflate-dev:amd64 (1.19-1build1.1) ...
Selecting previously unselected package libedit-dev:amd64.
Preparing to unpack .../140-libedit-dev_3.1-20230828-1build1_amd64.deb ...
Unpacking libedit-dev:amd64 (3.1-20230828-1build1) ...
Selecting previously unselected package libeditreadline-dev:amd64.
Preparing to unpack .../141-libeditreadline-dev_3.1-20230828-1build1_amd64.deb ...
Unpacking libeditreadline-dev:amd64 (3.1-20230828-1build1) ...
Selecting previously unselected package libglx-dev:amd64.
Preparing to unpack .../142-libglx-dev_1.7.0-1build1_amd64.deb ...
Unpacking libglx-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgl-dev:amd64.
Preparing to unpack .../143-libgl-dev_1.7.0-1build1_amd64.deb ...
Unpacking libgl-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libegl-dev:amd64.
Preparing to unpack .../144-libegl-dev_1.7.0-1build1_amd64.deb ...
Unpacking libegl-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libglvnd-core-dev:amd64.
Preparing to unpack .../145-libglvnd-core-dev_1.7.0-1build1_amd64.deb ...
Unpacking libglvnd-core-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgles1:amd64.
Preparing to unpack .../146-libgles1_1.7.0-1build1_amd64.deb ...
Unpacking libgles1:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgles2:amd64.
Preparing to unpack .../147-libgles2_1.7.0-1build1_amd64.deb ...
Unpacking libgles2:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgles-dev:amd64.
Preparing to unpack .../148-libgles-dev_1.7.0-1build1_amd64.deb ...
Unpacking libgles-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libopengl0:amd64.
Preparing to unpack .../149-libopengl0_1.7.0-1build1_amd64.deb ...
Unpacking libopengl0:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libopengl-dev:amd64.
Preparing to unpack .../150-libopengl-dev_1.7.0-1build1_amd64.deb ...
Unpacking libopengl-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libglvnd-dev:amd64.
Preparing to unpack .../151-libglvnd-dev_1.7.0-1build1_amd64.deb ...
Unpacking libglvnd-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libegl1-mesa-dev:amd64.
Preparing to unpack .../152-libegl1-mesa-dev_25.2.8-0ubuntu0.24.04.2_amd64.deb ...
Unpacking libegl1-mesa-dev:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Selecting previously unselected package libepoxy-dev:amd64.
Preparing to unpack .../153-libepoxy-dev_1.5.10-1build1_amd64.deb ...
Unpacking libepoxy-dev:amd64 (1.5.10-1build1) ...
Selecting previously unselected package libevent-2.1-7t64:amd64.
Preparing to unpack .../154-libevent-2.1-7t64_2.1.12-stable-9ubuntu2.1_amd64.deb ...
Unpacking libevent-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Preparing to unpack .../155-libevent-pthreads-2.1-7t64_2.1.12-stable-9ubuntu2.1_amd64.deb ...
Unpacking libevent-pthreads-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) over (2.1.12-stable-9ubuntu2) ...
Preparing to unpack .../156-libevent-core-2.1-7t64_2.1.12-stable-9ubuntu2.1_amd64.deb ...
Unpacking libevent-core-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) over (2.1.12-stable-9ubuntu2) ...
Selecting previously unselected package libflac12t64:amd64.
Preparing to unpack .../157-libflac12t64_1.4.3+ds-2.1ubuntu2_amd64.deb ...
Unpacking libflac12t64:amd64 (1.4.3+ds-2.1ubuntu2) ...
Selecting previously unselected package libfmt9:amd64.
Preparing to unpack .../158-libfmt9_9.1.0+ds1-2_amd64.deb ...
Unpacking libfmt9:amd64 (9.1.0+ds1-2) ...
Selecting previously unselected package libfribidi-dev:amd64.
Preparing to unpack .../159-libfribidi-dev_1.0.13-3build1_amd64.deb ...
Unpacking libfribidi-dev:amd64 (1.0.13-3build1) ...
Selecting previously unselected package libgdk-pixbuf2.0-bin.
Preparing to unpack .../160-libgdk-pixbuf2.0-bin_2.42.10+dfsg-3ubuntu3.3_amd64.deb ...
Unpacking libgdk-pixbuf2.0-bin (2.42.10+dfsg-3ubuntu3.3) ...
Selecting previously unselected package libjpeg-turbo8-dev:amd64.
Preparing to unpack .../161-libjpeg-turbo8-dev_2.1.5-2ubuntu2_amd64.deb ...
Unpacking libjpeg-turbo8-dev:amd64 (2.1.5-2ubuntu2) ...
Selecting previously unselected package libjbig-dev:amd64.
Preparing to unpack .../162-libjbig-dev_2.1-6.1ubuntu2_amd64.deb ...
Unpacking libjbig-dev:amd64 (2.1-6.1ubuntu2) ...
Selecting previously unselected package liblzma-dev:amd64.
Preparing to unpack .../163-liblzma-dev_5.6.1+really5.4.5-1ubuntu0.3_amd64.deb ...
Unpacking liblzma-dev:amd64 (5.6.1+really5.4.5-1ubuntu0.3) ...
Selecting previously unselected package libwebpdecoder3:amd64.
Preparing to unpack .../164-libwebpdecoder3_1.3.2-0.4build3_amd64.deb ...
Unpacking libwebpdecoder3:amd64 (1.3.2-0.4build3) ...
Selecting previously unselected package libsharpyuv-dev:amd64.
Preparing to unpack .../165-libsharpyuv-dev_1.3.2-0.4build3_amd64.deb ...
Unpacking libsharpyuv-dev:amd64 (1.3.2-0.4build3) ...
Selecting previously unselected package libwebp-dev:amd64.
Preparing to unpack .../166-libwebp-dev_1.3.2-0.4build3_amd64.deb ...
Unpacking libwebp-dev:amd64 (1.3.2-0.4build3) ...
Selecting previously unselected package libtiffxx6:amd64.
Preparing to unpack .../167-libtiffxx6_4.5.1+git230720-4ubuntu2.5_amd64.deb ...
Unpacking libtiffxx6:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Selecting previously unselected package liblerc-dev:amd64.
Preparing to unpack .../168-liblerc-dev_4.0.0+ds-4ubuntu2_amd64.deb ...
Unpacking liblerc-dev:amd64 (4.0.0+ds-4ubuntu2) ...
Selecting previously unselected package libtiff-dev:amd64.
Preparing to unpack .../169-libtiff-dev_4.5.1+git230720-4ubuntu2.5_amd64.deb ...
Unpacking libtiff-dev:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Selecting previously unselected package libgdk-pixbuf-2.0-dev:amd64.
Preparing to unpack .../170-libgdk-pixbuf-2.0-dev_2.42.10+dfsg-3ubuntu3.3_amd64.deb ...
Unpacking libgdk-pixbuf-2.0-dev:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Selecting previously unselected package libglu1-mesa:amd64.
Preparing to unpack .../171-libglu1-mesa_9.0.2-1.1build1_amd64.deb ...
Unpacking libglu1-mesa:amd64 (9.0.2-1.1build1) ...
Selecting previously unselected package libglu1-mesa-dev:amd64.
Preparing to unpack .../172-libglu1-mesa-dev_9.0.2-1.1build1_amd64.deb ...
Unpacking libglu1-mesa-dev:amd64 (9.0.2-1.1build1) ...
Selecting previously unselected package libgpiod2t64:amd64.
Preparing to unpack .../173-libgpiod2t64_1.6.3-1.1build1_amd64.deb ...
Unpacking libgpiod2t64:amd64 (1.6.3-1.1build1) ...
Selecting previously unselected package libgpiod-dev:amd64.
Preparing to unpack .../174-libgpiod-dev_1.6.3-1.1build1_amd64.deb ...
Unpacking libgpiod-dev:amd64 (1.6.3-1.1build1) ...
Selecting previously unselected package libgraphite2-dev:amd64.
Preparing to unpack .../175-libgraphite2-dev_1.3.14-2ubuntu0.24.04.1_amd64.deb ...
Unpacking libgraphite2-dev:amd64 (1.3.14-2ubuntu0.24.04.1) ...
Selecting previously unselected package libharfbuzz-icu0:amd64.
Preparing to unpack .../176-libharfbuzz-icu0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-icu0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libharfbuzz-subset0:amd64.
Preparing to unpack .../177-libharfbuzz-subset0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-subset0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libharfbuzz-cairo0:amd64.
Preparing to unpack .../178-libharfbuzz-cairo0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-cairo0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libharfbuzz-dev:amd64.
Preparing to unpack .../179-libharfbuzz-dev_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-dev:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libthai-dev:amd64.
Preparing to unpack .../180-libthai-dev_0.1.29-2build1_amd64.deb ...
Unpacking libthai-dev:amd64 (0.1.29-2build1) ...
Selecting previously unselected package libxft-dev:amd64.
Preparing to unpack .../181-libxft-dev_2.3.6-1build1_amd64.deb ...
Unpacking libxft-dev:amd64 (2.3.6-1build1) ...
Selecting previously unselected package pango1.0-tools.
Preparing to unpack .../182-pango1.0-tools_1.52.1+ds-1build1_amd64.deb ...
Unpacking pango1.0-tools (1.52.1+ds-1build1) ...
Selecting previously unselected package libpango1.0-dev:amd64.
Preparing to unpack .../183-libpango1.0-dev_1.52.1+ds-1build1_amd64.deb ...
Unpacking libpango1.0-dev:amd64 (1.52.1+ds-1build1) ...
Selecting previously unselected package libwayland-server0:amd64.
Preparing to unpack .../184-libwayland-server0_1.22.0-2.1build1_amd64.deb ...
Unpacking libwayland-server0:amd64 (1.22.0-2.1build1) ...
Selecting previously unselected package libwayland-bin.
Preparing to unpack .../185-libwayland-bin_1.22.0-2.1build1_amd64.deb ...
Unpacking libwayland-bin (1.22.0-2.1build1) ...
Selecting previously unselected package libwayland-dev:amd64.
Preparing to unpack .../186-libwayland-dev_1.22.0-2.1build1_amd64.deb ...
Unpacking libwayland-dev:amd64 (1.22.0-2.1build1) ...
Selecting previously unselected package libxcomposite-dev:amd64.
Preparing to unpack .../187-libxcomposite-dev_1%3a0.4.5-1build3_amd64.deb ...
Unpacking libxcomposite-dev:amd64 (1:0.4.5-1build3) ...
Selecting previously unselected package libxcursor-dev:amd64.
Preparing to unpack .../188-libxcursor-dev_1%3a1.2.1-1build1_amd64.deb ...
Unpacking libxcursor-dev:amd64 (1:1.2.1-1build1) ...
Selecting previously unselected package libxdamage-dev:amd64.
Preparing to unpack .../189-libxdamage-dev_1%3a1.1.6-1build1_amd64.deb ...
Unpacking libxdamage-dev:amd64 (1:1.1.6-1build1) ...
Selecting previously unselected package libxinerama-dev:amd64.
Preparing to unpack .../190-libxinerama-dev_2%3a1.1.4-3build1_amd64.deb ...
Unpacking libxinerama-dev:amd64 (2:1.1.4-3build1) ...
Selecting previously unselected package libxkbcommon-dev:amd64.
Preparing to unpack .../191-libxkbcommon-dev_1.6.0-1build1_amd64.deb ...
Unpacking libxkbcommon-dev:amd64 (1.6.0-1build1) ...
Selecting previously unselected package libxrandr-dev:amd64.
Preparing to unpack .../192-libxrandr-dev_2%3a1.5.2-2build1_amd64.deb ...
Unpacking libxrandr-dev:amd64 (2:1.5.2-2build1) ...
Selecting previously unselected package wayland-protocols.
Preparing to unpack .../193-wayland-protocols_1.45-1~ubuntu0.24.04.2_all.deb ...
Unpacking wayland-protocols (1.45-1~ubuntu0.24.04.2) ...
Selecting previously unselected package libgtk-3-dev:amd64.
Preparing to unpack .../194-libgtk-3-dev_3.24.41-4ubuntu1.3_amd64.deb ...
Unpacking libgtk-3-dev:amd64 (3.24.41-4ubuntu1.3) ...
Selecting previously unselected package liblapack3:amd64.
Preparing to unpack .../195-liblapack3_3.12.0-3build1.1_amd64.deb ...
Unpacking liblapack3:amd64 (3.12.0-3build1.1) ...
Selecting previously unselected package liblbfgsb0:amd64.
Preparing to unpack .../196-liblbfgsb0_3.0+dfsg.4-1build1_amd64.deb ...
Unpacking liblbfgsb0:amd64 (3.0+dfsg.4-1build1) ...
Selecting previously unselected package liblocale-codes-perl.
Preparing to unpack .../197-liblocale-codes-perl_3.77-1_all.deb ...
Unpacking liblocale-codes-perl (3.77-1) ...
Selecting previously unselected package libmime-charset-perl.
Preparing to unpack .../198-libmime-charset-perl_1.013.1-2_all.deb ...
Unpacking libmime-charset-perl (1.013.1-2) ...
Selecting previously unselected package libminizip1t64:amd64.
Preparing to unpack .../199-libminizip1t64_1%3a1.3.dfsg-3.1ubuntu2.2_amd64.deb ...
Unpacking libminizip1t64:amd64 (1:1.3.dfsg-3.1ubuntu2.2) ...
Selecting previously unselected package libmp3lame0:amd64.
Preparing to unpack .../200-libmp3lame0_3.100-6build1_amd64.deb ...
Unpacking libmp3lame0:amd64 (3.100-6build1) ...
Selecting previously unselected package libmpg123-0t64:amd64.
Preparing to unpack .../201-libmpg123-0t64_1.32.5-1ubuntu1.1_amd64.deb ...
Unpacking libmpg123-0t64:amd64 (1.32.5-1ubuntu1.1) ...
Selecting previously unselected package libnet-ip-perl.
Preparing to unpack .../202-libnet-ip-perl_1.26-3ubuntu0.24.04.1_all.deb ...
Unpacking libnet-ip-perl (1.26-3ubuntu0.24.04.1) ...
Selecting previously unselected package libnetpbm11t64:amd64.
Preparing to unpack .../203-libnetpbm11t64_2%3a11.05.02-1.1build1_amd64.deb ...
Unpacking libnetpbm11t64:amd64 (2:11.05.02-1.1build1) ...
Selecting previously unselected package libopus0:amd64.
Preparing to unpack .../204-libopus0_1.4-1build1_amd64.deb ...
Unpacking libopus0:amd64 (1.4-1build1) ...
Selecting previously unselected package libosp5.
Preparing to unpack .../205-libosp5_1.5.2-15ubuntu2_amd64.deb ...
Unpacking libosp5 (1.5.2-15ubuntu2) ...
Selecting previously unselected package libvorbisenc2:amd64.
Preparing to unpack .../206-libvorbisenc2_1.3.7-1build3_amd64.deb ...
Unpacking libvorbisenc2:amd64 (1.3.7-1build3) ...
Selecting previously unselected package libsndfile1:amd64.
Preparing to unpack .../207-libsndfile1_1.2.2-1ubuntu5.24.04.1_amd64.deb ...
Unpacking libsndfile1:amd64 (1.2.2-1ubuntu5.24.04.1) ...
Selecting previously unselected package libpulse0:amd64.
Preparing to unpack .../208-libpulse0_1%3a16.1+dfsg1-2ubuntu10.1_amd64.deb ...
Unpacking libpulse0:amd64 (1:16.1+dfsg1-2ubuntu10.1) ...
Selecting previously unselected package libqscintilla2-qt5-l10n.
Preparing to unpack .../209-libqscintilla2-qt5-l10n_2.14.1+dfsg-1build3_all.deb ...
Unpacking libqscintilla2-qt5-l10n (2.14.1+dfsg-1build3) ...
Selecting previously unselected package libqscintilla2-qt5-15:amd64.
Preparing to unpack .../210-libqscintilla2-qt5-15_2.14.1+dfsg-1build3_amd64.deb ...
Unpacking libqscintilla2-qt5-15:amd64 (2.14.1+dfsg-1build3) ...
Selecting previously unselected package libqt5charts5:amd64.
Preparing to unpack .../211-libqt5charts5_5.15.13-1_amd64.deb ...
Unpacking libqt5charts5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5xml5t64:amd64.
Preparing to unpack .../212-libqt5xml5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5xml5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5designer5:amd64.
Preparing to unpack .../213-libqt5designer5_5.15.13-1_amd64.deb ...
Unpacking libqt5designer5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5sql5t64:amd64.
Preparing to unpack .../214-libqt5sql5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5sql5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5help5:amd64.
Preparing to unpack .../215-libqt5help5_5.15.13-1_amd64.deb ...
Unpacking libqt5help5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5positioningquick5:amd64.
Preparing to unpack .../216-libqt5positioningquick5_5.15.13+dfsg-1_amd64.deb ...
Unpacking libqt5positioningquick5:amd64 (5.15.13+dfsg-1) ...
Selecting previously unselected package libqt5location5:amd64.
Preparing to unpack .../217-libqt5location5_5.15.13+dfsg-1_amd64.deb ...
Unpacking libqt5location5:amd64 (5.15.13+dfsg-1) ...
Selecting previously unselected package libqt5multimedia5:amd64.
Preparing to unpack .../218-libqt5multimedia5_5.15.13-1_amd64.deb ...
Unpacking libqt5multimedia5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5multimediawidgets5:amd64.
Preparing to unpack .../219-libqt5multimediawidgets5_5.15.13-1_amd64.deb ...
Unpacking libqt5multimediawidgets5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5opengl5t64:amd64.
Preparing to unpack .../220-libqt5opengl5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5opengl5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5quickwidgets5:amd64.
Preparing to unpack .../221-libqt5quickwidgets5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5quickwidgets5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5remoteobjects5:amd64.
Preparing to unpack .../222-libqt5remoteobjects5_5.15.13-1_amd64.deb ...
Unpacking libqt5remoteobjects5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5serialport5:amd64.
Preparing to unpack .../223-libqt5serialport5_5.15.13-1_amd64.deb ...
Unpacking libqt5serialport5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5svg5:amd64.
Preparing to unpack .../224-libqt5svg5_5.15.13-1_amd64.deb ...
Unpacking libqt5svg5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5test5t64:amd64.
Preparing to unpack .../225-libqt5test5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5test5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5texttospeech5:amd64.
Preparing to unpack .../226-libqt5texttospeech5_5.15.13-1_amd64.deb ...
Unpacking libqt5texttospeech5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5webengine-data.
Preparing to unpack .../227-libqt5webengine-data_5.15.16+dfsg-3_all.deb ...
Unpacking libqt5webengine-data (5.15.16+dfsg-3) ...
Selecting previously unselected package libvpx9:amd64.
Preparing to unpack .../228-libvpx9_1.14.0-1ubuntu2.3_amd64.deb ...
Unpacking libvpx9:amd64 (1.14.0-1ubuntu2.3) ...
Selecting previously unselected package libqt5webenginecore5:amd64.
Preparing to unpack .../229-libqt5webenginecore5_5.15.16+dfsg-3_amd64.deb ...
Unpacking libqt5webenginecore5:amd64 (5.15.16+dfsg-3) ...
Selecting previously unselected package libqt5webengine5:amd64.
Preparing to unpack .../230-libqt5webengine5_5.15.16+dfsg-3_amd64.deb ...
Unpacking libqt5webengine5:amd64 (5.15.16+dfsg-3) ...
Selecting previously unselected package libqt5webenginewidgets5:amd64.
Preparing to unpack .../231-libqt5webenginewidgets5_5.15.16+dfsg-3_amd64.deb ...
Unpacking libqt5webenginewidgets5:amd64 (5.15.16+dfsg-3) ...
Selecting previously unselected package libqt5websockets5:amd64.
Preparing to unpack .../232-libqt5websockets5_5.15.13-1_amd64.deb ...
Unpacking libqt5websockets5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5xmlpatterns5:amd64.
Preparing to unpack .../233-libqt5xmlpatterns5_5.15.13-1_amd64.deb ...
Unpacking libqt5xmlpatterns5:amd64 (5.15.13-1) ...
Selecting previously unselected package librsvg2-2:amd64.
Preparing to unpack .../234-librsvg2-2_2.58.0+dfsg-1build1_amd64.deb ...
Unpacking librsvg2-2:amd64 (2.58.0+dfsg-1build1) ...
Selecting previously unselected package librsvg2-bin.
Preparing to unpack .../235-librsvg2-bin_2.58.0+dfsg-1build1_amd64.deb ...
Unpacking librsvg2-bin (2.58.0+dfsg-1build1) ...
Selecting previously unselected package libsgmls-perl.
Preparing to unpack .../236-libsgmls-perl_1.03ii-38_all.deb ...
Unpacking libsgmls-perl (1.03ii-38) ...
Selecting previously unselected package libsombok3:amd64.
Preparing to unpack .../237-libsombok3_2.4.0-2build1_amd64.deb ...
Unpacking libsombok3:amd64 (2.4.0-2build1) ...
Selecting previously unselected package libudev-dev:amd64.
Preparing to unpack .../238-libudev-dev_255.4-1ubuntu8.17_amd64.deb ...
Unpacking libudev-dev:amd64 (255.4-1ubuntu8.17) ...
Selecting previously unselected package libunicode-linebreak-perl.
Preparing to unpack .../239-libunicode-linebreak-perl_0.0.20190101-1build7_amd64.deb ...
Unpacking libunicode-linebreak-perl (0.0.20190101-1build7) ...
Selecting previously unselected package libusb-1.0-0-dev:amd64.
Preparing to unpack .../240-libusb-1.0-0-dev_2%3a1.0.27-1_amd64.deb ...
Unpacking libusb-1.0-0-dev:amd64 (2:1.0.27-1) ...
Selecting previously unselected package libxt-dev:amd64.
Preparing to unpack .../241-libxt-dev_1%3a1.2.1-1.2build1_amd64.deb ...
Unpacking libxt-dev:amd64 (1:1.2.1-1.2build1) ...
Selecting previously unselected package libxmu-headers.
Preparing to unpack .../242-libxmu-headers_2%3a1.1.3-3build2_all.deb ...
Unpacking libxmu-headers (2:1.1.3-3build2) ...
Selecting previously unselected package libxmu-dev:amd64.
Preparing to unpack .../243-libxmu-dev_2%3a1.1.3-3build2_amd64.deb ...
Unpacking libxmu-dev:amd64 (2:1.1.3-3build2) ...
Selecting previously unselected package libxss-dev:amd64.
Preparing to unpack .../244-libxss-dev_1%3a1.2.3-1build3_amd64.deb ...
Unpacking libxss-dev:amd64 (1:1.2.3-1build3) ...
Selecting previously unselected package libxv1:amd64.
Preparing to unpack .../245-libxv1_2%3a1.0.11-1.1build1_amd64.deb ...
Unpacking libxv1:amd64 (2:1.0.11-1.1build1) ...
Selecting previously unselected package libxxf86dga1:amd64.
Preparing to unpack .../246-libxxf86dga1_2%3a1.1.5-1build1_amd64.deb ...
Unpacking libxxf86dga1:amd64 (2:1.1.5-1build1) ...
Selecting previously unselected package libyaml-tiny-perl.
Preparing to unpack .../247-libyaml-tiny-perl_1.74-1_all.deb ...
Unpacking libyaml-tiny-perl (1.74-1) ...
Selecting previously unselected package netpbm.
Preparing to unpack .../248-netpbm_2%3a11.05.02-1.1build1_amd64.deb ...
Unpacking netpbm (2:11.05.02-1.1build1) ...
Selecting previously unselected package opensp.
Preparing to unpack .../249-opensp_1.5.2-15ubuntu2_amd64.deb ...
Unpacking opensp (1.5.2-15ubuntu2) ...
Selecting previously unselected package po4a.
Preparing to unpack .../250-po4a_0.69-1_all.deb ...
Unpacking po4a (0.69-1) ...
Selecting previously unselected package pybind11-dev.
Preparing to unpack .../251-pybind11-dev_2.11.1-2_all.deb ...
Unpacking pybind11-dev (2.11.1-2) ...
Selecting previously unselected package python3-pyqt5.sip.
Preparing to unpack .../252-python3-pyqt5.sip_12.13.0-1build3_amd64.deb ...
Unpacking python3-pyqt5.sip (12.13.0-1build3) ...
Selecting previously unselected package python3-pyqt5.
Preparing to unpack .../253-python3-pyqt5_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5 (5.15.10+dfsg-1build6) ...
Selecting previously unselected package pyqt5-dev-tools.
Preparing to unpack .../254-pyqt5-dev-tools_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking pyqt5-dev-tools (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-appdirs.
Preparing to unpack .../255-python3-appdirs_1.4.4-4_all.deb ...
Unpacking python3-appdirs (1.4.4-4) ...
Selecting previously unselected package python3-brotli.
Preparing to unpack .../256-python3-brotli_1.1.0-2build2_amd64.deb ...
Unpacking python3-brotli (1.1.0-2build2) ...
Selecting previously unselected package python3-cairo.
Preparing to unpack .../257-python3-cairo_1.25.1-2build2_amd64.deb ...
Unpacking python3-cairo (1.25.1-2build2) ...
Selecting previously unselected package python3-dbus.mainloop.pyqt5.
Preparing to unpack .../258-python3-dbus.mainloop.pyqt5_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-dbus.mainloop.pyqt5 (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-decorator.
Preparing to unpack .../259-python3-decorator_5.1.1-5_all.deb ...
Unpacking python3-decorator (5.1.1-5) ...
Selecting previously unselected package python3-numpy.
Preparing to unpack .../260-python3-numpy_1%3a1.26.4+ds-6ubuntu1_amd64.deb ...
Unpacking python3-numpy (1:1.26.4+ds-6ubuntu1) ...
Selecting previously unselected package python3-scipy.
Preparing to unpack .../261-python3-scipy_1.11.4-6build1_amd64.deb ...
Unpacking python3-scipy (1.11.4-6build1) ...
Selecting previously unselected package python3-ufolib2.
Preparing to unpack .../262-python3-ufolib2_0.16.0+dfsg1-1_all.deb ...
Unpacking python3-ufolib2 (0.16.0+dfsg1-1) ...
Selecting previously unselected package python3-mpmath.
Preparing to unpack .../263-python3-mpmath_1.2.1-3_all.deb ...
Unpacking python3-mpmath (1.2.1-3) ...
Selecting previously unselected package python3-sympy.
Preparing to unpack .../264-python3-sympy_1.12-7_all.deb ...
Unpacking python3-sympy (1.12-7) ...
Selecting previously unselected package python3-fs.
Preparing to unpack .../265-python3-fs_2.4.16-3_all.deb ...
Unpacking python3-fs (2.4.16-3) ...
Selecting previously unselected package python3-lxml:amd64.
Preparing to unpack .../266-python3-lxml_5.2.1-1_amd64.deb ...
Unpacking python3-lxml:amd64 (5.2.1-1) ...
Selecting previously unselected package python3-lz4.
Preparing to unpack .../267-python3-lz4_4.0.2+dfsg-1build4_amd64.deb ...
Unpacking python3-lz4 (4.0.2+dfsg-1build4) ...
Selecting previously unselected package python3-unicodedata2.
Preparing to unpack .../268-python3-unicodedata2_15.1.0+ds-1build1_amd64.deb ...
Unpacking python3-unicodedata2 (15.1.0+ds-1build1) ...
Selecting previously unselected package unicode-data.
Preparing to unpack .../269-unicode-data_15.1.0-1_all.deb ...
Unpacking unicode-data (15.1.0-1) ...
Selecting previously unselected package python3-fonttools.
Preparing to unpack .../270-python3-fonttools_4.46.0-1build2_amd64.deb ...
Unpacking python3-fonttools (4.46.0-1build2) ...
Selecting previously unselected package python3-gi-cairo.
Preparing to unpack .../271-python3-gi-cairo_3.48.2-1_amd64.deb ...
Unpacking python3-gi-cairo (3.48.2-1) ...
Selecting previously unselected package python3-opengl.
Preparing to unpack .../272-python3-opengl_3.1.7+dfsg-1_all.deb ...
Unpacking python3-opengl (3.1.7+dfsg-1) ...
Selecting previously unselected package python3-py.
Preparing to unpack .../273-python3-py_1.11.0-2_all.deb ...
Unpacking python3-py (1.11.0-2) ...
Selecting previously unselected package python3-pybind11.
Preparing to unpack .../274-python3-pybind11_2.11.1-2_all.deb ...
Unpacking python3-pybind11 (2.11.1-2) ...
Selecting previously unselected package python3-pyqt5.qsci.
Preparing to unpack .../275-python3-pyqt5.qsci_2.14.1+dfsg-1build3_amd64.deb ...
Unpacking python3-pyqt5.qsci (2.14.1+dfsg-1build3) ...
Selecting previously unselected package python3-pyqt5.qtchart.
Preparing to unpack .../276-python3-pyqt5.qtchart_5.15.6+dfsg-1build2_amd64.deb ...
Unpacking python3-pyqt5.qtchart (5.15.6+dfsg-1build2) ...
Selecting previously unselected package python3-pyqt5.qtmultimedia.
Preparing to unpack .../277-python3-pyqt5.qtmultimedia_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtmultimedia (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtopengl.
Preparing to unpack .../278-python3-pyqt5.qtopengl_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtopengl (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtpositioning.
Preparing to unpack .../279-python3-pyqt5.qtpositioning_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtpositioning (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtquick.
Preparing to unpack .../280-python3-pyqt5.qtquick_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtquick (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtremoteobjects.
Preparing to unpack .../281-python3-pyqt5.qtremoteobjects_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtremoteobjects (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtsensors.
Preparing to unpack .../282-python3-pyqt5.qtsensors_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtsensors (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtserialport.
Preparing to unpack .../283-python3-pyqt5.qtserialport_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtserialport (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtsql.
Preparing to unpack .../284-python3-pyqt5.qtsql_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtsql (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtsvg.
Preparing to unpack .../285-python3-pyqt5.qtsvg_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtsvg (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qttexttospeech.
Preparing to unpack .../286-python3-pyqt5.qttexttospeech_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qttexttospeech (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtwebchannel.
Preparing to unpack .../287-python3-pyqt5.qtwebchannel_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtwebchannel (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtwebengine.
Preparing to unpack .../288-python3-pyqt5.qtwebengine_5.15.6-1build2_amd64.deb ...
Unpacking python3-pyqt5.qtwebengine (5.15.6-1build2) ...
Selecting previously unselected package python3-pyqt5.qtwebkit.
Preparing to unpack .../289-python3-pyqt5.qtwebkit_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtwebkit (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtwebsockets.
Preparing to unpack .../290-python3-pyqt5.qtwebsockets_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtwebsockets (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtxmlpatterns.
Preparing to unpack .../291-python3-pyqt5.qtxmlpatterns_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtxmlpatterns (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-qtpy.
Preparing to unpack .../292-python3-qtpy_2.4.1-2_all.deb ...
Unpacking python3-qtpy (2.4.1-2) ...
Selecting previously unselected package python3-tk:amd64.
Preparing to unpack .../293-python3-tk_3.12.3-0ubuntu1_amd64.deb ...
Unpacking python3-tk:amd64 (3.12.3-0ubuntu1) ...
Selecting previously unselected package python3-yapps.
Preparing to unpack .../294-python3-yapps_2.2.1-3.2_all.deb ...
Unpacking python3-yapps (2.2.1-3.2) ...
Selecting previously unselected package python3-zmq.
Preparing to unpack .../295-python3-zmq_24.0.1-5build1_amd64.deb ...
Unpacking python3-zmq (24.0.1-5build1) ...
Selecting previously unselected package ruby-public-suffix.
Preparing to unpack .../296-ruby-public-suffix_4.0.6+ds-2_all.deb ...
Unpacking ruby-public-suffix (4.0.6+ds-2) ...
Selecting previously unselected package ruby-addressable.
Preparing to unpack .../297-ruby-addressable_2.8.5-1_all.deb ...
Unpacking ruby-addressable (2.8.5-1) ...
Selecting previously unselected package ruby-afm.
Preparing to unpack .../298-ruby-afm_0.2.2-3_all.deb ...
Unpacking ruby-afm (0.2.2-3) ...
Selecting previously unselected package ruby-ascii85.
Preparing to unpack .../299-ruby-ascii85_1.0.3-1_all.deb ...
Unpacking ruby-ascii85 (1.0.3-1) ...
Selecting previously unselected package ruby-concurrent.
Preparing to unpack .../300-ruby-concurrent_1.2.3-2build1_all.deb ...
Unpacking ruby-concurrent (1.2.3-2build1) ...
Selecting previously unselected package ruby-pdf-core.
Preparing to unpack .../301-ruby-pdf-core_0.9.0-1_all.deb ...
Unpacking ruby-pdf-core (0.9.0-1) ...
Selecting previously unselected package ruby-ttfunk.
Preparing to unpack .../302-ruby-ttfunk_1.7.0-1_all.deb ...
Unpacking ruby-ttfunk (1.7.0-1) ...
Selecting previously unselected package ruby-prawn.
Preparing to unpack .../303-ruby-prawn_2.4.0+dfsg-1~_all.deb ...
Unpacking ruby-prawn (2.4.0+dfsg-1~) ...
Selecting previously unselected package ruby-rc4.
Preparing to unpack .../304-ruby-rc4_0.1.5-3.1_all.deb ...
Unpacking ruby-rc4 (0.1.5-3.1) ...
Selecting previously unselected package ruby-hashery.
Preparing to unpack .../305-ruby-hashery_2.1.2-1.1_all.deb ...
Unpacking ruby-hashery (2.1.2-1.1) ...
Selecting previously unselected package ruby-pdf-reader.
Preparing to unpack .../306-ruby-pdf-reader_2.11.0-1_all.deb ...
Unpacking ruby-pdf-reader (2.11.0-1) ...
Selecting previously unselected package ruby-prawn-templates.
Preparing to unpack .../307-ruby-prawn-templates_0.1.2-3_all.deb ...
Unpacking ruby-prawn-templates (0.1.2-3) ...
Selecting previously unselected package ruby-prawn-icon.
Preparing to unpack .../308-ruby-prawn-icon_3.1.0-1_all.deb ...
Unpacking ruby-prawn-icon (3.1.0-1) ...
Selecting previously unselected package ruby-css-parser.
Preparing to unpack .../309-ruby-css-parser_1.16.0-1_all.deb ...
Unpacking ruby-css-parser (1.16.0-1) ...
Selecting previously unselected package ruby-prawn-svg.
Preparing to unpack .../310-ruby-prawn-svg_0.32.0-1_all.deb ...
Unpacking ruby-prawn-svg (0.32.0-1) ...
Selecting previously unselected package ruby-prawn-table.
Preparing to unpack .../311-ruby-prawn-table_0.2.2-1.1_all.deb ...
Unpacking ruby-prawn-table (0.2.2-1.1) ...
Selecting previously unselected package ruby-polyglot.
Preparing to unpack .../312-ruby-polyglot_0.3.4-1.1_all.deb ...
Unpacking ruby-polyglot (0.3.4-1.1) ...
Selecting previously unselected package ruby-treetop.
Preparing to unpack .../313-ruby-treetop_1.6.12-1_all.deb ...
Unpacking ruby-treetop (1.6.12-1) ...
Selecting previously unselected package ruby-asciidoctor-pdf.
Preparing to unpack .../314-ruby-asciidoctor-pdf_2.3.4-3_all.deb ...
Unpacking ruby-asciidoctor-pdf (2.3.4-3) ...
Selecting previously unselected package ruby-rouge.
Preparing to unpack .../315-ruby-rouge_4.2.0-1_all.deb ...
Unpacking ruby-rouge (4.2.0-1) ...
Selecting previously unselected package tcl8.6-dev:amd64.
Preparing to unpack .../316-tcl8.6-dev_8.6.14+dfsg-1build1_amd64.deb ...
Unpacking tcl8.6-dev:amd64 (8.6.14+dfsg-1build1) ...
Selecting previously unselected package tclx8.4.
Preparing to unpack .../317-tclx8.4_8.4.1-4_amd64.deb ...
Unpacking tclx8.4 (8.4.1-4) ...
Selecting previously unselected package tk8.6-dev:amd64.
Preparing to unpack .../318-tk8.6-dev_8.6.14-1build1_amd64.deb ...
Unpacking tk8.6-dev:amd64 (8.6.14-1build1) ...
Selecting previously unselected package w3c-linkchecker.
Preparing to unpack .../319-w3c-linkchecker_5.0.0-2_all.deb ...
Unpacking w3c-linkchecker (5.0.0-2) ...
Selecting previously unselected package x11-utils.
Preparing to unpack .../320-x11-utils_7.7+6build2_amd64.deb ...
Unpacking x11-utils (7.7+6build2) ...
Selecting previously unselected package x11-xserver-utils.
Preparing to unpack .../321-x11-xserver-utils_7.7+10build2_amd64.deb ...
Unpacking x11-xserver-utils (7.7+10build2) ...
Selecting previously unselected package yapps2.
Preparing to unpack .../322-yapps2_2.2.1-3.2_all.deb ...
Unpacking yapps2 (2.2.1-3.2) ...
Selecting previously unselected package libfmt-dev:amd64.
Preparing to unpack .../323-libfmt-dev_9.1.0+ds1-2_amd64.deb ...
Unpacking libfmt-dev:amd64 (9.1.0+ds1-2) ...
Selecting previously unselected package libmodbus5:amd64.
Preparing to unpack .../324-libmodbus5_3.1.10-1ubuntu1_amd64.deb ...
Unpacking libmodbus5:amd64 (3.1.10-1ubuntu1) ...
Selecting previously unselected package libmodbus-dev:amd64.
Preparing to unpack .../325-libmodbus-dev_3.1.10-1ubuntu1_amd64.deb ...
Unpacking libmodbus-dev:amd64 (3.1.10-1ubuntu1) ...
Selecting previously unselected package libtirpc-dev:amd64.
Preparing to unpack .../326-libtirpc-dev_1.3.4+ds-1.1build1_amd64.deb ...
Unpacking libtirpc-dev:amd64 (1.3.4+ds-1.1build1) ...
Selecting previously unselected package python3-xlib.
Preparing to unpack .../327-python3-xlib_0.33-2_all.deb ...
Unpacking python3-xlib (0.33-2) ...
Setting up dh-python (6.20240401) ...
Setting up python3-xlib (0.33-2) ...
Setting up libcairo-script-interpreter2:amd64 (1.18.0-3build1) ...
Setting up libboost-python1.83.0 (1.83.0-2.1ubuntu3.2) ...
Setting up libglib2.0-dev-bin (2.80.0-6ubuntu3.8) ...
Setting up libwayland-server0:amd64 (1.22.0-2.1build1) ...
Setting up libpaper1:amd64 (1.1.29build1) ...

Creating config file /etc/papersize with new version
Setting up libxml-parser-perl (2.47-1ubuntu0.24.04.1) ...
Setting up libjpeg-turbo8-dev:amd64 (2.1.5-2ubuntu2) ...
Setting up libdouble-conversion3:amd64 (3.3.0-1build1) ...
Setting up libcss-dom-perl (0.17-3) ...
Setting up libmodbus5:amd64 (3.1.10-1ubuntu1) ...
Setting up tk8.6-blt2.5 (2.5.3+dfsg-7build1) ...
Setting up libboost1.83-dev:amd64 (1.83.0-2.1ubuntu3.2) ...
Setting up libsgmls-perl (1.03ii-38) ...
Setting up gir1.2-freedesktop:amd64 (1.80.1-1) ...
Setting up libconfig-general-perl (2.65-2) ...
Setting up libharfbuzz-icu0:amd64 (8.3.0-2build2) ...
Setting up libpixman-1-dev:amd64 (0.42.2-1build1) ...
Setting up python3-cairo (1.25.1-2build2) ...
Setting up desktop-file-utils (0.27-2build1) ...
Setting up libpangoxft-1.0-0:amd64 (1.52.1+ds-1build1) ...
Setting up libglvnd-core-dev:amd64 (1.7.0-1build1) ...
Setting up libqt5webengine-data (5.15.16+dfsg-3) ...
Setting up libxcb-xinput0:amd64 (1.15-1ubuntu2) ...
Setting up libwoff1:amd64 (1.0.2-2build1) ...
Setting up python3-py (1.11.0-2) ...
Setting up gir1.2-gdkpixbuf-2.0:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Setting up libhyphen0:amd64 (2.8.8-7build3) ...
Setting up libdebuginfod-common (0.190-1.1ubuntu0.1) ...
Setting up libgirepository-2.0-0:amd64 (2.80.0-6ubuntu3.8) ...
Setting up libsombok3:amd64 (2.4.0-2build1) ...
Setting up python3-lz4 (4.0.2+dfsg-1build4) ...
Setting up gir1.2-atk-1.0:amd64 (2.52.0-1build1) ...
Setting up python3-unicodedata2 (15.1.0+ds-1build1) ...
Setting up libqscintilla2-qt5-l10n (2.14.1+dfsg-1build3) ...
Setting up libijs-0.35:amd64 (0.35-15.1build1) ...
Setting up libfribidi-dev:amd64 (1.0.13-3build1) ...
Setting up ruby-public-suffix (4.0.6+ds-2) ...
Setting up blt (2.5.3+dfsg-7build1) ...
Setting up tcl8.6-dev:amd64 (8.6.14+dfsg-1build1) ...
Setting up libxkbcommon-dev:amd64 (1.6.0-1build1) ...
Setting up libgs-common (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up ruby-afm (0.2.2-3) ...
Setting up fonts-noto-cjk (1:20230817+repack1-3) ...
Setting up liblab-gamut1:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libpng-dev:amd64 (1.6.43-5ubuntu0.6) ...
Setting up pango1.0-tools (1.52.1+ds-1build1) ...
Setting up libxcb-keysyms1:amd64 (0.4.0-1build4) ...
Setting up libxcb-shape0:amd64 (1.15-1ubuntu2) ...
Setting up libxxf86dga1:amd64 (2:1.1.5-1build1) ...
Setting up libjbig-dev:amd64 (2.1-6.1ubuntu2) ...
Setting up libwebpdecoder3:amd64 (1.3.2-0.4build3) ...
Setting up libusb-1.0-0-dev:amd64 (2:1.0.27-1) ...
Setting up libevent-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Setting up libxcb-render-util0:amd64 (0.3.9-1build4) ...
Setting up python3-tk:amd64 (3.12.3-0ubuntu1) ...
Setting up ruby-pdf-core (0.9.0-1) ...
Setting up libxcb-icccm4:amd64 (0.4.1-1.1build3) ...
Setting up libharfbuzz-gobject0:amd64 (8.3.0-2build2) ...
Setting up gir1.2-atspi-2.0:amd64 (2.52.0-1build1) ...
Setting up libmpg123-0t64:amd64 (1.32.5-1ubuntu1.1) ...
Setting up ruby-concurrent (1.2.3-2build1) ...
Setting up x11-xserver-utils (7.7+10build2) ...
Setting up libyaml-tiny-perl (1.74-1) ...
Setting up gir1.2-harfbuzz-0.0:amd64 (8.3.0-2build2) ...
Setting up libpthread-stubs0-dev:amd64 (0.4-1build3) ...
Setting up pybind11-dev (2.11.1-2) ...
Setting up libnetpbm11t64:amd64 (2:11.05.02-1.1build1) ...
Setting up libsource-highlight-common (3.1.9-4.3build1) ...
Setting up libopengl0:amd64 (1.7.0-1build1) ...
Setting up libxcb-util1:amd64 (0.4.0-1build3) ...
Setting up poppler-data (0.4.12-1) ...
Setting up liborc-0.4-0t64:amd64 (1:0.4.38-1ubuntu0.1) ...
Setting up libxcb-xkb1:amd64 (1.15-1ubuntu2) ...
Setting up libxcb-image0:amd64 (0.4.0-2build1) ...
Setting up libosp5 (1.5.2-15ubuntu2) ...
Setting up librsvg2-2:amd64 (2.58.0+dfsg-1build1) ...
Setting up unicode-data (15.1.0-1) ...
Setting up ruby-hashery (2.1.2-1.1) ...
Setting up xtrans-dev (1.4.0-1) ...
Setting up libqt5core5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libwayland-bin (1.22.0-2.1build1) ...
Setting up python3-decorator (5.1.1-5) ...
Setting up libqt5texttospeech5:amd64 (5.15.13-1) ...
Setting up libgraphite2-dev:amd64 (1.3.14-2ubuntu0.24.04.1) ...
Setting up gir1.2-pango-1.0:amd64 (1.52.1+ds-1build1) ...
Setting up libblas3:amd64 (3.12.0-3build1.1) ...
update-alternatives: using /usr/lib/x86_64-linux-gnu/blas/libblas.so.3 to provide /usr/lib/x86_64-linux-gnu/libblas.so.3 (libblas.so.3-x86_64-linux-gnu) in auto mode
Setting up libegl-mesa0:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Setting up libxcb-xinerama0:amd64 (1.15-1ubuntu2) ...
Setting up libtirpc-dev:amd64 (1.3.4+ds-1.1build1) ...
Setting up libgles2:amd64 (1.7.0-1build1) ...
Setting up libharfbuzz-cairo0:amd64 (8.3.0-2build2) ...
Setting up libdbus-1-dev:amd64 (1.14.10-4ubuntu4.1) ...
Setting up libjbig2dec0:amd64 (0.20-1ubuntu0.24.04.1) ...
Setting up uuid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Setting up libpathplan4:amd64 (2.42.2-9ubuntu0.1) ...
Setting up python3-zmq (24.0.1-5build1) ...
Setting up python3-brotli (1.1.0-2build2) ...
Setting up libann0 (1.1.2+doc-9build1) ...
Setting up libgles1:amd64 (1.7.0-1build1) ...
Setting up xfonts-encodings (1:1.0.5-0ubuntu2) ...
Setting up libopus0:amd64 (1.4-1build1) ...
Setting up libboost-python1.83-dev (1.83.0-2.1ubuntu3.2) ...
Setting up ruby-asciidoctor (2.0.20-1) ...
Setting up libxkbcommon-x11-0:amd64 (1.6.0-1build1) ...
Setting up libxv1:amd64 (2:1.0.11-1.1build1) ...
Setting up libidn12:amd64 (1.42-1ubuntu0.1) ...
Setting up intltool (0.51.0-6) ...
Setting up libipt2 (2.0.6-1build1) ...
Setting up libudev-dev:amd64 (255.4-1ubuntu8.17) ...
Setting up libsepol-dev:amd64 (3.5-2build1) ...
Setting up liblerc-dev:amd64 (4.0.0+ds-4ubuntu2) ...
Setting up netpbm (2:11.05.02-1.1build1) ...
Setting up libbabeltrace1:amd64 (1.5.11-3build3) ...
Setting up libfmt9:amd64 (9.1.0+ds1-2) ...
Setting up asciidoctor (2.0.20-1) ...
Setting up liblzma-dev:amd64 (5.6.1+really5.4.5-1ubuntu0.3) ...
Setting up imagemagick-6.q16 (8:6.9.12.98+dfsg1-5.2build2) ...
update-alternatives: using /usr/bin/compare-im6.q16 to provide /usr/bin/compare (compare) in auto mode
update-alternatives: using /usr/bin/compare-im6.q16 to provide /usr/bin/compare-im6 (compare-im6) in auto mode
update-alternatives: using /usr/bin/animate-im6.q16 to provide /usr/bin/animate (animate) in auto mode
update-alternatives: using /usr/bin/animate-im6.q16 to provide /usr/bin/animate-im6 (animate-im6) in auto mode
update-alternatives: using /usr/bin/convert-im6.q16 to provide /usr/bin/convert (convert) in auto mode
update-alternatives: using /usr/bin/convert-im6.q16 to provide /usr/bin/convert-im6 (convert-im6) in auto mode
update-alternatives: using /usr/bin/composite-im6.q16 to provide /usr/bin/composite (composite) in auto mode
update-alternatives: using /usr/bin/composite-im6.q16 to provide /usr/bin/composite-im6 (composite-im6) in auto mode
update-alternatives: using /usr/bin/conjure-im6.q16 to provide /usr/bin/conjure (conjure) in auto mode
update-alternatives: using /usr/bin/conjure-im6.q16 to provide /usr/bin/conjure-im6 (conjure-im6) in auto mode
update-alternatives: using /usr/bin/import-im6.q16 to provide /usr/bin/import (import) in auto mode
update-alternatives: using /usr/bin/import-im6.q16 to provide /usr/bin/import-im6 (import-im6) in auto mode
update-alternatives: using /usr/bin/identify-im6.q16 to provide /usr/bin/identify (identify) in auto mode
update-alternatives: using /usr/bin/identify-im6.q16 to provide /usr/bin/identify-im6 (identify-im6) in auto mode
update-alternatives: using /usr/bin/stream-im6.q16 to provide /usr/bin/stream (stream) in auto mode
update-alternatives: using /usr/bin/stream-im6.q16 to provide /usr/bin/stream-im6 (stream-im6) in auto mode
update-alternatives: using /usr/bin/display-im6.q16 to provide /usr/bin/display (display) in auto mode
update-alternatives: using /usr/bin/display-im6.q16 to provide /usr/bin/display-im6 (display-im6) in auto mode
update-alternatives: using /usr/bin/montage-im6.q16 to provide /usr/bin/montage (montage) in auto mode
update-alternatives: using /usr/bin/montage-im6.q16 to provide /usr/bin/montage-im6 (montage-im6) in auto mode
update-alternatives: using /usr/bin/mogrify-im6.q16 to provide /usr/bin/mogrify (mogrify) in auto mode
update-alternatives: using /usr/bin/mogrify-im6.q16 to provide /usr/bin/mogrify-im6 (mogrify-im6) in auto mode
Setting up python3-pyqt5.sip (12.13.0-1build3) ...
Setting up liblocale-codes-perl (3.77-1) ...
Setting up libvpx9:amd64 (1.14.0-1ubuntu2.3) ...
Setting up ruby-rc4 (0.1.5-3.1) ...
Setting up wayland-protocols (1.45-1~ubuntu0.24.04.2) ...
Setting up libdatrie-dev:amd64 (0.2.13-3build1) ...
Setting up libmtdev1t64:amd64 (1.1.6-1.1build1) ...
Setting up ruby-ttfunk (1.7.0-1) ...
Setting up libminizip1t64:amd64 (1:1.3.dfsg-3.1ubuntu2.2) ...
Setting up ruby-rouge (4.2.0-1) ...
Setting up gir1.2-glib-2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Setting up libasyncns0:amd64 (0.8-6build4) ...
Setting up libgdk-pixbuf2.0-bin (2.42.10+dfsg-3ubuntu3.3) ...
Setting up python3-lxml:amd64 (5.2.1-1) ...
Setting up libmime-charset-perl (1.013.1-2) ...
Setting up tclx8.4 (8.4.1-4) ...
Setting up libmd-dev:amd64 (1.1.0-2build1.1) ...
Setting up libegl1:amd64 (1.7.0-1build1) ...
Setting up x11-utils (7.7+6build2) ...
Setting up libqt5sql5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libmd4c0:amd64 (0.4.8-1build1) ...
Setting up libharfbuzz-subset0:amd64 (8.3.0-2build2) ...
Setting up xorg-sgml-doctools (1:1.11-1.1) ...
Setting up libgts-0.7-5t64:amd64 (0.7.6+darcs121130-5.2build1) ...
Setting up libcdt5:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libcgraph6:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libevent-core-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Setting up libglu1-mesa:amd64 (9.0.2-1.1build1) ...
Setting up bwidget (1.9.16-1) ...
Setting up libflac12t64:amd64 (1.4.3+ds-2.1ubuntu2) ...
Setting up ruby-polyglot (0.3.4-1.1) ...
Setting up libopengl-dev:amd64 (1.7.0-1build1) ...
Setting up libgpiod2t64:amd64 (1.6.3-1.1build1) ...
Setting up python3-mpmath (1.2.1-3) ...
Setting up libsharpyuv-dev:amd64 (1.3.2-0.4build3) ...
Setting up libnet-ip-perl (1.26-3ubuntu0.24.04.1) ...
Setting up python3-gi-cairo (3.48.2-1) ...
Setting up libtiffxx6:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Setting up python3-yapps (2.2.1-3.2) ...
Setting up libcap-dev:amd64 (1:2.66-5ubuntu2.4) ...
Setting up libdeflate-dev:amd64 (1.19-1build1.1) ...
Setting up ruby-ascii85 (1.0.3-1) ...
Setting up python3-appdirs (1.4.4-4) ...
Setting up libgtksourceview-4-common (4.8.4-5build4) ...
Setting up libbsd-dev:amd64 (0.12.1-1build1.1) ...
Setting up libbrotli-dev:amd64 (1.1.0-2build2) ...
Setting up python3-pybind11 (2.11.1-2) ...
Setting up libmp3lame0:amd64 (3.100-6build1) ...
Setting up libvorbisenc2:amd64 (1.3.7-1build3) ...
Setting up libwacom-common (2.10.0-2) ...
Setting up libbz2-dev:amd64 (1.0.8-5.1ubuntu0.1) ...
Setting up libmodbus-dev:amd64 (3.1.10-1ubuntu1) ...
Setting up python3-dbus.mainloop.pyqt5 (5.15.10+dfsg-1build6) ...
Setting up ruby-addressable (2.8.5-1) ...
Setting up python3-sympy (1.12-7) ...
Setting up librsvg2-bin (2.58.0+dfsg-1build1) ...
Setting up libblkid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Setting up w3c-linkchecker (5.0.0-2) ...

Creating config file /etc/w3c/checklink.conf with new version
apache2_invoke: Enable configuration w3c-linkchecker
[0;1;31mapache2.service is not active, cannot reload.[0m
invoke-rc.d: initscript apache2, action "reload" failed.
Setting up libdebuginfod1t64:amd64 (0.190-1.1ubuntu0.1) ...
Setting up liblapack3:amd64 (3.12.0-3build1.1) ...
update-alternatives: using /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3 to provide /usr/lib/x86_64-linux-gnu/liblapack.so.3 (liblapack.so.3-x86_64-linux-gnu) in auto mode
Setting up libqt5dbus5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libwacom9:amd64 (2.10.0-2) ...
Setting up libselinux1-dev:amd64 (3.5-2ubuntu2.1) ...
Setting up libevent-pthreads-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Setting up libqt5positioning5:amd64 (5.15.13+dfsg-1) ...
Setting up ruby-pdf-reader (2.11.0-1) ...
Setting up libqt5network5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up gir1.2-gtk-3.0:amd64 (3.24.41-4ubuntu1.3) ...
Setting up libqt5xml5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libgstreamer-plugins-base1.0-0:amd64 (1.24.2-1ubuntu0.4) ...
Setting up ruby-treetop (1.6.12-1) ...
Setting up libsource-highlight4t64:amd64 (3.1.9-4.3build1) ...
Setting up libqt5serialport5:amd64 (5.15.13-1) ...
Setting up opensp (1.5.2-15ubuntu2) ...
Setting up libqt5test5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up python3-opengl (3.1.7+dfsg-1) ...
/usr/lib/python3/dist-packages/OpenGL/GL/AMD/vertex_shader_tessellator.py:1: SyntaxWarning: invalid escape sequence '\ '
  '''OpenGL extension AMD.vertex_shader_tessellator
Setting up xfonts-utils (1:7.7+6build3) ...
Setting up libwayland-dev:amd64 (1.22.0-2.1build1) ...
Setting up libboost-python-dev (1.83.0.1ubuntu2) ...
Setting up libinput-bin (1.25.0-1ubuntu3.6) ...
Setting up libfreetype-dev:amd64 (2.13.2+dfsg-1ubuntu0.1) ...
Setting up python3-fs (2.4.16-3) ...
Setting up libqt5websockets5:amd64 (5.15.13-1) ...
Setting up libgtksourceview-4-0:amd64 (4.8.4-5build4) ...
Setting up libwebp-dev:amd64 (1.3.2-0.4build3) ...
Setting up gdb (15.1-1ubuntu1~24.04.1) ...
Setting up ruby-prawn (2.4.0+dfsg-1~) ...
Setting up ruby-css-parser (1.16.0-1) ...
Setting up libtiff-dev:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Setting up libqt5qml5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up libunicode-linebreak-perl (0.0.20190101-1build7) ...
Setting up gir1.2-freedesktop-dev:amd64 (1.80.1-1) ...
Setting up libedit-dev:amd64 (3.1-20230828-1build1) ...
Setting up libgvc6 (2.42.2-9ubuntu0.1) ...
Setting up libfmt-dev:amd64 (9.1.0+ds1-2) ...
Setting up libqt5webchannel5:amd64 (5.15.13-1) ...
Setting up ruby-prawn-table (0.2.2-1.1) ...
Setting up python3-numpy (1:1.26.4+ds-6ubuntu1) ...
Setting up imagemagick (8:6.9.12.98+dfsg1-5.2build2) ...
Setting up libthai-dev:amd64 (0.1.29-2build1) ...
Setting up libgvpr2:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libgpiod-dev:amd64 (1.6.3-1.1build1) ...
Setting up libsndfile1:amd64 (1.2.2-1ubuntu5.24.04.1) ...
Setting up ruby-prawn-templates (0.1.2-3) ...
Setting up libqt5sensors5:amd64 (5.15.13-1) ...
Setting up yapps2 (2.2.1-3.2) ...
Setting up libmount-dev:amd64 (2.39.3-9ubuntu6.6) ...
Setting up liblbfgsb0:amd64 (3.0+dfsg.4-1build1) ...
Setting up graphviz (2.42.2-9ubuntu0.1) ...
Setting up libinput10:amd64 (1.25.0-1ubuntu3.6) ...
Setting up gir1.2-gtksource-4:amd64 (4.8.4-5build4) ...
Setting up libqt5qmlmodels5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up python3-scipy (1.11.4-6build1) ...
Setting up libpulse0:amd64 (1:16.1+dfsg1-2ubuntu10.1) ...
Setting up libqt5xmlpatterns5:amd64 (5.15.13-1) ...
Setting up libfontconfig-dev:amd64 (2.15.0-1.1ubuntu2) ...
Setting up libqt5remoteobjects5:amd64 (5.15.13-1) ...
Setting up libeditreadline-dev:amd64 (3.1-20230828-1build1) ...
Setting up fonts-urw-base35 (20200910-8) ...
Setting up ruby-prawn-icon (3.1.0-1) ...
Setting up ruby-prawn-svg (0.32.0-1) ...
Setting up libqt5gui5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libglib2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Setting up libqt5quick5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up libgs10-common (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up libqt5positioningquick5:amd64 (5.15.13+dfsg-1) ...
Setting up ruby-asciidoctor-pdf (2.3.4-3) ...
Setting up libqt5location5:amd64 (5.15.13+dfsg-1) ...
Setting up libqt5widgets5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libqt5svg5:amd64 (5.15.13-1) ...
Setting up libqt5help5:amd64 (5.15.13-1) ...
Setting up libqt5charts5:amd64 (5.15.13-1) ...
Setting up libqt5multimedia5:amd64 (5.15.13-1) ...
Setting up libqt5quickwidgets5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up libqt5multimediawidgets5:amd64 (5.15.13-1) ...
Setting up libqt5webenginecore5:amd64 (5.15.16+dfsg-3) ...
Setting up libqt5opengl5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libqt5printsupport5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libgs10:amd64 (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up libqt5designer5:amd64 (5.15.13-1) ...
Setting up libqscintilla2-qt5-15:amd64 (2.14.1+dfsg-1build3) ...
Setting up libqt5webkit5:amd64 (5.212.0~alpha4-36) ...
Setting up ghostscript (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up libqt5webengine5:amd64 (5.15.16+dfsg-3) ...
Setting up libqt5webenginewidgets5:amd64 (5.15.16+dfsg-3) ...
Setting up python3-pyqt5 (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtpositioning (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtsvg (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qttexttospeech (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtsql (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtopengl (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtmultimedia (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtchart (5.15.6+dfsg-1build2) ...
Setting up python3-pyqt5.qtxmlpatterns (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtsensors (5.15.10+dfsg-1build6) ...
Setting up pyqt5-dev-tools (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtwebsockets (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtserialport (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtremoteobjects (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtwebchannel (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtwebkit (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtwebengine (5.15.6-1build2) ...
Setting up python3-pyqt5.qtquick (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qsci (2.14.1+dfsg-1build3) ...
Setting up python3-qtpy (2.4.1-2) ...
Setting up python3-fonttools (4.46.0-1build2) ...
Setting up python3-ufolib2 (0.16.0+dfsg1-1) ...
Processing triggers for sgml-base (1.31) ...
Setting up x11proto-dev (2023.2-1) ...
Processing triggers for fontconfig (2.15.0-1.1ubuntu2) ...
Setting up po4a (0.69-1) ...
Setting up libxau-dev:amd64 (1:1.0.9-1build6) ...
Processing triggers for hicolor-icon-theme (0.17-2) ...
Setting up libice-dev:amd64 (2:1.0.10-1build3) ...
Setting up libsm-dev:amd64 (2:1.2.3-1build3) ...
Processing triggers for libc-bin (2.39-0ubuntu8.8) ...
Processing triggers for man-db (2.12.0-4build2) ...
Not building database; man-db/auto-update is not 'true'.
Setting up libxdmcp-dev:amd64 (1:1.1.3-0ubuntu6) ...
Processing triggers for libglib2.0-0t64:amd64 (2.80.0-6ubuntu3.8) ...
Processing triggers for udev (255.4-1ubuntu8.17) ...
Setting up libatk1.0-dev:amd64 (2.52.0-1build1) ...
Setting up libgdk-pixbuf-2.0-dev:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Setting up libharfbuzz-dev:amd64 (8.3.0-2build2) ...
Setting up libxcb1-dev:amd64 (1.15-1ubuntu2) ...
Setting up libx11-dev:amd64 (2:1.8.7-1build1) ...
Setting up libxfixes-dev:amd64 (1:6.0.0-2build1) ...
Setting up libxcb-shm0-dev:amd64 (1.15-1ubuntu2) ...
Setting up libxt-dev:amd64 (1:1.2.1-1.2build1) ...
Setting up libxcb-render0-dev:amd64 (1.15-1ubuntu2) ...
Setting up libxext-dev:amd64 (2:1.3.4-1build2) ...
Setting up libglx-dev:amd64 (1.7.0-1build1) ...
Setting up libxi-dev:amd64 (2:1.8.1-1build1) ...
Setting up libxrender-dev:amd64 (1:0.9.10-1.1build1) ...
Setting up libgl-dev:amd64 (1.7.0-1build1) ...
Setting up libxft-dev:amd64 (2.3.6-1build1) ...
Setting up libxtst-dev:amd64 (2:1.2.3-1.1build1) ...
Setting up libxdamage-dev:amd64 (1:1.1.6-1build1) ...
Setting up libatspi2.0-dev:amd64 (2.52.0-1build1) ...
Setting up libxmu-headers (2:1.1.3-3build2) ...
Setting up libegl-dev:amd64 (1.7.0-1build1) ...
Setting up libxcomposite-dev:amd64 (1:0.4.5-1build3) ...
Setting up libxcursor-dev:amd64 (1:1.2.1-1build1) ...
Setting up libepoxy-dev:amd64 (1.5.10-1build1) ...
Setting up libatk-bridge2.0-dev:amd64 (2.52.0-1build1) ...
Setting up libxmu-dev:amd64 (2:1.1.3-3build2) ...
Setting up libxss-dev:amd64 (1:1.2.3-1build3) ...
Setting up libxrandr-dev:amd64 (2:1.5.2-2build1) ...
Setting up libglu1-mesa-dev:amd64 (9.0.2-1.1build1) ...
Setting up libxinerama-dev:amd64 (2:1.1.4-3build1) ...
Setting up tk8.6-dev:amd64 (8.6.14-1build1) ...
Setting up libcairo2-dev:amd64 (1.18.0-3build1) ...
Setting up libgles-dev:amd64 (1.7.0-1build1) ...
Setting up libglvnd-dev:amd64 (1.7.0-1build1) ...
Setting up libpango1.0-dev:amd64 (1.52.1+ds-1build1) ...
Setting up libegl1-mesa-dev:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Setting up libgtk-3-dev:amd64 (3.24.41-4ubuntu1.3) ...
checking for c++... c++
checking whether the C++ compiler works... yes
checking for C++ compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether the compiler supports GNU C++... yes
checking whether c++ accepts -g... yes
checking for c++ option to enable C++11 features... none needed
checking for a BSD-compatible install... /usr/bin/install -c
checking whether c++ supports C++20 features by default... no
checking whether c++ supports C++20 features with -std=gnu++20... yes
checking build toplevel... /home/runner/work/_temp/linuxcnc-t02-task
checking installation prefix... run in place
checking for grep... /usr/bin/grep
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for gcc... gcc
checking whether the compiler supports GNU C... yes
checking whether gcc accepts -g... yes
checking for gcc option to enable C11 features... none needed
checking for stdio.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for strings.h... yes
checking for sys/stat.h... yes
checking for sys/types.h... yes
checking for unistd.h... yes
checking for rpc/rpc.h... no
checking for get_myaddress in -ltirpc... yes
checking for rpc/rpc.h... yes
checking for rtai-config... none
checking for xeno-config... none
checking for evl/evl.h... no
checking for realtime API(s) to use... uspace
checking whether to enable userspace PCI access... yes
checking for libudev... yes - version 255
checking for cc version... not specified
checking whether the compiler supports GNU C... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to enable C11 features... (cached) none needed
checking how to run the C preprocessor... gcc -E
checking for usability of linux/hidraw.h... yes
checking for usability of rpc/rpc.h... yes
checking for libmodbus3... yes - version 3.1.10
checking for libusb-1.0... yes
checking for libgpiod < 3.0.0... yes
configure: libgpiod version 1.6.3 found
checking for module installation directory... configuring for run-in-place
/home/runner/work/_temp/linuxcnc-t02-task/rtlib
checking for glib... yes - 2.80.0
checking whether make sets $(MAKE)... yes
checking for ranlib... ranlib
checking for ar... /usr/bin/ar
checking for install... /usr/bin/install -c
checking for sed... /usr/bin/sed
checking for ps... /usr/bin/ps
checking for kill... /usr/bin/kill
checking for whoami... /usr/bin/whoami
checking for awk... /usr/bin/awk
checking for pidof... /usr/bin/pidof
checking for ipcs... /usr/bin/ipcs
checking for fuser... /usr/bin/fuser
checking for yapps... no
checking for yapps2... /usr/bin/yapps2
checking for mandb... /usr/bin/mandb
checking for intltool-extract... /usr/bin/intltool-extract
checking for yapps... (cached) /usr/bin/yapps2
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking for boostlib >=  (102000)... yes
checking for python build information... 
checking for python3.14... no
checking for python3.13... no
checking for python3.12... python3.12
checking for main in -lpython3.12... yes
  results of the Python check:
    Binary:      python3.12
    Library:     python3.12
    Include Dir: /usr/include/python3.12
checking for python3.12... /usr/bin/python3.12
checking for python... (cached) /usr/bin/python3.12
checking for a version of Python >= '2.1.0'... yes
checking for the sysconfig Python package... yes
checking for Python include path... -I/usr/include/python3.12
checking for Python library path... -L/usr/lib/x86_64-linux-gnu -lpython3.12
checking for Python site-packages path... /home/runner/work/_temp/linuxcnc-t02-task/lib/python3.12/site-packages
checking for Python platform specific site-packages path... /home/runner/work/_temp/linuxcnc-t02-task/lib/python3.12/site-packages
checking python extra libraries... -ldl -lm
checking python extra linking flags... -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions
checking consistency of all components of python development environment... yes
checking whether the Boost::Python library is available... yes
checking whether boost_python is the correct library... no
checking whether boost_python312 is the correct library... yes
checking whether c++ -std=gnu++20 has a "maybe uninitialized" false positive... no
checking whether to build documentation... no
checking for asciidoctor... /usr/bin/asciidoctor
checking for sys/io.h... yes
checking for sys/wait.h that is POSIX.1 compatible... yes
checking for semtimedop... yes
checking for optreset... no
checking for library containing dlopen... none required
checking for library containing clock_nanosleep... none required
checking for X... libraries , headers 
checking for gethostbyname... yes
checking for connect... yes
checking for remove... yes
checking for shmat... yes
checking for IceConnectionNumber in -lICE... yes
checking for X11/extensions/Xinerama.h... yes
checking for XineramaQueryExtension in -lXinerama... yes
checking for fmt/format.h... yes
checking for pybind11/pybind11.h... yes
checking for sys/capability.h... yes
checking for editline/readline.h... yes
checking for histedit.h... yes
checking for readline in -ledit... yes
checking for locale.h... yes
checking for setlocale... yes
checking for libintl.h... yes
checking for gettext in -lintl... no
checking for xgettext... /usr/bin/xgettext
checking for msgfmt... /usr/bin/msgfmt
checking python version... OK
checking for site-package location... /usr/lib/python3/dist-packages
configure: creating ./config.status
config.status: creating ../scripts/rtapi.conf
config.status: creating ../scripts/linuxcnc
config.status: creating ../scripts/linuxcnc_info
config.status: creating ../scripts/halrun
config.status: creating ../scripts/rip-environment
config.status: creating ../scripts/haltcl
config.status: creating ../scripts/halcmd_twopass
config.status: creating ../scripts/realtime
config.status: creating ../scripts/runtests
config.status: creating ../scripts/linuxcnc_var
config.status: creating Makefile.inc
config.status: creating Makefile.modinc
config.status: creating ../tcl/linuxcnc.tcl
config.status: creating ../lib/python/nf.py
config.status: creating ../scripts/linuxcncmkdesktop
config.status: creating ../share/applications/linuxcnc-latency.desktop
config.status: creating ../share/applications/linuxcnc-latency-histogram.desktop
config.status: creating ../share/applications/linuxcnc-pncconf.desktop
config.status: creating ../share/applications/linuxcnc-stepconf.desktop
config.status: creating ../share/applications/linuxcnc.desktop
config.status: creating ../share/desktop-directories/linuxcnc-cnc.directory
config.status: creating ../share/desktop-directories/linuxcnc-ref.directory
config.status: creating ../share/desktop-directories/linuxcnc-doc.directory
config.status: creating ../share/menus/CNC.menu
config.status: creating config.h


######################################################################
#                LinuxCNC - Enhanced Machine Controller              #
######################################################################
#                                                                    #
#   LinuxCNC is a software system for computer control of machine    #
#   tools such as milling machines. LinuxCNC is released under the   #
#   GPL.  Check out http://www.linuxcnc.org/ for more details.       #
#                                                                    #
#                                                                    #
#   It seems that ./configure completed successfully.                #
#   This means that RT is properly installed                         #
#   If things don't work check config.log for errors & warnings      #
#                                                                    #
#   Next compile by typing                                           #
#         make                                                       #
#         sudo make setuid                                           #
#          (if realtime behavior and hardware access are required)   #
#                                                                    #
#   Before running the software, set the environment:                #
#         . (top dir)/scripts/rip-environment                        #
#                                                                    #
#   To run the software type                                         #
#         linuxcnc                                                   #
#                                                                    #
######################################################################


make: Entering directory '/home/runner/work/_temp/linuxcnc-t02-task/src'
Creating mesa_uart.mak
Creating mesa_7i65.mak
Creating serport.mak
Creating xyzbca_trsrn.mak
Creating xyzacb_trsrn.mak
Creating xyzab_tdr_kins.mak
Creating xor2.mak
Creating xhc_hb04_util.mak
Creating wcomp.mak
Creating userkins.mak
Creating updown.mak
Creating tristate_float.mak
Creating tristate_bit.mak
Creating ton.mak
Creating tp.mak
Creating toggle2nist.mak
Creating toggle.mak
Creating tof.mak
Creating timedelta.mak
Creating timedelay.mak
Creating time.mak
Creating threadtest.mak
Creating thcud.mak
Creating thc.mak
Creating sum2.mak
Creating steptest.mak
Creating spindle_monitor.mak
Creating spindle.mak
Creating sphereprobe.mak
Creating simple_tp.mak
Creating sim_spindle.mak
Creating sim_parport.mak
Creating sim_matrix_kb.mak
Creating sim_home_switch.mak
Creating sim_axis_hardware.mak
Creating select8.mak
Creating scaled_s32_sums.mak
Creating scale.mak
Creating sample_hold.mak
Creating safety_latch.mak
Creating reset.mak
Creating radiobutton.mak
Creating raster.mak
Creating pushmsg.mak
Creating plasmac.mak
Creating output_buffer.mak
Creating orient.mak
Creating or2.mak
Creating oneshot.mak
Creating ohmic.mak
Creating offset.mak
Creating not.mak
Creating near.mak
Creating mux8.mak
Creating mux4.mak
Creating mux2.mak
Creating mux16.mak
Creating multiclick.mak
Creating multiswitch.mak
Creating mult2.mak
Creating moveoff.mak
Creating momentary2nist.mak
Creating minmax.mak
Creating millturn.mak
Creating message.mak
Creating mesa_pktgyro_test.mak
Creating max31855.mak
Creating matrixkins.mak
Creating match8.mak
Creating maj3.mak
Creating lut5.mak
Creating lowpass.mak
Creating logic.mak
Creating lincurve.mak
Creating limit_axis.mak
Creating limit3.mak
Creating limit2.mak
Creating limit1.mak
Creating led_dim.mak
Creating latencybinstream.mak
Creating latencybins.mak
Creating laserpower.mak
Creating knob2float.mak
Creating joyhandle.mak
Creating joint_axis_mapper.mak
Creating invert.mak
Creating integ.mak
Creating ilowpass.mak
Creating hypot.mak
Creating homecomp.mak
Creating histobinstream.mak
Creating histobins.mak
Creating gray2bin.mak
Creating gearchange.mak
Creating gantry.mak
Creating flipflop.mak
Creating filter_kalman.mak
Creating feedcomp.mak
Creating estop_latch.mak
Creating eoffset_per_angle.mak
Creating edge.mak
Creating div2.mak
Creating differential.mak
Creating demux.mak
Creating deadzone.mak
Creating ddt.mak
Creating dbounce.mak
Creating corexy_by_hal.mak
converting conv for conv_u64_u32.comp
converting conv for conv_u64_s64.comp
converting conv for conv_u64_s32.comp
converting conv for conv_u64_float.comp
converting conv for conv_u64_bit.comp
converting conv for conv_u32_u64.comp
converting conv for conv_u32_s32.comp
converting conv for conv_u32_s64.comp
converting conv for conv_u32_float.comp
converting conv for conv_u32_bit.comp
converting conv for conv_s64_u64.comp
converting conv for conv_s64_u32.comp
converting conv for conv_s64_s32.comp
converting conv for conv_s64_float.comp
converting conv for conv_s64_bit.comp
converting conv for conv_s32_u64.comp
converting conv for conv_s32_u32.comp
converting conv for conv_s32_s64.comp
converting conv for conv_s32_float.comp
converting conv for conv_s32_bit.comp
converting conv for conv_float_u64.comp
converting conv for conv_float_u32.comp
converting conv for conv_float_s64.comp
converting conv for conv_float_s32.comp
converting conv for conv_bit_u64.comp
converting conv for conv_bit_u32.comp
converting conv for conv_bit_s64.comp
converting conv for conv_bit_s32.comp
converting conv for conv_bit_float.comp
Creating comp.mak
Creating clarkeinv.mak
Creating clarke3.mak
Creating clarke2.mak
Creating charge_pump.mak
Creating carousel.mak
Creating blend.mak
Creating bldc.mak
Creating bitwise.mak
Creating bitslice.mak
Creating bitmerge.mak
Creating biquad.mak
Creating bin2gray.mak
Creating axistest.mak
Creating anglejog.mak
Creating and2.mak
Creating abs_s64.mak
Creating abs_s32.mak
Creating abs.mak
Creating conv_u64_u32.mak
Creating conv_u64_s64.mak
Creating conv_u64_s32.mak
Creating conv_u64_float.mak
Creating conv_u64_bit.mak
Creating conv_u32_u64.mak
Creating conv_u32_s64.mak
Creating conv_u32_s32.mak
Creating conv_u32_float.mak
Creating conv_u32_bit.mak
Creating conv_s64_u64.mak
Creating conv_s64_u32.mak
Creating conv_s64_s32.mak
Creating conv_s64_float.mak
Creating conv_s64_bit.mak
Creating conv_s32_u64.mak
Creating conv_s32_u32.mak
Creating conv_s32_s64.mak
Creating conv_s32_float.mak
Creating conv_s32_bit.mak
Creating conv_float_u64.mak
Creating conv_float_u32.mak
Creating conv_float_s64.mak
Creating conv_float_s32.mak
Creating conv_bit_u64.mak
Creating conv_bit_u32.mak
Creating conv_bit_s64.mak
Creating conv_bit_s32.mak
Creating conv_bit_float.mak
Exporting hal.h
Exporting hostmot2-serial.h
Exporting linuxcnc.h
Exporting kinematics.h
Exporting emcmotcfg.h
Exporting inifile.hh
Exporting inifile.h
Exporting emcpos.h
Exporting motion_types.h
Exporting posemath.h
Exporting emcpose.h
Exporting posemath.hh
Exporting posemath_types.h
Exporting rtapi.h
Exporting rtapi_app.h
Exporting rtapi_atomic.h
Exporting rtapi_bitops.h
Exporting rtapi_bool.h
Exporting rtapi_byteorder.h
Exporting rtapi_ctype.h
Exporting rtapi_device.h
Exporting rtapi_errno.h
Exporting rtapi_firmware.h
Exporting rtapi_gfp.h
Exporting rtapi_io.h
Exporting rtapi_limits.h
Exporting rtapi_list.h
Exporting rtapi_math.h
Exporting rtapi_math64.h
Exporting rtapi_math_i386.h
Exporting rtapi_mutex.h
Exporting rtapi_parport.h
Exporting rtapi_pci.h
Exporting rtapi_slab.h
Exporting rtapi_stdint.h
Exporting rtapi_string.h
Copying test input hal/components/lincurve.comp
Exporting rtapi_vsnprintf.h
Copying test input hal/components/logic.comp
Copying test input hal/components/bitslice.comp
sed hal/drivers/mesa_uart.comp -e "1 s/mesa_uart/mesa_uart_test/" > ../tests/halcompile/serial-out-of-tree/mesa_uart_test.comp
sed ../tests/halcompile/userspace/rand.comp -e "1 s/rand/rand_test/" > ../tests/halcompile/userspace/rand_test.comp
cp ../scripts/rtapi.conf ../tests/uspace/spawnv-root/rtapi.conf
Compiling libposemath/_posemath.c
Compiling libposemath/posemath.cc
Compiling libposemath/gomath.c
Compiling libposemath/emcpose.c
Compiling libnml/rcs/rcs_print.cc
Compiling libnml/rcs/rcs_exit.cc
Compiling libnml/os_intf/_sem.c
Compiling libnml/os_intf/_shm.c
Compiling libnml/os_intf/_timer.c
Compiling libnml/os_intf/sem.cc
Compiling libnml/os_intf/shm.cc
Compiling libnml/os_intf/timer.cc
Compiling libnml/buffer/locmem.cc
Compiling libnml/buffer/memsem.cc
Compiling libnml/buffer/phantom.cc
Compiling libnml/buffer/physmem.cc
Compiling libnml/buffer/recvn.c
Compiling libnml/buffer/sendn.c
Compiling libnml/buffer/shmem.cc
Compiling libnml/buffer/tcpmem.cc
Compiling libnml/cms/cms.cc
Compiling libnml/cms/cms_aup.cc
Compiling libnml/cms/cms_cfg.cc
Compiling libnml/cms/cms_in.cc
Compiling libnml/cms/cms_dup.cc
Compiling libnml/cms/cms_pm.cc
Compiling libnml/cms/cms_srv.cc
Compiling libnml/cms/cms_up.cc
Compiling libnml/cms/cms_xup.cc
Compiling libnml/cms/cmsdiag.cc
Compiling libnml/cms/tcp_opts.cc
Compiling libnml/cms/tcp_srv.cc
Compiling libnml/nml/cmd_msg.cc
Compiling libnml/nml/nml_oi.cc
Compiling libnml/nml/nml_srv.cc
Compiling libnml/nml/nml.cc
Compiling libnml/nml/nmldiag.cc
Compiling libnml/nml/nmlmsg.cc
Compiling libnml/nml/stat_msg.cc
Compiling libnml/linklist/linklist.cc
Compiling rtapi/uspace_rtapi_main.cc
Compiling rtapi/uspace_rtapi_app.cc
Compiling rtapi/uspace_rtapi_parport.cc
Compiling rtapi/uspace_rtapi_string.c
Compiling rtapi/rtapi_pci.cc
Compiling rtapi/uspace_posix.cc
Compiling hal/components/streamer_usr.c
Compiling hal/hal_lib.c
Compiling hal/hal_lib_query.c
Compiling hal/hal_lib_extra.c
Compiling rtapi/uspace_ulapi.c
Compiling hal/components/sampler_usr.c
Compiling hal/components/panelui.c
Compiling hal/user_comps/mb2hal/mb2hal.c
Compiling hal/user_comps/mb2hal/mb2hal_init.c
Compiling hal/user_comps/mb2hal/mb2hal_modbus.c
Compiling hal/user_comps/mb2hal/mb2hal_hal.c
Compiling emc/ini/inifile.cc
Compiling hal/user_comps/gs2_vfd.c
Compiling hal/user_comps/hy_gt_vfd.c
Compiling hal/user_comps/svd-ps_vfd.c
Compiling hal/user_comps/shuttle.c
Compiling hal/user_comps/xhc-hb04.cc
Compiling hal/user_comps/sendkeys.c
Compiling hal/user_comps/vfs11_vfd/vfs11_vfd.c
Compiling hal/utils/halcmd.c
Compiling hal/utils/halcmd_commands.cc
Compiling hal/utils/halcmd_main.c
Compiling hal/setps_util.c
Compiling hal/utils/halcmd_completion.c
Compiling hal/utils/halrmt.cc
Syntax checking python script elbpcom
Copying python script elbpcom
Syntax checking python script modcompile
Copying python script modcompile
Copying Modbus template mesa_modbus.c.tmpl
Syntax checking python script mesambccc
Copying python script mesambccc
Compiling hal/user_comps/vfdb_vfd/vfdb_vfd.c
Compiling hal/user_comps/huanyang-vfd/hy_vfd.c
Compiling hal/user_comps/huanyang-vfd/hy_comm.c
Compiling hal/user_comps/xhc-whb04b-6/hal.cc
Compiling hal/user_comps/xhc-whb04b-6/usb.cc
Compiling hal/user_comps/xhc-whb04b-6/pendant-types.cc
Compiling hal/user_comps/xhc-whb04b-6/pendant.cc
Compiling hal/user_comps/xhc-whb04b-6/xhc-whb04b6.cc
Compiling hal/user_comps/xhc-whb04b-6/main.cc
Compiling emc/usr_intf/emcrsh.cc
Compiling emc/usr_intf/mapini.cc
Compiling emc/usr_intf/shcom.cc
Compiling emc/nml_intf/emcglb.c
Compiling emc/nml_intf/modal_state.cc
Compiling emc/nml_intf/emc.cc
Compiling emc/nml_intf/emcargs.cc
Compiling emc/nml_intf/emcops.cc
Compiling emc/nml_intf/canon_position.cc
Compiling emc/ini/iniaxis.cc
Compiling emc/ini/inijoint.cc
Compiling emc/ini/inispindle.cc
Compiling emc/ini/initraj.cc
Compiling emc/ini/inihal.cc
Compiling emc/nml_intf/interpl.cc
Compiling emc/usr_intf/schedrmt.cc
Compiling emc/usr_intf/emcsched.cc
Compiling emc/usr_intf/emclcd.cc
Compiling emc/usr_intf/sockets.c
Compiling emc/usr_intf/halui.cc
Compiling emc/tooldata/tooldata_mmap.cc
Compiling emc/tooldata/tooldata_common.cc
Compiling emc/tooldata/tooldata_db.cc
Compiling emc/task/emcsvr.cc
Compiling emc/motion/emcmotglb.c
Compiling emc/task/emctask.cc
Compiling emc/task/emccanon.cc
Compiling emc/task/emctaskmain.cc
Compiling emc/motion/usrmotintf.cc
Compiling emc/motion/emcmotutil.c
Compiling emc/task/taskintf.cc
Compiling emc/motion/dbuf.c
Compiling emc/motion/stashf.c
Compiling emc/task/taskclass.cc
Compiling emc/task/backtrace.cc
Compiling emc/rs274ngc/interp_arc.cc
Compiling emc/rs274ngc/interp_array.cc
Compiling emc/rs274ngc/interp_base.cc
Compiling emc/rs274ngc/interp_check.cc
Compiling emc/rs274ngc/interp_convert.cc
Compiling emc/rs274ngc/interp_queue.cc
Compiling emc/rs274ngc/interp_cycles.cc
Compiling emc/rs274ngc/interp_execute.cc
Compiling emc/rs274ngc/interp_find.cc
Compiling emc/rs274ngc/interp_internal.cc
Compiling emc/rs274ngc/interp_inverse.cc
Compiling emc/rs274ngc/interp_read.cc
Compiling emc/rs274ngc/interp_write.cc
Compiling emc/rs274ngc/interp_o_word.cc
Compiling emc/rs274ngc/interp_g7x.cc
Compiling emc/rs274ngc/nurbs_additional_functions.cc
Compiling emc/rs274ngc/interp_namedparams.cc
Compiling emc/rs274ngc/interp_python.cc
Compiling emc/rs274ngc/interp_remap.cc
Compiling emc/rs274ngc/interp_setup.cc
Compiling emc/rs274ngc/canonmodule.cc
Compiling emc/rs274ngc/pyparamclass.cc
Compiling emc/rs274ngc/pyemctypes.cc
Compiling emc/rs274ngc/pyinterp1.cc
Compiling emc/rs274ngc/pyblock.cc
Compiling emc/rs274ngc/pyarrays.cc
Compiling emc/rs274ngc/interpmodule.cc
Compiling emc/rs274ngc/rs274ngc_pre.cc
Compiling emc/rs274ngc/interp_inspection.cc
Compiling emc/pythonplugin/python_plugin.cc
Compiling emc/kinematics/ugenserkins.c
Compiling emc/kinematics/genserfuncs.c
Compiling emc/canterp/canterp.cc
Compiling emc/ini/inivalue.cc
Copy inivar
Compiling emc/sai/saicanon.cc
Compiling emc/sai/driver.cc
Compiling emc/sai/dummyemcstat.cc
Compiling emc/motion-logger/motion-logger.c
Compiling emc/motion/axis.c
Compiling emc/motion/simple_tp.c
Compiling emc/tp/sp_scurve.c
Compiling emc/tp/ruckig_wrapper.c
Compiling emc/tp/cruckig/block.c
Compiling emc/tp/cruckig/brake.c
Compiling emc/tp/cruckig/calculator.c
Compiling emc/tp/cruckig/cruckig.c
Compiling emc/tp/cruckig/input_parameter.c
Compiling emc/tp/cruckig/output_parameter.c
Compiling emc/tp/cruckig/profile.c
Compiling emc/tp/cruckig/roots.c
Compiling emc/tp/cruckig/trajectory.c
Compiling emc/tp/cruckig/position_first_step1.c
Compiling emc/tp/cruckig/position_first_step2.c
Compiling emc/tp/cruckig/position_second_step1.c
Compiling emc/tp/cruckig/position_second_step2.c
Compiling emc/tp/cruckig/position_third_step1.c
Compiling emc/tp/cruckig/position_third_step2.c
Compiling emc/tp/cruckig/velocity_second_step1.c
Compiling emc/tp/cruckig/velocity_second_step2.c
Compiling emc/tp/cruckig/velocity_third_step1.c
Compiling emc/tp/cruckig/velocity_third_step2.c
Compiling module_helper/module_helper.c
Compiling localized message catalog ../share/locale/ar/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/bg/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/cs/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/da/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/de/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/es/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/fi/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/fr/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/hu/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/it/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/ja/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/ka/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/nb/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/pl/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/pt_BR/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/ro/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/ru/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/sk/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/sr/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/sv/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/tr/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/uk/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/vi/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/zh_CN/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/zh_HK/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/zh_TW/LC_MESSAGES/linuxcnc.mo
Compiling localized gmoccapy message catalog ../share/locale/ar/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/bg/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/cs/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/da/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/de/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/es/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/fi/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/fr/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/hu/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/it/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/ja/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/ka/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/nb/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/pl/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/pt_BR/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/ro/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/ru/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/sk/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/sr/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/sv/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/tr/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/uk/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/vi/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/zh_CN/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/zh_HK/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/zh_TW/LC_MESSAGES/gmoccapy.mo
Compiling localized message catalog objects/ar.msg
Compiling localized message catalog objects/bg.msg
Compiling localized message catalog objects/cs.msg
Compiling localized message catalog objects/da.msg
Compiling localized message catalog objects/de.msg
Compiling localized message catalog objects/es.msg
Compiling localized message catalog objects/fi.msg
Compiling localized message catalog objects/fr.msg
Compiling localized message catalog objects/hu.msg
Compiling localized message catalog objects/it.msg
Compiling localized message catalog objects/ja.msg
Compiling localized message catalog objects/ka.msg
Compiling localized message catalog objects/nb.msg
Compiling localized message catalog objects/pl.msg
Compiling localized message catalog objects/pt_BR.msg
Compiling localized message catalog objects/ro.msg
Compiling localized message catalog objects/ru.msg
Compiling localized message catalog objects/sk.msg
Compiling localized message catalog objects/sr.msg
Compiling localized message catalog objects/sv.msg
Compiling localized message catalog objects/tr.msg
Compiling localized message catalog objects/uk.msg
Compiling localized message catalog objects/vi.msg
Compiling localized message catalog objects/zh_CN.msg
Compiling localized message catalog objects/zh_HK.msg
Compiling localized message catalog objects/zh_TW.msg
Syntax checking python script hal_input
Syntax checking python script scorbot-er-3
Syntax checking python script mitsub_vfd
Syntax checking python script pmx485
Copying python script scorbot-er-3
Copying python script hal_input
Syntax checking python script sim-torch
Syntax checking python script z_level_compensation
Copying python script mitsub_vfd
Syntax checking python script mqtt-publisher
Copying python script pmx485
Syntax checking python script hal_bridge
Copying python script sim-torch
Copying python script z_level_compensation
Syntax checking python script mtconnect-agent
Syntax checking python script pumagui
Copying python script mqtt-publisher
Syntax checking python script puma560gui
Copying python script hal_bridge
Syntax checking python script lineardelta
Copying python script mtconnect-agent
Copying python script pumagui
Syntax checking python script scaragui
Syntax checking python script hexagui
Copying python script puma560gui
Syntax checking python script 5axisgui
Copying python script lineardelta
Syntax checking python script max5gui
Copying python script scaragui
Copying python script hexagui
Syntax checking python script maho600gui
Syntax checking python script hbmgui
Copying python script 5axisgui
Copying python script max5gui
Syntax checking python script rotarydelta
Syntax checking python script melfagui
Copying python script maho600gui
Copying python script hbmgui
Syntax checking python script millturngui
Syntax checking python script xyzac-trt-gui
Copying python script rotarydelta
Copying python script melfagui
Syntax checking python script xyzbc-trt-gui
Syntax checking python script xyzab-tdr-gui
Copying python script millturngui
Copying python script xyzac-trt-gui
Compiling hal/halmodule.cc
Compiling hal/halquery.cc
Copying python script xyzbc-trt-gui
Copying python script xyzab-tdr-gui
Compiling emc/usr_intf/axis/extensions/emcmodule.cc
Syntax checking python script linuxcnctop
Copying python script linuxcnctop
Syntax checking python script mdi
Copying python script mdi
Syntax checking python script lintini
Copying python script lintini
Syntax checking python script debuglevel
Copying python script debuglevel
Syntax checking python script tracking-test
Copying python script tracking-test
Compiling emc/kinematics/lineardeltakins.cc
Compiling emc/kinematics/rotarydeltakins.cc
Syntax checking python script update_ini
Copying python script update_ini
Syntax checking python script linuxcnc_check_ini
Copying python script linuxcnc_check_ini
Compiling emc/rs274ngc/gcodemodule.cc
Compiling realtime hal/components/boss_plc.c
Compiling realtime hal/components/debounce.c
Compiling realtime hal/components/demux_generic.c
Compiling realtime hal/components/encoder.c
Compiling realtime hal/components/enum.c
Compiling realtime hal/components/counter.c
Compiling realtime hal/components/encoder_ratio.c
Compiling realtime hal/components/stepgen.c
Compiling realtime hal/components/lcd.c
Compiling realtime hal/components/matrix_kb.c
Compiling realtime hal/components/mux_generic.c
Compiling realtime hal/components/pwmgen.c
Compiling realtime hal/components/siggen.c
Compiling realtime hal/components/pid.c
Compiling realtime hal/components/threads.c
Compiling realtime hal/components/supply.c
Compiling realtime hal/components/sim_encoder.c
Compiling realtime hal/components/weighted_sum.c
Compiling realtime hal/components/watchdog.c
Compiling realtime hal/components/modmath.c
Compiling realtime hal/components/streamer.c
Compiling realtime hal/components/sampler.c
Compiling realtime hal/drivers/hal_parport.c
Compiling realtime hal/drivers/hal_speaker.c
Compiling realtime hal/drivers/hal_gm.c
Compiling realtime hal/drivers/hal_ppmc.c
Compiling realtime hal/drivers/hal_bb_gpio.c
Compiling realtime hal/drivers/hal_pi_gpio.c
Compiling realtime hal/drivers/cpuinfo.c
Compiling realtime hal/drivers/hal_gpio.c
Compiling realtime hal/drivers/mesa-hostmot2/hostmot2.c
Compiling realtime hal/drivers/mesa-hostmot2/abs_encoder.c
Compiling realtime hal/drivers/mesa-hostmot2/bitfile.c
Compiling realtime hal/drivers/mesa-hostmot2/bspi.c
Compiling realtime hal/drivers/mesa-hostmot2/dpll.c
Compiling realtime hal/drivers/mesa-hostmot2/encoder.c
Compiling realtime hal/drivers/mesa-hostmot2/inm.c
Compiling realtime hal/drivers/mesa-hostmot2/inmux.c
Compiling realtime hal/drivers/mesa-hostmot2/ioport.c
Compiling realtime hal/drivers/mesa-hostmot2/led.c
Compiling realtime hal/drivers/mesa-hostmot2/pins.c
Compiling realtime hal/drivers/mesa-hostmot2/pktuart.c
Compiling realtime hal/drivers/mesa-hostmot2/pwmgen.c
Compiling realtime hal/drivers/mesa-hostmot2/oneshot.c
Compiling realtime hal/drivers/mesa-hostmot2/periodm.c
Compiling realtime hal/drivers/mesa-hostmot2/raw.c
Compiling realtime hal/drivers/mesa-hostmot2/rcpwmgen.c
Compiling realtime hal/drivers/mesa-hostmot2/resolver.c
Compiling realtime hal/drivers/mesa-hostmot2/sserial.c
Compiling realtime hal/drivers/mesa-hostmot2/ssr.c
Compiling realtime hal/drivers/mesa-hostmot2/outm.c
Compiling realtime hal/drivers/mesa-hostmot2/stepgen.c
Compiling realtime hal/drivers/mesa-hostmot2/tp_pwmgen.c
Compiling realtime hal/drivers/mesa-hostmot2/tram.c
Compiling realtime hal/drivers/mesa-hostmot2/uart.c
Compiling realtime hal/drivers/mesa-hostmot2/watchdog.c
Compiling realtime hal/drivers/mesa-hostmot2/xy2mod.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_test.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_pci.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_7i43.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_7i90.c
Compiling realtime hal/drivers/mesa-hostmot2/setsserial.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_modbus.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_eth.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_eth_net_posix.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_spi.c
Compiling realtime hal/drivers/mesa-hostmot2/llio_info.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_rpspi.c
Compiling realtime hal/drivers/mesa-hostmot2/kmod_check.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_spix.c
Compiling realtime hal/drivers/mesa-hostmot2/spix_rpi5.c
Compiling realtime hal/drivers/mesa-hostmot2/spix_rpi3.c
Compiling realtime hal/drivers/mesa-hostmot2/spix_spidev.c
Compiling realtime hal/classicladder/module_hal.c
Compiling realtime hal/classicladder/arithm_eval.c
Compiling realtime hal/classicladder/arrays.c
Compiling realtime hal/classicladder/calc.c
Compiling realtime hal/classicladder/calc_sequential.c
Compiling realtime hal/classicladder/manager.c
Compiling realtime hal/classicladder/symbols.c
Compiling realtime hal/classicladder/vars_access.c
Compiling realtime hal/utils/scope_rt.c
Compiling realtime hal/hal_lib.c
Compiling realtime emc/kinematics/trivkins.c
Compiling realtime emc/kinematics/kins_util.c
Compiling realtime emc/kinematics/maxkins.c
Compiling realtime emc/kinematics/rotatekins.c
Compiling realtime emc/kinematics/tripodkins.c
Compiling realtime emc/kinematics/corexykins.c
Compiling realtime emc/kinematics/lineardeltakins.c
Compiling realtime emc/kinematics/pentakins.c
Compiling realtime libposemath/_posemath.c
Compiling realtime emc/kinematics/rotarydeltakins.c
Compiling realtime emc/kinematics/rosekins.c
Compiling realtime emc/kinematics/scorbot-kins.c
Compiling realtime emc/kinematics/genhexkins.c
Compiling realtime emc/kinematics/switchkins.c
Compiling realtime emc/kinematics/userkfuncs.c
Compiling realtime emc/kinematics/genserkins.c
Compiling realtime emc/kinematics/genserfuncs.c
Compiling realtime libposemath/gomath.c
Compiling realtime emc/kinematics/xyzac-trt-kins.c
Compiling realtime emc/kinematics/trtfuncs.c
Compiling realtime emc/kinematics/xyzbc-trt-kins.c
Compiling realtime emc/kinematics/scarakins.c
Compiling realtime emc/kinematics/pumakins.c
Compiling realtime emc/kinematics/three21kins.c
Compiling realtime emc/kinematics/5axiskins.c
Compiling realtime emc/kinematics/cubic.c
Compiling realtime emc/motion/axis.c
Compiling realtime emc/motion/motion.c
Compiling realtime emc/motion/command.c
Compiling realtime emc/motion/control.c
Compiling realtime emc/motion/simple_tp.c
Compiling realtime emc/motion/emcmotutil.c
Compiling realtime emc/motion/stashf.c
Compiling realtime emc/motion/dbuf.c
Compiling realtime emc/tp/sp_scurve.c
Compiling realtime emc/tp/ruckig_wrapper.c
Compiling realtime emc/tp/cruckig/block.c
Compiling realtime emc/tp/cruckig/brake.c
Compiling realtime emc/tp/cruckig/calculator.c
Compiling realtime emc/tp/cruckig/cruckig.c
Compiling realtime emc/tp/cruckig/input_parameter.c
Compiling realtime emc/tp/cruckig/output_parameter.c
Compiling realtime emc/tp/cruckig/profile.c
Compiling realtime emc/tp/cruckig/roots.c
Compiling realtime emc/tp/cruckig/trajectory.c
Compiling realtime emc/tp/cruckig/position_first_step1.c
Compiling realtime emc/tp/cruckig/position_first_step2.c
Compiling realtime emc/tp/cruckig/position_second_step1.c
Compiling realtime emc/tp/cruckig/position_second_step2.c
Compiling realtime emc/tp/cruckig/position_third_step1.c
Compiling realtime emc/tp/cruckig/position_third_step2.c
Compiling realtime emc/tp/cruckig/velocity_second_step1.c
Compiling realtime emc/tp/cruckig/velocity_second_step2.c
Compiling realtime emc/tp/cruckig/velocity_third_step1.c
Compiling realtime emc/tp/cruckig/velocity_third_step2.c
Compiling realtime emc/motion/homemod.c
Compiling realtime emc/motion/homing.c
Compiling realtime emc/tp/tpmod.c
Compiling realtime emc/tp/tc.c
Compiling realtime emc/tp/tcq.c
Compiling realtime emc/tp/tp.c
Compiling realtime emc/tp/spherical_arc.c
Compiling realtime emc/tp/blendmath.c
Compiling realtime libposemath/emcpose.c
config.status: creating ../scripts/setup_designer
config.status: creating ../lib/python/lcnc_realtime.py
Creating shared library libposemath.so.0
Creating shared library libnml.so.0
Linking rtapi_app
Linking liblinuxcnc-uspace-posix.so.0
Creating shared library liblinuxcnchal.so.0
Creating shared library liblinuxcncini.so.1
Syntax checking python script halcompile
ln -sf liblinuxcnchal.so.0 ../lib/liblinuxcnchal.so
Linking hy_vfd
Linking xhc-whb04b-6
Linking liblinuxcnc.a
Copying python script halcompile
tooldata: depends: objects/emc/tooldata/tooldata_mmap.o objects/emc/tooldata/tooldata_common.o objects/emc/tooldata/tooldata_db.o
tooldata: Linking: libtooldata.so.0
ln -sf liblinuxcncini.so.1 ../lib/liblinuxcncini.so
Linking libpyplugin.so.0
Linking inivalue
c++ -std=gnu++20 -g -L/home/runner/work/_temp/linuxcnc-t02-task/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-t02-task/lib -ltirpc  -lgpiod  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-soname,libpyplugin.so.0 -shared -o ../lib/libpyplugin.so.0 objects/emc/pythonplugin/python_plugin.o ../lib/liblinuxcncini.so.1 -lstdc++ -lboost_python312 -L/usr/lib/x86_64-linux-gnu -lpython3.12 -ldl -lm
Linking motion-logger
ln -sf libtooldata.so.0 ../lib/libtooldata.so
Linking linuxcnc_module_helper
gcc -Wl,-z,relro -o ../bin/linuxcnc_module_helper objects/module_helper/module_helper.o
Linking python module _hal.so
Linking python module lineardeltakins.so
c++ -std=gnu++20 -L/home/runner/work/_temp/linuxcnc-t02-task/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-t02-task/lib -ltirpc  -lgpiod  -shared -o ../lib/python/lineardeltakins.so objects/emc/kinematics/lineardeltakins.o -lboost_python312
Linking python module rotarydeltakins.so
c++ -std=gnu++20 -L/home/runner/work/_temp/linuxcnc-t02-task/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-t02-task/lib -ltirpc  -lgpiod  -shared -o ../lib/python/rotarydeltakins.so objects/emc/kinematics/rotarydeltakins.o -lboost_python312
Preprocessing abs.comp
Preprocessing abs_s32.comp
Preprocessing abs_s64.comp
Preprocessing and2.comp
Preprocessing anglejog.comp
Preprocessing axistest.comp
Preprocessing bin2gray.comp
Preprocessing biquad.comp
Preprocessing bitmerge.comp
Preprocessing bitslice.comp
Preprocessing bitwise.comp
Preprocessing bldc.comp
Preprocessing blend.comp
Preprocessing carousel.comp
Preprocessing charge_pump.comp
Preprocessing clarke2.comp
Preprocessing clarke3.comp
Preprocessing clarkeinv.comp
Preprocessing comp.comp
Preprocessing conv_bit_float.comp
Preprocessing conv_bit_s32.comp
Preprocessing conv_bit_s64.comp
Preprocessing conv_bit_u32.comp
Preprocessing conv_bit_u64.comp
Preprocessing conv_float_s32.comp
Preprocessing conv_float_s64.comp
Preprocessing conv_float_u32.comp
Preprocessing conv_float_u64.comp
Preprocessing conv_s32_bit.comp
Preprocessing conv_s32_float.comp
Preprocessing conv_s32_s64.comp
Preprocessing conv_s32_u32.comp
Preprocessing conv_s32_u64.comp
Preprocessing conv_s64_bit.comp
Preprocessing conv_s64_float.comp
Preprocessing conv_s64_s32.comp
Preprocessing conv_s64_u32.comp
Preprocessing conv_s64_u64.comp
Preprocessing conv_u32_bit.comp
Preprocessing conv_u32_float.comp
Preprocessing conv_u32_s32.comp
Preprocessing conv_u32_s64.comp
Preprocessing conv_u32_u64.comp
Preprocessing conv_u64_bit.comp
Preprocessing conv_u64_float.comp
Preprocessing conv_u64_s32.comp
Preprocessing conv_u64_s64.comp
Preprocessing conv_u64_u32.comp
Preprocessing corexy_by_hal.comp
Preprocessing dbounce.comp
Preprocessing ddt.comp
Preprocessing deadzone.comp
Preprocessing demux.comp
Preprocessing differential.comp
Preprocessing div2.comp
Preprocessing edge.comp
Preprocessing eoffset_per_angle.comp
Preprocessing estop_latch.comp
Preprocessing feedcomp.comp
Preprocessing filter_kalman.comp
Preprocessing flipflop.comp
Preprocessing gantry.comp
Preprocessing gearchange.comp
Preprocessing gray2bin.comp
Preprocessing histobins.comp
Preprocessing histobinstream.comp
Preprocessing homecomp.comp
Preprocessing hypot.comp
Preprocessing ilowpass.comp
Preprocessing integ.comp
Preprocessing invert.comp
Preprocessing joint_axis_mapper.comp
Preprocessing joyhandle.comp
Preprocessing knob2float.comp
Preprocessing laserpower.comp
Preprocessing latencybins.comp
Preprocessing latencybinstream.comp
Preprocessing led_dim.comp
Preprocessing limit1.comp
Preprocessing limit2.comp
Preprocessing limit3.comp
Preprocessing limit_axis.comp
Preprocessing lincurve.comp
Preprocessing logic.comp
Preprocessing lowpass.comp
Preprocessing lut5.comp
Preprocessing maj3.comp
Preprocessing match8.comp
Preprocessing matrixkins.comp
Preprocessing max31855.comp
Preprocessing mesa_pktgyro_test.comp
Preprocessing message.comp
Preprocessing millturn.comp
Preprocessing minmax.comp
Preprocessing momentary2nist.comp
Preprocessing moveoff.comp
Preprocessing mult2.comp
Preprocessing multiclick.comp
Preprocessing multiswitch.comp
Preprocessing mux16.comp
Preprocessing mux2.comp
Preprocessing mux4.comp
Preprocessing mux8.comp
Preprocessing near.comp
Preprocessing not.comp
Preprocessing offset.comp
Preprocessing ohmic.comp
Preprocessing oneshot.comp
Preprocessing or2.comp
Preprocessing orient.comp
Preprocessing output_buffer.comp
Preprocessing plasmac.comp
Preprocessing pushmsg.comp
Preprocessing radiobutton.comp
Preprocessing raster.comp
Preprocessing reset.comp
Preprocessing safety_latch.comp
Preprocessing sample_hold.comp
Preprocessing scale.comp
Preprocessing scaled_s32_sums.comp
Preprocessing select8.comp
Preprocessing sim_axis_hardware.comp
Preprocessing sim_home_switch.comp
Preprocessing sim_matrix_kb.comp
Preprocessing sim_parport.comp
Preprocessing sim_spindle.comp
Preprocessing simple_tp.comp
Preprocessing sphereprobe.comp
Preprocessing spindle.comp
Preprocessing spindle_monitor.comp
Preprocessing steptest.comp
Preprocessing sum2.comp
Preprocessing thc.comp
Preprocessing thcud.comp
Preprocessing threadtest.comp
Preprocessing time.comp
Preprocessing timedelay.comp
Preprocessing timedelta.comp
Preprocessing tof.comp
Preprocessing toggle.comp
Preprocessing toggle2nist.comp
Preprocessing ton.comp
Preprocessing tp.comp
Preprocessing tristate_bit.comp
Preprocessing tristate_float.comp
Preprocessing updown.comp
Preprocessing userkins.comp
Preprocessing wcomp.comp
Preprocessing xhc_hb04_util.comp
Preprocessing xor2.comp
Preprocessing xyzab_tdr_kins.comp
Preprocessing xyzacb_trsrn.comp
Preprocessing xyzbca_trsrn.comp
Preprocessing serport.comp
Preprocessing mesa_7i65.comp
Preprocessing mesa_uart.comp
Compiling realtime objects/hal/components/abs.c
Compiling realtime objects/hal/components/abs_s32.c
Compiling realtime objects/hal/components/abs_s64.c
Compiling realtime objects/hal/components/and2.c
Compiling realtime objects/hal/components/anglejog.c
Compiling realtime objects/hal/components/axistest.c
Compiling realtime objects/hal/components/bin2gray.c
Compiling realtime objects/hal/components/biquad.c
Compiling realtime objects/hal/components/bitmerge.c
Compiling realtime objects/hal/components/bitslice.c
Compiling realtime objects/hal/components/bitwise.c
Compiling realtime objects/hal/components/bldc.c
Compiling realtime objects/hal/components/blend.c
Compiling realtime objects/hal/components/carousel.c
Compiling realtime objects/hal/components/charge_pump.c
Compiling realtime objects/hal/components/clarke2.c
Compiling realtime objects/hal/components/clarke3.c
Compiling realtime objects/hal/components/clarkeinv.c
Compiling realtime objects/hal/components/comp.c
Compiling realtime objects/hal/components/conv_bit_float.c
Compiling realtime objects/hal/components/conv_bit_s32.c
Compiling realtime objects/hal/components/conv_bit_s64.c
Compiling realtime objects/hal/components/conv_bit_u32.c
Compiling realtime objects/hal/components/conv_bit_u64.c
Compiling realtime objects/hal/components/conv_float_s32.c
Compiling realtime objects/hal/components/conv_float_s64.c
Compiling realtime objects/hal/components/conv_float_u32.c
Compiling realtime objects/hal/components/conv_float_u64.c
Compiling realtime objects/hal/components/conv_s32_bit.c
Compiling realtime objects/hal/components/conv_s32_float.c
Compiling realtime objects/hal/components/conv_s32_s64.c
Compiling realtime objects/hal/components/conv_s32_u32.c
Compiling realtime objects/hal/components/conv_s32_u64.c
Compiling realtime objects/hal/components/conv_s64_bit.c
Compiling realtime objects/hal/components/conv_s64_float.c
Compiling realtime objects/hal/components/conv_s64_s32.c
Compiling realtime objects/hal/components/conv_s64_u32.c
Compiling realtime objects/hal/components/conv_s64_u64.c
Compiling realtime objects/hal/components/conv_u32_bit.c
Compiling realtime objects/hal/components/conv_u32_float.c
Compiling realtime objects/hal/components/conv_u32_s32.c
Compiling realtime objects/hal/components/conv_u32_s64.c
Compiling realtime objects/hal/components/conv_u32_u64.c
Compiling realtime objects/hal/components/conv_u64_bit.c
Compiling realtime objects/hal/components/conv_u64_float.c
Compiling realtime objects/hal/components/conv_u64_s32.c
Compiling realtime objects/hal/components/conv_u64_s64.c
Compiling realtime objects/hal/components/conv_u64_u32.c
Compiling realtime objects/hal/components/corexy_by_hal.c
Compiling realtime objects/hal/components/dbounce.c
Compiling realtime objects/hal/components/ddt.c
Compiling realtime objects/hal/components/deadzone.c
Compiling realtime objects/hal/components/demux.c
Compiling realtime objects/hal/components/differential.c
Compiling realtime objects/hal/components/div2.c
Compiling realtime objects/hal/components/edge.c
Compiling realtime objects/hal/components/eoffset_per_angle.c
Compiling realtime objects/hal/components/estop_latch.c
Compiling realtime objects/hal/components/feedcomp.c
Compiling realtime objects/hal/components/filter_kalman.c
Compiling realtime objects/hal/components/flipflop.c
Compiling realtime objects/hal/components/gantry.c
Compiling realtime objects/hal/components/gearchange.c
Compiling realtime objects/hal/components/gray2bin.c
Compiling realtime objects/hal/components/histobins.c
Compiling realtime objects/hal/components/histobinstream.c
Compiling realtime objects/hal/components/homecomp.c
Compiling realtime objects/hal/components/hypot.c
Compiling realtime objects/hal/components/ilowpass.c
Compiling realtime objects/hal/components/integ.c
Compiling realtime objects/hal/components/invert.c
Compiling realtime objects/hal/components/joint_axis_mapper.c
Compiling realtime objects/hal/components/joyhandle.c
Compiling realtime objects/hal/components/knob2float.c
Compiling realtime objects/hal/components/laserpower.c
Compiling realtime objects/hal/components/latencybins.c
Compiling realtime objects/hal/components/latencybinstream.c
Compiling realtime objects/hal/components/led_dim.c
Compiling realtime objects/hal/components/limit1.c
Compiling realtime objects/hal/components/limit2.c
Compiling realtime objects/hal/components/limit3.c
Compiling realtime objects/hal/components/limit_axis.c
Compiling realtime objects/hal/components/lincurve.c
Compiling realtime objects/hal/components/logic.c
Compiling realtime objects/hal/components/lowpass.c
Compiling realtime objects/hal/components/lut5.c
Compiling realtime objects/hal/components/maj3.c
Compiling realtime objects/hal/components/match8.c
Compiling realtime objects/hal/components/matrixkins.c
Compiling realtime objects/hal/components/max31855.c
Compiling realtime objects/hal/components/mesa_pktgyro_test.c
Compiling realtime objects/hal/components/message.c
Compiling realtime objects/hal/components/millturn.c
Compiling realtime objects/hal/components/minmax.c
Compiling realtime objects/hal/components/momentary2nist.c
Compiling realtime objects/hal/components/moveoff.c
Compiling realtime objects/hal/components/mult2.c
Compiling realtime objects/hal/components/multiclick.c
Compiling realtime objects/hal/components/multiswitch.c
Compiling realtime objects/hal/components/mux16.c
Compiling realtime objects/hal/components/mux2.c
Compiling realtime objects/hal/components/mux4.c
Compiling realtime objects/hal/components/mux8.c
Compiling realtime objects/hal/components/near.c
Compiling realtime objects/hal/components/not.c
Compiling realtime objects/hal/components/offset.c
Compiling realtime objects/hal/components/ohmic.c
Compiling realtime objects/hal/components/oneshot.c
Compiling realtime objects/hal/components/or2.c
Compiling realtime objects/hal/components/orient.c
Compiling realtime objects/hal/components/output_buffer.c
Compiling realtime objects/hal/components/plasmac.c
Compiling realtime objects/hal/components/pushmsg.c
Compiling realtime objects/hal/components/radiobutton.c
Compiling realtime objects/hal/components/raster.c
Compiling realtime objects/hal/components/reset.c
Compiling realtime objects/hal/components/safety_latch.c
Compiling realtime objects/hal/components/sample_hold.c
Compiling realtime objects/hal/components/scale.c
Compiling realtime objects/hal/components/scaled_s32_sums.c
Compiling realtime objects/hal/components/select8.c
Compiling realtime objects/hal/components/sim_axis_hardware.c
Compiling realtime objects/hal/components/sim_home_switch.c
Compiling realtime objects/hal/components/sim_matrix_kb.c
Compiling realtime objects/hal/components/sim_parport.c
Compiling realtime objects/hal/components/sim_spindle.c
Compiling realtime objects/hal/components/simple_tp.c
Compiling realtime objects/hal/components/sphereprobe.c
Compiling realtime objects/hal/components/spindle.c
Compiling realtime objects/hal/components/spindle_monitor.c
Compiling realtime objects/hal/components/steptest.c
Compiling realtime objects/hal/components/sum2.c
Compiling realtime objects/hal/components/thc.c
Compiling realtime objects/hal/components/thcud.c
Compiling realtime objects/hal/components/threadtest.c
Compiling realtime objects/hal/components/time.c
Compiling realtime objects/hal/components/timedelay.c
Compiling realtime objects/hal/components/timedelta.c
Compiling realtime objects/hal/components/tof.c
Compiling realtime objects/hal/components/toggle.c
Compiling realtime objects/hal/components/toggle2nist.c
Compiling realtime objects/hal/components/ton.c
Compiling realtime objects/hal/components/tp.c
Compiling realtime objects/hal/components/tristate_bit.c
Compiling realtime objects/hal/components/tristate_float.c
Compiling realtime objects/hal/components/updown.c
Compiling realtime objects/hal/components/userkins.c
Compiling realtime objects/hal/components/wcomp.c
Compiling realtime objects/hal/components/xhc_hb04_util.c
Compiling realtime objects/hal/components/xor2.c
Compiling realtime objects/hal/components/xyzab_tdr_kins.c
Compiling realtime objects/hal/components/xyzacb_trsrn.c
Compiling realtime objects/hal/components/xyzbca_trsrn.c
Compiling realtime objects/hal/drivers/serport.c
Compiling realtime objects/hal/drivers/mesa_7i65.c
Compiling realtime objects/hal/drivers/mesa_uart.c
Linking ../rtlib/boss_plc.so
Linking ../rtlib/debounce.so
Linking ../rtlib/demux_generic.so
Linking ../rtlib/encoder.so
Linking ../rtlib/enum.so
Linking ../rtlib/counter.so
Linking ../rtlib/encoder_ratio.so
Linking ../rtlib/stepgen.so
Linking ../rtlib/lcd.so
Linking ../rtlib/matrix_kb.so
Linking ../rtlib/mux_generic.so
Linking ../rtlib/pwmgen.so
Linking ../rtlib/siggen.so
Linking ../rtlib/pid.so
Linking ../rtlib/threads.so
Linking ../rtlib/supply.so
Linking ../rtlib/sim_encoder.so
Linking ../rtlib/weighted_sum.so
Linking ../rtlib/watchdog.so
Linking ../rtlib/modmath.so
Linking ../rtlib/streamer.so
Linking ../rtlib/sampler.so
Linking ../rtlib/hal_parport.so
Linking ../rtlib/hal_speaker.so
Linking ../rtlib/hal_gm.so
Linking ../rtlib/hal_ppmc.so
Linking ../rtlib/hal_bb_gpio.so
Linking ../rtlib/hal_pi_gpio.so
Linking ../rtlib/hal_gpio.so
Linking ../rtlib/hostmot2.so
Linking ../rtlib/hm2_test.so
Linking ../rtlib/hm2_pci.so
Linking ../rtlib/hm2_7i43.so
Linking ../rtlib/hm2_7i90.so
Linking ../rtlib/setsserial.so
Linking ../rtlib/hm2_modbus.so
Linking ../rtlib/hm2_eth.so
Linking ../rtlib/hm2_spi.so
Linking ../rtlib/hm2_rpspi.so
Linking ../rtlib/hm2_spix.so
Linking ../rtlib/classicladder_rt.so
Linking ../rtlib/scope_rt.so
Linking ../rtlib/hal_lib.so
Linking ../rtlib/trivkins.so
Linking ../rtlib/maxkins.so
Linking ../rtlib/rotatekins.so
Linking ../rtlib/tripodkins.so
Linking ../rtlib/corexykins.so
Linking ../rtlib/lineardeltakins.so
Linking ../rtlib/pentakins.so
Linking ../rtlib/rotarydeltakins.so
Linking ../rtlib/rosekins.so
Linking ../rtlib/scorbot-kins.so
Linking ../rtlib/genhexkins.so
Linking ../rtlib/genserkins.so
Linking ../rtlib/xyzac-trt-kins.so
Linking ../rtlib/xyzbc-trt-kins.so
Linking ../rtlib/scarakins.so
Linking ../rtlib/pumakins.so
Linking ../rtlib/three21kins.so
Linking ../rtlib/5axiskins.so
Linking ../rtlib/motmod.so
Linking ../rtlib/homemod.so
Linking ../rtlib/tpmod.so
ln -sf libposemath.so.0 ../lib/libposemath.so
ln -sf libnml.so.0 ../lib/libnml.so
ln -sf liblinuxcnc-uspace-posix.so.0 ../lib/liblinuxcnc-uspace-posix.so
Linking halstreamer
Linking halsampler
Linking panelui
Linking mb2hal
Linking gs2_vfd
Linking hy_gt_vfd
Linking svd-ps_vfd
Linking shuttle
Linking xhc-hb04
Linking sendkeys
Preprocessing thermistor.comp
Linking vfs11_vfd
Linking halcmd
Linking halrmt
Linking vfdb_vfd
Preprocessing wj200_vfd.comp
Preprocessing pi500_vfd.comp
Linking linuxcncrsh
Linking schedrmt
Linking linuxcnclcd
Linking halui
Linking linuxcncsvr
ln -sf libpyplugin.so.0 ../lib/libpyplugin.so
emc/Submakefile:Linking genserkins
Linking python module linuxcnc.so
Linking ../rtlib/abs.so
Linking ../rtlib/abs_s32.so
Linking ../rtlib/abs_s64.so
Linking ../rtlib/and2.so
Linking ../rtlib/anglejog.so
Linking ../rtlib/axistest.so
Linking ../rtlib/bin2gray.so
Linking ../rtlib/biquad.so
Linking ../rtlib/bitmerge.so
Linking ../rtlib/bitslice.so
Linking ../rtlib/bitwise.so
Linking ../rtlib/bldc.so
Linking ../rtlib/blend.so
Linking ../rtlib/carousel.so
Linking ../rtlib/charge_pump.so
Linking ../rtlib/clarke2.so
Linking ../rtlib/clarke3.so
Linking ../rtlib/clarkeinv.so
Linking ../rtlib/comp.so
Linking ../rtlib/conv_bit_float.so
Linking ../rtlib/conv_bit_s32.so
Linking ../rtlib/conv_bit_s64.so
Linking ../rtlib/conv_bit_u32.so
Linking ../rtlib/conv_bit_u64.so
Linking ../rtlib/conv_float_s32.so
Linking ../rtlib/conv_float_s64.so
Linking ../rtlib/conv_float_u32.so
Linking ../rtlib/conv_float_u64.so
Linking ../rtlib/conv_s32_bit.so
Linking ../rtlib/conv_s32_float.so
Linking ../rtlib/conv_s32_s64.so
Linking ../rtlib/conv_s32_u32.so
Linking ../rtlib/conv_s32_u64.so
Linking ../rtlib/conv_s64_bit.so
Linking ../rtlib/conv_s64_float.so
Linking ../rtlib/conv_s64_s32.so
Linking ../rtlib/conv_s64_u32.so
Linking ../rtlib/conv_s64_u64.so
Linking ../rtlib/conv_u32_bit.so
Linking ../rtlib/conv_u32_float.so
Linking ../rtlib/conv_u32_s32.so
Linking ../rtlib/conv_u32_s64.so
Linking ../rtlib/conv_u32_u64.so
Linking ../rtlib/conv_u64_bit.so
Linking ../rtlib/conv_u64_float.so
Linking ../rtlib/conv_u64_s32.so
Linking ../rtlib/conv_u64_s64.so
Linking ../rtlib/conv_u64_u32.so
Linking ../rtlib/corexy_by_hal.so
Linking ../rtlib/dbounce.so
Linking ../rtlib/ddt.so
Linking ../rtlib/deadzone.so
Linking ../rtlib/demux.so
Linking ../rtlib/differential.so
Linking ../rtlib/div2.so
Linking ../rtlib/edge.so
Linking ../rtlib/eoffset_per_angle.so
Linking ../rtlib/estop_latch.so
Linking ../rtlib/feedcomp.so
Linking ../rtlib/filter_kalman.so
Linking ../rtlib/flipflop.so
Linking ../rtlib/gantry.so
Linking ../rtlib/gearchange.so
Linking ../rtlib/gray2bin.so
Linking ../rtlib/histobins.so
Linking ../rtlib/histobinstream.so
Linking ../rtlib/homecomp.so
Linking ../rtlib/hypot.so
Linking ../rtlib/ilowpass.so
Linking ../rtlib/integ.so
Linking ../rtlib/invert.so
Linking ../rtlib/joint_axis_mapper.so
Linking ../rtlib/joyhandle.so
Linking ../rtlib/knob2float.so
Linking ../rtlib/laserpower.so
Linking ../rtlib/latencybins.so
Linking ../rtlib/latencybinstream.so
Linking ../rtlib/led_dim.so
Linking ../rtlib/limit1.so
Linking ../rtlib/limit2.so
Linking ../rtlib/limit3.so
Linking ../rtlib/limit_axis.so
Linking ../rtlib/lincurve.so
Linking ../rtlib/logic.so
Linking ../rtlib/lowpass.so
Linking ../rtlib/lut5.so
Linking ../rtlib/maj3.so
Linking ../rtlib/match8.so
Linking ../rtlib/matrixkins.so
Linking ../rtlib/max31855.so
Linking ../rtlib/mesa_pktgyro_test.so
Linking ../rtlib/message.so
Linking ../rtlib/millturn.so
Linking ../rtlib/minmax.so
Linking ../rtlib/momentary2nist.so
Linking ../rtlib/moveoff.so
Linking ../rtlib/mult2.so
Linking ../rtlib/multiclick.so
Linking ../rtlib/multiswitch.so
Linking ../rtlib/mux16.so
Linking ../rtlib/mux2.so
Linking ../rtlib/mux4.so
Linking ../rtlib/mux8.so
Linking ../rtlib/near.so
Linking ../rtlib/not.so
Linking ../rtlib/offset.so
Linking ../rtlib/ohmic.so
Linking ../rtlib/oneshot.so
Linking ../rtlib/or2.so
Linking ../rtlib/orient.so
Linking ../rtlib/output_buffer.so
Linking ../rtlib/plasmac.so
Linking ../rtlib/pushmsg.so
Linking ../rtlib/radiobutton.so
Linking ../rtlib/raster.so
Linking ../rtlib/reset.so
Linking ../rtlib/safety_latch.so
Linking ../rtlib/sample_hold.so
Linking ../rtlib/scale.so
Linking ../rtlib/scaled_s32_sums.so
Linking ../rtlib/select8.so
Linking ../rtlib/sim_axis_hardware.so
Linking ../rtlib/sim_home_switch.so
Linking ../rtlib/sim_matrix_kb.so
Linking ../rtlib/sim_parport.so
Linking ../rtlib/sim_spindle.so
Linking ../rtlib/simple_tp.so
Linking ../rtlib/sphereprobe.so
Linking ../rtlib/spindle.so
Linking ../rtlib/spindle_monitor.so
Linking ../rtlib/steptest.so
Linking ../rtlib/sum2.so
Linking ../rtlib/thc.so
Linking ../rtlib/thcud.so
Linking ../rtlib/threadtest.so
Linking ../rtlib/time.so
Linking ../rtlib/timedelay.so
Linking ../rtlib/timedelta.so
Linking ../rtlib/tof.so
Linking ../rtlib/toggle.so
Linking ../rtlib/toggle2nist.so
Linking ../rtlib/ton.so
Linking ../rtlib/tp.so
Linking ../rtlib/tristate_bit.so
Linking ../rtlib/tristate_float.so
Linking ../rtlib/updown.so
Linking ../rtlib/userkins.so
Linking ../rtlib/wcomp.so
Linking ../rtlib/xhc_hb04_util.so
Linking ../rtlib/xor2.so
Linking ../rtlib/xyzab_tdr_kins.so
Linking ../rtlib/xyzacb_trsrn.so
Linking ../rtlib/xyzbca_trsrn.so
Linking ../rtlib/serport.so
Linking ../rtlib/mesa_7i65.so
Linking ../rtlib/mesa_uart.so
Compiling objects/hal/user_comps/thermistor.c
Compiling hal/user_comps/wj200_vfd/wj200_vfd.c
Compiling hal/user_comps/pi500_vfd/pi500_vfd.c
Linking librs274.so.0
c++ -std=gnu++20 -g -L/home/runner/work/_temp/linuxcnc-t02-task/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-t02-task/lib -ltirpc  -lgpiod  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-soname,librs274.so.0 -shared -o ../lib/librs274.so.0 objects/emc/rs274ngc/interp_arc.o objects/emc/rs274ngc/interp_array.o objects/emc/rs274ngc/interp_base.o objects/emc/rs274ngc/interp_check.o objects/emc/rs274ngc/interp_convert.o objects/emc/rs274ngc/interp_queue.o objects/emc/rs274ngc/interp_cycles.o objects/emc/rs274ngc/interp_execute.o objects/emc/rs274ngc/interp_find.o objects/emc/rs274ngc/interp_internal.o objects/emc/rs274ngc/interp_inverse.o objects/emc/rs274ngc/interp_read.o objects/emc/rs274ngc/interp_write.o objects/emc/rs274ngc/interp_o_word.o objects/emc/rs274ngc/interp_g7x.o objects/emc/rs274ngc/nurbs_additional_functions.o objects/emc/rs274ngc/interp_namedparams.o objects/emc/rs274ngc/interp_python.o objects/emc/rs274ngc/interp_remap.o objects/emc/rs274ngc/interp_setup.o objects/emc/rs274ngc/canonmodule.o objects/emc/rs274ngc/pyparamclass.o objects/emc/rs274ngc/pyemctypes.o objects/emc/rs274ngc/pyinterp1.o objects/emc/rs274ngc/pyblock.o objects/emc/rs274ngc/pyarrays.o objects/emc/rs274ngc/interpmodule.o objects/emc/rs274ngc/rs274ngc_pre.o objects/emc/rs274ngc/interp_inspection.o objects/emc/nml_intf/modal_state.o ../lib/liblinuxcncini.so ../lib/libpyplugin.so ../lib/liblinuxcnchal.so.0 ../lib/libtooldata.so.0 -lstdc++ -lboost_python312 -L/usr/lib/x86_64-linux-gnu -lpython3.12 -ldl -lm
Linking thermistor
Linking pi500_vfd
Linking wj200_vfd
ln -sf librs274.so.0 ../lib/librs274.so
Linking milltask
c++ -std=gnu++20 -o ../bin/milltask objects/emc/motion/emcmotglb.o objects/emc/task/emctask.o objects/emc/task/emccanon.o objects/emc/task/emctaskmain.o objects/emc/motion/usrmotintf.o objects/emc/motion/emcmotutil.o objects/emc/task/taskintf.o objects/emc/motion/dbuf.o objects/emc/motion/stashf.o objects/emc/task/taskclass.o objects/emc/task/backtrace.o objects/emc/usr_intf/mapini.o ../lib/librs274.so.0 ../lib/liblinuxcnc.a ../lib/libnml.so.0 ../lib/liblinuxcncini.so.1 ../lib/libposemath.so.0 ../lib/liblinuxcnchal.so.0 ../lib/libpyplugin.so.0 ../lib/libtooldata.so.0 -L/home/runner/work/_temp/linuxcnc-t02-task/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-t02-task/lib -ltirpc  -lgpiod  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -lboost_python312 -L/usr/lib/x86_64-linux-gnu -lpython3.12 -ldl -lm -lfmt
Linking rs274
Linking python module gcode.so
c++ -std=gnu++20 -L/home/runner/work/_temp/linuxcnc-t02-task/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-t02-task/lib -ltirpc  -lgpiod  -shared -o ../lib/python/gcode.so objects/emc/rs274ngc/gcodemodule.o ../lib/librs274.so.0 -lstdc++
Linking canterp.so
You now need to run 'sudo make setuid' or 'sudo make setcap' in order to run in place with access to hardware.
make: Leaving directory '/home/runner/work/_temp/linuxcnc-t02-task/src'
linuxcnc-bin=/home/runner/work/_temp/linuxcnc-t02-task/scripts/linuxcnc
linuxcnc-python-module=/home/runner/work/_temp/linuxcnc-t02-task/lib/python/linuxcnc.so
gate-A=PASS
program-sha256=40da6cf40bbae2c342cf0307e8bb43a7c962519a2d28ee88b8ecf25f323387f6
Program: metric absolute; 20 mm feed move at 120 mm/min (~10 s nominal) followed by G4 P0.75.
runtime-ready-probe=3
constant-EXEC_DONE=2
constant-EXEC_WAITING_FOR_MOTION_AND_IO=7
constant-EXEC_WAITING_FOR_DELAY=8
constant-INTERP_IDLE=1
constant-MODE_MANUAL=1
constant-MODE_AUTO=2
constant-STATE_ESTOP_RESET=2
constant-STATE_ON=4
constant-AUTO_RUN=0
estop-reset-wait-complete=1
machine-on-wait-complete=1
manual-mode-wait-complete=1
active-joint-count=3
joint-0-homed=PASS
joint-1-homed=PASS
joint-2-homed=PASS
all-active-joints-homed=PASS
pre-run-inpos=PASS
auto-mode-wait-complete=1
program-open-wait-complete=1
loaded-file=/home/runner/work/_temp/linuxcnc-t02-task/tests/linuxcncrsh/t02-019.ngc
gate-B=PASS
start-x-actual=0.000000000 start-x-commanded=0.000000000
trace-samples=2110
saw-independent-motion=1
saw-WAITING_FOR_MOTION_AND_IO-while-incomplete=1
WAITING_FOR_DELAY-while-incomplete=0
line-at-or-past-dwell-while-motion-incomplete=1
error-count=0
program-finished=1
gate-C=PASS
gate-D=PASS
gate-E=PASS
waiting-for-delay-observed-span=0.748012
gate-F=PASS
final-x-actual=0.787401575 final-x-commanded=0.787401575
gate-G=PASS
anti-circular-line-ahead-observed=YES
T02-019 overall=PASS

== Trace evidence slices ==
-- first 12 samples --
t,exec_state,interp_state,state,current_line,read_line,motion_line,inpos,actual_x,commanded_x,dtg,queue,active_queue
0.020233,7,4,2,3,5,3,0,0.001141732,0.001377953,0.786023622,1,1
0.025328,7,4,2,3,5,3,0,0.001535433,0.001771654,0.785629921,1,1
0.030425,7,4,2,3,5,3,0,0.002007874,0.002244094,0.785157480,1,1
0.035513,7,4,2,3,5,3,0,0.002401575,0.002637795,0.784763780,1,1
0.040603,7,4,2,3,5,3,0,0.002716535,0.002952756,0.784448819,1,1
0.045693,7,4,2,3,5,3,0,0.003110236,0.003346457,0.784055118,1,1
0.050781,7,4,2,3,5,3,0,0.003582677,0.003818898,0.783582677,1,1
0.055868,7,4,2,3,5,3,0,0.003976378,0.004212598,0.783188976,1,1
0.060953,7,4,2,3,5,3,0,0.004370079,0.004606299,0.782795276,1,1
0.066043,7,4,2,3,5,3,0,0.004763780,0.005000000,0.782401575,1,1
0.071132,7,4,2,3,5,3,0,0.005157480,0.005393701,0.782007874,1,1
0.076219,7,4,2,3,5,3,0,0.005551181,0.005787402,0.781614173,1,1
-- samples containing exec_state transitions --
transition-index=0 exec_state=7
0.020233,7,4,2,3,5,3,0,0.001141732,0.001377953,0.786023622,1,1
0.025328,7,4,2,3,5,3,0,0.001535433,0.001771654,0.785629921,1,1
transition-index=1961 exec_state=8
10.000425,7,4,2,3,5,3,0,0.786968504,0.787204724,0.000196850,1,1
10.005517,8,4,2,3,5,3,1,0.787395013,0.787401575,0.000000000,0,0
10.010606,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
transition-index=2109 exec_state=2
10.753529,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.758618,2,1,1,3,0,3,1,0.787401575,0.787401575,0.000000000,0,0
-- final 12 samples --
10.702645,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.707731,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.712821,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.717910,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.723001,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.728086,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.733172,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.738256,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.743343,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.748440,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.753529,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.758618,2,1,1,3,0,3,1,0.787401575,0.787401575,0.000000000,0,0
=== BEGIN T02-019 FULL RAW TRACE CSV ===
t,exec_state,interp_state,state,current_line,read_line,motion_line,inpos,actual_x,commanded_x,dtg,queue,active_queue
0.020233,7,4,2,3,5,3,0,0.001141732,0.001377953,0.786023622,1,1
0.025328,7,4,2,3,5,3,0,0.001535433,0.001771654,0.785629921,1,1
0.030425,7,4,2,3,5,3,0,0.002007874,0.002244094,0.785157480,1,1
0.035513,7,4,2,3,5,3,0,0.002401575,0.002637795,0.784763780,1,1
0.040603,7,4,2,3,5,3,0,0.002716535,0.002952756,0.784448819,1,1
0.045693,7,4,2,3,5,3,0,0.003110236,0.003346457,0.784055118,1,1
0.050781,7,4,2,3,5,3,0,0.003582677,0.003818898,0.783582677,1,1
0.055868,7,4,2,3,5,3,0,0.003976378,0.004212598,0.783188976,1,1
0.060953,7,4,2,3,5,3,0,0.004370079,0.004606299,0.782795276,1,1
0.066043,7,4,2,3,5,3,0,0.004763780,0.005000000,0.782401575,1,1
0.071132,7,4,2,3,5,3,0,0.005157480,0.005393701,0.782007874,1,1
0.076219,7,4,2,3,5,3,0,0.005551181,0.005787402,0.781614173,1,1
0.081305,7,4,2,3,5,3,0,0.006023622,0.006259843,0.781141732,1,1
0.086392,7,4,2,3,5,3,0,0.006338583,0.006574803,0.780826772,1,1
0.091482,7,4,2,3,5,3,0,0.006732283,0.006968504,0.780433071,1,1
0.096568,7,4,2,3,5,3,0,0.007204724,0.007440945,0.779960630,1,1
0.101654,7,4,2,3,5,3,0,0.007598425,0.007834646,0.779566929,1,1
0.106749,7,4,2,3,5,3,0,0.007913386,0.008149606,0.779251969,1,1
0.111845,7,4,2,3,5,3,0,0.008385827,0.008622047,0.778779528,1,1
0.116932,7,4,2,3,5,3,0,0.008779528,0.009015748,0.778385827,1,1
0.122024,7,4,2,3,5,3,0,0.009173228,0.009409449,0.777992126,1,1
0.127115,7,4,2,3,5,3,0,0.009645669,0.009881890,0.777519685,1,1
0.132212,7,4,2,3,5,3,0,0.009960630,0.010196850,0.777204724,1,1
0.137302,7,4,2,3,5,3,0,0.010354331,0.010590551,0.776811024,1,1
0.142390,7,4,2,3,5,3,0,0.010826772,0.011062992,0.776338583,1,1
0.147475,7,4,2,3,5,3,0,0.011220472,0.011456693,0.775944882,1,1
0.152564,7,4,2,3,5,3,0,0.011535433,0.011771654,0.775629921,1,1
0.157653,7,4,2,3,5,3,0,0.012007874,0.012244094,0.775157480,1,1
0.162740,7,4,2,3,5,3,0,0.012401575,0.012637795,0.774763780,1,1
0.167824,7,4,2,3,5,3,0,0.012795276,0.013031496,0.774370079,1,1
0.172916,7,4,2,3,5,3,0,0.013110236,0.013346457,0.774055118,1,1
0.177999,7,4,2,3,5,3,0,0.013582677,0.013818898,0.773582677,1,1
0.183085,7,4,2,3,5,3,0,0.013976378,0.014212598,0.773188976,1,1
0.188179,7,4,2,3,5,3,0,0.014370079,0.014606299,0.772795276,1,1
0.193344,7,4,2,3,5,3,0,0.014842520,0.015078740,0.772322835,1,1
0.198434,7,4,2,3,5,3,0,0.015157480,0.015393701,0.772007874,1,1
0.203528,7,4,2,3,5,3,0,0.015551181,0.015787402,0.771614173,1,1
0.208618,7,4,2,3,5,3,0,0.016023622,0.016259843,0.771141732,1,1
0.213705,7,4,2,3,5,3,0,0.016417323,0.016653543,0.770748031,1,1
0.218793,7,4,2,3,5,3,0,0.016732283,0.016968504,0.770433071,1,1
0.223884,7,4,2,3,5,3,0,0.017204724,0.017440945,0.769960630,1,1
0.228972,7,4,2,3,5,3,0,0.017598425,0.017834646,0.769566929,1,1
0.234059,7,4,2,3,5,3,0,0.017992126,0.018228346,0.769173228,1,1
0.239146,7,4,2,3,5,3,0,0.018385827,0.018622047,0.768779528,1,1
0.244232,7,4,2,3,5,3,0,0.018779528,0.019015748,0.768385827,1,1
0.249320,7,4,2,3,5,3,0,0.019173228,0.019409449,0.767992126,1,1
0.254405,7,4,2,3,5,3,0,0.019645669,0.019881890,0.767519685,1,1
0.259491,7,4,2,3,5,3,0,0.019960630,0.020196850,0.767204724,1,1
0.264584,7,4,2,3,5,3,0,0.020354331,0.020590551,0.766811024,1,1
0.269678,7,4,2,3,5,3,0,0.020826772,0.021062992,0.766338583,1,1
0.274769,7,4,2,3,5,3,0,0.021220472,0.021456693,0.765944882,1,1
0.279862,7,4,2,3,5,3,0,0.021614173,0.021850394,0.765551181,1,1
0.284955,7,4,2,3,5,3,0,0.022007874,0.022244094,0.765157480,1,1
0.290044,7,4,2,3,5,3,0,0.022401575,0.022637795,0.764763780,1,1
0.295130,7,4,2,3,5,3,0,0.022795276,0.023031496,0.764370079,1,1
0.300217,7,4,2,3,5,3,0,0.023267717,0.023503937,0.763897638,1,1
0.305305,7,4,2,3,5,3,0,0.023582677,0.023818898,0.763582677,1,1
0.310393,7,4,2,3,5,3,0,0.023976378,0.024212598,0.763188976,1,1
0.315481,7,4,2,3,5,3,0,0.024448819,0.024685039,0.762716535,1,1
0.320569,7,4,2,3,5,3,0,0.024842520,0.025078740,0.762322835,1,1
0.325664,7,4,2,3,5,3,0,0.025157480,0.025393701,0.762007874,1,1
0.330755,7,4,2,3,5,3,0,0.025629921,0.025866142,0.761535433,1,1
0.335843,7,4,2,3,5,3,0,0.026023622,0.026259843,0.761141732,1,1
0.340931,7,4,2,3,5,3,0,0.026417323,0.026653543,0.760748031,1,1
0.346020,7,4,2,3,5,3,0,0.026811024,0.027047244,0.760354331,1,1
0.351107,7,4,2,3,5,3,0,0.027204724,0.027440945,0.759960630,1,1
0.356194,7,4,2,3,5,3,0,0.027598425,0.027834646,0.759566929,1,1
0.361281,7,4,2,3,5,3,0,0.028070866,0.028307087,0.759094488,1,1
0.366370,7,4,2,3,5,3,0,0.028385827,0.028622047,0.758779528,1,1
0.371458,7,4,2,3,5,3,0,0.028779528,0.029015748,0.758385827,1,1
0.376548,7,4,2,3,5,3,0,0.029251969,0.029488189,0.757913386,1,1
0.381634,7,4,2,3,5,3,0,0.029645669,0.029881890,0.757519685,1,1
0.386720,7,4,2,3,5,3,0,0.029960630,0.030196850,0.757204724,1,1
0.391811,7,4,2,3,5,3,0,0.030433071,0.030669291,0.756732283,1,1
0.396905,7,4,2,3,5,3,0,0.030826772,0.031062992,0.756338583,1,1
0.401991,7,4,2,3,5,3,0,0.031220472,0.031456693,0.755944882,1,1
0.407085,7,4,2,3,5,3,0,0.031692913,0.031929134,0.755472441,1,1
0.412172,7,4,2,3,5,3,0,0.032007874,0.032244094,0.755157480,1,1
0.417258,7,4,2,3,5,3,0,0.032401575,0.032637795,0.754763780,1,1
0.422342,7,4,2,3,5,3,0,0.032874016,0.033110236,0.754291339,1,1
0.427431,7,4,2,3,5,3,0,0.033267717,0.033503937,0.753897638,1,1
0.432519,7,4,2,3,5,3,0,0.033582677,0.033818898,0.753582677,1,1
0.437611,7,4,2,3,5,3,0,0.033976378,0.034212598,0.753188976,1,1
0.442698,7,4,2,3,5,3,0,0.034448819,0.034685039,0.752716535,1,1
0.447784,7,4,2,3,5,3,0,0.034842520,0.035078740,0.752322835,1,1
0.452876,7,4,2,3,5,3,0,0.035157480,0.035393701,0.752007874,1,1
0.457962,7,4,2,3,5,3,0,0.035629921,0.035866142,0.751535433,1,1
0.463051,7,4,2,3,5,3,0,0.036023622,0.036259843,0.751141732,1,1
0.468137,7,4,2,3,5,3,0,0.036417323,0.036653543,0.750748031,1,1
0.473227,7,4,2,3,5,3,0,0.036811024,0.037047244,0.750354331,1,1
0.478322,7,4,2,3,5,3,0,0.037204724,0.037440945,0.749960630,1,1
0.483407,7,4,2,3,5,3,0,0.037598425,0.037834646,0.749566929,1,1
0.488493,7,4,2,3,5,3,0,0.038070866,0.038307087,0.749094488,1,1
0.493579,7,4,2,3,5,3,0,0.038385827,0.038622047,0.748779528,1,1
0.498677,7,4,2,3,5,3,0,0.038779528,0.039015748,0.748385827,1,1
0.503763,7,4,2,3,5,3,0,0.039251969,0.039488189,0.747913386,1,1
0.508850,7,4,2,3,5,3,0,0.039645669,0.039881890,0.747519685,1,1
0.513940,7,4,2,3,5,3,0,0.040039370,0.040275591,0.747125984,1,1
0.519026,7,4,2,3,5,3,0,0.040433071,0.040669291,0.746732283,1,1
0.524116,7,4,2,3,5,3,0,0.040826772,0.041062992,0.746338583,1,1
0.529206,7,4,2,3,5,3,0,0.041220472,0.041456693,0.745944882,1,1
0.534293,7,4,2,3,5,3,0,0.041692913,0.041929134,0.745472441,1,1
0.539379,7,4,2,3,5,3,0,0.042007874,0.042244094,0.745157480,1,1
0.544467,7,4,2,3,5,3,0,0.042401575,0.042637795,0.744763780,1,1
0.549549,7,4,2,3,5,3,0,0.042874016,0.043110236,0.744291339,1,1
0.554632,7,4,2,3,5,3,0,0.043267717,0.043503937,0.743897638,1,1
0.559717,7,4,2,3,5,3,0,0.043582677,0.043818898,0.743582677,1,1
0.564799,7,4,2,3,5,3,0,0.044055118,0.044291339,0.743110236,1,1
0.569882,7,4,2,3,5,3,0,0.044448819,0.044685039,0.742716535,1,1
0.574973,7,4,2,3,5,3,0,0.044842520,0.045078740,0.742322835,1,1
0.580068,7,4,2,3,5,3,0,0.045314961,0.045551181,0.741850394,1,1
0.585157,7,4,2,3,5,3,0,0.045629921,0.045866142,0.741535433,1,1
0.590248,7,4,2,3,5,3,0,0.046023622,0.046259843,0.741141732,1,1
0.595338,7,4,2,3,5,3,0,0.046496063,0.046732283,0.740669291,1,1
0.600425,7,4,2,3,5,3,0,0.046889764,0.047125984,0.740275591,1,1
0.605516,7,4,2,3,5,3,0,0.047204724,0.047440945,0.739960630,1,1
0.610602,7,4,2,3,5,3,0,0.047598425,0.047834646,0.739566929,1,1
0.615692,7,4,2,3,5,3,0,0.048070866,0.048307087,0.739094488,1,1
0.620780,7,4,2,3,5,3,0,0.048464567,0.048700787,0.738700787,1,1
0.625870,7,4,2,3,5,3,0,0.048779528,0.049015748,0.738385827,1,1
0.630964,7,4,2,3,5,3,0,0.049251969,0.049488189,0.737913386,1,1
0.636058,7,4,2,3,5,3,0,0.049645669,0.049881890,0.737519685,1,1
0.641164,7,4,2,3,5,3,0,0.050039370,0.050275591,0.737125984,1,1
0.646259,7,4,2,3,5,3,0,0.050511811,0.050748031,0.736653543,1,1
0.651386,7,4,2,3,5,3,0,0.050826772,0.051062992,0.736338583,1,1
0.656531,7,4,2,3,5,3,0,0.051220472,0.051456693,0.735944882,1,1
0.661667,7,4,2,3,5,3,0,0.051692913,0.051929134,0.735472441,1,1
0.666853,7,4,2,3,5,3,0,0.052086614,0.052322835,0.735078740,1,1
0.671995,7,4,2,3,5,3,0,0.052480315,0.052716535,0.734685039,1,1
0.677138,7,4,2,3,5,3,0,0.052874016,0.053110236,0.734291339,1,1
0.682275,7,4,2,3,5,3,0,0.053267717,0.053503937,0.733897638,1,1
0.687401,7,4,2,3,5,3,0,0.053661417,0.053897638,0.733503937,1,1
0.692506,7,4,2,3,5,3,0,0.054133858,0.054370079,0.733031496,1,1
0.697607,7,4,2,3,5,3,0,0.054448819,0.054685039,0.732716535,1,1
0.702706,7,4,2,3,5,3,0,0.054921260,0.055157480,0.732244094,1,1
0.707796,7,4,2,3,5,3,0,0.055314961,0.055551181,0.731850394,1,1
0.712884,7,4,2,3,5,3,0,0.055708661,0.055944882,0.731456693,1,1
0.717972,7,4,2,3,5,3,0,0.056102362,0.056338583,0.731062992,1,1
0.723065,7,4,2,3,5,3,0,0.056496063,0.056732283,0.730669291,1,1
0.728153,7,4,2,3,5,3,0,0.056889764,0.057125984,0.730275591,1,1
0.733241,7,4,2,3,5,3,0,0.057362205,0.057598425,0.729803150,1,1
0.738333,7,4,2,3,5,3,0,0.057677165,0.057913386,0.729488189,1,1
0.743479,7,4,2,3,5,3,0,0.058070866,0.058307087,0.729094488,1,1
0.748572,7,4,2,3,5,3,0,0.058543307,0.058779528,0.728622047,1,1
0.753658,7,4,2,3,5,3,0,0.058937008,0.059173228,0.728228346,1,1
0.758749,7,4,2,3,5,3,0,0.059251969,0.059488189,0.727913386,1,1
0.763845,7,4,2,3,5,3,0,0.059724409,0.059960630,0.727440945,1,1
0.768931,7,4,2,3,5,3,0,0.060118110,0.060354331,0.727047244,1,1
0.774019,7,4,2,3,5,3,0,0.060511811,0.060748031,0.726653543,1,1
0.779106,7,4,2,3,5,3,0,0.060984252,0.061220472,0.726181102,1,1
0.784198,7,4,2,3,5,3,0,0.061299213,0.061535433,0.725866142,1,1
0.789288,7,4,2,3,5,3,0,0.061692913,0.061929134,0.725472441,1,1
0.794375,7,4,2,3,5,3,0,0.062165354,0.062401575,0.725000000,1,1
0.799461,7,4,2,3,5,3,0,0.062559055,0.062795276,0.724606299,1,1
0.804549,7,4,2,3,5,3,0,0.062874016,0.063110236,0.724291339,1,1
0.809638,7,4,2,3,5,3,0,0.063346457,0.063582677,0.723818898,1,1
0.814725,7,4,2,3,5,3,0,0.063740157,0.063976378,0.723425197,1,1
0.819809,7,4,2,3,5,3,0,0.064133858,0.064370079,0.723031496,1,1
0.824900,7,4,2,3,5,3,0,0.064448819,0.064685039,0.722716535,1,1
0.829995,7,4,2,3,5,3,0,0.064921260,0.065157480,0.722244094,1,1
0.835082,7,4,2,3,5,3,0,0.065314961,0.065551181,0.721850394,1,1
0.840169,7,4,2,3,5,3,0,0.065708661,0.065944882,0.721456693,1,1
0.845258,7,4,2,3,5,3,0,0.066181102,0.066417323,0.720984252,1,1
0.850350,7,4,2,3,5,3,0,0.066496063,0.066732283,0.720669291,1,1
0.855438,7,4,2,3,5,3,0,0.066889764,0.067125984,0.720275591,1,1
0.860525,7,4,2,3,5,3,0,0.067362205,0.067598425,0.719803150,1,1
0.865611,7,4,2,3,5,3,0,0.067755906,0.067992126,0.719409449,1,1
0.870698,7,4,2,3,5,3,0,0.068070866,0.068307087,0.719094488,1,1
0.875784,7,4,2,3,5,3,0,0.068543307,0.068779528,0.718622047,1,1
0.880869,7,4,2,3,5,3,0,0.068937008,0.069173228,0.718228346,1,1
0.885953,7,4,2,3,5,3,0,0.069330709,0.069566929,0.717834646,1,1
0.891038,7,4,2,3,5,3,0,0.069724409,0.069960630,0.717440945,1,1
0.896123,7,4,2,3,5,3,0,0.070118110,0.070354331,0.717047244,1,1
0.901208,7,4,2,3,5,3,0,0.070511811,0.070748031,0.716653543,1,1
0.906293,7,4,2,3,5,3,0,0.070984252,0.071220472,0.716181102,1,1
0.911379,7,4,2,3,5,3,0,0.071299213,0.071535433,0.715866142,1,1
0.916470,7,4,2,3,5,3,0,0.071692913,0.071929134,0.715472441,1,1
0.921559,7,4,2,3,5,3,0,0.072165354,0.072401575,0.715000000,1,1
0.926651,7,4,2,3,5,3,0,0.072559055,0.072795276,0.714606299,1,1
0.931751,7,4,2,3,5,3,0,0.072874016,0.073110236,0.714291339,1,1
0.936857,7,4,2,3,5,3,0,0.073346457,0.073582677,0.713818898,1,1
0.941944,7,4,2,3,5,3,0,0.073740157,0.073976378,0.713425197,1,1
0.947032,7,4,2,3,5,3,0,0.074133858,0.074370079,0.713031496,1,1
0.952116,7,4,2,3,5,3,0,0.074606299,0.074842520,0.712559055,1,1
0.957204,7,4,2,3,5,3,0,0.074921260,0.075157480,0.712244094,1,1
0.962291,7,4,2,3,5,3,0,0.075314961,0.075551181,0.711850394,1,1
0.967363,7,4,2,3,5,3,0,0.075787402,0.076023622,0.711377953,1,1
0.972449,7,4,2,3,5,3,0,0.076181102,0.076417323,0.710984252,1,1
0.977534,7,4,2,3,5,3,0,0.076496063,0.076732283,0.710669291,1,1
0.982624,7,4,2,3,5,3,0,0.076889764,0.077125984,0.710275591,1,1
0.987713,7,4,2,3,5,3,0,0.077362205,0.077598425,0.709803150,1,1
0.992799,7,4,2,3,5,3,0,0.077755906,0.077992126,0.709409449,1,1
0.997884,7,4,2,3,5,3,0,0.078070866,0.078307087,0.709094488,1,1
1.002970,7,4,2,3,5,3,0,0.078543307,0.078779528,0.708622047,1,1
1.008055,7,4,2,3,5,3,0,0.078937008,0.079173228,0.708228346,1,1
1.013141,7,4,2,3,5,3,0,0.079330709,0.079566929,0.707834646,1,1
1.018232,7,4,2,3,5,3,0,0.079724409,0.079960630,0.707440945,1,1
1.023319,7,4,2,3,5,3,0,0.080118110,0.080354331,0.707047244,1,1
1.028411,7,4,2,3,5,3,0,0.080511811,0.080748031,0.706653543,1,1
1.033499,7,4,2,3,5,3,0,0.080984252,0.081220472,0.706181102,1,1
1.038599,7,4,2,3,5,3,0,0.081299213,0.081535433,0.705866142,1,1
1.043698,7,4,2,3,5,3,0,0.081692913,0.081929134,0.705472441,1,1
1.048785,7,4,2,3,5,3,0,0.082165354,0.082401575,0.705000000,1,1
1.053872,7,4,2,3,5,3,0,0.082559055,0.082795276,0.704606299,1,1
1.058959,7,4,2,3,5,3,0,0.082952756,0.083188976,0.704212598,1,1
1.064044,7,4,2,3,5,3,0,0.083346457,0.083582677,0.703818898,1,1
1.069130,7,4,2,3,5,3,0,0.083740157,0.083976378,0.703425197,1,1
1.074215,7,4,2,3,5,3,0,0.084133858,0.084370079,0.703031496,1,1
1.079304,7,4,2,3,5,3,0,0.084606299,0.084842520,0.702559055,1,1
1.084392,7,4,2,3,5,3,0,0.084921260,0.085157480,0.702244094,1,1
1.089485,7,4,2,3,5,3,0,0.085314961,0.085551181,0.701850394,1,1
1.094572,7,4,2,3,5,3,0,0.085787402,0.086023622,0.701377953,1,1
1.099666,7,4,2,3,5,3,0,0.086181102,0.086417323,0.700984252,1,1
1.104758,7,4,2,3,5,3,0,0.086496063,0.086732283,0.700669291,1,1
1.109862,7,4,2,3,5,3,0,0.086968504,0.087204724,0.700196850,1,1
1.114949,7,4,2,3,5,3,0,0.087362205,0.087598425,0.699803150,1,1
1.120034,7,4,2,3,5,3,0,0.087755906,0.087992126,0.699409449,1,1
1.125122,7,4,2,3,5,3,0,0.088228346,0.088464567,0.698937008,1,1
1.130212,7,4,2,3,5,3,0,0.088543307,0.088779528,0.698622047,1,1
1.135298,7,4,2,3,5,3,0,0.088937008,0.089173228,0.698228346,1,1
1.140390,7,4,2,3,5,3,0,0.089409449,0.089645669,0.697755906,1,1
1.145477,7,4,2,3,5,3,0,0.089803150,0.090039370,0.697362205,1,1
1.150562,7,4,2,3,5,3,0,0.090118110,0.090354331,0.697047244,1,1
1.155648,7,4,2,3,5,3,0,0.090590551,0.090826772,0.696574803,1,1
1.160733,7,4,2,3,5,3,0,0.090984252,0.091220472,0.696181102,1,1
1.165818,7,4,2,3,5,3,0,0.091377953,0.091614173,0.695787402,1,1
1.170905,7,4,2,3,5,3,0,0.091771654,0.092007874,0.695393701,1,1
1.176008,7,4,2,3,5,3,0,0.092165354,0.092401575,0.695000000,1,1
1.181141,7,4,2,3,5,3,0,0.092559055,0.092795276,0.694606299,1,1
1.186273,7,4,2,3,5,3,0,0.093031496,0.093267717,0.694133858,1,1
1.191411,7,4,2,3,5,3,0,0.093425197,0.093661417,0.693740157,1,1
1.196542,7,4,2,3,5,3,0,0.093740157,0.093976378,0.693425197,1,1
1.201676,7,4,2,3,5,3,0,0.094133858,0.094370079,0.693031496,1,1
1.206811,7,4,2,3,5,3,0,0.094606299,0.094842520,0.692559055,1,1
1.211952,7,4,2,3,5,3,0,0.095000000,0.095236220,0.692165354,1,1
1.217103,7,4,2,3,5,3,0,0.095472441,0.095708661,0.691692913,1,1
1.222243,7,4,2,3,5,3,0,0.095787402,0.096023622,0.691377953,1,1
1.227383,7,4,2,3,5,3,0,0.096181102,0.096417323,0.690984252,1,1
1.232528,7,4,2,3,5,3,0,0.096574803,0.096811024,0.690590551,1,1
1.237669,7,4,2,3,5,3,0,0.097047244,0.097283465,0.690118110,1,1
1.242817,7,4,2,3,5,3,0,0.097440945,0.097677165,0.689724409,1,1
1.247949,7,4,2,3,5,3,0,0.097755906,0.097992126,0.689409449,1,1
1.253081,7,4,2,3,5,3,0,0.098228346,0.098464567,0.688937008,1,1
1.258221,7,4,2,3,5,3,0,0.098622047,0.098858268,0.688543307,1,1
1.263361,7,4,2,3,5,3,0,0.099015748,0.099251969,0.688149606,1,1
1.268500,7,4,2,3,5,3,0,0.099488189,0.099724409,0.687677165,1,1
1.273640,7,4,2,3,5,3,0,0.099881890,0.100118110,0.687283465,1,1
1.278783,7,4,2,3,5,3,0,0.100196850,0.100433071,0.686968504,1,1
1.283926,7,4,2,3,5,3,0,0.100669291,0.100905512,0.686496063,1,1
1.289062,7,4,2,3,5,3,0,0.101062992,0.101299213,0.686102362,1,1
1.294200,7,4,2,3,5,3,0,0.101456693,0.101692913,0.685708661,1,1
1.299339,7,4,2,3,5,3,0,0.101929134,0.102165354,0.685236220,1,1
1.304486,7,4,2,3,5,3,0,0.102244094,0.102480315,0.684921260,1,1
1.309630,7,4,2,3,5,3,0,0.102637795,0.102874016,0.684527559,1,1
1.314775,7,4,2,3,5,3,0,0.103110236,0.103346457,0.684055118,1,1
1.319940,7,4,2,3,5,3,0,0.103503937,0.103740157,0.683661417,1,1
1.325079,7,4,2,3,5,3,0,0.103897638,0.104133858,0.683267717,1,1
1.330219,7,4,2,3,5,3,0,0.104370079,0.104606299,0.682795276,1,1
1.335360,7,4,2,3,5,3,0,0.104685039,0.104921260,0.682480315,1,1
1.340499,7,4,2,3,5,3,0,0.105078740,0.105314961,0.682086614,1,1
1.345640,7,4,2,3,5,3,0,0.105551181,0.105787402,0.681614173,1,1
1.350780,7,4,2,3,5,3,0,0.105944882,0.106181102,0.681220472,1,1
1.355919,7,4,2,3,5,3,0,0.106338583,0.106574803,0.680826772,1,1
1.361061,7,4,2,3,5,3,0,0.106732283,0.106968504,0.680433071,1,1
1.366194,7,4,2,3,5,3,0,0.107125984,0.107362205,0.680039370,1,1
1.371339,7,4,2,3,5,3,0,0.107519685,0.107755906,0.679645669,1,1
1.376475,7,4,2,3,5,3,0,0.107992126,0.108228346,0.679173228,1,1
1.381618,7,4,2,3,5,3,0,0.108385827,0.108622047,0.678779528,1,1
1.386758,7,4,2,3,5,3,0,0.108700787,0.108937008,0.678464567,1,1
1.391906,7,4,2,3,5,3,0,0.109173228,0.109409449,0.677992126,1,1
1.397042,7,4,2,3,5,3,0,0.109566929,0.109803150,0.677598425,1,1
1.402196,7,4,2,3,5,3,0,0.109960630,0.110196850,0.677204724,1,1
1.407258,7,4,2,3,5,3,0,0.110433071,0.110669291,0.676732283,1,1
1.412350,7,4,2,3,5,3,0,0.110748031,0.110984252,0.676417323,1,1
1.417435,7,4,2,3,5,3,0,0.111141732,0.111377953,0.676023622,1,1
1.422521,7,4,2,3,5,3,0,0.111614173,0.111850394,0.675551181,1,1
1.427606,7,4,2,3,5,3,0,0.112007874,0.112244094,0.675157480,1,1
1.432691,7,4,2,3,5,3,0,0.112322835,0.112559055,0.674842520,1,1
1.437783,7,4,2,3,5,3,0,0.112795276,0.113031496,0.674370079,1,1
1.442867,7,4,2,3,5,3,0,0.113188976,0.113425197,0.673976378,1,1
1.447960,7,4,2,3,5,3,0,0.113582677,0.113818898,0.673582677,1,1
1.453055,7,4,2,3,5,3,0,0.113897638,0.114133858,0.673267717,1,1
1.458150,7,4,2,3,5,3,0,0.114370079,0.114606299,0.672795276,1,1
1.463238,7,4,2,3,5,3,0,0.114763780,0.115000000,0.672401575,1,1
1.468325,7,4,2,3,5,3,0,0.115236220,0.115472441,0.671929134,1,1
1.473412,7,4,2,3,5,3,0,0.115629921,0.115866142,0.671535433,1,1
1.478502,7,4,2,3,5,3,0,0.115944882,0.116181102,0.671220472,1,1
1.483589,7,4,2,3,5,3,0,0.116338583,0.116574803,0.670826772,1,1
1.488674,7,4,2,3,5,3,0,0.116811024,0.117047244,0.670354331,1,1
1.493760,7,4,2,3,5,3,0,0.117204724,0.117440945,0.669960630,1,1
1.498846,7,4,2,3,5,3,0,0.117519685,0.117755906,0.669645669,1,1
1.503939,7,4,2,3,5,3,0,0.117992126,0.118228346,0.669173228,1,1
1.509026,7,4,2,3,5,3,0,0.118385827,0.118622047,0.668779528,1,1
1.514113,7,4,2,3,5,3,0,0.118779528,0.119015748,0.668385827,1,1
1.519200,7,4,2,3,5,3,0,0.119173228,0.119409449,0.667992126,1,1
1.524286,7,4,2,3,5,3,0,0.119566929,0.119803150,0.667598425,1,1
1.529373,7,4,2,3,5,3,0,0.119960630,0.120196850,0.667204724,1,1
1.534462,7,4,2,3,5,3,0,0.120433071,0.120669291,0.666732283,1,1
1.539549,7,4,2,3,5,3,0,0.120748031,0.120984252,0.666417323,1,1
1.544638,7,4,2,3,5,3,0,0.121141732,0.121377953,0.666023622,1,1
1.549731,7,4,2,3,5,3,0,0.121614173,0.121850394,0.665551181,1,1
1.554817,7,4,2,3,5,3,0,0.122007874,0.122244094,0.665157480,1,1
1.559915,7,4,2,3,5,3,0,0.122401575,0.122637795,0.664763780,1,1
1.565009,7,4,2,3,5,3,0,0.122795276,0.123031496,0.664370079,1,1
1.570100,7,4,2,3,5,3,0,0.123188976,0.123425197,0.663976378,1,1
1.575187,7,4,2,3,5,3,0,0.123582677,0.123818898,0.663582677,1,1
1.580272,7,4,2,3,5,3,0,0.124055118,0.124291339,0.663110236,1,1
1.585360,7,4,2,3,5,3,0,0.124370079,0.124606299,0.662795276,1,1
1.590448,7,4,2,3,5,3,0,0.124763780,0.125000000,0.662401575,1,1
1.595533,7,4,2,3,5,3,0,0.125236220,0.125472441,0.661929134,1,1
1.600626,7,4,2,3,5,3,0,0.125629921,0.125866142,0.661535433,1,1
1.605714,7,4,2,3,5,3,0,0.125944882,0.126181102,0.661220472,1,1
1.610804,7,4,2,3,5,3,0,0.126417323,0.126653543,0.660748031,1,1
1.615891,7,4,2,3,5,3,0,0.126811024,0.127047244,0.660354331,1,1
1.620979,7,4,2,3,5,3,0,0.127204724,0.127440945,0.659960630,1,1
1.626066,7,4,2,3,5,3,0,0.127598425,0.127834646,0.659566929,1,1
1.631155,7,4,2,3,5,3,0,0.127992126,0.128228346,0.659173228,1,1
1.636245,7,4,2,3,5,3,0,0.128385827,0.128622047,0.658779528,1,1
1.641336,7,4,2,3,5,3,0,0.128858268,0.129094488,0.658307087,1,1
1.646423,7,4,2,3,5,3,0,0.129173228,0.129409449,0.657992126,1,1
1.651517,7,4,2,3,5,3,0,0.129566929,0.129803150,0.657598425,1,1
1.656605,7,4,2,3,5,3,0,0.130039370,0.130275591,0.657125984,1,1
1.661694,7,4,2,3,5,3,0,0.130433071,0.130669291,0.656732283,1,1
1.666788,7,4,2,3,5,3,0,0.130826772,0.131062992,0.656338583,1,1
1.671879,7,4,2,3,5,3,0,0.131220472,0.131456693,0.655944882,1,1
1.676965,7,4,2,3,5,3,0,0.131614173,0.131850394,0.655551181,1,1
1.682051,7,4,2,3,5,3,0,0.132007874,0.132244094,0.655157480,1,1
1.687138,7,4,2,3,5,3,0,0.132480315,0.132716535,0.654685039,1,1
1.692224,7,4,2,3,5,3,0,0.132795276,0.133031496,0.654370079,1,1
1.697315,7,4,2,3,5,3,0,0.133188976,0.133425197,0.653976378,1,1
1.702406,7,4,2,3,5,3,0,0.133661417,0.133897638,0.653503937,1,1
1.707492,7,4,2,3,5,3,0,0.134055118,0.134291339,0.653110236,1,1
1.712578,7,4,2,3,5,3,0,0.134370079,0.134606299,0.652795276,1,1
1.717663,7,4,2,3,5,3,0,0.134842520,0.135078740,0.652322835,1,1
1.722749,7,4,2,3,5,3,0,0.135236220,0.135472441,0.651929134,1,1
1.727836,7,4,2,3,5,3,0,0.135629921,0.135866142,0.651535433,1,1
1.732925,7,4,2,3,5,3,0,0.135944882,0.136181102,0.651220472,1,1
1.738009,7,4,2,3,5,3,0,0.136417323,0.136653543,0.650748031,1,1
1.743094,7,4,2,3,5,3,0,0.136811024,0.137047244,0.650354331,1,1
1.748181,7,4,2,3,5,3,0,0.137204724,0.137440945,0.649960630,1,1
1.753274,7,4,2,3,5,3,0,0.137598425,0.137834646,0.649566929,1,1
1.758364,7,4,2,3,5,3,0,0.137992126,0.138228346,0.649173228,1,1
1.763460,7,4,2,3,5,3,0,0.138385827,0.138622047,0.648779528,1,1
1.768547,7,4,2,3,5,3,0,0.138858268,0.139094488,0.648307087,1,1
1.773641,7,4,2,3,5,3,0,0.139251969,0.139488189,0.647913386,1,1
1.778728,7,4,2,3,5,3,0,0.139566929,0.139803150,0.647598425,1,1
1.783812,7,4,2,3,5,3,0,0.140039370,0.140275591,0.647125984,1,1
1.788902,7,4,2,3,5,3,0,0.140433071,0.140669291,0.646732283,1,1
1.794001,7,4,2,3,5,3,0,0.140826772,0.141062992,0.646338583,1,1
1.799089,7,4,2,3,5,3,0,0.141220472,0.141456693,0.645944882,1,1
1.804178,7,4,2,3,5,3,0,0.141614173,0.141850394,0.645551181,1,1
1.809264,7,4,2,3,5,3,0,0.142007874,0.142244094,0.645157480,1,1
1.814349,7,4,2,3,5,3,0,0.142480315,0.142716535,0.644685039,1,1
1.819434,7,4,2,3,5,3,0,0.142795276,0.143031496,0.644370079,1,1
1.824524,7,4,2,3,5,3,0,0.143188976,0.143425197,0.643976378,1,1
1.829611,7,4,2,3,5,3,0,0.143661417,0.143897638,0.643503937,1,1
1.834697,7,4,2,3,5,3,0,0.144055118,0.144291339,0.643110236,1,1
1.839782,7,4,2,3,5,3,0,0.144370079,0.144606299,0.642795276,1,1
1.844867,7,4,2,3,5,3,0,0.144842520,0.145078740,0.642322835,1,1
1.849961,7,4,2,3,5,3,0,0.145236220,0.145472441,0.641929134,1,1
1.855058,7,4,2,3,5,3,0,0.145629921,0.145866142,0.641535433,1,1
1.860154,7,4,2,3,5,3,0,0.146023622,0.146259843,0.641141732,1,1
1.865241,7,4,2,3,5,3,0,0.146417323,0.146653543,0.640748031,1,1
1.870332,7,4,2,3,5,3,0,0.146811024,0.147047244,0.640354331,1,1
1.875424,7,4,2,3,5,3,0,0.147283465,0.147519685,0.639881890,1,1
1.880517,7,4,2,3,5,3,0,0.147598425,0.147834646,0.639566929,1,1
1.885613,7,4,2,3,5,3,0,0.147992126,0.148228346,0.639173228,1,1
1.890705,7,4,2,3,5,3,0,0.148464567,0.148700787,0.638700787,1,1
1.895792,7,4,2,3,5,3,0,0.148858268,0.149094488,0.638307087,1,1
1.900878,7,4,2,3,5,3,0,0.149251969,0.149488189,0.637913386,1,1
1.905968,7,4,2,3,5,3,0,0.149645669,0.149881890,0.637519685,1,1
1.911056,7,4,2,3,5,3,0,0.150039370,0.150275591,0.637125984,1,1
1.916143,7,4,2,3,5,3,0,0.150433071,0.150669291,0.636732283,1,1
1.921229,7,4,2,3,5,3,0,0.150905512,0.151141732,0.636259843,1,1
1.926314,7,4,2,3,5,3,0,0.151220472,0.151456693,0.635944882,1,1
1.931400,7,4,2,3,5,3,0,0.151614173,0.151850394,0.635551181,1,1
1.936488,7,4,2,3,5,3,0,0.152086614,0.152322835,0.635078740,1,1
1.941578,7,4,2,3,5,3,0,0.152480315,0.152716535,0.634685039,1,1
1.946664,7,4,2,3,5,3,0,0.152795276,0.153031496,0.634370079,1,1
1.951748,7,4,2,3,5,3,0,0.153267717,0.153503937,0.633897638,1,1
1.956839,7,4,2,3,5,3,0,0.153661417,0.153897638,0.633503937,1,1
1.961924,7,4,2,3,5,3,0,0.154055118,0.154291339,0.633110236,1,1
1.967008,7,4,2,3,5,3,0,0.154448819,0.154685039,0.632716535,1,1
1.972115,7,4,2,3,5,3,0,0.154842520,0.155078740,0.632322835,1,1
1.977202,7,4,2,3,5,3,0,0.155236220,0.155472441,0.631929134,1,1
1.982287,7,4,2,3,5,3,0,0.155708661,0.155944882,0.631456693,1,1
1.987382,7,4,2,3,5,3,0,0.156102362,0.156338583,0.631062992,1,1
1.992473,7,4,2,3,5,3,0,0.156417323,0.156653543,0.630748031,1,1
1.997560,7,4,2,3,5,3,0,0.156889764,0.157125984,0.630275591,1,1
2.002648,7,4,2,3,5,3,0,0.157283465,0.157519685,0.629881890,1,1
2.007739,7,4,2,3,5,3,0,0.157677165,0.157913386,0.629488189,1,1
2.012825,7,4,2,3,5,3,0,0.157992126,0.158228346,0.629173228,1,1
2.017915,7,4,2,3,5,3,0,0.158464567,0.158700787,0.628700787,1,1
2.022999,7,4,2,3,5,3,0,0.158858268,0.159094488,0.628307087,1,1
2.028084,7,4,2,3,5,3,0,0.159251969,0.159488189,0.627913386,1,1
2.033173,7,4,2,3,5,3,0,0.159645669,0.159881890,0.627519685,1,1
2.038257,7,4,2,3,5,3,0,0.160039370,0.160275591,0.627125984,1,1
2.043341,7,4,2,3,5,3,0,0.160433071,0.160669291,0.626732283,1,1
2.048425,7,4,2,3,5,3,0,0.160905512,0.161141732,0.626259843,1,1
2.053510,7,4,2,3,5,3,0,0.161220472,0.161456693,0.625944882,1,1
2.058613,7,4,2,3,5,3,0,0.161614173,0.161850394,0.625551181,1,1
2.063699,7,4,2,3,5,3,0,0.162086614,0.162322835,0.625078740,1,1
2.068784,7,4,2,3,5,3,0,0.162480315,0.162716535,0.624685039,1,1
2.073868,7,4,2,3,5,3,0,0.162874016,0.163110236,0.624291339,1,1
2.078954,7,4,2,3,5,3,0,0.163267717,0.163503937,0.623897638,1,1
2.084043,7,4,2,3,5,3,0,0.163661417,0.163897638,0.623503937,1,1
2.089128,7,4,2,3,5,3,0,0.164055118,0.164291339,0.623110236,1,1
2.094212,7,4,2,3,5,3,0,0.164527559,0.164763780,0.622637795,1,1
2.099297,7,4,2,3,5,3,0,0.164842520,0.165078740,0.622322835,1,1
2.104383,7,4,2,3,5,3,0,0.165236220,0.165472441,0.621929134,1,1
2.109474,7,4,2,3,5,3,0,0.165708661,0.165944882,0.621456693,1,1
2.114560,7,4,2,3,5,3,0,0.166102362,0.166338583,0.621062992,1,1
2.119646,7,4,2,3,5,3,0,0.166417323,0.166653543,0.620748031,1,1
2.124731,7,4,2,3,5,3,0,0.166889764,0.167125984,0.620275591,1,1
2.129818,7,4,2,3,5,3,0,0.167283465,0.167519685,0.619881890,1,1
2.134903,7,4,2,3,5,3,0,0.167677165,0.167913386,0.619488189,1,1
2.139992,7,4,2,3,5,3,0,0.167992126,0.168228346,0.619173228,1,1
2.145087,7,4,2,3,5,3,0,0.168464567,0.168700787,0.618700787,1,1
2.150177,7,4,2,3,5,3,0,0.168858268,0.169094488,0.618307087,1,1
2.155261,7,4,2,3,5,3,0,0.169251969,0.169488189,0.617913386,1,1
2.160351,7,4,2,3,5,3,0,0.169724409,0.169960630,0.617440945,1,1
2.165436,7,4,2,3,5,3,0,0.170039370,0.170275591,0.617125984,1,1
2.170521,7,4,2,3,5,3,0,0.170433071,0.170669291,0.616732283,1,1
2.175605,7,4,2,3,5,3,0,0.170905512,0.171141732,0.616259843,1,1
2.180689,7,4,2,3,5,3,0,0.171299213,0.171535433,0.615866142,1,1
2.185774,7,4,2,3,5,3,0,0.171614173,0.171850394,0.615551181,1,1
2.190860,7,4,2,3,5,3,0,0.172086614,0.172322835,0.615078740,1,1
2.195946,7,4,2,3,5,3,0,0.172480315,0.172716535,0.614685039,1,1
2.201032,7,4,2,3,5,3,0,0.172874016,0.173110236,0.614291339,1,1
2.206118,7,4,2,3,5,3,0,0.173267717,0.173503937,0.613897638,1,1
2.211210,7,4,2,3,5,3,0,0.173661417,0.173897638,0.613503937,1,1
2.216303,7,4,2,3,5,3,0,0.174055118,0.174291339,0.613110236,1,1
2.221388,7,4,2,3,5,3,0,0.174527559,0.174763780,0.612637795,1,1
2.226473,7,4,2,3,5,3,0,0.174842520,0.175078740,0.612322835,1,1
2.231556,7,4,2,3,5,3,0,0.175236220,0.175472441,0.611929134,1,1
2.236641,7,4,2,3,5,3,0,0.175708661,0.175944882,0.611456693,1,1
2.241725,7,4,2,3,5,3,0,0.176102362,0.176338583,0.611062992,1,1
2.246810,7,4,2,3,5,3,0,0.176417323,0.176653543,0.610748031,1,1
2.251907,7,4,2,3,5,3,0,0.176889764,0.177125984,0.610275591,1,1
2.256994,7,4,2,3,5,3,0,0.177283465,0.177519685,0.609881890,1,1
2.262084,7,4,2,3,5,3,0,0.177677165,0.177913386,0.609488189,1,1
2.267173,7,4,2,3,5,3,0,0.178149606,0.178385827,0.609015748,1,1
2.272259,7,4,2,3,5,3,0,0.178464567,0.178700787,0.608700787,1,1
2.277343,7,4,2,3,5,3,0,0.178858268,0.179094488,0.608307087,1,1
2.282433,7,4,2,3,5,3,0,0.179330709,0.179566929,0.607834646,1,1
2.287518,7,4,2,3,5,3,0,0.179724409,0.179960630,0.607440945,1,1
2.292603,7,4,2,3,5,3,0,0.180039370,0.180275591,0.607125984,1,1
2.297688,7,4,2,3,5,3,0,0.180511811,0.180748031,0.606653543,1,1
2.302773,7,4,2,3,5,3,0,0.180905512,0.181141732,0.606259843,1,1
2.307859,7,4,2,3,5,3,0,0.181299213,0.181535433,0.605866142,1,1
2.312959,7,4,2,3,5,3,0,0.181692913,0.181929134,0.605472441,1,1
2.318045,7,4,2,3,5,3,0,0.182086614,0.182322835,0.605078740,1,1
2.323136,7,4,2,3,5,3,0,0.182480315,0.182716535,0.604685039,1,1
2.328230,7,4,2,3,5,3,0,0.182952756,0.183188976,0.604212598,1,1
2.333320,7,4,2,3,5,3,0,0.183267717,0.183503937,0.603897638,1,1
2.338408,7,4,2,3,5,3,0,0.183661417,0.183897638,0.603503937,1,1
2.343502,7,4,2,3,5,3,0,0.184133858,0.184370079,0.603031496,1,1
2.348617,7,4,2,3,5,3,0,0.184527559,0.184763780,0.602637795,1,1
2.353738,7,4,2,3,5,3,0,0.184921260,0.185157480,0.602244094,1,1
2.358875,7,4,2,3,5,3,0,0.185314961,0.185551181,0.601850394,1,1
2.364017,7,4,2,3,5,3,0,0.185708661,0.185944882,0.601456693,1,1
2.369156,7,4,2,3,5,3,0,0.186102362,0.186338583,0.601062992,1,1
2.374236,7,4,2,3,5,3,0,0.186574803,0.186811024,0.600590551,1,1
2.379338,7,4,2,3,5,3,0,0.186889764,0.187125984,0.600275591,1,1
2.384427,7,4,2,3,5,3,0,0.187283465,0.187519685,0.599881890,1,1
2.389518,7,4,2,3,5,3,0,0.187755906,0.187992126,0.599409449,1,1
2.394606,7,4,2,3,5,3,0,0.188070866,0.188307087,0.599094488,1,1
2.399695,7,4,2,3,5,3,0,0.188464567,0.188700787,0.598700787,1,1
2.404782,7,4,2,3,5,3,0,0.188937008,0.189173228,0.598228346,1,1
2.409875,7,4,2,3,5,3,0,0.189330709,0.189566929,0.597834646,1,1
2.414979,7,4,2,3,5,3,0,0.189724409,0.189960630,0.597440945,1,1
2.420076,7,4,2,3,5,3,0,0.190118110,0.190354331,0.597047244,1,1
2.425163,7,4,2,3,5,3,0,0.190511811,0.190748031,0.596653543,1,1
2.430251,7,4,2,3,5,3,0,0.190905512,0.191141732,0.596259843,1,1
2.435338,7,4,2,3,5,3,0,0.191377953,0.191614173,0.595787402,1,1
2.440428,7,4,2,3,5,3,0,0.191692913,0.191929134,0.595472441,1,1
2.445514,7,4,2,3,5,3,0,0.192086614,0.192322835,0.595078740,1,1
2.450599,7,4,2,3,5,3,0,0.192559055,0.192795276,0.594606299,1,1
2.455684,7,4,2,3,5,3,0,0.192952756,0.193188976,0.594212598,1,1
2.460769,7,4,2,3,5,3,0,0.193267717,0.193503937,0.593897638,1,1
2.465859,7,4,2,3,5,3,0,0.193740157,0.193976378,0.593425197,1,1
2.470947,7,4,2,3,5,3,0,0.194133858,0.194370079,0.593031496,1,1
2.476052,7,4,2,3,5,3,0,0.194527559,0.194763780,0.592637795,1,1
2.481140,7,4,2,3,5,3,0,0.195000000,0.195236220,0.592165354,1,1
2.486229,7,4,2,3,5,3,0,0.195314961,0.195551181,0.591850394,1,1
2.491314,7,4,2,3,5,3,0,0.195708661,0.195944882,0.591456693,1,1
2.496399,7,4,2,3,5,3,0,0.196102362,0.196338583,0.591062992,1,1
2.501484,7,4,2,3,5,3,0,0.196574803,0.196811024,0.590590551,1,1
2.506593,7,4,2,3,5,3,0,0.196889764,0.197125984,0.590275591,1,1
2.511705,7,4,2,3,5,3,0,0.197283465,0.197519685,0.589881890,1,1
2.516810,7,4,2,3,5,3,0,0.197755906,0.197992126,0.589409449,1,1
2.521906,7,4,2,3,5,3,0,0.198149606,0.198385827,0.589015748,1,1
2.527000,7,4,2,3,5,3,0,0.198543307,0.198779528,0.588622047,1,1
2.532091,7,4,2,3,5,3,0,0.198937008,0.199173228,0.588228346,1,1
2.537213,7,4,2,3,5,3,0,0.199330709,0.199566929,0.587834646,1,1
2.542359,7,4,2,3,5,3,0,0.199724409,0.199960630,0.587440945,1,1
2.547508,7,4,2,3,5,3,0,0.200196850,0.200433071,0.586968504,1,1
2.552650,7,4,2,3,5,3,0,0.200590551,0.200826772,0.586574803,1,1
2.557782,7,4,2,3,5,3,0,0.200905512,0.201141732,0.586259843,1,1
2.562916,7,4,2,3,5,3,0,0.201377953,0.201614173,0.585787402,1,1
2.568062,7,4,2,3,5,3,0,0.201771654,0.202007874,0.585393701,1,1
2.573202,7,4,2,3,5,3,0,0.202165354,0.202401575,0.585000000,1,1
2.578343,7,4,2,3,5,3,0,0.202637795,0.202874016,0.584527559,1,1
2.583483,7,4,2,3,5,3,0,0.203031496,0.203267717,0.584133858,1,1
2.588624,7,4,2,3,5,3,0,0.203346457,0.203582677,0.583818898,1,1
2.593765,7,4,2,3,5,3,0,0.203818898,0.204055118,0.583346457,1,1
2.598906,7,4,2,3,5,3,0,0.204212598,0.204448819,0.582952756,1,1
2.604057,7,4,2,3,5,3,0,0.204606299,0.204842520,0.582559055,1,1
2.609197,7,4,2,3,5,3,0,0.205078740,0.205314961,0.582086614,1,1
2.614339,7,4,2,3,5,3,0,0.205393701,0.205629921,0.581771654,1,1
2.619458,7,4,2,3,5,3,0,0.205787402,0.206023622,0.581377953,1,1
2.624579,7,4,2,3,5,3,0,0.206259843,0.206496063,0.580905512,1,1
2.629673,7,4,2,3,5,3,0,0.206653543,0.206889764,0.580511811,1,1
2.634771,7,4,2,3,5,3,0,0.207047244,0.207283465,0.580118110,1,1
2.639877,7,4,2,3,5,3,0,0.207362205,0.207598425,0.579803150,1,1
2.644984,7,4,2,3,5,3,0,0.207834646,0.208070866,0.579330709,1,1
2.650080,7,4,2,3,5,3,0,0.208228346,0.208464567,0.578937008,1,1
2.655168,7,4,2,3,5,3,0,0.208622047,0.208858268,0.578543307,1,1
2.660256,7,4,2,3,5,3,0,0.209094488,0.209330709,0.578070866,1,1
2.665344,7,4,2,3,5,3,0,0.209409449,0.209645669,0.577755906,1,1
2.670440,7,4,2,3,5,3,0,0.209803150,0.210039370,0.577362205,1,1
2.675529,7,4,2,3,5,3,0,0.210275591,0.210511811,0.576889764,1,1
2.680614,7,4,2,3,5,3,0,0.210669291,0.210905512,0.576496063,1,1
2.685703,7,4,2,3,5,3,0,0.210984252,0.211220472,0.576181102,1,1
2.690791,7,4,2,3,5,3,0,0.211456693,0.211692913,0.575708661,1,1
2.695879,7,4,2,3,5,3,0,0.211850394,0.212086614,0.575314961,1,1
2.700970,7,4,2,3,5,3,0,0.212244094,0.212480315,0.574921260,1,1
2.706068,7,4,2,3,5,3,0,0.212637795,0.212874016,0.574527559,1,1
2.711155,7,4,2,3,5,3,0,0.213031496,0.213267717,0.574133858,1,1
2.716242,7,4,2,3,5,3,0,0.213425197,0.213661417,0.573740157,1,1
2.721332,7,4,2,3,5,3,0,0.213897638,0.214133858,0.573267717,1,1
2.726423,7,4,2,3,5,3,0,0.214212598,0.214448819,0.572952756,1,1
2.731516,7,4,2,3,5,3,0,0.214606299,0.214842520,0.572559055,1,1
2.736608,7,4,2,3,5,3,0,0.215078740,0.215314961,0.572086614,1,1
2.741695,7,4,2,3,5,3,0,0.215472441,0.215708661,0.571692913,1,1
2.746783,7,4,2,3,5,3,0,0.215787402,0.216023622,0.571377953,1,1
2.751874,7,4,2,3,5,3,0,0.216259843,0.216496063,0.570905512,1,1
2.756963,7,4,2,3,5,3,0,0.216653543,0.216889764,0.570511811,1,1
2.762063,7,4,2,3,5,3,0,0.217047244,0.217283465,0.570118110,1,1
2.767150,7,4,2,3,5,3,0,0.217519685,0.217755906,0.569645669,1,1
2.772242,7,4,2,3,5,3,0,0.217834646,0.218070866,0.569330709,1,1
2.777329,7,4,2,3,5,3,0,0.218228346,0.218464567,0.568937008,1,1
2.782418,7,4,2,3,5,3,0,0.218700787,0.218937008,0.568464567,1,1
2.787510,7,4,2,3,5,3,0,0.219094488,0.219330709,0.568070866,1,1
2.792600,7,4,2,3,5,3,0,0.219409449,0.219645669,0.567755906,1,1
2.797688,7,4,2,3,5,3,0,0.219803150,0.220039370,0.567362205,1,1
2.802785,7,4,2,3,5,3,0,0.220275591,0.220511811,0.566889764,1,1
2.807870,7,4,2,3,5,3,0,0.220669291,0.220905512,0.566496063,1,1
2.812959,7,4,2,3,5,3,0,0.220984252,0.221220472,0.566181102,1,1
2.818061,7,4,2,3,5,3,0,0.221456693,0.221692913,0.565708661,1,1
2.823154,7,4,2,3,5,3,0,0.221850394,0.222086614,0.565314961,1,1
2.828238,7,4,2,3,5,3,0,0.222244094,0.222480315,0.564921260,1,1
2.833326,7,4,2,3,5,3,0,0.222716535,0.222952756,0.564448819,1,1
2.838411,7,4,2,3,5,3,0,0.223031496,0.223267717,0.564133858,1,1
2.843496,7,4,2,3,5,3,0,0.223425197,0.223661417,0.563740157,1,1
2.848582,7,4,2,3,5,3,0,0.223897638,0.224133858,0.563267717,1,1
2.853667,7,4,2,3,5,3,0,0.224291339,0.224527559,0.562874016,1,1
2.858752,7,4,2,3,5,3,0,0.224606299,0.224842520,0.562559055,1,1
2.863845,7,4,2,3,5,3,0,0.225078740,0.225314961,0.562086614,1,1
2.868936,7,4,2,3,5,3,0,0.225472441,0.225708661,0.561692913,1,1
2.874024,7,4,2,3,5,3,0,0.225866142,0.226102362,0.561299213,1,1
2.879110,7,4,2,3,5,3,0,0.226259843,0.226496063,0.560905512,1,1
2.884196,7,4,2,3,5,3,0,0.226653543,0.226889764,0.560511811,1,1
2.889281,7,4,2,3,5,3,0,0.227047244,0.227283465,0.560118110,1,1
2.894366,7,4,2,3,5,3,0,0.227519685,0.227755906,0.559645669,1,1
2.899452,7,4,2,3,5,3,0,0.227834646,0.228070866,0.559330709,1,1
2.904536,7,4,2,3,5,3,0,0.228228346,0.228464567,0.558937008,1,1
2.909624,7,4,2,3,5,3,0,0.228700787,0.228937008,0.558464567,1,1
2.914713,7,4,2,3,5,3,0,0.229094488,0.229330709,0.558070866,1,1
2.919801,7,4,2,3,5,3,0,0.229488189,0.229724409,0.557677165,1,1
2.924893,7,4,2,3,5,3,0,0.229881890,0.230118110,0.557283465,1,1
2.929989,7,4,2,3,5,3,0,0.230275591,0.230511811,0.556889764,1,1
2.935080,7,4,2,3,5,3,0,0.230669291,0.230905512,0.556496063,1,1
2.940167,7,4,2,3,5,3,0,0.231141732,0.231377953,0.556023622,1,1
2.945252,7,4,2,3,5,3,0,0.231456693,0.231692913,0.555708661,1,1
2.950338,7,4,2,3,5,3,0,0.231850394,0.232086614,0.555314961,1,1
2.955427,7,4,2,3,5,3,0,0.232322835,0.232559055,0.554842520,1,1
2.960519,7,4,2,3,5,3,0,0.232716535,0.232952756,0.554448819,1,1
2.965605,7,4,2,3,5,3,0,0.233031496,0.233267717,0.554133858,1,1
2.970691,7,4,2,3,5,3,0,0.233503937,0.233740157,0.553661417,1,1
2.975787,7,4,2,3,5,3,0,0.233897638,0.234133858,0.553267717,1,1
2.980875,7,4,2,3,5,3,0,0.234291339,0.234527559,0.552874016,1,1
2.985963,7,4,2,3,5,3,0,0.234606299,0.234842520,0.552559055,1,1
2.991063,7,4,2,3,5,3,0,0.235078740,0.235314961,0.552086614,1,1
2.996154,7,4,2,3,5,3,0,0.235472441,0.235708661,0.551692913,1,1
3.001242,7,4,2,3,5,3,0,0.235866142,0.236102362,0.551299213,1,1
3.006330,7,4,2,3,5,3,0,0.236338583,0.236574803,0.550826772,1,1
3.011424,7,4,2,3,5,3,0,0.236653543,0.236889764,0.550511811,1,1
3.016518,7,4,2,3,5,3,0,0.237047244,0.237283465,0.550118110,1,1
3.021607,7,4,2,3,5,3,0,0.237519685,0.237755906,0.549645669,1,1
3.026705,7,4,2,3,5,3,0,0.237913386,0.238149606,0.549251969,1,1
3.031798,7,4,2,3,5,3,0,0.238228346,0.238464567,0.548937008,1,1
3.036892,7,4,2,3,5,3,0,0.238700787,0.238937008,0.548464567,1,1
3.041988,7,4,2,3,5,3,0,0.239094488,0.239330709,0.548070866,1,1
3.047085,7,4,2,3,5,3,0,0.239488189,0.239724409,0.547677165,1,1
3.052177,7,4,2,3,5,3,0,0.239881890,0.240118110,0.547283465,1,1
3.057266,7,4,2,3,5,3,0,0.240275591,0.240511811,0.546889764,1,1
3.062359,7,4,2,3,5,3,0,0.240669291,0.240905512,0.546496063,1,1
3.067445,7,4,2,3,5,3,0,0.241141732,0.241377953,0.546023622,1,1
3.072532,7,4,2,3,5,3,0,0.241535433,0.241771654,0.545629921,1,1
3.077623,7,4,2,3,5,3,0,0.241850394,0.242086614,0.545314961,1,1
3.082709,7,4,2,3,5,3,0,0.242322835,0.242559055,0.544842520,1,1
3.087794,7,4,2,3,5,3,0,0.242716535,0.242952756,0.544448819,1,1
3.092889,7,4,2,3,5,3,0,0.243110236,0.243346457,0.544055118,1,1
3.097995,7,4,2,3,5,3,0,0.243425197,0.243661417,0.543740157,1,1
3.103087,7,4,2,3,5,3,0,0.243897638,0.244133858,0.543267717,1,1
3.108173,7,4,2,3,5,3,0,0.244291339,0.244527559,0.542874016,1,1
3.113262,7,4,2,3,5,3,0,0.244685039,0.244921260,0.542480315,1,1
3.118350,7,4,2,3,5,3,0,0.245157480,0.245393701,0.542007874,1,1
3.123443,7,4,2,3,5,3,0,0.245472441,0.245708661,0.541692913,1,1
3.128530,7,4,2,3,5,3,0,0.245866142,0.246102362,0.541299213,1,1
3.133615,7,4,2,3,5,3,0,0.246338583,0.246574803,0.540826772,1,1
3.138701,7,4,2,3,5,3,0,0.246732283,0.246968504,0.540433071,1,1
3.143786,7,4,2,3,5,3,0,0.247047244,0.247283465,0.540118110,1,1
3.148874,7,4,2,3,5,3,0,0.247519685,0.247755906,0.539645669,1,1
3.153963,7,4,2,3,5,3,0,0.247913386,0.248149606,0.539251969,1,1
3.159062,7,4,2,3,5,3,0,0.248307087,0.248543307,0.538858268,1,1
3.164146,7,4,2,3,5,3,0,0.248779528,0.249015748,0.538385827,1,1
3.169232,7,4,2,3,5,3,0,0.249094488,0.249330709,0.538070866,1,1
3.174316,7,4,2,3,5,3,0,0.249488189,0.249724409,0.537677165,1,1
3.179407,7,4,2,3,5,3,0,0.249960630,0.250196850,0.537204724,1,1
3.184492,7,4,2,3,5,3,0,0.250354331,0.250590551,0.536811024,1,1
3.189580,7,4,2,3,5,3,0,0.250669291,0.250905512,0.536496063,1,1
3.194666,7,4,2,3,5,3,0,0.251141732,0.251377953,0.536023622,1,1
3.199751,7,4,2,3,5,3,0,0.251535433,0.251771654,0.535629921,1,1
3.204835,7,4,2,3,5,3,0,0.251929134,0.252165354,0.535236220,1,1
3.209921,7,4,2,3,5,3,0,0.252322835,0.252559055,0.534842520,1,1
3.215005,7,4,2,3,5,3,0,0.252716535,0.252952756,0.534448819,1,1
3.220095,7,4,2,3,5,3,0,0.253110236,0.253346457,0.534055118,1,1
3.225181,7,4,2,3,5,3,0,0.253582677,0.253818898,0.533582677,1,1
3.230272,7,4,2,3,5,3,0,0.253897638,0.254133858,0.533267717,1,1
3.235358,7,4,2,3,5,3,0,0.254291339,0.254527559,0.532874016,1,1
3.240445,7,4,2,3,5,3,0,0.254685039,0.254921260,0.532480315,1,1
3.245532,7,4,2,3,5,3,0,0.255157480,0.255393701,0.532007874,1,1
3.250618,7,4,2,3,5,3,0,0.255472441,0.255708661,0.531692913,1,1
3.255707,7,4,2,3,5,3,0,0.255866142,0.256102362,0.531299213,1,1
3.260793,7,4,2,3,5,3,0,0.256338583,0.256574803,0.530826772,1,1
3.265877,7,4,2,3,5,3,0,0.256732283,0.256968504,0.530433071,1,1
3.270961,7,4,2,3,5,3,0,0.257125984,0.257362205,0.530039370,1,1
3.276085,7,4,2,3,5,3,0,0.257519685,0.257755906,0.529645669,1,1
3.281176,7,4,2,3,5,3,0,0.257913386,0.258149606,0.529251969,1,1
3.286261,7,4,2,3,5,3,0,0.258307087,0.258543307,0.528858268,1,1
3.291351,7,4,2,3,5,3,0,0.258779528,0.259015748,0.528385827,1,1
3.296439,7,4,2,3,5,3,0,0.259094488,0.259330709,0.528070866,1,1
3.301526,7,4,2,3,5,3,0,0.259488189,0.259724409,0.527677165,1,1
3.306613,7,4,2,3,5,3,0,0.259960630,0.260196850,0.527204724,1,1
3.311700,7,4,2,3,5,3,0,0.260354331,0.260590551,0.526811024,1,1
3.316792,7,4,2,3,5,3,0,0.260669291,0.260905512,0.526496063,1,1
3.321878,7,4,2,3,5,3,0,0.261141732,0.261377953,0.526023622,1,1
3.326974,7,4,2,3,5,3,0,0.261535433,0.261771654,0.525629921,1,1
3.332073,7,4,2,3,5,3,0,0.261929134,0.262165354,0.525236220,1,1
3.337160,7,4,2,3,5,3,0,0.262401575,0.262637795,0.524763780,1,1
3.342245,7,4,2,3,5,3,0,0.262716535,0.262952756,0.524448819,1,1
3.347330,7,4,2,3,5,3,0,0.263110236,0.263346457,0.524055118,1,1
3.352416,7,4,2,3,5,3,0,0.263582677,0.263818898,0.523582677,1,1
3.357503,7,4,2,3,5,3,0,0.263976378,0.264212598,0.523188976,1,1
3.362589,7,4,2,3,5,3,0,0.264291339,0.264527559,0.522874016,1,1
3.367677,7,4,2,3,5,3,0,0.264763780,0.265000000,0.522401575,1,1
3.372763,7,4,2,3,5,3,0,0.265157480,0.265393701,0.522007874,1,1
3.377848,7,4,2,3,5,3,0,0.265551181,0.265787402,0.521614173,1,1
3.382940,7,4,2,3,5,3,0,0.265866142,0.266102362,0.521299213,1,1
3.388027,7,4,2,3,5,3,0,0.266338583,0.266574803,0.520826772,1,1
3.393113,7,4,2,3,5,3,0,0.266732283,0.266968504,0.520433071,1,1
3.398197,7,4,2,3,5,3,0,0.267125984,0.267362205,0.520039370,1,1
3.403282,7,4,2,3,5,3,0,0.267519685,0.267755906,0.519645669,1,1
3.408367,7,4,2,3,5,3,0,0.267913386,0.268149606,0.519251969,1,1
3.413452,7,4,2,3,5,3,0,0.268307087,0.268543307,0.518858268,1,1
3.418537,7,4,2,3,5,3,0,0.268779528,0.269015748,0.518385827,1,1
3.423622,7,4,2,3,5,3,0,0.269173228,0.269409449,0.517992126,1,1
3.428708,7,4,2,3,5,3,0,0.269488189,0.269724409,0.517677165,1,1
3.433797,7,4,2,3,5,3,0,0.269960630,0.270196850,0.517204724,1,1
3.438887,7,4,2,3,5,3,0,0.270354331,0.270590551,0.516811024,1,1
3.443984,7,4,2,3,5,3,0,0.270748031,0.270984252,0.516417323,1,1
3.449080,7,4,2,3,5,3,0,0.271141732,0.271377953,0.516023622,1,1
3.454168,7,4,2,3,5,3,0,0.271535433,0.271771654,0.515629921,1,1
3.459255,7,4,2,3,5,3,0,0.271929134,0.272165354,0.515236220,1,1
3.464345,7,4,2,3,5,3,0,0.272401575,0.272637795,0.514763780,1,1
3.469434,7,4,2,3,5,3,0,0.272716535,0.272952756,0.514448819,1,1
3.474521,7,4,2,3,5,3,0,0.273110236,0.273346457,0.514055118,1,1
3.479609,7,4,2,3,5,3,0,0.273582677,0.273818898,0.513582677,1,1
3.484700,7,4,2,3,5,3,0,0.273976378,0.274212598,0.513188976,1,1
3.489789,7,4,2,3,5,3,0,0.274291339,0.274527559,0.512874016,1,1
3.494876,7,4,2,3,5,3,0,0.274763780,0.275000000,0.512401575,1,1
3.499982,7,4,2,3,5,3,0,0.275157480,0.275393701,0.512007874,1,1
3.505078,7,4,2,3,5,3,0,0.275551181,0.275787402,0.511614173,1,1
3.510167,7,4,2,3,5,3,0,0.276023622,0.276259843,0.511141732,1,1
3.515256,7,4,2,3,5,3,0,0.276338583,0.276574803,0.510826772,1,1
3.520344,7,4,2,3,5,3,0,0.276732283,0.276968504,0.510433071,1,1
3.525429,7,4,2,3,5,3,0,0.277204724,0.277440945,0.509960630,1,1
3.530514,7,4,2,3,5,3,0,0.277598425,0.277834646,0.509566929,1,1
3.535603,7,4,2,3,5,3,0,0.277913386,0.278149606,0.509251969,1,1
3.540690,7,4,2,3,5,3,0,0.278385827,0.278622047,0.508779528,1,1
3.545787,7,4,2,3,5,3,0,0.278779528,0.279015748,0.508385827,1,1
3.550890,7,4,2,3,5,3,0,0.279173228,0.279409449,0.507992126,1,1
3.555994,7,4,2,3,5,3,0,0.279566929,0.279803150,0.507598425,1,1
3.561094,7,4,2,3,5,3,0,0.279960630,0.280196850,0.507204724,1,1
3.566180,7,4,2,3,5,3,0,0.280354331,0.280590551,0.506811024,1,1
3.571267,7,4,2,3,5,3,0,0.280748031,0.280984252,0.506417323,1,1
3.576354,7,4,2,3,5,3,0,0.281220472,0.281456693,0.505944882,1,1
3.581446,7,4,2,3,5,3,0,0.281535433,0.281771654,0.505629921,1,1
3.586536,7,4,2,3,5,3,0,0.281929134,0.282165354,0.505236220,1,1
3.591622,7,4,2,3,5,3,0,0.282401575,0.282637795,0.504763780,1,1
3.596707,7,4,2,3,5,3,0,0.282795276,0.283031496,0.504370079,1,1
3.601792,7,4,2,3,5,3,0,0.283110236,0.283346457,0.504055118,1,1
3.606879,7,4,2,3,5,3,0,0.283582677,0.283818898,0.503582677,1,1
3.611971,7,4,2,3,5,3,0,0.283976378,0.284212598,0.503188976,1,1
3.617068,7,4,2,3,5,3,0,0.284370079,0.284606299,0.502795276,1,1
3.622156,7,4,2,3,5,3,0,0.284763780,0.285000000,0.502401575,1,1
3.627241,7,4,2,3,5,3,0,0.285157480,0.285393701,0.502007874,1,1
3.632331,7,4,2,3,5,3,0,0.285551181,0.285787402,0.501614173,1,1
3.637433,7,4,2,3,5,3,0,0.286023622,0.286259843,0.501141732,1,1
3.642527,7,4,2,3,5,3,0,0.286417323,0.286653543,0.500748031,1,1
3.647620,7,4,2,3,5,3,0,0.286732283,0.286968504,0.500433071,1,1
3.652712,7,4,2,3,5,3,0,0.287204724,0.287440945,0.499960630,1,1
3.657798,7,4,2,3,5,3,0,0.287598425,0.287834646,0.499566929,1,1
3.662885,7,4,2,3,5,3,0,0.287992126,0.288228346,0.499173228,1,1
3.667973,7,4,2,3,5,3,0,0.288385827,0.288622047,0.498779528,1,1
3.673058,7,4,2,3,5,3,0,0.288779528,0.289015748,0.498385827,1,1
3.678143,7,4,2,3,5,3,0,0.289173228,0.289409449,0.497992126,1,1
3.683229,7,4,2,3,5,3,0,0.289645669,0.289881890,0.497519685,1,1
3.688321,7,4,2,3,5,3,0,0.289960630,0.290196850,0.497204724,1,1
3.693414,7,4,2,3,5,3,0,0.290354331,0.290590551,0.496811024,1,1
3.698499,7,4,2,3,5,3,0,0.290826772,0.291062992,0.496338583,1,1
3.703583,7,4,2,3,5,3,0,0.291220472,0.291456693,0.495944882,1,1
3.708680,7,4,2,3,5,3,0,0.291614173,0.291850394,0.495551181,1,1
3.713773,7,4,2,3,5,3,0,0.291929134,0.292165354,0.495236220,1,1
3.718859,7,4,2,3,5,3,0,0.292401575,0.292637795,0.494763780,1,1
3.723949,7,4,2,3,5,3,0,0.292795276,0.293031496,0.494370079,1,1
3.729052,7,4,2,3,5,3,0,0.293110236,0.293346457,0.494055118,1,1
3.734148,7,4,2,3,5,3,0,0.293582677,0.293818898,0.493582677,1,1
3.740132,7,4,2,3,5,3,0,0.294055118,0.294291339,0.493110236,1,1
3.745222,7,4,2,3,5,3,0,0.294448819,0.294685039,0.492716535,1,1
3.750310,7,4,2,3,5,3,0,0.294921260,0.295157480,0.492244094,1,1
3.755396,7,4,2,3,5,3,0,0.295236220,0.295472441,0.491929134,1,1
3.760482,7,4,2,3,5,3,0,0.295629921,0.295866142,0.491535433,1,1
3.765567,7,4,2,3,5,3,0,0.296102362,0.296338583,0.491062992,1,1
3.770652,7,4,2,3,5,3,0,0.296496063,0.296732283,0.490669291,1,1
3.775743,7,4,2,3,5,3,0,0.296811024,0.297047244,0.490354331,1,1
3.780827,7,4,2,3,5,3,0,0.297283465,0.297519685,0.489881890,1,1
3.785909,7,4,2,3,5,3,0,0.297677165,0.297913386,0.489488189,1,1
3.791004,7,4,2,3,5,3,0,0.298070866,0.298307087,0.489094488,1,1
3.796095,7,4,2,3,5,3,0,0.298464567,0.298700787,0.488700787,1,1
3.801183,7,4,2,3,5,3,0,0.298858268,0.299094488,0.488307087,1,1
3.806271,7,4,2,3,5,3,0,0.299251969,0.299488189,0.487913386,1,1
3.811358,7,4,2,3,5,3,0,0.299724409,0.299960630,0.487440945,1,1
3.816445,7,4,2,3,5,3,0,0.300039370,0.300275591,0.487125984,1,1
3.821532,7,4,2,3,5,3,0,0.300433071,0.300669291,0.486732283,1,1
3.826620,7,4,2,3,5,3,0,0.300905512,0.301141732,0.486259843,1,1
3.831706,7,4,2,3,5,3,0,0.301299213,0.301535433,0.485866142,1,1
3.836795,7,4,2,3,5,3,0,0.301614173,0.301850394,0.485551181,1,1
3.841889,7,4,2,3,5,3,0,0.302086614,0.302322835,0.485078740,1,1
3.846984,7,4,2,3,5,3,0,0.302480315,0.302716535,0.484685039,1,1
3.852078,7,4,2,3,5,3,0,0.302874016,0.303110236,0.484291339,1,1
3.857163,7,4,2,3,5,3,0,0.303346457,0.303582677,0.483818898,1,1
3.862248,7,4,2,3,5,3,0,0.303661417,0.303897638,0.483503937,1,1
3.867334,7,4,2,3,5,3,0,0.304055118,0.304291339,0.483110236,1,1
3.872424,7,4,2,3,5,3,0,0.304527559,0.304763780,0.482637795,1,1
3.877513,7,4,2,3,5,3,0,0.304921260,0.305157480,0.482244094,1,1
3.882601,7,4,2,3,5,3,0,0.305236220,0.305472441,0.481929134,1,1
3.887690,7,4,2,3,5,3,0,0.305708661,0.305944882,0.481456693,1,1
3.892783,7,4,2,3,5,3,0,0.306102362,0.306338583,0.481062992,1,1
3.897868,7,4,2,3,5,3,0,0.306496063,0.306732283,0.480669291,1,1
3.902960,7,4,2,3,5,3,0,0.306811024,0.307047244,0.480354331,1,1
3.908059,7,4,2,3,5,3,0,0.307283465,0.307519685,0.479881890,1,1
3.913148,7,4,2,3,5,3,0,0.307677165,0.307913386,0.479488189,1,1
3.918234,7,4,2,3,5,3,0,0.308149606,0.308385827,0.479015748,1,1
3.923319,7,4,2,3,5,3,0,0.308464567,0.308700787,0.478700787,1,1
3.928463,7,4,2,3,5,3,0,0.308858268,0.309094488,0.478307087,1,1
3.933554,7,4,2,3,5,3,0,0.309251969,0.309488189,0.477913386,1,1
3.938643,7,4,2,3,5,3,0,0.309724409,0.309960630,0.477440945,1,1
3.943736,7,4,2,3,5,3,0,0.310118110,0.310354331,0.477047244,1,1
3.948828,7,4,2,3,5,3,0,0.310433071,0.310669291,0.476732283,1,1
3.953915,7,4,2,3,5,3,0,0.310905512,0.311141732,0.476259843,1,1
3.959006,7,4,2,3,5,3,0,0.311299213,0.311535433,0.475866142,1,1
3.964094,7,4,2,3,5,3,0,0.311692913,0.311929134,0.475472441,1,1
3.969186,7,4,2,3,5,3,0,0.312086614,0.312322835,0.475078740,1,1
3.974274,7,4,2,3,5,3,0,0.312480315,0.312716535,0.474685039,1,1
3.979361,7,4,2,3,5,3,0,0.312874016,0.313110236,0.474291339,1,1
3.984448,7,4,2,3,5,3,0,0.313346457,0.313582677,0.473818898,1,1
3.989535,7,4,2,3,5,3,0,0.313661417,0.313897638,0.473503937,1,1
3.994626,7,4,2,3,5,3,0,0.314055118,0.314291339,0.473110236,1,1
3.999719,7,4,2,3,5,3,0,0.314527559,0.314763780,0.472637795,1,1
4.004807,7,4,2,3,5,3,0,0.314921260,0.315157480,0.472244094,1,1
4.009894,7,4,2,3,5,3,0,0.315314961,0.315551181,0.471850394,1,1
4.014992,7,4,2,3,5,3,0,0.315708661,0.315944882,0.471456693,1,1
4.020084,7,4,2,3,5,3,0,0.316102362,0.316338583,0.471062992,1,1
4.025172,7,4,2,3,5,3,0,0.316496063,0.316732283,0.470669291,1,1
4.030259,7,4,2,3,5,3,0,0.316968504,0.317204724,0.470196850,1,1
4.035351,7,4,2,3,5,3,0,0.317283465,0.317519685,0.469881890,1,1
4.040438,7,4,2,3,5,3,0,0.317677165,0.317913386,0.469488189,1,1
4.045527,7,4,2,3,5,3,0,0.318149606,0.318385827,0.469015748,1,1
4.050617,7,4,2,3,5,3,0,0.318543307,0.318779528,0.468622047,1,1
4.055706,7,4,2,3,5,3,0,0.318858268,0.319094488,0.468307087,1,1
4.060794,7,4,2,3,5,3,0,0.319330709,0.319566929,0.467834646,1,1
4.065884,7,4,2,3,5,3,0,0.319724409,0.319960630,0.467440945,1,1
4.070984,7,4,2,3,5,3,0,0.320118110,0.320354331,0.467047244,1,1
4.076077,7,4,2,3,5,3,0,0.320590551,0.320826772,0.466574803,1,1
4.081163,7,4,2,3,5,3,0,0.320905512,0.321141732,0.466259843,1,1
4.086248,7,4,2,3,5,3,0,0.321299213,0.321535433,0.465866142,1,1
4.091333,7,4,2,3,5,3,0,0.321771654,0.322007874,0.465393701,1,1
4.096418,7,4,2,3,5,3,0,0.322165354,0.322401575,0.465000000,1,1
4.101508,7,4,2,3,5,3,0,0.322480315,0.322716535,0.464685039,1,1
4.106595,7,4,2,3,5,3,0,0.322874016,0.323110236,0.464291339,1,1
4.111683,7,4,2,3,5,3,0,0.323346457,0.323582677,0.463818898,1,1
4.116768,7,4,2,3,5,3,0,0.323740157,0.323976378,0.463425197,1,1
4.121856,7,4,2,3,5,3,0,0.324055118,0.324291339,0.463110236,1,1
4.126942,7,4,2,3,5,3,0,0.324527559,0.324763780,0.462637795,1,1
4.132032,7,4,2,3,5,3,0,0.324921260,0.325157480,0.462244094,1,1
4.137120,7,4,2,3,5,3,0,0.325314961,0.325551181,0.461850394,1,1
4.142207,7,4,2,3,5,3,0,0.325708661,0.325944882,0.461456693,1,1
4.147294,7,4,2,3,5,3,0,0.326102362,0.326338583,0.461062992,1,1
4.152381,7,4,2,3,5,3,0,0.326496063,0.326732283,0.460669291,1,1
4.157469,7,4,2,3,5,3,0,0.326968504,0.327204724,0.460196850,1,1
4.162559,7,4,2,3,5,3,0,0.327283465,0.327519685,0.459881890,1,1
4.167645,7,4,2,3,5,3,0,0.327677165,0.327913386,0.459488189,1,1
4.172730,7,4,2,3,5,3,0,0.328149606,0.328385827,0.459015748,1,1
4.177819,7,4,2,3,5,3,0,0.328543307,0.328779528,0.458622047,1,1
4.182905,7,4,2,3,5,3,0,0.328937008,0.329173228,0.458228346,1,1
4.187996,7,4,2,3,5,3,0,0.329330709,0.329566929,0.457834646,1,1
4.193083,7,4,2,3,5,3,0,0.329724409,0.329960630,0.457440945,1,1
4.198173,7,4,2,3,5,3,0,0.330118110,0.330354331,0.457047244,1,1
4.203263,7,4,2,3,5,3,0,0.330590551,0.330826772,0.456574803,1,1
4.208352,7,4,2,3,5,3,0,0.330905512,0.331141732,0.456259843,1,1
4.213439,7,4,2,3,5,3,0,0.331299213,0.331535433,0.455866142,1,1
4.218524,7,4,2,3,5,3,0,0.331771654,0.332007874,0.455393701,1,1
4.223612,7,4,2,3,5,3,0,0.332165354,0.332401575,0.455000000,1,1
4.228705,7,4,2,3,5,3,0,0.332480315,0.332716535,0.454685039,1,1
4.233793,7,4,2,3,5,3,0,0.332952756,0.333188976,0.454212598,1,1
4.238879,7,4,2,3,5,3,0,0.333346457,0.333582677,0.453818898,1,1
4.243970,7,4,2,3,5,3,0,0.333740157,0.333976378,0.453425197,1,1
4.249072,7,4,2,3,5,3,0,0.334133858,0.334370079,0.453031496,1,1
4.254159,7,4,2,3,5,3,0,0.334527559,0.334763780,0.452637795,1,1
4.259246,7,4,2,3,5,3,0,0.334921260,0.335157480,0.452244094,1,1
4.264333,7,4,2,3,5,3,0,0.335393701,0.335629921,0.451771654,1,1
4.269419,7,4,2,3,5,3,0,0.335787402,0.336023622,0.451377953,1,1
4.274506,7,4,2,3,5,3,0,0.336102362,0.336338583,0.451062992,1,1
4.279598,7,4,2,3,5,3,0,0.336574803,0.336811024,0.450590551,1,1
4.284695,7,4,2,3,5,3,0,0.336968504,0.337204724,0.450196850,1,1
4.289786,7,4,2,3,5,3,0,0.337362205,0.337598425,0.449803150,1,1
4.294880,7,4,2,3,5,3,0,0.337677165,0.337913386,0.449488189,1,1
4.299971,7,4,2,3,5,3,0,0.338149606,0.338385827,0.449015748,1,1
4.305059,7,4,2,3,5,3,0,0.338543307,0.338779528,0.448622047,1,1
4.310144,7,4,2,3,5,3,0,0.339015748,0.339251969,0.448149606,1,1
4.315230,7,4,2,3,5,3,0,0.339330709,0.339566929,0.447834646,1,1
4.320317,7,4,2,3,5,3,0,0.339724409,0.339960630,0.447440945,1,1
4.325403,7,4,2,3,5,3,0,0.340118110,0.340354331,0.447047244,1,1
4.330490,7,4,2,3,5,3,0,0.340590551,0.340826772,0.446574803,1,1
4.335577,7,4,2,3,5,3,0,0.340905512,0.341141732,0.446259843,1,1
4.340666,7,4,2,3,5,3,0,0.341299213,0.341535433,0.445866142,1,1
4.345752,7,4,2,3,5,3,0,0.341771654,0.342007874,0.445393701,1,1
4.350849,7,4,2,3,5,3,0,0.342165354,0.342401575,0.445000000,1,1
4.355947,7,4,2,3,5,3,0,0.342480315,0.342716535,0.444685039,1,1
4.361049,7,4,2,3,5,3,0,0.342952756,0.343188976,0.444212598,1,1
4.366138,7,4,2,3,5,3,0,0.343346457,0.343582677,0.443818898,1,1
4.371226,7,4,2,3,5,3,0,0.343740157,0.343976378,0.443425197,1,1
4.376312,7,4,2,3,5,3,0,0.344212598,0.344448819,0.442952756,1,1
4.381397,7,4,2,3,5,3,0,0.344527559,0.344763780,0.442637795,1,1
4.386482,7,4,2,3,5,3,0,0.344921260,0.345157480,0.442244094,1,1
4.391567,7,4,2,3,5,3,0,0.345393701,0.345629921,0.441771654,1,1
4.396653,7,4,2,3,5,3,0,0.345787402,0.346023622,0.441377953,1,1
4.401749,7,4,2,3,5,3,0,0.346102362,0.346338583,0.441062992,1,1
4.406837,7,4,2,3,5,3,0,0.346574803,0.346811024,0.440590551,1,1
4.411921,7,4,2,3,5,3,0,0.346968504,0.347204724,0.440196850,1,1
4.417009,7,4,2,3,5,3,0,0.347362205,0.347598425,0.439803150,1,1
4.422097,7,4,2,3,5,3,0,0.347755906,0.347992126,0.439409449,1,1
4.427182,7,4,2,3,5,3,0,0.348149606,0.348385827,0.439015748,1,1
4.432266,7,4,2,3,5,3,0,0.348543307,0.348779528,0.438622047,1,1
4.437351,7,4,2,3,5,3,0,0.349015748,0.349251969,0.438149606,1,1
4.442440,7,4,2,3,5,3,0,0.349330709,0.349566929,0.437834646,1,1
4.447526,7,4,2,3,5,3,0,0.349724409,0.349960630,0.437440945,1,1
4.452616,7,4,2,3,5,3,0,0.350196850,0.350433071,0.436968504,1,1
4.457701,7,4,2,3,5,3,0,0.350590551,0.350826772,0.436574803,1,1
4.462799,7,4,2,3,5,3,0,0.350905512,0.351141732,0.436259843,1,1
4.467899,7,4,2,3,5,3,0,0.351377953,0.351614173,0.435787402,1,1
4.472985,7,4,2,3,5,3,0,0.351771654,0.352007874,0.435393701,1,1
4.478072,7,4,2,3,5,3,0,0.352165354,0.352401575,0.435000000,1,1
4.483159,7,4,2,3,5,3,0,0.352637795,0.352874016,0.434527559,1,1
4.488249,7,4,2,3,5,3,0,0.352952756,0.353188976,0.434212598,1,1
4.493335,7,4,2,3,5,3,0,0.353346457,0.353582677,0.433818898,1,1
4.498418,7,4,2,3,5,3,0,0.353818898,0.354055118,0.433346457,1,1
4.503507,7,4,2,3,5,3,0,0.354212598,0.354448819,0.432952756,1,1
4.508590,7,4,2,3,5,3,0,0.354527559,0.354763780,0.432637795,1,1
4.513676,7,4,2,3,5,3,0,0.354921260,0.355157480,0.432244094,1,1
4.518760,7,4,2,3,5,3,0,0.355393701,0.355629921,0.431771654,1,1
4.523844,7,4,2,3,5,3,0,0.355787402,0.356023622,0.431377953,1,1
4.528946,7,4,2,3,5,3,0,0.356102362,0.356338583,0.431062992,1,1
4.534041,7,4,2,3,5,3,0,0.356574803,0.356811024,0.430590551,1,1
4.539125,7,4,2,3,5,3,0,0.356968504,0.357204724,0.430196850,1,1
4.544211,7,4,2,3,5,3,0,0.357362205,0.357598425,0.429803150,1,1
4.549299,7,4,2,3,5,3,0,0.357834646,0.358070866,0.429330709,1,1
4.554390,7,4,2,3,5,3,0,0.358149606,0.358385827,0.429015748,1,1
4.559475,7,4,2,3,5,3,0,0.358543307,0.358779528,0.428622047,1,1
4.564559,7,4,2,3,5,3,0,0.359015748,0.359251969,0.428149606,1,1
4.569643,7,4,2,3,5,3,0,0.359409449,0.359645669,0.427755906,1,1
4.574727,7,4,2,3,5,3,0,0.359724409,0.359960630,0.427440945,1,1
4.579833,7,4,2,3,5,3,0,0.360196850,0.360433071,0.426968504,1,1
4.584928,7,4,2,3,5,3,0,0.360590551,0.360826772,0.426574803,1,1
4.590015,7,4,2,3,5,3,0,0.360984252,0.361220472,0.426181102,1,1
4.595107,7,4,2,3,5,3,0,0.361377953,0.361614173,0.425787402,1,1
4.600192,7,4,2,3,5,3,0,0.361771654,0.362007874,0.425393701,1,1
4.605279,7,4,2,3,5,3,0,0.362165354,0.362401575,0.425000000,1,1
4.610364,7,4,2,3,5,3,0,0.362637795,0.362874016,0.424527559,1,1
4.615454,7,4,2,3,5,3,0,0.362952756,0.363188976,0.424212598,1,1
4.620541,7,4,2,3,5,3,0,0.363346457,0.363582677,0.423818898,1,1
4.625630,7,4,2,3,5,3,0,0.363818898,0.364055118,0.423346457,1,1
4.630712,7,4,2,3,5,3,0,0.364212598,0.364448819,0.422952756,1,1
4.635810,7,4,2,3,5,3,0,0.364527559,0.364763780,0.422637795,1,1
4.640910,7,4,2,3,5,3,0,0.365000000,0.365236220,0.422165354,1,1
4.646002,7,4,2,3,5,3,0,0.365393701,0.365629921,0.421771654,1,1
4.651094,7,4,2,3,5,3,0,0.365787402,0.366023622,0.421377953,1,1
4.656182,7,4,2,3,5,3,0,0.366259843,0.366496063,0.420905512,1,1
4.661269,7,4,2,3,5,3,0,0.366574803,0.366811024,0.420590551,1,1
4.666354,7,4,2,3,5,3,0,0.366968504,0.367204724,0.420196850,1,1
4.671442,7,4,2,3,5,3,0,0.367440945,0.367677165,0.419724409,1,1
4.676527,7,4,2,3,5,3,0,0.367834646,0.368070866,0.419330709,1,1
4.681616,7,4,2,3,5,3,0,0.368149606,0.368385827,0.419015748,1,1
4.686705,7,4,2,3,5,3,0,0.368622047,0.368858268,0.418543307,1,1
4.691794,7,4,2,3,5,3,0,0.369015748,0.369251969,0.418149606,1,1
4.696881,7,4,2,3,5,3,0,0.369409449,0.369645669,0.417755906,1,1
4.701973,7,4,2,3,5,3,0,0.369803150,0.370039370,0.417362205,1,1
4.707061,7,4,2,3,5,3,0,0.370196850,0.370433071,0.416968504,1,1
4.712148,7,4,2,3,5,3,0,0.370590551,0.370826772,0.416574803,1,1
4.717234,7,4,2,3,5,3,0,0.371062992,0.371299213,0.416102362,1,1
4.722321,7,4,2,3,5,3,0,0.371377953,0.371614173,0.415787402,1,1
4.727370,7,4,2,3,5,3,0,0.371771654,0.372007874,0.415393701,1,1
4.732460,7,4,2,3,5,3,0,0.372244094,0.372480315,0.414921260,1,1
4.737548,7,4,2,3,5,3,0,0.372637795,0.372874016,0.414527559,1,1
4.742637,7,4,2,3,5,3,0,0.372952756,0.373188976,0.414212598,1,1
4.747738,7,4,2,3,5,3,0,0.373346457,0.373582677,0.413818898,1,1
4.752826,7,4,2,3,5,3,0,0.373818898,0.374055118,0.413346457,1,1
4.757915,7,4,2,3,5,3,0,0.374212598,0.374448819,0.412952756,1,1
4.763004,7,4,2,3,5,3,0,0.374685039,0.374921260,0.412480315,1,1
4.768089,7,4,2,3,5,3,0,0.375000000,0.375236220,0.412165354,1,1
4.773173,7,4,2,3,5,3,0,0.375393701,0.375629921,0.411771654,1,1
4.778258,7,4,2,3,5,3,0,0.375787402,0.376023622,0.411377953,1,1
4.783349,7,4,2,3,5,3,0,0.376259843,0.376496063,0.410905512,1,1
4.788446,7,4,2,3,5,3,0,0.376574803,0.376811024,0.410590551,1,1
4.793537,7,4,2,3,5,3,0,0.376968504,0.377204724,0.410196850,1,1
4.798624,7,4,2,3,5,3,0,0.377440945,0.377677165,0.409724409,1,1
4.803709,7,4,2,3,5,3,0,0.377834646,0.378070866,0.409330709,1,1
4.808799,7,4,2,3,5,3,0,0.378149606,0.378385827,0.409015748,1,1
4.813888,7,4,2,3,5,3,0,0.378622047,0.378858268,0.408543307,1,1
4.818972,7,4,2,3,5,3,0,0.379015748,0.379251969,0.408149606,1,1
4.824056,7,4,2,3,5,3,0,0.379409449,0.379645669,0.407755906,1,1
4.829148,7,4,2,3,5,3,0,0.379803150,0.380039370,0.407362205,1,1
4.834250,7,4,2,3,5,3,0,0.380196850,0.380433071,0.406968504,1,1
4.839345,7,4,2,3,5,3,0,0.380590551,0.380826772,0.406574803,1,1
4.844440,7,4,2,3,5,3,0,0.381062992,0.381299213,0.406102362,1,1
4.849527,7,4,2,3,5,3,0,0.381456693,0.381692913,0.405708661,1,1
4.854613,7,4,2,3,5,3,0,0.381771654,0.382007874,0.405393701,1,1
4.859705,7,4,2,3,5,3,0,0.382244094,0.382480315,0.404921260,1,1
4.864792,7,4,2,3,5,3,0,0.382637795,0.382874016,0.404527559,1,1
4.869879,7,4,2,3,5,3,0,0.383031496,0.383267717,0.404133858,1,1
4.874966,7,4,2,3,5,3,0,0.383425197,0.383661417,0.403740157,1,1
4.880057,7,4,2,3,5,3,0,0.383818898,0.384055118,0.403346457,1,1
4.885144,7,4,2,3,5,3,0,0.384212598,0.384448819,0.402952756,1,1
4.890229,7,4,2,3,5,3,0,0.384685039,0.384921260,0.402480315,1,1
4.895318,7,4,2,3,5,3,0,0.385000000,0.385236220,0.402165354,1,1
4.900402,7,4,2,3,5,3,0,0.385393701,0.385629921,0.401771654,1,1
4.905488,7,4,2,3,5,3,0,0.385866142,0.386102362,0.401299213,1,1
4.910582,7,4,2,3,5,3,0,0.386259843,0.386496063,0.400905512,1,1
4.915668,7,4,2,3,5,3,0,0.386574803,0.386811024,0.400590551,1,1
4.920753,7,4,2,3,5,3,0,0.387047244,0.387283465,0.400118110,1,1
4.925838,7,4,2,3,5,3,0,0.387440945,0.387677165,0.399724409,1,1
4.930930,7,4,2,3,5,3,0,0.387834646,0.388070866,0.399330709,1,1
4.936069,7,4,2,3,5,3,0,0.388307087,0.388543307,0.398858268,1,1
4.941194,7,4,2,3,5,3,0,0.388622047,0.388858268,0.398543307,1,1
4.946325,7,4,2,3,5,3,0,0.389015748,0.389251969,0.398149606,1,1
4.951420,7,4,2,3,5,3,0,0.389488189,0.389724409,0.397677165,1,1
4.956511,7,4,2,3,5,3,0,0.389881890,0.390118110,0.397283465,1,1
4.961603,7,4,2,3,5,3,0,0.390196850,0.390433071,0.396968504,1,1
4.966690,7,4,2,3,5,3,0,0.390590551,0.390826772,0.396574803,1,1
4.971777,7,4,2,3,5,3,0,0.391062992,0.391299213,0.396102362,1,1
4.976863,7,4,2,3,5,3,0,0.391456693,0.391692913,0.395708661,1,1
4.981947,7,4,2,3,5,3,0,0.391771654,0.392007874,0.395393701,1,1
4.987037,7,4,2,3,5,3,0,0.392244094,0.392480315,0.394921260,1,1
4.992120,7,4,2,3,5,3,0,0.392637795,0.392874016,0.394527559,1,1
4.997205,7,4,2,3,5,3,0,0.393031496,0.393267717,0.394133858,1,1
5.002297,7,4,2,3,5,3,0,0.393503937,0.393740157,0.393661417,1,1
5.007391,7,4,2,3,5,3,0,0.393818898,0.394055118,0.393346457,1,1
5.012485,7,4,2,3,5,3,0,0.394212598,0.394448819,0.392952756,1,1
5.017573,7,4,2,3,5,3,0,0.394685039,0.394921260,0.392480315,1,1
5.022661,7,4,2,3,5,3,0,0.395078740,0.395314961,0.392086614,1,1
5.027749,7,4,2,3,5,3,0,0.395393701,0.395629921,0.391771654,1,1
5.032836,7,4,2,3,5,3,0,0.395866142,0.396102362,0.391299213,1,1
5.037922,7,4,2,3,5,3,0,0.396259843,0.396496063,0.390905512,1,1
5.043009,7,4,2,3,5,3,0,0.396653543,0.396889764,0.390511811,1,1
5.048095,7,4,2,3,5,3,0,0.397047244,0.397283465,0.390118110,1,1
5.053184,7,4,2,3,5,3,0,0.397440945,0.397677165,0.389724409,1,1
5.058270,7,4,2,3,5,3,0,0.397834646,0.398070866,0.389330709,1,1
5.063360,7,4,2,3,5,3,0,0.398307087,0.398543307,0.388858268,1,1
5.068444,7,4,2,3,5,3,0,0.398700787,0.398937008,0.388464567,1,1
5.073534,7,4,2,3,5,3,0,0.399015748,0.399251969,0.388149606,1,1
5.078619,7,4,2,3,5,3,0,0.399488189,0.399724409,0.387677165,1,1
5.083703,7,4,2,3,5,3,0,0.399881890,0.400118110,0.387283465,1,1
5.088788,7,4,2,3,5,3,0,0.400275591,0.400511811,0.386889764,1,1
5.093874,7,4,2,3,5,3,0,0.400669291,0.400905512,0.386496063,1,1
5.098960,7,4,2,3,5,3,0,0.401062992,0.401299213,0.386102362,1,1
5.104058,7,4,2,3,5,3,0,0.401456693,0.401692913,0.385708661,1,1
5.109145,7,4,2,3,5,3,0,0.401929134,0.402165354,0.385236220,1,1
5.114250,7,4,2,3,5,3,0,0.402244094,0.402480315,0.384921260,1,1
5.119339,7,4,2,3,5,3,0,0.402637795,0.402874016,0.384527559,1,1
5.124423,7,4,2,3,5,3,0,0.403031496,0.403267717,0.384133858,1,1
5.129511,7,4,2,3,5,3,0,0.403503937,0.403740157,0.383661417,1,1
5.134603,7,4,2,3,5,3,0,0.403818898,0.404055118,0.383346457,1,1
5.139696,7,4,2,3,5,3,0,0.404212598,0.404448819,0.382952756,1,1
5.144784,7,4,2,3,5,3,0,0.404685039,0.404921260,0.382480315,1,1
5.149871,7,4,2,3,5,3,0,0.405078740,0.405314961,0.382086614,1,1
5.154958,7,4,2,3,5,3,0,0.405472441,0.405708661,0.381692913,1,1
5.160055,7,4,2,3,5,3,0,0.405866142,0.406102362,0.381299213,1,1
5.165146,7,4,2,3,5,3,0,0.406259843,0.406496063,0.380905512,1,1
5.170233,7,4,2,3,5,3,0,0.406653543,0.406889764,0.380511811,1,1
5.175320,7,4,2,3,5,3,0,0.407125984,0.407362205,0.380039370,1,1
5.180409,7,4,2,3,5,3,0,0.407440945,0.407677165,0.379724409,1,1
5.185500,7,4,2,3,5,3,0,0.407834646,0.408070866,0.379330709,1,1
5.190586,7,4,2,3,5,3,0,0.408307087,0.408543307,0.378858268,1,1
5.195671,7,4,2,3,5,3,0,0.408700787,0.408937008,0.378464567,1,1
5.200765,7,4,2,3,5,3,0,0.409015748,0.409251969,0.378149606,1,1
5.205851,7,4,2,3,5,3,0,0.409488189,0.409724409,0.377677165,1,1
5.210935,7,4,2,3,5,3,0,0.409881890,0.410118110,0.377283465,1,1
5.216027,7,4,2,3,5,3,0,0.410275591,0.410511811,0.376889764,1,1
5.221113,7,4,2,3,5,3,0,0.410669291,0.410905512,0.376496063,1,1
5.226197,7,4,2,3,5,3,0,0.411062992,0.411299213,0.376102362,1,1
5.231306,7,4,2,3,5,3,0,0.411456693,0.411692913,0.375708661,1,1
5.236394,7,4,2,3,5,3,0,0.411929134,0.412165354,0.375236220,1,1
5.241479,7,4,2,3,5,3,0,0.412322835,0.412559055,0.374842520,1,1
5.246564,7,4,2,3,5,3,0,0.412637795,0.412874016,0.374527559,1,1
5.251650,7,4,2,3,5,3,0,0.413110236,0.413346457,0.374055118,1,1
5.256735,7,4,2,3,5,3,0,0.413503937,0.413740157,0.373661417,1,1
5.261819,7,4,2,3,5,3,0,0.413897638,0.414133858,0.373267717,1,1
5.266911,7,4,2,3,5,3,0,0.414291339,0.414527559,0.372874016,1,1
5.272003,7,4,2,3,5,3,0,0.414685039,0.414921260,0.372480315,1,1
5.277088,7,4,2,3,5,3,0,0.415078740,0.415314961,0.372086614,1,1
5.282173,7,4,2,3,5,3,0,0.415551181,0.415787402,0.371614173,1,1
5.287263,7,4,2,3,5,3,0,0.415866142,0.416102362,0.371299213,1,1
5.292351,7,4,2,3,5,3,0,0.416259843,0.416496063,0.370905512,1,1
5.297438,7,4,2,3,5,3,0,0.416653543,0.416889764,0.370511811,1,1
5.302525,7,4,2,3,5,3,0,0.417125984,0.417362205,0.370039370,1,1
5.307613,7,4,2,3,5,3,0,0.417440945,0.417677165,0.369724409,1,1
5.312700,7,4,2,3,5,3,0,0.417834646,0.418070866,0.369330709,1,1
5.317792,7,4,2,3,5,3,0,0.418307087,0.418543307,0.368858268,1,1
5.322881,7,4,2,3,5,3,0,0.418700787,0.418937008,0.368464567,1,1
5.327983,7,4,2,3,5,3,0,0.419094488,0.419330709,0.368070866,1,1
5.333082,7,4,2,3,5,3,0,0.419488189,0.419724409,0.367677165,1,1
5.338169,7,4,2,3,5,3,0,0.419881890,0.420118110,0.367283465,1,1
5.343257,7,4,2,3,5,3,0,0.420275591,0.420511811,0.366889764,1,1
5.348342,7,4,2,3,5,3,0,0.420748031,0.420984252,0.366417323,1,1
5.353430,7,4,2,3,5,3,0,0.421062992,0.421299213,0.366102362,1,1
5.358517,7,4,2,3,5,3,0,0.421456693,0.421692913,0.365708661,1,1
5.363602,7,4,2,3,5,3,0,0.421929134,0.422165354,0.365236220,1,1
5.368692,7,4,2,3,5,3,0,0.422322835,0.422559055,0.364842520,1,1
5.373780,7,4,2,3,5,3,0,0.422637795,0.422874016,0.364527559,1,1
5.378865,7,4,2,3,5,3,0,0.423110236,0.423346457,0.364055118,1,1
5.383954,7,4,2,3,5,3,0,0.423503937,0.423740157,0.363661417,1,1
5.389051,7,4,2,3,5,3,0,0.423897638,0.424133858,0.363267717,1,1
5.394142,7,4,2,3,5,3,0,0.424370079,0.424606299,0.362795276,1,1
5.399234,7,4,2,3,5,3,0,0.424685039,0.424921260,0.362480315,1,1
5.404320,7,4,2,3,5,3,0,0.425078740,0.425314961,0.362086614,1,1
5.409405,7,4,2,3,5,3,0,0.425551181,0.425787402,0.361614173,1,1
5.414490,7,4,2,3,5,3,0,0.425944882,0.426181102,0.361220472,1,1
5.419579,7,4,2,3,5,3,0,0.426259843,0.426496063,0.360905512,1,1
5.424664,7,4,2,3,5,3,0,0.426732283,0.426968504,0.360433071,1,1
5.429753,7,4,2,3,5,3,0,0.427125984,0.427362205,0.360039370,1,1
5.434839,7,4,2,3,5,3,0,0.427519685,0.427755906,0.359645669,1,1
5.439929,7,4,2,3,5,3,0,0.427913386,0.428149606,0.359251969,1,1
5.445017,7,4,2,3,5,3,0,0.428307087,0.428543307,0.358858268,1,1
5.450104,7,4,2,3,5,3,0,0.428700787,0.428937008,0.358464567,1,1
5.455191,7,4,2,3,5,3,0,0.429173228,0.429409449,0.357992126,1,1
5.460282,7,4,2,3,5,3,0,0.429488189,0.429724409,0.357677165,1,1
5.465371,7,4,2,3,5,3,0,0.429881890,0.430118110,0.357283465,1,1
5.470462,7,4,2,3,5,3,0,0.430275591,0.430511811,0.356889764,1,1
5.475549,7,4,2,3,5,3,0,0.430748031,0.430984252,0.356417323,1,1
5.480636,7,4,2,3,5,3,0,0.431141732,0.431377953,0.356023622,1,1
5.485723,7,4,2,3,5,3,0,0.431456693,0.431692913,0.355708661,1,1
5.490810,7,4,2,3,5,3,0,0.431929134,0.432165354,0.355236220,1,1
5.495896,7,4,2,3,5,3,0,0.432322835,0.432559055,0.354842520,1,1
5.500992,7,4,2,3,5,3,0,0.432716535,0.432952756,0.354448819,1,1
5.506083,7,4,2,3,5,3,0,0.433110236,0.433346457,0.354055118,1,1
5.511170,7,4,2,3,5,3,0,0.433503937,0.433740157,0.353661417,1,1
5.516256,7,4,2,3,5,3,0,0.433897638,0.434133858,0.353267717,1,1
5.521348,7,4,2,3,5,3,0,0.434370079,0.434606299,0.352795276,1,1
5.526440,7,4,2,3,5,3,0,0.434685039,0.434921260,0.352480315,1,1
5.531527,7,4,2,3,5,3,0,0.435078740,0.435314961,0.352086614,1,1
5.536617,7,4,2,3,5,3,0,0.435551181,0.435787402,0.351614173,1,1
5.541702,7,4,2,3,5,3,0,0.435944882,0.436181102,0.351220472,1,1
5.546791,7,4,2,3,5,3,0,0.436259843,0.436496063,0.350905512,1,1
5.551877,7,4,2,3,5,3,0,0.436732283,0.436968504,0.350433071,1,1
5.556963,7,4,2,3,5,3,0,0.437125984,0.437362205,0.350039370,1,1
5.562062,7,4,2,3,5,3,0,0.437519685,0.437755906,0.349645669,1,1
5.567146,7,4,2,3,5,3,0,0.437992126,0.438228346,0.349173228,1,1
5.572236,7,4,2,3,5,3,0,0.438307087,0.438543307,0.348858268,1,1
5.577321,7,4,2,3,5,3,0,0.438700787,0.438937008,0.348464567,1,1
5.582407,7,4,2,3,5,3,0,0.439173228,0.439409449,0.347992126,1,1
5.587491,7,4,2,3,5,3,0,0.439566929,0.439803150,0.347598425,1,1
5.592582,7,4,2,3,5,3,0,0.439881890,0.440118110,0.347283465,1,1
5.597669,7,4,2,3,5,3,0,0.440275591,0.440511811,0.346889764,1,1
5.602755,7,4,2,3,5,3,0,0.440748031,0.440984252,0.346417323,1,1
5.607839,7,4,2,3,5,3,0,0.441141732,0.441377953,0.346023622,1,1
5.612927,7,4,2,3,5,3,0,0.441456693,0.441692913,0.345708661,1,1
5.618014,7,4,2,3,5,3,0,0.441929134,0.442165354,0.345236220,1,1
5.623108,7,4,2,3,5,3,0,0.442322835,0.442559055,0.344842520,1,1
5.628193,7,4,2,3,5,3,0,0.442716535,0.442952756,0.344448819,1,1
5.633280,7,4,2,3,5,3,0,0.443188976,0.443425197,0.343976378,1,1
5.638373,7,4,2,3,5,3,0,0.443503937,0.443740157,0.343661417,1,1
5.643463,7,4,2,3,5,3,0,0.443897638,0.444133858,0.343267717,1,1
5.648558,7,4,2,3,5,3,0,0.444370079,0.444606299,0.342795276,1,1
5.653666,7,4,2,3,5,3,0,0.444763780,0.445000000,0.342401575,1,1
5.658779,7,4,2,3,5,3,0,0.445078740,0.445314961,0.342086614,1,1
5.663868,7,4,2,3,5,3,0,0.445551181,0.445787402,0.341614173,1,1
5.668955,7,4,2,3,5,3,0,0.445944882,0.446181102,0.341220472,1,1
5.674052,7,4,2,3,5,3,0,0.446338583,0.446574803,0.340826772,1,1
5.679138,7,4,2,3,5,3,0,0.446732283,0.446968504,0.340433071,1,1
5.684222,7,4,2,3,5,3,0,0.447125984,0.447362205,0.340039370,1,1
5.689307,7,4,2,3,5,3,0,0.447519685,0.447755906,0.339645669,1,1
5.694389,7,4,2,3,5,3,0,0.447992126,0.448228346,0.339173228,1,1
5.699477,7,4,2,3,5,3,0,0.448307087,0.448543307,0.338858268,1,1
5.704571,7,4,2,3,5,3,0,0.448700787,0.448937008,0.338464567,1,1
5.709655,7,4,2,3,5,3,0,0.449173228,0.449409449,0.337992126,1,1
5.714737,7,4,2,3,5,3,0,0.449566929,0.449803150,0.337598425,1,1
5.719822,7,4,2,3,5,3,0,0.449960630,0.450196850,0.337204724,1,1
5.724908,7,4,2,3,5,3,0,0.450354331,0.450590551,0.336811024,1,1
5.729987,7,4,2,3,5,3,0,0.450748031,0.450984252,0.336417323,1,1
5.735083,7,4,2,3,5,3,0,0.451141732,0.451377953,0.336023622,1,1
5.740171,7,4,2,3,5,3,0,0.451614173,0.451850394,0.335551181,1,1
5.745262,7,4,2,3,5,3,0,0.451929134,0.452165354,0.335236220,1,1
5.750351,7,4,2,3,5,3,0,0.452322835,0.452559055,0.334842520,1,1
5.755436,7,4,2,3,5,3,0,0.452795276,0.453031496,0.334370079,1,1
5.760524,7,4,2,3,5,3,0,0.453188976,0.453425197,0.333976378,1,1
5.765609,7,4,2,3,5,3,0,0.453503937,0.453740157,0.333661417,1,1
5.770695,7,4,2,3,5,3,0,0.453976378,0.454212598,0.333188976,1,1
5.775785,7,4,2,3,5,3,0,0.454370079,0.454606299,0.332795276,1,1
5.780870,7,4,2,3,5,3,0,0.454763780,0.455000000,0.332401575,1,1
5.785960,7,4,2,3,5,3,0,0.455078740,0.455314961,0.332086614,1,1
5.791050,7,4,2,3,5,3,0,0.455551181,0.455787402,0.331614173,1,1
5.796138,7,4,2,3,5,3,0,0.455944882,0.456181102,0.331220472,1,1
5.801224,7,4,2,3,5,3,0,0.456338583,0.456574803,0.330826772,1,1
5.806321,7,4,2,3,5,3,0,0.456811024,0.457047244,0.330354331,1,1
5.811413,7,4,2,3,5,3,0,0.457125984,0.457362205,0.330039370,1,1
5.816500,7,4,2,3,5,3,0,0.457519685,0.457755906,0.329645669,1,1
5.821588,7,4,2,3,5,3,0,0.457992126,0.458228346,0.329173228,1,1
5.826679,7,4,2,3,5,3,0,0.458385827,0.458622047,0.328779528,1,1
5.831765,7,4,2,3,5,3,0,0.458700787,0.458937008,0.328464567,1,1
5.836853,7,4,2,3,5,3,0,0.459173228,0.459409449,0.327992126,1,1
5.841939,7,4,2,3,5,3,0,0.459566929,0.459803150,0.327598425,1,1
5.847026,7,4,2,3,5,3,0,0.459960630,0.460196850,0.327204724,1,1
5.852116,7,4,2,3,5,3,0,0.460354331,0.460590551,0.326811024,1,1
5.857204,7,4,2,3,5,3,0,0.460748031,0.460984252,0.326417323,1,1
5.862290,7,4,2,3,5,3,0,0.461141732,0.461377953,0.326023622,1,1
5.867377,7,4,2,3,5,3,0,0.461614173,0.461850394,0.325551181,1,1
5.872467,7,4,2,3,5,3,0,0.461929134,0.462165354,0.325236220,1,1
5.877560,7,4,2,3,5,3,0,0.462322835,0.462559055,0.324842520,1,1
5.882668,7,4,2,3,5,3,0,0.462795276,0.463031496,0.324370079,1,1
5.887756,7,4,2,3,5,3,0,0.463188976,0.463425197,0.323976378,1,1
5.892842,7,4,2,3,5,3,0,0.463582677,0.463818898,0.323582677,1,1
5.897928,7,4,2,3,5,3,0,0.463976378,0.464212598,0.323188976,1,1
5.903012,7,4,2,3,5,3,0,0.464370079,0.464606299,0.322795276,1,1
5.908097,7,4,2,3,5,3,0,0.464763780,0.465000000,0.322401575,1,1
5.913190,7,4,2,3,5,3,0,0.465236220,0.465472441,0.321929134,1,1
5.918277,7,4,2,3,5,3,0,0.465551181,0.465787402,0.321614173,1,1
5.923363,7,4,2,3,5,3,0,0.465944882,0.466181102,0.321220472,1,1
5.928453,7,4,2,3,5,3,0,0.466417323,0.466653543,0.320748031,1,1
5.933538,7,4,2,3,5,3,0,0.466811024,0.467047244,0.320354331,1,1
5.938624,7,4,2,3,5,3,0,0.467125984,0.467362205,0.320039370,1,1
5.943715,7,4,2,3,5,3,0,0.467598425,0.467834646,0.319566929,1,1
5.948806,7,4,2,3,5,3,0,0.467992126,0.468228346,0.319173228,1,1
5.953892,7,4,2,3,5,3,0,0.468385827,0.468622047,0.318779528,1,1
5.958984,7,4,2,3,5,3,0,0.468700787,0.468937008,0.318464567,1,1
5.964077,7,4,2,3,5,3,0,0.469173228,0.469409449,0.317992126,1,1
5.969162,7,4,2,3,5,3,0,0.469566929,0.469803150,0.317598425,1,1
5.974246,7,4,2,3,5,3,0,0.469960630,0.470196850,0.317204724,1,1
5.979341,7,4,2,3,5,3,0,0.470433071,0.470669291,0.316732283,1,1
5.984427,7,4,2,3,5,3,0,0.470748031,0.470984252,0.316417323,1,1
5.989513,7,4,2,3,5,3,0,0.471141732,0.471377953,0.316023622,1,1
5.994597,7,4,2,3,5,3,0,0.471614173,0.471850394,0.315551181,1,1
5.999682,7,4,2,3,5,3,0,0.472007874,0.472244094,0.315157480,1,1
6.004768,7,4,2,3,5,3,0,0.472322835,0.472559055,0.314842520,1,1
6.009853,7,4,2,3,5,3,0,0.472795276,0.473031496,0.314370079,1,1
6.014937,7,4,2,3,5,3,0,0.473188976,0.473425197,0.313976378,1,1
6.020023,7,4,2,3,5,3,0,0.473582677,0.473818898,0.313582677,1,1
6.025107,7,4,2,3,5,3,0,0.473976378,0.474212598,0.313188976,1,1
6.030196,7,4,2,3,5,3,0,0.474370079,0.474606299,0.312795276,1,1
6.035281,7,4,2,3,5,3,0,0.474763780,0.475000000,0.312401575,1,1
6.040366,7,4,2,3,5,3,0,0.475236220,0.475472441,0.311929134,1,1
6.045456,7,4,2,3,5,3,0,0.475551181,0.475787402,0.311614173,1,1
6.050541,7,4,2,3,5,3,0,0.475944882,0.476181102,0.311220472,1,1
6.055626,7,4,2,3,5,3,0,0.476417323,0.476653543,0.310748031,1,1
6.060710,7,4,2,3,5,3,0,0.476811024,0.477047244,0.310354331,1,1
6.065795,7,4,2,3,5,3,0,0.477204724,0.477440945,0.309960630,1,1
6.070881,7,4,2,3,5,3,0,0.477598425,0.477834646,0.309566929,1,1
6.075969,7,4,2,3,5,3,0,0.477992126,0.478228346,0.309173228,1,1
6.081070,7,4,2,3,5,3,0,0.478385827,0.478622047,0.308779528,1,1
6.086155,7,4,2,3,5,3,0,0.478858268,0.479094488,0.308307087,1,1
6.091240,7,4,2,3,5,3,0,0.479173228,0.479409449,0.307992126,1,1
6.096324,7,4,2,3,5,3,0,0.479566929,0.479803150,0.307598425,1,1
6.101409,7,4,2,3,5,3,0,0.480039370,0.480275591,0.307125984,1,1
6.106494,7,4,2,3,5,3,0,0.480433071,0.480669291,0.306732283,1,1
6.111586,7,4,2,3,5,3,0,0.480748031,0.480984252,0.306417323,1,1
6.116672,7,4,2,3,5,3,0,0.481220472,0.481456693,0.305944882,1,1
6.121759,7,4,2,3,5,3,0,0.481614173,0.481850394,0.305551181,1,1
6.126844,7,4,2,3,5,3,0,0.482007874,0.482244094,0.305157480,1,1
6.131939,7,4,2,3,5,3,0,0.482322835,0.482559055,0.304842520,1,1
6.137028,7,4,2,3,5,3,0,0.482795276,0.483031496,0.304370079,1,1
6.142116,7,4,2,3,5,3,0,0.483188976,0.483425197,0.303976378,1,1
6.147203,7,4,2,3,5,3,0,0.483582677,0.483818898,0.303582677,1,1
6.152290,7,4,2,3,5,3,0,0.484055118,0.484291339,0.303110236,1,1
6.157377,7,4,2,3,5,3,0,0.484370079,0.484606299,0.302795276,1,1
6.162464,7,4,2,3,5,3,0,0.484763780,0.485000000,0.302401575,1,1
6.167551,7,4,2,3,5,3,0,0.485236220,0.485472441,0.301929134,1,1
6.172638,7,4,2,3,5,3,0,0.485629921,0.485866142,0.301535433,1,1
6.177731,7,4,2,3,5,3,0,0.485944882,0.486181102,0.301220472,1,1
6.182823,7,4,2,3,5,3,0,0.486417323,0.486653543,0.300748031,1,1
6.187910,7,4,2,3,5,3,0,0.486811024,0.487047244,0.300354331,1,1
6.193003,7,4,2,3,5,3,0,0.487204724,0.487440945,0.299960630,1,1
6.198090,7,4,2,3,5,3,0,0.487598425,0.487834646,0.299566929,1,1
6.203176,7,4,2,3,5,3,0,0.487992126,0.488228346,0.299173228,1,1
6.208263,7,4,2,3,5,3,0,0.488385827,0.488622047,0.298779528,1,1
6.213349,7,4,2,3,5,3,0,0.488858268,0.489094488,0.298307087,1,1
6.218434,7,4,2,3,5,3,0,0.489173228,0.489409449,0.297992126,1,1
6.223519,7,4,2,3,5,3,0,0.489566929,0.489803150,0.297598425,1,1
6.228604,7,4,2,3,5,3,0,0.490039370,0.490275591,0.297125984,1,1
6.233693,7,4,2,3,5,3,0,0.490433071,0.490669291,0.296732283,1,1
6.238781,7,4,2,3,5,3,0,0.490826772,0.491062992,0.296338583,1,1
6.243866,7,4,2,3,5,3,0,0.491220472,0.491456693,0.295944882,1,1
6.248951,7,4,2,3,5,3,0,0.491614173,0.491850394,0.295551181,1,1
6.254044,7,4,2,3,5,3,0,0.492007874,0.492244094,0.295157480,1,1
6.259129,7,4,2,3,5,3,0,0.492480315,0.492716535,0.294685039,1,1
6.264214,7,4,2,3,5,3,0,0.492795276,0.493031496,0.294370079,1,1
6.269299,7,4,2,3,5,3,0,0.493188976,0.493425197,0.293976378,1,1
6.274384,7,4,2,3,5,3,0,0.493661417,0.493897638,0.293503937,1,1
6.279469,7,4,2,3,5,3,0,0.494055118,0.494291339,0.293110236,1,1
6.284558,7,4,2,3,5,3,0,0.494370079,0.494606299,0.292795276,1,1
6.289648,7,4,2,3,5,3,0,0.494763780,0.495000000,0.292401575,1,1
6.294736,7,4,2,3,5,3,0,0.495236220,0.495472441,0.291929134,1,1
6.299823,7,4,2,3,5,3,0,0.495629921,0.495866142,0.291535433,1,1
6.304915,7,4,2,3,5,3,0,0.495944882,0.496181102,0.291220472,1,1
6.310005,7,4,2,3,5,3,0,0.496417323,0.496653543,0.290748031,1,1
6.315093,7,4,2,3,5,3,0,0.496811024,0.497047244,0.290354331,1,1
6.320179,7,4,2,3,5,3,0,0.497204724,0.497440945,0.289960630,1,1
6.325266,7,4,2,3,5,3,0,0.497677165,0.497913386,0.289488189,1,1
6.330353,7,4,2,3,5,3,0,0.497992126,0.498228346,0.289173228,1,1
6.335445,7,4,2,3,5,3,0,0.498385827,0.498622047,0.288779528,1,1
6.340532,7,4,2,3,5,3,0,0.498858268,0.499094488,0.288307087,1,1
6.345619,7,4,2,3,5,3,0,0.499251969,0.499488189,0.287913386,1,1
6.350706,7,4,2,3,5,3,0,0.499566929,0.499803150,0.287598425,1,1
6.355795,7,4,2,3,5,3,0,0.500039370,0.500275591,0.287125984,1,1
6.360886,7,4,2,3,5,3,0,0.500433071,0.500669291,0.286732283,1,1
6.365987,7,4,2,3,5,3,0,0.500826772,0.501062992,0.286338583,1,1
6.371089,7,4,2,3,5,3,0,0.501220472,0.501456693,0.285944882,1,1
6.376177,7,4,2,3,5,3,0,0.501614173,0.501850394,0.285551181,1,1
6.381264,7,4,2,3,5,3,0,0.502007874,0.502244094,0.285157480,1,1
6.386355,7,4,2,3,5,3,0,0.502480315,0.502716535,0.284685039,1,1
6.391469,7,4,2,3,5,3,0,0.502874016,0.503110236,0.284291339,1,1
6.396557,7,4,2,3,5,3,0,0.503188976,0.503425197,0.283976378,1,1
6.401641,7,4,2,3,5,3,0,0.503582677,0.503818898,0.283582677,1,1
6.406728,7,4,2,3,5,3,0,0.504055118,0.504291339,0.283110236,1,1
6.411819,7,4,2,3,5,3,0,0.504448819,0.504685039,0.282716535,1,1
6.416913,7,4,2,3,5,3,0,0.504842520,0.505078740,0.282322835,1,1
6.422002,7,4,2,3,5,3,0,0.505236220,0.505472441,0.281929134,1,1
6.427092,7,4,2,3,5,3,0,0.505629921,0.505866142,0.281535433,1,1
6.432178,7,4,2,3,5,3,0,0.506023622,0.506259843,0.281141732,1,1
6.437271,7,4,2,3,5,3,0,0.506496063,0.506732283,0.280669291,1,1
6.442362,7,4,2,3,5,3,0,0.506811024,0.507047244,0.280354331,1,1
6.447452,7,4,2,3,5,3,0,0.507204724,0.507440945,0.279960630,1,1
6.452539,7,4,2,3,5,3,0,0.507677165,0.507913386,0.279488189,1,1
6.457625,7,4,2,3,5,3,0,0.508070866,0.508307087,0.279094488,1,1
6.462711,7,4,2,3,5,3,0,0.508385827,0.508622047,0.278779528,1,1
6.467798,7,4,2,3,5,3,0,0.508858268,0.509094488,0.278307087,1,1
6.472883,7,4,2,3,5,3,0,0.509251969,0.509488189,0.277913386,1,1
6.477968,7,4,2,3,5,3,0,0.509645669,0.509881890,0.277519685,1,1
6.483051,7,4,2,3,5,3,0,0.510039370,0.510275591,0.277125984,1,1
6.488141,7,4,2,3,5,3,0,0.510433071,0.510669291,0.276732283,1,1
6.493225,7,4,2,3,5,3,0,0.510826772,0.511062992,0.276338583,1,1
6.498314,7,4,2,3,5,3,0,0.511299213,0.511535433,0.275866142,1,1
6.503401,7,4,2,3,5,3,0,0.511614173,0.511850394,0.275551181,1,1
6.508486,7,4,2,3,5,3,0,0.512007874,0.512244094,0.275157480,1,1
6.513572,7,4,2,3,5,3,0,0.512480315,0.512716535,0.274685039,1,1
6.518660,7,4,2,3,5,3,0,0.512874016,0.513110236,0.274291339,1,1
6.523746,7,4,2,3,5,3,0,0.513188976,0.513425197,0.273976378,1,1
6.528845,7,4,2,3,5,3,0,0.513661417,0.513897638,0.273503937,1,1
6.533953,7,4,2,3,5,3,0,0.514055118,0.514291339,0.273110236,1,1
6.539044,7,4,2,3,5,3,0,0.514448819,0.514685039,0.272716535,1,1
6.544129,7,4,2,3,5,3,0,0.514921260,0.515157480,0.272244094,1,1
6.549214,7,4,2,3,5,3,0,0.515236220,0.515472441,0.271929134,1,1
6.554298,7,4,2,3,5,3,0,0.515629921,0.515866142,0.271535433,1,1
6.559384,7,4,2,3,5,3,0,0.516102362,0.516338583,0.271062992,1,1
6.564475,7,4,2,3,5,3,0,0.516496063,0.516732283,0.270669291,1,1
6.569562,7,4,2,3,5,3,0,0.516811024,0.517047244,0.270354331,1,1
6.574652,7,4,2,3,5,3,0,0.517283465,0.517519685,0.269881890,1,1
6.579739,7,4,2,3,5,3,0,0.517677165,0.517913386,0.269488189,1,1
6.584824,7,4,2,3,5,3,0,0.518070866,0.518307087,0.269094488,1,1
6.589917,7,4,2,3,5,3,0,0.518385827,0.518622047,0.268779528,1,1
6.595002,7,4,2,3,5,3,0,0.518858268,0.519094488,0.268307087,1,1
6.600088,7,4,2,3,5,3,0,0.519251969,0.519488189,0.267913386,1,1
6.605170,7,4,2,3,5,3,0,0.519724409,0.519960630,0.267440945,1,1
6.610256,7,4,2,3,5,3,0,0.520039370,0.520275591,0.267125984,1,1
6.615342,7,4,2,3,5,3,0,0.520433071,0.520669291,0.266732283,1,1
6.620430,7,4,2,3,5,3,0,0.520826772,0.521062992,0.266338583,1,1
6.625520,7,4,2,3,5,3,0,0.521299213,0.521535433,0.265866142,1,1
6.630610,7,4,2,3,5,3,0,0.521692913,0.521929134,0.265472441,1,1
6.635697,7,4,2,3,5,3,0,0.522007874,0.522244094,0.265157480,1,1
6.640791,7,4,2,3,5,3,0,0.522480315,0.522716535,0.264685039,1,1
6.645880,7,4,2,3,5,3,0,0.522874016,0.523110236,0.264291339,1,1
6.650972,7,4,2,3,5,3,0,0.523267717,0.523503937,0.263897638,1,1
6.656072,7,4,2,3,5,3,0,0.523661417,0.523897638,0.263503937,1,1
6.661158,7,4,2,3,5,3,0,0.524055118,0.524291339,0.263110236,1,1
6.666243,7,4,2,3,5,3,0,0.524448819,0.524685039,0.262716535,1,1
6.671328,7,4,2,3,5,3,0,0.524921260,0.525157480,0.262244094,1,1
6.676414,7,4,2,3,5,3,0,0.525236220,0.525472441,0.261929134,1,1
6.681500,7,4,2,3,5,3,0,0.525629921,0.525866142,0.261535433,1,1
6.686584,7,4,2,3,5,3,0,0.526102362,0.526338583,0.261062992,1,1
6.691674,7,4,2,3,5,3,0,0.526496063,0.526732283,0.260669291,1,1
6.696763,7,4,2,3,5,3,0,0.526811024,0.527047244,0.260354331,1,1
6.701849,7,4,2,3,5,3,0,0.527283465,0.527519685,0.259881890,1,1
6.706937,7,4,2,3,5,3,0,0.527677165,0.527913386,0.259488189,1,1
6.712024,7,4,2,3,5,3,0,0.528070866,0.528307087,0.259094488,1,1
6.717111,7,4,2,3,5,3,0,0.528543307,0.528779528,0.258622047,1,1
6.722196,7,4,2,3,5,3,0,0.528858268,0.529094488,0.258307087,1,1
6.727281,7,4,2,3,5,3,0,0.529251969,0.529488189,0.257913386,1,1
6.732367,7,4,2,3,5,3,0,0.529724409,0.529960630,0.257440945,1,1
6.737453,7,4,2,3,5,3,0,0.530118110,0.530354331,0.257047244,1,1
6.742544,7,4,2,3,5,3,0,0.530433071,0.530669291,0.256732283,1,1
6.747630,7,4,2,3,5,3,0,0.530826772,0.531062992,0.256338583,1,1
6.752716,7,4,2,3,5,3,0,0.531299213,0.531535433,0.255866142,1,1
6.757809,7,4,2,3,5,3,0,0.531692913,0.531929134,0.255472441,1,1
6.762894,7,4,2,3,5,3,0,0.532007874,0.532244094,0.255157480,1,1
6.767985,7,4,2,3,5,3,0,0.532480315,0.532716535,0.254685039,1,1
6.773078,7,4,2,3,5,3,0,0.532874016,0.533110236,0.254291339,1,1
6.778164,7,4,2,3,5,3,0,0.533267717,0.533503937,0.253897638,1,1
6.783297,7,4,2,3,5,3,0,0.533740157,0.533976378,0.253425197,1,1
6.788387,7,4,2,3,5,3,0,0.534055118,0.534291339,0.253110236,1,1
6.793480,7,4,2,3,5,3,0,0.534448819,0.534685039,0.252716535,1,1
6.798567,7,4,2,3,5,3,0,0.534921260,0.535157480,0.252244094,1,1
6.803655,7,4,2,3,5,3,0,0.535314961,0.535551181,0.251850394,1,1
6.808740,7,4,2,3,5,3,0,0.535629921,0.535866142,0.251535433,1,1
6.813826,7,4,2,3,5,3,0,0.536102362,0.536338583,0.251062992,1,1
6.818911,7,4,2,3,5,3,0,0.536496063,0.536732283,0.250669291,1,1
6.824001,7,4,2,3,5,3,0,0.536889764,0.537125984,0.250275591,1,1
6.829085,7,4,2,3,5,3,0,0.537283465,0.537519685,0.249881890,1,1
6.834170,7,4,2,3,5,3,0,0.537677165,0.537913386,0.249488189,1,1
6.839255,7,4,2,3,5,3,0,0.538070866,0.538307087,0.249094488,1,1
6.844353,7,4,2,3,5,3,0,0.538543307,0.538779528,0.248622047,1,1
6.849439,7,4,2,3,5,3,0,0.538858268,0.539094488,0.248307087,1,1
6.854522,7,4,2,3,5,3,0,0.539251969,0.539488189,0.247913386,1,1
6.859608,7,4,2,3,5,3,0,0.539724409,0.539960630,0.247440945,1,1
6.864693,7,4,2,3,5,3,0,0.540118110,0.540354331,0.247047244,1,1
6.869778,7,4,2,3,5,3,0,0.540511811,0.540748031,0.246653543,1,1
6.874864,7,4,2,3,5,3,0,0.540905512,0.541141732,0.246259843,1,1
6.879951,7,4,2,3,5,3,0,0.541299213,0.541535433,0.245866142,1,1
6.885051,7,4,2,3,5,3,0,0.541692913,0.541929134,0.245472441,1,1
6.890142,7,4,2,3,5,3,0,0.542165354,0.542401575,0.245000000,1,1
6.895231,7,4,2,3,5,3,0,0.542480315,0.542716535,0.244685039,1,1
6.900320,7,4,2,3,5,3,0,0.542874016,0.543110236,0.244291339,1,1
6.905403,7,4,2,3,5,3,0,0.543346457,0.543582677,0.243818898,1,1
6.910490,7,4,2,3,5,3,0,0.543740157,0.543976378,0.243425197,1,1
6.915580,7,4,2,3,5,3,0,0.544055118,0.544291339,0.243110236,1,1
6.920665,7,4,2,3,5,3,0,0.544448819,0.544685039,0.242716535,1,1
6.925753,7,4,2,3,5,3,0,0.544921260,0.545157480,0.242244094,1,1
6.930838,7,4,2,3,5,3,0,0.545314961,0.545551181,0.241850394,1,1
6.935922,7,4,2,3,5,3,0,0.545629921,0.545866142,0.241535433,1,1
6.941010,7,4,2,3,5,3,0,0.546102362,0.546338583,0.241062992,1,1
6.946100,7,4,2,3,5,3,0,0.546496063,0.546732283,0.240669291,1,1
6.951186,7,4,2,3,5,3,0,0.546889764,0.547125984,0.240275591,1,1
6.956276,7,4,2,3,5,3,0,0.547362205,0.547598425,0.239803150,1,1
6.961366,7,4,2,3,5,3,0,0.547677165,0.547913386,0.239488189,1,1
6.966453,7,4,2,3,5,3,0,0.548070866,0.548307087,0.239094488,1,1
6.971540,7,4,2,3,5,3,0,0.548543307,0.548779528,0.238622047,1,1
6.976628,7,4,2,3,5,3,0,0.548937008,0.549173228,0.238228346,1,1
6.981716,7,4,2,3,5,3,0,0.549251969,0.549488189,0.237913386,1,1
6.986802,7,4,2,3,5,3,0,0.549724409,0.549960630,0.237440945,1,1
6.991893,7,4,2,3,5,3,0,0.550118110,0.550354331,0.237047244,1,1
6.996990,7,4,2,3,5,3,0,0.550511811,0.550748031,0.236653543,1,1
7.002079,7,4,2,3,5,3,0,0.550905512,0.551141732,0.236259843,1,1
7.007164,7,4,2,3,5,3,0,0.551299213,0.551535433,0.235866142,1,1
7.012249,7,4,2,3,5,3,0,0.551692913,0.551929134,0.235472441,1,1
7.017338,7,4,2,3,5,3,0,0.552165354,0.552401575,0.235000000,1,1
7.022426,7,4,2,3,5,3,0,0.552480315,0.552716535,0.234685039,1,1
7.027510,7,4,2,3,5,3,0,0.552874016,0.553110236,0.234291339,1,1
7.032595,7,4,2,3,5,3,0,0.553346457,0.553582677,0.233818898,1,1
7.037680,7,4,2,3,5,3,0,0.553740157,0.553976378,0.233425197,1,1
7.042764,7,4,2,3,5,3,0,0.554133858,0.554370079,0.233031496,1,1
7.047854,7,4,2,3,5,3,0,0.554527559,0.554763780,0.232637795,1,1
7.052940,7,4,2,3,5,3,0,0.554921260,0.555157480,0.232244094,1,1
7.058027,7,4,2,3,5,3,0,0.555314961,0.555551181,0.231850394,1,1
7.063112,7,4,2,3,5,3,0,0.555787402,0.556023622,0.231377953,1,1
7.068197,7,4,2,3,5,3,0,0.556102362,0.556338583,0.231062992,1,1
7.073281,7,4,2,3,5,3,0,0.556496063,0.556732283,0.230669291,1,1
7.078366,7,4,2,3,5,3,0,0.556968504,0.557204724,0.230196850,1,1
7.083457,7,4,2,3,5,3,0,0.557362205,0.557598425,0.229803150,1,1
7.088545,7,4,2,3,5,3,0,0.557677165,0.557913386,0.229488189,1,1
7.093630,7,4,2,3,5,3,0,0.558070866,0.558307087,0.229094488,1,1
7.098720,7,4,2,3,5,3,0,0.558543307,0.558779528,0.228622047,1,1
7.103805,7,4,2,3,5,3,0,0.558937008,0.559173228,0.228228346,1,1
7.108892,7,4,2,3,5,3,0,0.559251969,0.559488189,0.227913386,1,1
7.113984,7,4,2,3,5,3,0,0.559724409,0.559960630,0.227440945,1,1
7.119076,7,4,2,3,5,3,0,0.560118110,0.560354331,0.227047244,1,1
7.124164,7,4,2,3,5,3,0,0.560511811,0.560748031,0.226653543,1,1
7.129251,7,4,2,3,5,3,0,0.560984252,0.561220472,0.226181102,1,1
7.134339,7,4,2,3,5,3,0,0.561299213,0.561535433,0.225866142,1,1
7.139421,7,4,2,3,5,3,0,0.561692913,0.561929134,0.225472441,1,1
7.144511,7,4,2,3,5,3,0,0.562165354,0.562401575,0.225000000,1,1
7.149607,7,4,2,3,5,3,0,0.562559055,0.562795276,0.224606299,1,1
7.154696,7,4,2,3,5,3,0,0.562874016,0.563110236,0.224291339,1,1
7.159784,7,4,2,3,5,3,0,0.563346457,0.563582677,0.223818898,1,1
7.164871,7,4,2,3,5,3,0,0.563740157,0.563976378,0.223425197,1,1
7.169958,7,4,2,3,5,3,0,0.564133858,0.564370079,0.223031496,1,1
7.175057,7,4,2,3,5,3,0,0.564527559,0.564763780,0.222637795,1,1
7.180144,7,4,2,3,5,3,0,0.564921260,0.565157480,0.222244094,1,1
7.185252,7,4,2,3,5,3,0,0.565314961,0.565551181,0.221850394,1,1
7.190341,7,4,2,3,5,3,0,0.565787402,0.566023622,0.221377953,1,1
7.195429,7,4,2,3,5,3,0,0.566102362,0.566338583,0.221062992,1,1
7.200523,7,4,2,3,5,3,0,0.566496063,0.566732283,0.220669291,1,1
7.205610,7,4,2,3,5,3,0,0.566968504,0.567204724,0.220196850,1,1
7.210699,7,4,2,3,5,3,0,0.567362205,0.567598425,0.219803150,1,1
7.215785,7,4,2,3,5,3,0,0.567755906,0.567992126,0.219409449,1,1
7.220870,7,4,2,3,5,3,0,0.568070866,0.568307087,0.219094488,1,1
7.225955,7,4,2,3,5,3,0,0.568543307,0.568779528,0.218622047,1,1
7.231051,7,4,2,3,5,3,0,0.568937008,0.569173228,0.218228346,1,1
7.236136,7,4,2,3,5,3,0,0.569330709,0.569566929,0.217834646,1,1
7.241221,7,4,2,3,5,3,0,0.569724409,0.569960630,0.217440945,1,1
7.246305,7,4,2,3,5,3,0,0.570118110,0.570354331,0.217047244,1,1
7.251392,7,4,2,3,5,3,0,0.570511811,0.570748031,0.216653543,1,1
7.256483,7,4,2,3,5,3,0,0.570984252,0.571220472,0.216181102,1,1
7.261569,7,4,2,3,5,3,0,0.571377953,0.571614173,0.215787402,1,1
7.266654,7,4,2,3,5,3,0,0.571692913,0.571929134,0.215472441,1,1
7.271739,7,4,2,3,5,3,0,0.572165354,0.572401575,0.215000000,1,1
7.276829,7,4,2,3,5,3,0,0.572559055,0.572795276,0.214606299,1,1
7.281917,7,4,2,3,5,3,0,0.572952756,0.573188976,0.214212598,1,1
7.287017,7,4,2,3,5,3,0,0.573346457,0.573582677,0.213818898,1,1
7.292107,7,4,2,3,5,3,0,0.573740157,0.573976378,0.213425197,1,1
7.297195,7,4,2,3,5,3,0,0.574133858,0.574370079,0.213031496,1,1
7.302283,7,4,2,3,5,3,0,0.574606299,0.574842520,0.212559055,1,1
7.307370,7,4,2,3,5,3,0,0.575000000,0.575236220,0.212165354,1,1
7.312458,7,4,2,3,5,3,0,0.575314961,0.575551181,0.211850394,1,1
7.317545,7,4,2,3,5,3,0,0.575708661,0.575944882,0.211456693,1,1
7.322631,7,4,2,3,5,3,0,0.576181102,0.576417323,0.210984252,1,1
7.327718,7,4,2,3,5,3,0,0.576574803,0.576811024,0.210590551,1,1
7.332805,7,4,2,3,5,3,0,0.576889764,0.577125984,0.210275591,1,1
7.337894,7,4,2,3,5,3,0,0.577362205,0.577598425,0.209803150,1,1
7.342997,7,4,2,3,5,3,0,0.577755906,0.577992126,0.209409449,1,1
7.348086,7,4,2,3,5,3,0,0.578149606,0.578385827,0.209015748,1,1
7.353175,7,4,2,3,5,3,0,0.578543307,0.578779528,0.208622047,1,1
7.358264,7,4,2,3,5,3,0,0.578937008,0.579173228,0.208228346,1,1
7.363350,7,4,2,3,5,3,0,0.579330709,0.579566929,0.207834646,1,1
7.368438,7,4,2,3,5,3,0,0.579803150,0.580039370,0.207362205,1,1
7.373525,7,4,2,3,5,3,0,0.580196850,0.580433071,0.206968504,1,1
7.378611,7,4,2,3,5,3,0,0.580511811,0.580748031,0.206653543,1,1
7.383701,7,4,2,3,5,3,0,0.580984252,0.581220472,0.206181102,1,1
7.388786,7,4,2,3,5,3,0,0.581377953,0.581614173,0.205787402,1,1
7.393873,7,4,2,3,5,3,0,0.581771654,0.582007874,0.205393701,1,1
7.398960,7,4,2,3,5,3,0,0.582165354,0.582401575,0.205000000,1,1
7.404060,7,4,2,3,5,3,0,0.582559055,0.582795276,0.204606299,1,1
7.409157,7,4,2,3,5,3,0,0.582952756,0.583188976,0.204212598,1,1
7.414244,7,4,2,3,5,3,0,0.583425197,0.583661417,0.203740157,1,1
7.419329,7,4,2,3,5,3,0,0.583740157,0.583976378,0.203425197,1,1
7.424415,7,4,2,3,5,3,0,0.584133858,0.584370079,0.203031496,1,1
7.429500,7,4,2,3,5,3,0,0.584606299,0.584842520,0.202559055,1,1
7.434587,7,4,2,3,5,3,0,0.585000000,0.585236220,0.202165354,1,1
7.439675,7,4,2,3,5,3,0,0.585314961,0.585551181,0.201850394,1,1
7.444767,7,4,2,3,5,3,0,0.585708661,0.585944882,0.201456693,1,1
7.449856,7,4,2,3,5,3,0,0.586181102,0.586417323,0.200984252,1,1
7.454948,7,4,2,3,5,3,0,0.586574803,0.586811024,0.200590551,1,1
7.460040,7,4,2,3,5,3,0,0.586968504,0.587204724,0.200196850,1,1
7.465127,7,4,2,3,5,3,0,0.587362205,0.587598425,0.199803150,1,1
7.470213,7,4,2,3,5,3,0,0.587755906,0.587992126,0.199409449,1,1
7.475304,7,4,2,3,5,3,0,0.588149606,0.588385827,0.199015748,1,1
7.480389,7,4,2,3,5,3,0,0.588622047,0.588858268,0.198543307,1,1
7.485477,7,4,2,3,5,3,0,0.588937008,0.589173228,0.198228346,1,1
7.490562,7,4,2,3,5,3,0,0.589330709,0.589566929,0.197834646,1,1
7.495648,7,4,2,3,5,3,0,0.589803150,0.590039370,0.197362205,1,1
7.500734,7,4,2,3,5,3,0,0.590196850,0.590433071,0.196968504,1,1
7.505825,7,4,2,3,5,3,0,0.590511811,0.590748031,0.196653543,1,1
7.510910,7,4,2,3,5,3,0,0.590984252,0.591220472,0.196181102,1,1
7.515998,7,4,2,3,5,3,0,0.591377953,0.591614173,0.195787402,1,1
7.521083,7,4,2,3,5,3,0,0.591771654,0.592007874,0.195393701,1,1
7.526168,7,4,2,3,5,3,0,0.592244094,0.592480315,0.194921260,1,1
7.531265,7,4,2,3,5,3,0,0.592559055,0.592795276,0.194606299,1,1
7.536355,7,4,2,3,5,3,0,0.592952756,0.593188976,0.194212598,1,1
7.541440,7,4,2,3,5,3,0,0.593425197,0.593661417,0.193740157,1,1
7.546528,7,4,2,3,5,3,0,0.593818898,0.594055118,0.193346457,1,1
7.551622,7,4,2,3,5,3,0,0.594133858,0.594370079,0.193031496,1,1
7.556719,7,4,2,3,5,3,0,0.594606299,0.594842520,0.192559055,1,1
7.561807,7,4,2,3,5,3,0,0.595000000,0.595236220,0.192165354,1,1
7.566896,7,4,2,3,5,3,0,0.595393701,0.595629921,0.191771654,1,1
7.571988,7,4,2,3,5,3,0,0.595787402,0.596023622,0.191377953,1,1
7.577082,7,4,2,3,5,3,0,0.596181102,0.596417323,0.190984252,1,1
7.582168,7,4,2,3,5,3,0,0.596574803,0.596811024,0.190590551,1,1
7.587253,7,4,2,3,5,3,0,0.597047244,0.597283465,0.190118110,1,1
7.592338,7,4,2,3,5,3,0,0.597362205,0.597598425,0.189803150,1,1
7.597424,7,4,2,3,5,3,0,0.597755906,0.597992126,0.189409449,1,1
7.602514,7,4,2,3,5,3,0,0.598149606,0.598385827,0.189015748,1,1
7.607607,7,4,2,3,5,3,0,0.598622047,0.598858268,0.188543307,1,1
7.612697,7,4,2,3,5,3,0,0.599015748,0.599251969,0.188149606,1,1
7.617792,7,4,2,3,5,3,0,0.599330709,0.599566929,0.187834646,1,1
7.622882,7,4,2,3,5,3,0,0.599803150,0.600039370,0.187362205,1,1
7.627981,7,4,2,3,5,3,0,0.600196850,0.600433071,0.186968504,1,1
7.633081,7,4,2,3,5,3,0,0.600590551,0.600826772,0.186574803,1,1
7.638169,7,4,2,3,5,3,0,0.600984252,0.601220472,0.186181102,1,1
7.643259,7,4,2,3,5,3,0,0.601377953,0.601614173,0.185787402,1,1
7.648347,7,4,2,3,5,3,0,0.601771654,0.602007874,0.185393701,1,1
7.653435,7,4,2,3,5,3,0,0.602244094,0.602480315,0.184921260,1,1
7.658535,7,4,2,3,5,3,0,0.602559055,0.602795276,0.184606299,1,1
7.663630,7,4,2,3,5,3,0,0.602952756,0.603188976,0.184212598,1,1
7.668722,7,4,2,3,5,3,0,0.603425197,0.603661417,0.183740157,1,1
7.673808,7,4,2,3,5,3,0,0.603818898,0.604055118,0.183346457,1,1
7.678895,7,4,2,3,5,3,0,0.604212598,0.604448819,0.182952756,1,1
7.683982,7,4,2,3,5,3,0,0.604606299,0.604842520,0.182559055,1,1
7.689069,7,4,2,3,5,3,0,0.605000000,0.605236220,0.182165354,1,1
7.694156,7,4,2,3,5,3,0,0.605393701,0.605629921,0.181771654,1,1
7.699242,7,4,2,3,5,3,0,0.605866142,0.606102362,0.181299213,1,1
7.704329,7,4,2,3,5,3,0,0.606181102,0.606417323,0.180984252,1,1
7.709421,7,4,2,3,5,3,0,0.606574803,0.606811024,0.180590551,1,1
7.714508,7,4,2,3,5,3,0,0.607047244,0.607283465,0.180118110,1,1
7.719595,7,4,2,3,5,3,0,0.607440945,0.607677165,0.179724409,1,1
7.724683,7,4,2,3,5,3,0,0.607755906,0.607992126,0.179409449,1,1
7.729770,7,4,2,3,5,3,0,0.608228346,0.608464567,0.178937008,1,1
7.734861,7,4,2,3,5,3,0,0.608622047,0.608858268,0.178543307,1,1
7.739949,7,4,2,3,5,3,0,0.609015748,0.609251969,0.178149606,1,1
7.745042,7,4,2,3,5,3,0,0.609409449,0.609645669,0.177755906,1,1
7.750130,7,4,2,3,5,3,0,0.609803150,0.610039370,0.177362205,1,1
7.755216,7,4,2,3,5,3,0,0.610196850,0.610433071,0.176968504,1,1
7.760306,7,4,2,3,5,3,0,0.610669291,0.610905512,0.176496063,1,1
7.765391,7,4,2,3,5,3,0,0.611062992,0.611299213,0.176102362,1,1
7.770477,7,4,2,3,5,3,0,0.611377953,0.611614173,0.175787402,1,1
7.775562,7,4,2,3,5,3,0,0.611771654,0.612007874,0.175393701,1,1
7.780647,7,4,2,3,5,3,0,0.612244094,0.612480315,0.174921260,1,1
7.785733,7,4,2,3,5,3,0,0.612637795,0.612874016,0.174527559,1,1
7.790824,7,4,2,3,5,3,0,0.612952756,0.613188976,0.174212598,1,1
7.795917,7,4,2,3,5,3,0,0.613425197,0.613661417,0.173740157,1,1
7.801004,7,4,2,3,5,3,0,0.613818898,0.614055118,0.173346457,1,1
7.806095,7,4,2,3,5,3,0,0.614212598,0.614448819,0.172952756,1,1
7.811187,7,4,2,3,5,3,0,0.614606299,0.614842520,0.172559055,1,1
7.816276,7,4,2,3,5,3,0,0.615000000,0.615236220,0.172165354,1,1
7.821368,7,4,2,3,5,3,0,0.615393701,0.615629921,0.171771654,1,1
7.826457,7,4,2,3,5,3,0,0.615866142,0.616102362,0.171299213,1,1
7.831545,7,4,2,3,5,3,0,0.616181102,0.616417323,0.170984252,1,1
7.836655,7,4,2,3,5,3,0,0.616574803,0.616811024,0.170590551,1,1
7.841742,7,4,2,3,5,3,0,0.617047244,0.617283465,0.170118110,1,1
7.846831,7,4,2,3,5,3,0,0.617440945,0.617677165,0.169724409,1,1
7.851918,7,4,2,3,5,3,0,0.617834646,0.618070866,0.169330709,1,1
7.857006,7,4,2,3,5,3,0,0.618228346,0.618464567,0.168937008,1,1
7.862098,7,4,2,3,5,3,0,0.618622047,0.618858268,0.168543307,1,1
7.867188,7,4,2,3,5,3,0,0.619015748,0.619251969,0.168149606,1,1
7.872276,7,4,2,3,5,3,0,0.619488189,0.619724409,0.167677165,1,1
7.877363,7,4,2,3,5,3,0,0.619803150,0.620039370,0.167362205,1,1
7.882452,7,4,2,3,5,3,0,0.620196850,0.620433071,0.166968504,1,1
7.887538,7,4,2,3,5,3,0,0.620669291,0.620905512,0.166496063,1,1
7.892623,7,4,2,3,5,3,0,0.621062992,0.621299213,0.166102362,1,1
7.897709,7,4,2,3,5,3,0,0.621377953,0.621614173,0.165787402,1,1
7.902795,7,4,2,3,5,3,0,0.621850394,0.622086614,0.165314961,1,1
7.907886,7,4,2,3,5,3,0,0.622244094,0.622480315,0.164921260,1,1
7.912981,7,4,2,3,5,3,0,0.622637795,0.622874016,0.164527559,1,1
7.918074,7,4,2,3,5,3,0,0.623110236,0.623346457,0.164055118,1,1
7.923165,7,4,2,3,5,3,0,0.623425197,0.623661417,0.163740157,1,1
7.928255,7,4,2,3,5,3,0,0.623818898,0.624055118,0.163346457,1,1
7.933341,7,4,2,3,5,3,0,0.624291339,0.624527559,0.162874016,1,1
7.938426,7,4,2,3,5,3,0,0.624685039,0.624921260,0.162480315,1,1
7.943515,7,4,2,3,5,3,0,0.625000000,0.625236220,0.162165354,1,1
7.948604,7,4,2,3,5,3,0,0.625393701,0.625629921,0.161771654,1,1
7.953690,7,4,2,3,5,3,0,0.625866142,0.626102362,0.161299213,1,1
7.958775,7,4,2,3,5,3,0,0.626259843,0.626496063,0.160905512,1,1
7.963865,7,4,2,3,5,3,0,0.626574803,0.626811024,0.160590551,1,1
7.968952,7,4,2,3,5,3,0,0.627047244,0.627283465,0.160118110,1,1
7.974047,7,4,2,3,5,3,0,0.627440945,0.627677165,0.159724409,1,1
7.979134,7,4,2,3,5,3,0,0.627834646,0.628070866,0.159330709,1,1
7.984221,7,4,2,3,5,3,0,0.628228346,0.628464567,0.158937008,1,1
7.989308,7,4,2,3,5,3,0,0.628622047,0.628858268,0.158543307,1,1
7.994399,7,4,2,3,5,3,0,0.629015748,0.629251969,0.158149606,1,1
7.999486,7,4,2,3,5,3,0,0.629488189,0.629724409,0.157677165,1,1
8.004573,7,4,2,3,5,3,0,0.629881890,0.630118110,0.157283465,1,1
8.009661,7,4,2,3,5,3,0,0.630196850,0.630433071,0.156968504,1,1
8.014748,7,4,2,3,5,3,0,0.630669291,0.630905512,0.156496063,1,1
8.019836,7,4,2,3,5,3,0,0.631062992,0.631299213,0.156102362,1,1
8.024923,7,4,2,3,5,3,0,0.631456693,0.631692913,0.155708661,1,1
8.030015,7,4,2,3,5,3,0,0.631850394,0.632086614,0.155314961,1,1
8.035102,7,4,2,3,5,3,0,0.632244094,0.632480315,0.154921260,1,1
8.040190,7,4,2,3,5,3,0,0.632637795,0.632874016,0.154527559,1,1
8.045277,7,4,2,3,5,3,0,0.633110236,0.633346457,0.154055118,1,1
8.050363,7,4,2,3,5,3,0,0.633425197,0.633661417,0.153740157,1,1
8.055455,7,4,2,3,5,3,0,0.633818898,0.634055118,0.153346457,1,1
8.060541,7,4,2,3,5,3,0,0.634291339,0.634527559,0.152874016,1,1
8.065630,7,4,2,3,5,3,0,0.634685039,0.634921260,0.152480315,1,1
8.070717,7,4,2,3,5,3,0,0.635000000,0.635236220,0.152165354,1,1
8.075803,7,4,2,3,5,3,0,0.635472441,0.635708661,0.151692913,1,1
8.080889,7,4,2,3,5,3,0,0.635866142,0.636102362,0.151299213,1,1
8.085982,7,4,2,3,5,3,0,0.636259843,0.636496063,0.150905512,1,1
8.091075,7,4,2,3,5,3,0,0.636732283,0.636968504,0.150433071,1,1
8.096160,7,4,2,3,5,3,0,0.637047244,0.637283465,0.150118110,1,1
8.101245,7,4,2,3,5,3,0,0.637440945,0.637677165,0.149724409,1,1
8.106331,7,4,2,3,5,3,0,0.637834646,0.638070866,0.149330709,1,1
8.111418,7,4,2,3,5,3,0,0.638307087,0.638543307,0.148858268,1,1
8.116508,7,4,2,3,5,3,0,0.638622047,0.638858268,0.148543307,1,1
8.121598,7,4,2,3,5,3,0,0.639015748,0.639251969,0.148149606,1,1
8.126687,7,4,2,3,5,3,0,0.639488189,0.639724409,0.147677165,1,1
8.131777,7,4,2,3,5,3,0,0.639881890,0.640118110,0.147283465,1,1
8.136869,7,4,2,3,5,3,0,0.640275591,0.640511811,0.146889764,1,1
8.141957,7,4,2,3,5,3,0,0.640669291,0.640905512,0.146496063,1,1
8.147055,7,4,2,3,5,3,0,0.641062992,0.641299213,0.146102362,1,1
8.152141,7,4,2,3,5,3,0,0.641456693,0.641692913,0.145708661,1,1
8.157228,7,4,2,3,5,3,0,0.641929134,0.642165354,0.145236220,1,1
8.162316,7,4,2,3,5,3,0,0.642244094,0.642480315,0.144921260,1,1
8.167409,7,4,2,3,5,3,0,0.642637795,0.642874016,0.144527559,1,1
8.172496,7,4,2,3,5,3,0,0.643110236,0.643346457,0.144055118,1,1
8.177583,7,4,2,3,5,3,0,0.643503937,0.643740157,0.143661417,1,1
8.182671,7,4,2,3,5,3,0,0.643818898,0.644055118,0.143346457,1,1
8.187763,7,4,2,3,5,3,0,0.644291339,0.644527559,0.142874016,1,1
8.192850,7,4,2,3,5,3,0,0.644685039,0.644921260,0.142480315,1,1
8.197937,7,4,2,3,5,3,0,0.645078740,0.645314961,0.142086614,1,1
8.203024,7,4,2,3,5,3,0,0.645472441,0.645708661,0.141692913,1,1
8.208112,7,4,2,3,5,3,0,0.645866142,0.646102362,0.141299213,1,1
8.213200,7,4,2,3,5,3,0,0.646259843,0.646496063,0.140905512,1,1
8.218291,7,4,2,3,5,3,0,0.646732283,0.646968504,0.140433071,1,1
8.223378,7,4,2,3,5,3,0,0.647125984,0.647362205,0.140039370,1,1
8.228467,7,4,2,3,5,3,0,0.647440945,0.647677165,0.139724409,1,1
8.233554,7,4,2,3,5,3,0,0.647834646,0.648070866,0.139330709,1,1
8.238645,7,4,2,3,5,3,0,0.648307087,0.648543307,0.138858268,1,1
8.243733,7,4,2,3,5,3,0,0.648700787,0.648937008,0.138464567,1,1
8.248821,7,4,2,3,5,3,0,0.649015748,0.649251969,0.138149606,1,1
8.253922,7,4,2,3,5,3,0,0.649488189,0.649724409,0.137677165,1,1
8.259008,7,4,2,3,5,3,0,0.649881890,0.650118110,0.137283465,1,1
8.264096,7,4,2,3,5,3,0,0.650275591,0.650511811,0.136889764,1,1
8.269188,7,4,2,3,5,3,0,0.650669291,0.650905512,0.136496063,1,1
8.274274,7,4,2,3,5,3,0,0.651062992,0.651299213,0.136102362,1,1
8.279359,7,4,2,3,5,3,0,0.651456693,0.651692913,0.135708661,1,1
8.284445,7,4,2,3,5,3,0,0.651929134,0.652165354,0.135236220,1,1
8.289530,7,4,2,3,5,3,0,0.652322835,0.652559055,0.134842520,1,1
8.294618,7,4,2,3,5,3,0,0.652637795,0.652874016,0.134527559,1,1
8.299710,7,4,2,3,5,3,0,0.653110236,0.653346457,0.134055118,1,1
8.304798,7,4,2,3,5,3,0,0.653503937,0.653740157,0.133661417,1,1
8.309886,7,4,2,3,5,3,0,0.653897638,0.654133858,0.133267717,1,1
8.314988,7,4,2,3,5,3,0,0.654291339,0.654527559,0.132874016,1,1
8.320085,7,4,2,3,5,3,0,0.654685039,0.654921260,0.132480315,1,1
8.325173,7,4,2,3,5,3,0,0.655078740,0.655314961,0.132086614,1,1
8.330259,7,4,2,3,5,3,0,0.655472441,0.655708661,0.131692913,1,1
8.335346,7,4,2,3,5,3,0,0.655944882,0.656181102,0.131220472,1,1
8.340433,7,4,2,3,5,3,0,0.656259843,0.656496063,0.130905512,1,1
8.345521,7,4,2,3,5,3,0,0.656653543,0.656889764,0.130511811,1,1
8.350609,7,4,2,3,5,3,0,0.657125984,0.657362205,0.130039370,1,1
8.355696,7,4,2,3,5,3,0,0.657519685,0.657755906,0.129645669,1,1
8.360784,7,4,2,3,5,3,0,0.657834646,0.658070866,0.129330709,1,1
8.365874,7,4,2,3,5,3,0,0.658307087,0.658543307,0.128858268,1,1
8.370970,7,4,2,3,5,3,0,0.658700787,0.658937008,0.128464567,1,1
8.376070,7,4,2,3,5,3,0,0.659094488,0.659330709,0.128070866,1,1
8.381162,7,4,2,3,5,3,0,0.659488189,0.659724409,0.127677165,1,1
8.386248,7,4,2,3,5,3,0,0.659881890,0.660118110,0.127283465,1,1
8.391335,7,4,2,3,5,3,0,0.660275591,0.660511811,0.126889764,1,1
8.396421,7,4,2,3,5,3,0,0.660748031,0.660984252,0.126417323,1,1
8.401506,7,4,2,3,5,3,0,0.661141732,0.661377953,0.126023622,1,1
8.406592,7,4,2,3,5,3,0,0.661456693,0.661692913,0.125708661,1,1
8.411677,7,4,2,3,5,3,0,0.661929134,0.662165354,0.125236220,1,1
8.416762,7,4,2,3,5,3,0,0.662322835,0.662559055,0.124842520,1,1
8.421851,7,4,2,3,5,3,0,0.662716535,0.662952756,0.124448819,1,1
8.426937,7,4,2,3,5,3,0,0.663110236,0.663346457,0.124055118,1,1
8.432021,7,4,2,3,5,3,0,0.663503937,0.663740157,0.123661417,1,1
8.437106,7,4,2,3,5,3,0,0.663897638,0.664133858,0.123267717,1,1
8.442196,7,4,2,3,5,3,0,0.664370079,0.664606299,0.122795276,1,1
8.447292,7,4,2,3,5,3,0,0.664685039,0.664921260,0.122480315,1,1
8.452381,7,4,2,3,5,3,0,0.665078740,0.665314961,0.122086614,1,1
8.457473,7,4,2,3,5,3,0,0.665551181,0.665787402,0.121614173,1,1
8.462562,7,4,2,3,5,3,0,0.665944882,0.666181102,0.121220472,1,1
8.467650,7,4,2,3,5,3,0,0.666259843,0.666496063,0.120905512,1,1
8.472741,7,4,2,3,5,3,0,0.666653543,0.666889764,0.120511811,1,1
8.477829,7,4,2,3,5,3,0,0.667125984,0.667362205,0.120039370,1,1
8.482916,7,4,2,3,5,3,0,0.667519685,0.667755906,0.119645669,1,1
8.488030,7,4,2,3,5,3,0,0.667913386,0.668149606,0.119251969,1,1
8.493118,7,4,2,3,5,3,0,0.668307087,0.668543307,0.118858268,1,1
8.498206,7,4,2,3,5,3,0,0.668700787,0.668937008,0.118464567,1,1
8.503294,7,4,2,3,5,3,0,0.669094488,0.669330709,0.118070866,1,1
8.508384,7,4,2,3,5,3,0,0.669566929,0.669803150,0.117598425,1,1
8.513472,7,4,2,3,5,3,0,0.669881890,0.670118110,0.117283465,1,1
8.518558,7,4,2,3,5,3,0,0.670275591,0.670511811,0.116889764,1,1
8.523648,7,4,2,3,5,3,0,0.670748031,0.670984252,0.116417323,1,1
8.528733,7,4,2,3,5,3,0,0.671141732,0.671377953,0.116023622,1,1
8.533819,7,4,2,3,5,3,0,0.671456693,0.671692913,0.115708661,1,1
8.538905,7,4,2,3,5,3,0,0.671929134,0.672165354,0.115236220,1,1
8.543996,7,4,2,3,5,3,0,0.672322835,0.672559055,0.114842520,1,1
8.549085,7,4,2,3,5,3,0,0.672716535,0.672952756,0.114448819,1,1
8.554179,7,4,2,3,5,3,0,0.673188976,0.673425197,0.113976378,1,1
8.559268,7,4,2,3,5,3,0,0.673503937,0.673740157,0.113661417,1,1
8.564357,7,4,2,3,5,3,0,0.673897638,0.674133858,0.113267717,1,1
8.569479,7,4,2,3,5,3,0,0.674370079,0.674606299,0.112795276,1,1
8.574627,7,4,2,3,5,3,0,0.674763780,0.675000000,0.112401575,1,1
8.579766,7,4,2,3,5,3,0,0.675157480,0.675393701,0.112007874,1,1
8.584907,7,4,2,3,5,3,0,0.675472441,0.675708661,0.111692913,1,1
8.590047,7,4,2,3,5,3,0,0.675944882,0.676181102,0.111220472,1,1
8.595187,7,4,2,3,5,3,0,0.676338583,0.676574803,0.110826772,1,1
8.600327,7,4,2,3,5,3,0,0.676732283,0.676968504,0.110433071,1,1
8.605463,7,4,2,3,5,3,0,0.677204724,0.677440945,0.109960630,1,1
8.610629,7,4,2,3,5,3,0,0.677598425,0.677834646,0.109566929,1,1
8.615770,7,4,2,3,5,3,0,0.677913386,0.678149606,0.109251969,1,1
8.620912,7,4,2,3,5,3,0,0.678385827,0.678622047,0.108779528,1,1
8.626057,7,4,2,3,5,3,0,0.678779528,0.679015748,0.108385827,1,1
8.631191,7,4,2,3,5,3,0,0.679173228,0.679409449,0.107992126,1,1
8.636291,7,4,2,3,5,3,0,0.679645669,0.679881890,0.107519685,1,1
8.641395,7,4,2,3,5,3,0,0.679960630,0.680196850,0.107204724,1,1
8.646489,7,4,2,3,5,3,0,0.680354331,0.680590551,0.106811024,1,1
8.651581,7,4,2,3,5,3,0,0.680826772,0.681062992,0.106338583,1,1
8.656674,7,4,2,3,5,3,0,0.681220472,0.681456693,0.105944882,1,1
8.661765,7,4,2,3,5,3,0,0.681535433,0.681771654,0.105629921,1,1
8.666854,7,4,2,3,5,3,0,0.682007874,0.682244094,0.105157480,1,1
8.671942,7,4,2,3,5,3,0,0.682401575,0.682637795,0.104763780,1,1
8.677035,7,4,2,3,5,3,0,0.682795276,0.683031496,0.104370079,1,1
8.682123,7,4,2,3,5,3,0,0.683188976,0.683425197,0.103976378,1,1
8.687210,7,4,2,3,5,3,0,0.683582677,0.683818898,0.103582677,1,1
8.692297,7,4,2,3,5,3,0,0.683976378,0.684212598,0.103188976,1,1
8.697385,7,4,2,3,5,3,0,0.684448819,0.684685039,0.102716535,1,1
8.702473,7,4,2,3,5,3,0,0.684763780,0.685000000,0.102401575,1,1
8.707576,7,4,2,3,5,3,0,0.685157480,0.685393701,0.102007874,1,1
8.712664,7,4,2,3,5,3,0,0.685629921,0.685866142,0.101535433,1,1
8.717752,7,4,2,3,5,3,0,0.686023622,0.686259843,0.101141732,1,1
8.722839,7,4,2,3,5,3,0,0.686417323,0.686653543,0.100748031,1,1
8.727931,7,4,2,3,5,3,0,0.686811024,0.687047244,0.100354331,1,1
8.733018,7,4,2,3,5,3,0,0.687204724,0.687440945,0.099960630,1,1
8.738105,7,4,2,3,5,3,0,0.687598425,0.687834646,0.099566929,1,1
8.743191,7,4,2,3,5,3,0,0.688070866,0.688307087,0.099094488,1,1
8.748278,7,4,2,3,5,3,0,0.688385827,0.688622047,0.098779528,1,1
8.753365,7,4,2,3,5,3,0,0.688779528,0.689015748,0.098385827,1,1
8.758453,7,4,2,3,5,3,0,0.689251969,0.689488189,0.097913386,1,1
8.763535,7,4,2,3,5,3,0,0.689645669,0.689881890,0.097519685,1,1
8.768619,7,4,2,3,5,3,0,0.689960630,0.690196850,0.097204724,1,1
8.773713,7,4,2,3,5,3,0,0.690433071,0.690669291,0.096732283,1,1
8.778806,7,4,2,3,5,3,0,0.690826772,0.691062992,0.096338583,1,1
8.783893,7,4,2,3,5,3,0,0.691220472,0.691456693,0.095944882,1,1
8.788982,7,4,2,3,5,3,0,0.691614173,0.691850394,0.095551181,1,1
8.794084,7,4,2,3,5,3,0,0.692007874,0.692244094,0.095157480,1,1
8.799171,7,4,2,3,5,3,0,0.692401575,0.692637795,0.094763780,1,1
8.804259,7,4,2,3,5,3,0,0.692795276,0.693031496,0.094370079,1,1
8.809346,7,4,2,3,5,3,0,0.693267717,0.693503937,0.093897638,1,1
8.814434,7,4,2,3,5,3,0,0.693582677,0.693818898,0.093582677,1,1
8.819522,7,4,2,3,5,3,0,0.693976378,0.694212598,0.093188976,1,1
8.824608,7,4,2,3,5,3,0,0.694448819,0.694685039,0.092716535,1,1
8.829701,7,4,2,3,5,3,0,0.694842520,0.695078740,0.092322835,1,1
8.834794,7,4,2,3,5,3,0,0.695157480,0.695393701,0.092007874,1,1
8.839881,7,4,2,3,5,3,0,0.695629921,0.695866142,0.091535433,1,1
8.844968,7,4,2,3,5,3,0,0.696023622,0.696259843,0.091141732,1,1
8.850055,7,4,2,3,5,3,0,0.696417323,0.696653543,0.090748031,1,1
8.855142,7,4,2,3,5,3,0,0.696811024,0.697047244,0.090354331,1,1
8.860228,7,4,2,3,5,3,0,0.697204724,0.697440945,0.089960630,1,1
8.865322,7,4,2,3,5,3,0,0.697598425,0.697834646,0.089566929,1,1
8.870410,7,4,2,3,5,3,0,0.698070866,0.698307087,0.089094488,1,1
8.875498,7,4,2,3,5,3,0,0.698385827,0.698622047,0.088779528,1,1
8.880597,7,4,2,3,5,3,0,0.698779528,0.699015748,0.088385827,1,1
8.885684,7,4,2,3,5,3,0,0.699251969,0.699488189,0.087913386,1,1
8.890769,7,4,2,3,5,3,0,0.699645669,0.699881890,0.087519685,1,1
8.895860,7,4,2,3,5,3,0,0.700039370,0.700275591,0.087125984,1,1
8.900960,7,4,2,3,5,3,0,0.700433071,0.700669291,0.086732283,1,1
8.906039,7,4,2,3,5,3,0,0.700826772,0.701062992,0.086338583,1,1
8.911135,7,4,2,3,5,3,0,0.701220472,0.701456693,0.085944882,1,1
8.916224,7,4,2,3,5,3,0,0.701692913,0.701929134,0.085472441,1,1
8.921310,7,4,2,3,5,3,0,0.702007874,0.702244094,0.085157480,1,1
8.926394,7,4,2,3,5,3,0,0.702401575,0.702637795,0.084763780,1,1
8.931481,7,4,2,3,5,3,0,0.702874016,0.703110236,0.084291339,1,1
8.936564,7,4,2,3,5,3,0,0.703267717,0.703503937,0.083897638,1,1
8.941650,7,4,2,3,5,3,0,0.703582677,0.703818898,0.083582677,1,1
8.946734,7,4,2,3,5,3,0,0.704055118,0.704291339,0.083110236,1,1
8.951815,7,4,2,3,5,3,0,0.704448819,0.704685039,0.082716535,1,1
8.956897,7,4,2,3,5,3,0,0.704842520,0.705078740,0.082322835,1,1
8.961984,7,4,2,3,5,3,0,0.705236220,0.705472441,0.081929134,1,1
8.967078,7,4,2,3,5,3,0,0.705629921,0.705866142,0.081535433,1,1
8.972164,7,4,2,3,5,3,0,0.706023622,0.706259843,0.081141732,1,1
8.977249,7,4,2,3,5,3,0,0.706496063,0.706732283,0.080669291,1,1
8.982338,7,4,2,3,5,3,0,0.706811024,0.707047244,0.080354331,1,1
8.987428,7,4,2,3,5,3,0,0.707204724,0.707440945,0.079960630,1,1
8.992514,7,4,2,3,5,3,0,0.707677165,0.707913386,0.079488189,1,1
8.997600,7,4,2,3,5,3,0,0.708070866,0.708307087,0.079094488,1,1
9.002689,7,4,2,3,5,3,0,0.708385827,0.708622047,0.078779528,1,1
9.007790,7,4,2,3,5,3,0,0.708779528,0.709015748,0.078385827,1,1
9.012875,7,4,2,3,5,3,0,0.709251969,0.709488189,0.077913386,1,1
9.017961,7,4,2,3,5,3,0,0.709645669,0.709881890,0.077519685,1,1
9.023047,7,4,2,3,5,3,0,0.710118110,0.710354331,0.077047244,1,1
9.028132,7,4,2,3,5,3,0,0.710433071,0.710669291,0.076732283,1,1
9.033227,7,4,2,3,5,3,0,0.710826772,0.711062992,0.076338583,1,1
9.038312,7,4,2,3,5,3,0,0.711220472,0.711456693,0.075944882,1,1
9.043398,7,4,2,3,5,3,0,0.711692913,0.711929134,0.075472441,1,1
9.048484,7,4,2,3,5,3,0,0.712007874,0.712244094,0.075157480,1,1
9.053569,7,4,2,3,5,3,0,0.712401575,0.712637795,0.074763780,1,1
9.058653,7,4,2,3,5,3,0,0.712874016,0.713110236,0.074291339,1,1
9.063740,7,4,2,3,5,3,0,0.713267717,0.713503937,0.073897638,1,1
9.068831,7,4,2,3,5,3,0,0.713582677,0.713818898,0.073582677,1,1
9.073916,7,4,2,3,5,3,0,0.714055118,0.714291339,0.073110236,1,1
9.079001,7,4,2,3,5,3,0,0.714448819,0.714685039,0.072716535,1,1
9.084091,7,4,2,3,5,3,0,0.714842520,0.715078740,0.072322835,1,1
9.089177,7,4,2,3,5,3,0,0.715236220,0.715472441,0.071929134,1,1
9.094277,7,4,2,3,5,3,0,0.715629921,0.715866142,0.071535433,1,1
9.099365,7,4,2,3,5,3,0,0.716023622,0.716259843,0.071141732,1,1
9.104451,7,4,2,3,5,3,0,0.716496063,0.716732283,0.070669291,1,1
9.109542,7,4,2,3,5,3,0,0.716889764,0.717125984,0.070275591,1,1
9.114633,7,4,2,3,5,3,0,0.717204724,0.717440945,0.069960630,1,1
9.119717,7,4,2,3,5,3,0,0.717677165,0.717913386,0.069488189,1,1
9.124801,7,4,2,3,5,3,0,0.718070866,0.718307087,0.069094488,1,1
9.129886,7,4,2,3,5,3,0,0.718464567,0.718700787,0.068700787,1,1
9.134978,7,4,2,3,5,3,0,0.718858268,0.719094488,0.068307087,1,1
9.140091,7,4,2,3,5,3,0,0.719251969,0.719488189,0.067913386,1,1
9.145180,7,4,2,3,5,3,0,0.719645669,0.719881890,0.067519685,1,1
9.150268,7,4,2,3,5,3,0,0.720118110,0.720354331,0.067047244,1,1
9.155354,7,4,2,3,5,3,0,0.720433071,0.720669291,0.066732283,1,1
9.160450,7,4,2,3,5,3,0,0.720826772,0.721062992,0.066338583,1,1
9.165538,7,4,2,3,5,3,0,0.721299213,0.721535433,0.065866142,1,1
9.170626,7,4,2,3,5,3,0,0.721692913,0.721929134,0.065472441,1,1
9.175713,7,4,2,3,5,3,0,0.722007874,0.722244094,0.065157480,1,1
9.180799,7,4,2,3,5,3,0,0.722480315,0.722716535,0.064685039,1,1
9.185890,7,4,2,3,5,3,0,0.722874016,0.723110236,0.064291339,1,1
9.190981,7,4,2,3,5,3,0,0.723267717,0.723503937,0.063897638,1,1
9.196081,7,4,2,3,5,3,0,0.723740157,0.723976378,0.063425197,1,1
9.201172,7,4,2,3,5,3,0,0.724055118,0.724291339,0.063110236,1,1
9.206263,7,4,2,3,5,3,0,0.724448819,0.724685039,0.062716535,1,1
9.211354,7,4,2,3,5,3,0,0.724921260,0.725157480,0.062244094,1,1
9.216444,7,4,2,3,5,3,0,0.725314961,0.725551181,0.061850394,1,1
9.221532,7,4,2,3,5,3,0,0.725629921,0.725866142,0.061535433,1,1
9.226624,7,4,2,3,5,3,0,0.726102362,0.726338583,0.061062992,1,1
9.231712,7,4,2,3,5,3,0,0.726496063,0.726732283,0.060669291,1,1
9.236802,7,4,2,3,5,3,0,0.726889764,0.727125984,0.060275591,1,1
9.241891,7,4,2,3,5,3,0,0.727204724,0.727440945,0.059960630,1,1
9.246987,7,4,2,3,5,3,0,0.727677165,0.727913386,0.059488189,1,1
9.252083,7,4,2,3,5,3,0,0.728070866,0.728307087,0.059094488,1,1
9.257171,7,4,2,3,5,3,0,0.728464567,0.728700787,0.058700787,1,1
9.262258,7,4,2,3,5,3,0,0.728858268,0.729094488,0.058307087,1,1
9.267344,7,4,2,3,5,3,0,0.729251969,0.729488189,0.057913386,1,1
9.272432,7,4,2,3,5,3,0,0.729645669,0.729881890,0.057519685,1,1
9.277523,7,4,2,3,5,3,0,0.730118110,0.730354331,0.057047244,1,1
9.282609,7,4,2,3,5,3,0,0.730511811,0.730748031,0.056653543,1,1
9.287700,7,4,2,3,5,3,0,0.730826772,0.731062992,0.056338583,1,1
9.292792,7,4,2,3,5,3,0,0.731299213,0.731535433,0.055866142,1,1
9.297879,7,4,2,3,5,3,0,0.731692913,0.731929134,0.055472441,1,1
9.302968,7,4,2,3,5,3,0,0.732086614,0.732322835,0.055078740,1,1
9.308065,7,4,2,3,5,3,0,0.732480315,0.732716535,0.054685039,1,1
9.313150,7,4,2,3,5,3,0,0.732874016,0.733110236,0.054291339,1,1
9.318235,7,4,2,3,5,3,0,0.733267717,0.733503937,0.053897638,1,1
9.323320,7,4,2,3,5,3,0,0.733740157,0.733976378,0.053425197,1,1
9.328404,7,4,2,3,5,3,0,0.734133858,0.734370079,0.053031496,1,1
9.333489,7,4,2,3,5,3,0,0.734448819,0.734685039,0.052716535,1,1
9.338578,7,4,2,3,5,3,0,0.734842520,0.735078740,0.052322835,1,1
9.343664,7,4,2,3,5,3,0,0.735314961,0.735551181,0.051850394,1,1
9.348749,7,4,2,3,5,3,0,0.735708661,0.735944882,0.051456693,1,1
9.353844,7,4,2,3,5,3,0,0.736023622,0.736259843,0.051141732,1,1
9.358932,7,4,2,3,5,3,0,0.736496063,0.736732283,0.050669291,1,1
9.364035,7,4,2,3,5,3,0,0.736889764,0.737125984,0.050275591,1,1
9.369122,7,4,2,3,5,3,0,0.737283465,0.737519685,0.049881890,1,1
9.374212,7,4,2,3,5,3,0,0.737677165,0.737913386,0.049488189,1,1
9.379297,7,4,2,3,5,3,0,0.738070866,0.738307087,0.049094488,1,1
9.384384,7,4,2,3,5,3,0,0.738464567,0.738700787,0.048700787,1,1
9.389473,7,4,2,3,5,3,0,0.738937008,0.739173228,0.048228346,1,1
9.394558,7,4,2,3,5,3,0,0.739330709,0.739566929,0.047834646,1,1
9.399643,7,4,2,3,5,3,0,0.739645669,0.739881890,0.047519685,1,1
9.404728,7,4,2,3,5,3,0,0.740118110,0.740354331,0.047047244,1,1
9.409812,7,4,2,3,5,3,0,0.740511811,0.740748031,0.046653543,1,1
9.414896,7,4,2,3,5,3,0,0.740905512,0.741141732,0.046259843,1,1
9.419991,7,4,2,3,5,3,0,0.741299213,0.741535433,0.045866142,1,1
9.425079,7,4,2,3,5,3,0,0.741692913,0.741929134,0.045472441,1,1
9.430164,7,4,2,3,5,3,0,0.742086614,0.742322835,0.045078740,1,1
9.435246,7,4,2,3,5,3,0,0.742559055,0.742795276,0.044606299,1,1
9.440334,7,4,2,3,5,3,0,0.742874016,0.743110236,0.044291339,1,1
9.445424,7,4,2,3,5,3,0,0.743267717,0.743503937,0.043897638,1,1
9.450512,7,4,2,3,5,3,0,0.743740157,0.743976378,0.043425197,1,1
9.455599,7,4,2,3,5,3,0,0.744133858,0.744370079,0.043031496,1,1
9.460687,7,4,2,3,5,3,0,0.744448819,0.744685039,0.042716535,1,1
9.465774,7,4,2,3,5,3,0,0.744921260,0.745157480,0.042244094,1,1
9.470861,7,4,2,3,5,3,0,0.745314961,0.745551181,0.041850394,1,1
9.475948,7,4,2,3,5,3,0,0.745708661,0.745944882,0.041456693,1,1
9.481040,7,4,2,3,5,3,0,0.746181102,0.746417323,0.040984252,1,1
9.486136,7,4,2,3,5,3,0,0.746496063,0.746732283,0.040669291,1,1
9.491227,7,4,2,3,5,3,0,0.746889764,0.747125984,0.040275591,1,1
9.496314,7,4,2,3,5,3,0,0.747283465,0.747519685,0.039881890,1,1
9.501401,7,4,2,3,5,3,0,0.747755906,0.747992126,0.039409449,1,1
9.506489,7,4,2,3,5,3,0,0.748070866,0.748307087,0.039094488,1,1
9.511576,7,4,2,3,5,3,0,0.748464567,0.748700787,0.038700787,1,1
9.516662,7,4,2,3,5,3,0,0.748937008,0.749173228,0.038228346,1,1
9.521748,7,4,2,3,5,3,0,0.749330709,0.749566929,0.037834646,1,1
9.526836,7,4,2,3,5,3,0,0.749645669,0.749881890,0.037519685,1,1
9.531924,7,4,2,3,5,3,0,0.750118110,0.750354331,0.037047244,1,1
9.537024,7,4,2,3,5,3,0,0.750511811,0.750748031,0.036653543,1,1
9.542115,7,4,2,3,5,3,0,0.750905512,0.751141732,0.036259843,1,1
9.547202,7,4,2,3,5,3,0,0.751299213,0.751535433,0.035866142,1,1
9.552293,7,4,2,3,5,3,0,0.751692913,0.751929134,0.035472441,1,1
9.557379,7,4,2,3,5,3,0,0.752086614,0.752322835,0.035078740,1,1
9.562467,7,4,2,3,5,3,0,0.752559055,0.752795276,0.034606299,1,1
9.567553,7,4,2,3,5,3,0,0.752952756,0.753188976,0.034212598,1,1
9.572640,7,4,2,3,5,3,0,0.753267717,0.753503937,0.033897638,1,1
9.577727,7,4,2,3,5,3,0,0.753740157,0.753976378,0.033425197,1,1
9.582814,7,4,2,3,5,3,0,0.754133858,0.754370079,0.033031496,1,1
9.587900,7,4,2,3,5,3,0,0.754527559,0.754763780,0.032637795,1,1
9.592990,7,4,2,3,5,3,0,0.754921260,0.755157480,0.032244094,1,1
9.598081,7,4,2,3,5,3,0,0.755314961,0.755551181,0.031850394,1,1
9.603168,7,4,2,3,5,3,0,0.755708661,0.755944882,0.031456693,1,1
9.608253,7,4,2,3,5,3,0,0.756181102,0.756417323,0.030984252,1,1
9.613345,7,4,2,3,5,3,0,0.756496063,0.756732283,0.030669291,1,1
9.618429,7,4,2,3,5,3,0,0.756889764,0.757125984,0.030275591,1,1
9.623514,7,4,2,3,5,3,0,0.757362205,0.757598425,0.029803150,1,1
9.628601,7,4,2,3,5,3,0,0.757755906,0.757992126,0.029409449,1,1
9.633688,7,4,2,3,5,3,0,0.758070866,0.758307087,0.029094488,1,1
9.638773,7,4,2,3,5,3,0,0.758464567,0.758700787,0.028700787,1,1
9.643868,7,4,2,3,5,3,0,0.758937008,0.759173228,0.028228346,1,1
9.648956,7,4,2,3,5,3,0,0.759330709,0.759566929,0.027834646,1,1
9.654052,7,4,2,3,5,3,0,0.759803150,0.760039370,0.027362205,1,1
9.659138,7,4,2,3,5,3,0,0.760118110,0.760354331,0.027047244,1,1
9.664225,7,4,2,3,5,3,0,0.760511811,0.760748031,0.026653543,1,1
9.669313,7,4,2,3,5,3,0,0.760905512,0.761141732,0.026259843,1,1
9.674399,7,4,2,3,5,3,0,0.761377953,0.761614173,0.025787402,1,1
9.679491,7,4,2,3,5,3,0,0.761692913,0.761929134,0.025472441,1,1
9.684578,7,4,2,3,5,3,0,0.762086614,0.762322835,0.025078740,1,1
9.689664,7,4,2,3,5,3,0,0.762559055,0.762795276,0.024606299,1,1
9.694759,7,4,2,3,5,3,0,0.762952756,0.763188976,0.024212598,1,1
9.699846,7,4,2,3,5,3,0,0.763267717,0.763503937,0.023897638,1,1
9.704931,7,4,2,3,5,3,0,0.763740157,0.763976378,0.023425197,1,1
9.710015,7,4,2,3,5,3,0,0.764133858,0.764370079,0.023031496,1,1
9.715100,7,4,2,3,5,3,0,0.764527559,0.764763780,0.022637795,1,1
9.720184,7,4,2,3,5,3,0,0.764921260,0.765157480,0.022244094,1,1
9.725269,7,4,2,3,5,3,0,0.765314961,0.765551181,0.021850394,1,1
9.730373,7,4,2,3,5,3,0,0.765708661,0.765944882,0.021456693,1,1
9.735495,7,4,2,3,5,3,0,0.766181102,0.766417323,0.020984252,1,1
9.740617,7,4,2,3,5,3,0,0.766574803,0.766811024,0.020590551,1,1
9.745742,7,4,2,3,5,3,0,0.766889764,0.767125984,0.020275591,1,1
9.750840,7,4,2,3,5,3,0,0.767362205,0.767598425,0.019803150,1,1
9.755937,7,4,2,3,5,3,0,0.767755906,0.767992126,0.019409449,1,1
9.761033,7,4,2,3,5,3,0,0.768149606,0.768385827,0.019015748,1,1
9.766126,7,4,2,3,5,3,0,0.768622047,0.768858268,0.018543307,1,1
9.771243,7,4,2,3,5,3,0,0.768937008,0.769173228,0.018228346,1,1
9.776379,7,4,2,3,5,3,0,0.769330709,0.769566929,0.017834646,1,1
9.781522,7,4,2,3,5,3,0,0.769803150,0.770039370,0.017362205,1,1
9.786632,7,4,2,3,5,3,0,0.770196850,0.770433071,0.016968504,1,1
9.791766,7,4,2,3,5,3,0,0.770590551,0.770826772,0.016574803,1,1
9.796861,7,4,2,3,5,3,0,0.770984252,0.771220472,0.016181102,1,1
9.801948,7,4,2,3,5,3,0,0.771377953,0.771614173,0.015787402,1,1
9.807059,7,4,2,3,5,3,0,0.771771654,0.772007874,0.015393701,1,1
9.812146,7,4,2,3,5,3,0,0.772244094,0.772480315,0.014921260,1,1
9.817232,7,4,2,3,5,3,0,0.772559055,0.772795276,0.014606299,1,1
9.822317,7,4,2,3,5,3,0,0.772952756,0.773188976,0.014212598,1,1
9.827407,7,4,2,3,5,3,0,0.773425197,0.773661417,0.013740157,1,1
9.832503,7,4,2,3,5,3,0,0.773818898,0.774055118,0.013346457,1,1
9.837586,7,4,2,3,5,3,0,0.774133858,0.774370079,0.013031496,1,1
9.842673,7,4,2,3,5,3,0,0.774527559,0.774763780,0.012637795,1,1
9.847765,7,4,2,3,5,3,0,0.775000000,0.775236220,0.012165354,1,1
9.852853,7,4,2,3,5,3,0,0.775393701,0.775629921,0.011771654,1,1
9.857940,7,4,2,3,5,3,0,0.775708661,0.775944882,0.011456693,1,1
9.863027,7,4,2,3,5,3,0,0.776181102,0.776417323,0.010984252,1,1
9.868113,7,4,2,3,5,3,0,0.776574803,0.776811024,0.010590551,1,1
9.873204,7,4,2,3,5,3,0,0.776968504,0.777204724,0.010196850,1,1
9.878294,7,4,2,3,5,3,0,0.777440945,0.777677165,0.009724409,1,1
9.883382,7,4,2,3,5,3,0,0.777755906,0.777992126,0.009409449,1,1
9.888471,7,4,2,3,5,3,0,0.778149606,0.778385827,0.009015748,1,1
9.893559,7,4,2,3,5,3,0,0.778622047,0.778858268,0.008543307,1,1
9.898649,7,4,2,3,5,3,0,0.779015748,0.779251969,0.008149606,1,1
9.903741,7,4,2,3,5,3,0,0.779330709,0.779566929,0.007834646,1,1
9.908828,7,4,2,3,5,3,0,0.779803150,0.780039370,0.007362205,1,1
9.913917,7,4,2,3,5,3,0,0.780196850,0.780433071,0.006968504,1,1
9.919002,7,4,2,3,5,3,0,0.780590551,0.780826772,0.006574803,1,1
9.924088,7,4,2,3,5,3,0,0.780984252,0.781220472,0.006181102,1,1
9.929173,7,4,2,3,5,3,0,0.781377953,0.781614173,0.005787402,1,1
9.934257,7,4,2,3,5,3,0,0.781771654,0.782007874,0.005393701,1,1
9.939348,7,4,2,3,5,3,0,0.782244094,0.782480315,0.004921260,1,1
9.944435,7,4,2,3,5,3,0,0.782559055,0.782795276,0.004606299,1,1
9.949531,7,4,2,3,5,3,0,0.782952756,0.783188976,0.004212598,1,1
9.954619,7,4,2,3,5,3,0,0.783425197,0.783661417,0.003740157,1,1
9.959707,7,4,2,3,5,3,0,0.783818898,0.784055118,0.003346457,1,1
9.964794,7,4,2,3,5,3,0,0.784212598,0.784448819,0.002952756,1,1
9.969881,7,4,2,3,5,3,0,0.784606299,0.784842520,0.002559055,1,1
9.974974,7,4,2,3,5,3,0,0.785000000,0.785236220,0.002165354,1,1
9.980072,7,4,2,3,5,3,0,0.785393701,0.785629921,0.001771654,1,1
9.985159,7,4,2,3,5,3,0,0.785866142,0.786102362,0.001299213,1,1
9.990246,7,4,2,3,5,3,0,0.786181102,0.786417323,0.000984252,1,1
9.995333,7,4,2,3,5,3,0,0.786574803,0.786811024,0.000590551,1,1
10.000425,7,4,2,3,5,3,0,0.786968504,0.787204724,0.000196850,1,1
10.005517,8,4,2,3,5,3,1,0.787395013,0.787401575,0.000000000,0,0
10.010606,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.015694,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.020781,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.025868,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.030955,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.036052,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.041139,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.046225,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.051313,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.056401,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.061485,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.066569,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.071655,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.076741,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.081828,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.086914,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.092003,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.097090,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.102181,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.107267,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.112357,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.117442,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.122528,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.127616,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.132709,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.137796,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.142884,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.147978,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.153078,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.158167,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.163253,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.168339,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.173426,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.178511,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.183599,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.188686,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.193773,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.198863,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.203953,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.209047,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.214133,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.219219,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.224305,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.229391,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.234477,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.239563,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.244649,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.249737,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.254829,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.259914,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.265005,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.270089,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.275174,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.280258,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.285343,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.290427,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.295518,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.300605,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.305697,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.310783,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.315869,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.320960,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.326059,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.331148,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.336236,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.341322,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.346410,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.351497,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.356589,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.361676,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.366763,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.371850,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.376945,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.382034,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.387120,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.392212,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.397298,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.402384,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.407473,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.412566,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.417656,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.422745,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.427833,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.432923,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.438029,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.443118,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.448204,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.453289,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.458379,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.463465,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.468548,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.473632,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.478716,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.483801,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.488886,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.493983,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.499068,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.504152,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.509251,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.514342,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.519472,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.524568,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.529666,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.534754,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.539840,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.544931,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.550024,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.555111,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.560209,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.565295,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.570381,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.575476,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.580567,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.585654,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.590746,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.595830,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.600916,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.605992,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.611093,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.616179,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.621265,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.626348,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.631430,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.636513,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.641598,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.646688,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.651776,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.656858,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.661959,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.667053,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.672137,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.677222,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.682306,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.687392,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.692477,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.697562,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.702645,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.707731,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.712821,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.717910,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.723001,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.728086,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.733172,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.738256,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.743343,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.748440,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.753529,8,4,2,3,5,3,1,0.787401575,0.787401575,0.000000000,0,0
10.758618,2,1,1,3,0,3,1,0.787401575,0.787401575,0.000000000,0,0
=== END T02-019 FULL RAW TRACE CSV ===

T02-019 shell-harness=PASS
UTC finish: 2026-09-08T02:26:29Z
```

## Standard error
```text

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
Cloning into '/home/runner/work/_temp/linuxcnc-t02-task'...
Updating files:   0% (1/9526)Updating files:   1% (96/9526)Updating files:   2% (191/9526)Updating files:   3% (286/9526)Updating files:   4% (382/9526)Updating files:   5% (477/9526)Updating files:   6% (572/9526)Updating files:   7% (667/9526)Updating files:   8% (763/9526)Updating files:   9% (858/9526)Updating files:  10% (953/9526)Updating files:  11% (1048/9526)Updating files:  12% (1144/9526)Updating files:  13% (1239/9526)Updating files:  14% (1334/9526)Updating files:  15% (1429/9526)Updating files:  16% (1525/9526)Updating files:  17% (1620/9526)Updating files:  18% (1715/9526)Updating files:  19% (1810/9526)Updating files:  20% (1906/9526)Updating files:  21% (2001/9526)Updating files:  22% (2096/9526)Updating files:  23% (2191/9526)Updating files:  23% (2215/9526)Updating files:  24% (2287/9526)Updating files:  25% (2382/9526)Updating files:  26% (2477/9526)Updating files:  27% (2573/9526)Updating files:  28% (2668/9526)Updating files:  29% (2763/9526)Updating files:  30% (2858/9526)Updating files:  31% (2954/9526)Updating files:  32% (3049/9526)Updating files:  33% (3144/9526)Updating files:  34% (3239/9526)Updating files:  35% (3335/9526)Updating files:  36% (3430/9526)Updating files:  37% (3525/9526)Updating files:  38% (3620/9526)Updating files:  39% (3716/9526)Updating files:  40% (3811/9526)Updating files:  41% (3906/9526)Updating files:  42% (4001/9526)Updating files:  43% (4097/9526)Updating files:  44% (4192/9526)Updating files:  45% (4287/9526)Updating files:  46% (4382/9526)Updating files:  47% (4478/9526)Updating files:  48% (4573/9526)Updating files:  49% (4668/9526)Updating files:  50% (4763/9526)Updating files:  51% (4859/9526)Updating files:  52% (4954/9526)Updating files:  53% (5049/9526)Updating files:  54% (5145/9526)Updating files:  55% (5240/9526)Updating files:  56% (5335/9526)Updating files:  57% (5430/9526)Updating files:  58% (5526/9526)Updating files:  59% (5621/9526)Updating files:  60% (5716/9526)Updating files:  61% (5811/9526)Updating files:  62% (5907/9526)Updating files:  63% (6002/9526)Updating files:  64% (6097/9526)Updating files:  65% (6192/9526)Updating files:  66% (6288/9526)Updating files:  67% (6383/9526)Updating files:  68% (6478/9526)Updating files:  69% (6573/9526)Updating files:  70% (6669/9526)Updating files:  71% (6764/9526)Updating files:  72% (6859/9526)Updating files:  73% (6954/9526)Updating files:  74% (7050/9526)Updating files:  75% (7145/9526)Updating files:  76% (7240/9526)Updating files:  77% (7336/9526)Updating files:  78% (7431/9526)Updating files:  79% (7526/9526)Updating files:  80% (7621/9526)Updating files:  81% (7717/9526)Updating files:  82% (7812/9526)Updating files:  83% (7907/9526)Updating files:  84% (8002/9526)Updating files:  85% (8098/9526)Updating files:  86% (8193/9526)Updating files:  87% (8288/9526)Updating files:  88% (8383/9526)Updating files:  89% (8479/9526)Updating files:  90% (8574/9526)Updating files:  91% (8669/9526)Updating files:  92% (8764/9526)Updating files:  93% (8860/9526)Updating files:  94% (8955/9526)Updating files:  95% (9050/9526)Updating files:  96% (9145/9526)Updating files:  97% (9241/9526)Updating files:  98% (9336/9526)Updating files:  99% (9431/9526)Updating files: 100% (9526/9526)Updating files: 100% (9526/9526), done.
HEAD is now at 8bf4605ae Merge pull request #4501 from grandixximo/gmoccapy-quit-4500

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
Reading 0/189 dependency files
Done reading dependencies
Reading 0/147 realtime dependency files
Done reading realtime dependencies
Reading 0/189 dependency files
Done reading dependencies
Reading 0/303 realtime dependency files
Done reading realtime dependencies
```
