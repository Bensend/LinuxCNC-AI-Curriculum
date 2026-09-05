# Latest LinuxCNC Lab Result

- Job: `003-stable-v2.9.10-baseline`
- Job file: `lab-jobs/003-stable-v2.9.10-baseline.sh`
- Workflow run ID: `33952061943`
- Attempt: `1`
- Source commit: `42f5a295c8364d529102dd18793707a6f0cf9f57`
- Exit code: `0`
- Finished UTC: `2026-09-05T07:21:02Z`

## Metadata
```text
LinuxCNC AI Curriculum Lab
UTC start: 2026-09-05T07:15:54Z
Repository commit: 42f5a295c8364d529102dd18793707a6f0cf9f57
Workflow run: 33952061943 attempt 1
Job file: lab-jobs/003-stable-v2.9.10-baseline.sh
Runner: Linux runnervmejwal 6.17.0-1022-azure #22-Ubuntu SMP Mon Jul 27 17:24:03 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

UTC finish: 2026-09-05T07:21:02Z
```

## Standard output
```text
== LinuxCNC L01 stable v2.9.10 baseline lab ==
UTC start: 2026-09-05T07:15:54Z
Pinned stable commit: 86cdca76fa2a36274c432caa21952b23c267989a
Expected release tag: v2.9.10
Selected upstream test: tests/realtime-math
Prediction: the exact v2.9.10 commit will configure/build as a uspace RIP tree on the same Ubuntu runner used for the development baseline, then run upstream realtime-math through its own scripts/runtests harness with exit 0. Any build or harness incompatibility is evidence to preserve rather than mask.
Comparison boundary: this job intentionally uses the stable checkout own build scripts, rip-environment, runtests, and test definition. It does not backport development-branch harness behavior.
Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [144 B]
Get:6 https://packages.microsoft.com/ubuntu/24.04/prod noble InRelease [3600 B]
Hit:2 http://azure.archive.ubuntu.com/ubuntu noble InRelease
Get:3 http://azure.archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Get:4 http://azure.archive.ubuntu.com/ubuntu noble-backports InRelease [126 kB]
Get:5 http://azure.archive.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:7 https://dl.google.com/linux/chrome-stable/deb stable InRelease [2548 B]
Get:8 https://packages.microsoft.com/ubuntu/24.04/prod noble/main amd64 Packages [441 kB]
Get:9 https://packages.microsoft.com/ubuntu/24.04/prod noble/main arm64 Packages [394 kB]
Get:10 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages [1260 kB]
Get:11 http://azure.archive.ubuntu.com/ubuntu noble-updates/main Translation-en [292 kB]
Get:12 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 Components [180 kB]
Get:13 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 Packages [1690 kB]
Get:14 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe Translation-en [339 kB]
Get:15 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 Components [388 kB]
Get:16 http://azure.archive.ubuntu.com/ubuntu noble-updates/restricted amd64 Packages [1536 kB]
Get:17 http://azure.archive.ubuntu.com/ubuntu noble-updates/restricted Translation-en [352 kB]
Get:18 http://azure.archive.ubuntu.com/ubuntu noble-updates/multiverse amd64 Components [940 B]
Get:19 http://azure.archive.ubuntu.com/ubuntu noble-backports/main amd64 Components [5740 B]
Get:20 http://azure.archive.ubuntu.com/ubuntu noble-backports/universe amd64 Components [12.6 kB]
Get:21 http://azure.archive.ubuntu.com/ubuntu noble-security/main amd64 Packages [1002 kB]
Get:22 http://azure.archive.ubuntu.com/ubuntu noble-security/main Translation-en [212 kB]
Get:23 http://azure.archive.ubuntu.com/ubuntu noble-security/main amd64 Components [46.4 kB]
Get:24 http://azure.archive.ubuntu.com/ubuntu noble-security/universe amd64 Packages [1206 kB]
Get:25 http://azure.archive.ubuntu.com/ubuntu noble-security/universe Translation-en [241 kB]
Get:26 http://azure.archive.ubuntu.com/ubuntu noble-security/universe amd64 Components [76.3 kB]
Get:27 http://azure.archive.ubuntu.com/ubuntu noble-security/restricted amd64 Packages [1437 kB]
Get:28 http://azure.archive.ubuntu.com/ubuntu noble-security/restricted Translation-en [334 kB]
Get:29 https://dl.google.com/linux/chrome-stable/deb stable/main amd64 Packages [1401 B]
Fetched 11.8 MB in 1s (8893 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
git is already the newest version (1:2.55.0-0ppa1~ubuntu24.04.2).
git set to manually installed.
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
0 upgraded, 168 newly installed, 0 to remove and 38 not upgraded.
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
Fetched 11.0 MB in 12s (944 kB/s)
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
Resolved commit: 86cdca76fa2a36274c432caa21952b23c267989a
Tags pointing at commit: v2.9.10 
VERSION: 2.9.10

== Stable harness identity ==
scripts/runtests.in SHA256: 84c13d31dfb99822e57caffd005ac61becf420a377e245d70886e56d59383047  scripts/runtests.in
tests/realtime-math/README SHA256: 772c222993faca4611e6fba2b38da8b710d2a52205967f9a05b8315ffe4e1b4f  tests/realtime-math/README
tests/realtime-math/test.sh SHA256: ad9c5b21df16d6a9ed1b71cda4ff5d0ed9a569fd2906665922ac14c903cfbab6  tests/realtime-math/test.sh

== Configure Debian metadata and install declared dependencies ==
uspace is accepted for compatibility, but ignored
unknown distribution: Ubuntu-24.04
detected dependencies may be incomplete or wrong
please consider fixing it and submitting a pull request
Successfully configured for 'uspace-Ubuntu-24.04'.
Note, using directory '.' to get the build dependencies
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  asciidoc asciidoc-base asciidoc-common asciidoc-dblatex blt bwidget dblatex
  desktop-file-utils dh-python docbook-dsssl docbook-utils docbook-xml
  docbook-xsl dvipng fonts-gfs-baskerville fonts-gfs-porson fonts-lmodern
  fonts-urw-base35 ghostscript gir1.2-atk-1.0 gir1.2-atspi-2.0
  gir1.2-freedesktop gir1.2-freedesktop-dev gir1.2-gdkpixbuf-2.0
  gir1.2-glib-2.0-dev gir1.2-gtk-2.0 gir1.2-gtk-3.0 gir1.2-harfbuzz-0.0
  gir1.2-pango-1.0 glib-networking glib-networking-common
  glib-networking-services graphviz groff gsettings-desktop-schemas
  imagemagick imagemagick-6.q16 inkscape intltool lib2geom1.2.0t64 libann0
  libapache-pom-java libatk-bridge2.0-dev libatk1.0-dev libatkmm-1.6-1v5
  libatspi2.0-dev libbibtex-parser-perl libblkid-dev libboost-filesystem1.83.0
  libboost-python-dev libboost-python1.83-dev libboost-python1.83.0
  libboost1.83-dev libbrotli-dev libbsd-dev libbz2-dev
  libcairo-script-interpreter2 libcairo2-dev libcairomm-1.0-1v5 libcdr-0.1-1
  libcdt5 libcgraph6 libcommons-logging-java libcommons-parent-java
  libconfig-general-perl libcss-dom-perl libdatrie-dev libdbus-1-dev
  libdeflate-dev libdouble-conversion3 libedit-dev libeditreadline-dev
  libegl-dev libegl-mesa0 libegl1 libegl1-mesa-dev libepoxy-dev
  libevent-2.1-7t64 libfontbox-java libfontconfig-dev libfreetype-dev
  libfribidi-dev libgdk-pixbuf-2.0-dev libgdk-pixbuf2.0-bin
  libgirepository-2.0-0 libgl-dev libgles-dev libgles1 libgles2 libglib2.0-dev
  libglib2.0-dev-bin libglibmm-2.4-1t64 libglu1-mesa libglu1-mesa-dev
  libglvnd-core-dev libglvnd-dev libglx-dev libgpiod-dev libgpiod2t64
  libgraphite2-dev libgs-common libgs10 libgs10-common libgsl27 libgslcblas0
  libgspell-1-2 libgspell-1-common libgtk-3-dev libgtk2.0-0t64
  libgtk2.0-common libgtk2.0-dev libgtkmm-3.0-1t64 libgts-0.7-5t64 libgvc6
  libgvpr2 libharfbuzz-cairo0 libharfbuzz-dev libharfbuzz-gobject0
  libharfbuzz-icu0 libharfbuzz-subset0 libice-dev libidn12 libijs-0.35
  libinput-bin libinput10 libjbig-dev libjbig2dec0 libjpeg-dev
  libjpeg-turbo8-dev libjpeg8-dev libkpathsea6 liblab-gamut1
  liblatex-tounicode-perl liblerc-dev liblocale-codes-perl liblzma-dev
  libmagick++-6.q16-9t64 libmd-dev libmd4c0 libmime-charset-perl
  libminizip1t64 libmodbus-dev libmodbus5 libmount-dev libmtdev1t64
  libnet-ip-perl libnetpbm11t64 libopengl-dev libopengl0 libopus0 libosp5
  libostyle1t64 libpango1.0-dev libpangomm-1.4-1v5 libpangoxft-1.0-0
  libpaper-utils libpaper1 libpathplan4 libpdfbox-java libpixman-1-dev
  libpng-dev libpoppler-glib8t64 libpoppler134 libpotrace0 libproxy1v5
  libptexenc1 libpthread-stubs0-dev libqt5core5t64 libqt5dbus5t64
  libqt5designer5 libqt5gui5t64 libqt5help5 libqt5network5t64
  libqt5positioning5 libqt5printsupport5t64 libqt5qml5 libqt5qmlmodels5
  libqt5quick5 libqt5quickwidgets5 libqt5sql5t64 libqt5test5t64
  libqt5webchannel5 libqt5webengine-data libqt5webengine5 libqt5webenginecore5
  libqt5webenginewidgets5 libqt5widgets5t64 libqt5xml5t64 librevenge-0.0-0
  librsvg2-2 librsvg2-common libselinux1-dev libsepol-dev libsgmls-perl
  libsharpyuv-dev libsigc++-2.0-0v5 libsm-dev libsombok3 libsoup-2.4-1
  libsoup2.4-common libsource-highlight-common libsource-highlight4t64
  libsynctex2 libteckit0 libtexlua53-5 libthai-dev libtiff-dev libtiffxx6
  libtirpc-dev libudev-dev libunicode-linebreak-perl libusb-1.0-0-dev
  libvisio-0.1-1 libvpx9 libwacom-common libwacom9 libwayland-bin
  libwayland-dev libwayland-server0 libwebp-dev libwebpdecoder3 libwpd-0.10-10
  libwpg-0.3-3 libx11-dev libxau-dev libxcb-icccm4 libxcb-image0
  libxcb-keysyms1 libxcb-render-util0 libxcb-render0-dev libxcb-shape0
  libxcb-shm0-dev libxcb-util1 libxcb-xinerama0 libxcb-xinput0 libxcb-xkb1
  libxcb1-dev libxcomposite-dev libxcursor-dev libxdamage-dev libxdmcp-dev
  libxext-dev libxfixes-dev libxft-dev libxi-dev libxinerama-dev
  libxkbcommon-dev libxkbcommon-x11-0 libxml-parser-perl libxml2-utils
  libxmu-dev libxmu-headers libxrandr-dev libxrender-dev libxss-dev libxt-dev
  libxtst-dev libyaml-tiny-perl libzzip-0-13t64 lmodern lynx lynx-common
  netpbm openjade opensp pango1.0-tools po4a poppler-data preview-latex-style
  python3-lxml python3-pyqt5 python3-pyqt5.qtwebchannel
  python3-pyqt5.qtwebengine python3-pyqt5.sip python3-tk python3-xlib
  python3-yapps session-migration sgml-data sgmlspl source-highlight
  tcl8.6-dev tclx8.4 teckit texlive texlive-base texlive-bibtex-extra
  texlive-binaries texlive-extra-utils texlive-font-utils
  texlive-fonts-recommended texlive-formats-extra texlive-lang-cyrillic
  texlive-lang-european texlive-lang-french texlive-lang-german
  texlive-lang-greek texlive-lang-polish texlive-lang-spanish
  texlive-latex-base texlive-latex-extra texlive-latex-recommended
  texlive-luatex texlive-pictures texlive-plain-generic texlive-science
  texlive-xetex tipa tk8.6-blt2.5 tk8.6-dev uuid-dev w3c-linkchecker
  wayland-protocols x11-xserver-utils x11proto-dev xfonts-encodings
  xfonts-utils xorg-sgml-doctools xsltproc xtrans-dev yapps2
The following packages will be upgraded:
  libevent-core-2.1-7t64 libevent-pthreads-2.1-7t64
2 upgraded, 321 newly installed, 0 to remove and 36 not upgraded.
Need to get 765 MB of archives.
After this operation, 1952 MB of additional disk space will be used.
Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [144 B]
Get:2 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 poppler-data all 0.4.12-1 [2060 kB]
Get:3 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 asciidoc-common all 10.2.0-2 [104 kB]
Get:4 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 docbook-xsl all 1.79.2+dfsg-7 [1070 kB]
Get:5 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libxml2-utils amd64 2.9.14+dfsg-1.3ubuntu3.8 [39.4 kB]
Get:6 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 xsltproc amd64 1.1.39-0exp1ubuntu0.24.04.3 [15.0 kB]
Get:7 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 asciidoc-base all 10.2.0-2 [83.6 kB]
Get:8 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 asciidoc all 10.2.0-2 [3248 B]
Get:9 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 sgml-data all 2.0.11+nmu1 [171 kB]
Get:10 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 docbook-xml all 4.5-12 [74.6 kB]
Get:11 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpaper1 amd64 1.1.29build1 [13.4 kB]
Get:12 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpaper-utils amd64 1.1.29build1 [8650 B]
Get:13 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libkpathsea6 amd64 2023.20230311.66589-9build3 [63.0 kB]
Get:14 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libptexenc1 amd64 2023.20230311.66589-9build3 [40.4 kB]
Get:15 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsynctex2 amd64 2023.20230311.66589-9build3 [59.6 kB]
Get:16 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtexlua53-5 amd64 2023.20230311.66589-9build3 [123 kB]
Get:17 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libpotrace0 amd64 1.16-2build1 [17.7 kB]
Get:18 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libteckit0 amd64 2.5.12+ds1-1 [411 kB]
Get:19 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libzzip-0-13t64 amd64 0.13.72+dfsg.1-1.2build1 [28.1 kB]
Get:20 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-binaries amd64 2023.20230311.66589-9build3 [8529 kB]
Get:21 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-base all 2023.20240207-1 [21.7 MB]
Get:22 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-fonts-recommended all 2023.20240207-1 [4973 kB]
Get:23 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 fonts-lmodern all 2.005-1 [4799 kB]
Get:24 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-latex-base all 2023.20240207-1 [1238 kB]
Get:25 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-latex-recommended all 2023.20240207-1 [8826 kB]
Get:26 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive all 2023.20240207-1 [14.0 kB]
Get:27 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 liblatex-tounicode-perl all 0.54-2 [29.0 kB]
Get:28 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libbibtex-parser-perl all 1.04+dfsg-1 [16.7 kB]
Get:29 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-bibtex-extra all 2023.20240207-1 [79.1 MB]
Get:30 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libsombok3 amd64 2.4.0-2build1 [29.4 kB]
Get:31 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmime-charset-perl all 1.013.1-2 [31.0 kB]
Get:32 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libunicode-linebreak-perl amd64 0.0.20190101-1build7 [92.6 kB]
Get:33 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libyaml-tiny-perl all 1.74-1 [25.3 kB]
Get:34 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xfonts-encodings all 1:1.0.5-0ubuntu2 [578 kB]
Get:35 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xfonts-utils amd64 1:7.7+6build3 [94.4 kB]
Get:36 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 lmodern all 2.005-1 [9542 kB]
Get:37 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-luatex all 2023.20240207-1 [25.8 MB]
Get:38 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-plain-generic all 2023.20240207-1 [29.0 MB]
Get:39 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-extra-utils all 2023.20240207-1 [63.0 MB]
Get:40 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libapache-pom-java all 29-2 [5284 B]
Get:41 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libcommons-parent-java all 56-1 [10.7 kB]
Get:42 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libcommons-logging-java all 1.3.0-1ubuntu1 [63.8 kB]
Get:43 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libfontbox-java all 1:1.8.16-5 [208 kB]
Get:44 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libpdfbox-java all 1:1.8.16-5 [5521 kB]
Get:45 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 preview-latex-style all 13.2-1 [347 kB]
Get:46 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-pictures all 2023.20240207-1 [16.7 MB]
Get:47 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-latex-extra all 2023.20240207-1 [19.2 MB]
Get:48 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 fonts-gfs-baskerville all 1.1-6 [43.7 kB]
Get:49 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 fonts-gfs-porson all 1.1-7 [33.9 kB]
Get:50 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-lang-greek all 2023.20240207-1 [79.2 MB]
Get:51 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-science all 2023.20240207-1 [3779 kB]
Get:52 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 dblatex all 0.3.12py3-4 [351 kB]
Get:53 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libosp5 amd64 1.5.2-15ubuntu2 [683 kB]
Get:54 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libostyle1t64 amd64 1.4devel1-23.1build1 [634 kB]
Get:55 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 openjade amd64 1.4devel1-23.1build1 [269 kB]
Get:56 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 docbook-dsssl all 1.79-10 [225 kB]
Get:57 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 teckit amd64 2.5.12+ds1-1 [713 kB]
Get:58 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 tipa all 2:1.3-21 [2967 kB]
Get:59 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-xetex all 2023.20240207-1 [10.8 MB]
Get:60 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-formats-extra all 2023.20240207-1 [7739 kB]
Get:61 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 lynx-common all 2.9.0rel.0-2build2 [1006 kB]
Get:62 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 lynx amd64 2.9.0rel.0-2build2 [715 kB]
Get:63 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libsgmls-perl all 1.03ii-38 [22.1 kB]
Get:64 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 sgmlspl all 1.03ii-38 [6210 B]
Get:65 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 opensp amd64 1.5.2-15ubuntu2 [147 kB]
Get:66 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 docbook-utils all 0.6.14-4 [60.2 kB]
Get:67 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 asciidoc-dblatex all 10.2.0-2 [4772 B]
Get:68 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 tk8.6-blt2.5 amd64 2.5.3+dfsg-7build1 [630 kB]
Get:69 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 blt amd64 2.5.3+dfsg-7build1 [4840 B]
Get:70 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 bwidget all 1.9.16-1 [178 kB]
Get:71 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 desktop-file-utils amd64 0.27-2build1 [53.8 kB]
Get:72 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 dh-python all 6.20240401 [110 kB]
Get:73 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 fonts-urw-base35 all 20200910-8 [11.0 MB]
Get:74 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgs-common all 10.02.1~dfsg1-0ubuntu7.8 [176 kB]
Get:75 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgs10-common all 10.02.1~dfsg1-0ubuntu7.8 [488 kB]
Get:76 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libidn12 amd64 1.42-1ubuntu0.1 [56.1 kB]
Get:77 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libijs-0.35 amd64 0.35-15.1build1 [15.3 kB]
Get:78 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libjbig2dec0 amd64 0.20-1ubuntu0.24.04.1 [65.2 kB]
Get:79 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgs10 amd64 10.02.1~dfsg1-0ubuntu7.8 [3897 kB]
Get:80 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 ghostscript amd64 10.02.1~dfsg1-0ubuntu7.8 [43.4 kB]
Get:81 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 dvipng amd64 1.15-1.1 [78.9 kB]
Get:82 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-atk-1.0 amd64 2.52.0-1build1 [23.1 kB]
Get:83 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-freedesktop amd64 1.80.1-1 [49.7 kB]
Get:84 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-atspi-2.0 amd64 2.52.0-1build1 [19.8 kB]
Get:85 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gir1.2-glib-2.0-dev amd64 2.80.0-6ubuntu3.8 [848 kB]
Get:86 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-freedesktop-dev amd64 1.80.1-1 [28.8 kB]
Get:87 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gir1.2-gdkpixbuf-2.0 amd64 2.42.10+dfsg-3ubuntu3.3 [9482 B]
Get:88 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgtk2.0-common all 2.24.33-4ubuntu1.1 [127 kB]
Get:89 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-gobject0 amd64 8.3.0-2build2 [34.3 kB]
Get:90 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-harfbuzz-0.0 amd64 8.3.0-2build2 [44.5 kB]
Get:91 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpangoxft-1.0-0 amd64 1.52.1+ds-1build1 [20.3 kB]
Get:92 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 gir1.2-pango-1.0 amd64 1.52.1+ds-1build1 [34.8 kB]
Get:93 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgtk2.0-0t64 amd64 2.24.33-4ubuntu1.1 [2006 kB]
Get:94 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 gir1.2-gtk-2.0 amd64 2.24.33-4ubuntu1.1 [209 kB]
Get:95 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gir1.2-gtk-3.0 amd64 3.24.41-4ubuntu1.3 [245 kB]
Get:96 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libproxy1v5 amd64 0.5.4-4build1 [26.5 kB]
Get:97 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 glib-networking-common all 2.80.0-1build1 [6702 B]
Get:98 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 glib-networking-services amd64 2.80.0-1build1 [12.8 kB]
Get:99 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 session-migration amd64 0.3.9build1 [9034 B]
Get:100 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 gsettings-desktop-schemas all 46.1-0ubuntu1 [35.6 kB]
Get:101 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 glib-networking amd64 2.80.0-1build1 [64.1 kB]
Get:102 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libann0 amd64 1.1.2+doc-9build1 [25.5 kB]
Get:103 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libcdt5 amd64 2.42.2-9ubuntu0.1 [21.6 kB]
Get:104 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libcgraph6 amd64 2.42.2-9ubuntu0.1 [44.6 kB]
Get:105 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgts-0.7-5t64 amd64 0.7.6+darcs121130-5.2build1 [161 kB]
Get:106 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libpathplan4 amd64 2.42.2-9ubuntu0.1 [24.0 kB]
Get:107 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libgvc6 amd64 2.42.2-9ubuntu0.1 [716 kB]
Get:108 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libgvpr2 amd64 2.42.2-9ubuntu0.1 [187 kB]
Get:109 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 liblab-gamut1 amd64 2.42.2-9ubuntu0.1 [1886 kB]
Get:110 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 graphviz amd64 2.42.2-9ubuntu0.1 [642 kB]
Get:111 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 groff amd64 1.23.0-3build2 [11.7 MB]
Get:112 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 imagemagick-6.q16 amd64 8:6.9.12.98+dfsg1-5.2build2 [254 kB]
Get:113 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 imagemagick amd64 8:6.9.12.98+dfsg1-5.2build2 [14.2 kB]
Get:114 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 librsvg2-2 amd64 2.58.0+dfsg-1build1 [2135 kB]
Get:115 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 librsvg2-common amd64 2.58.0+dfsg-1build1 [11.8 kB]
Get:116 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libdouble-conversion3 amd64 3.3.0-1build1 [40.3 kB]
Get:117 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgslcblas0 amd64 2.7.1+dfsg-6ubuntu2 [104 kB]
Get:118 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgsl27 amd64 2.7.1+dfsg-6ubuntu2 [987 kB]
Get:119 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 lib2geom1.2.0t64 amd64 1.2.2-3.1build1 [344 kB]
Get:120 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsigc++-2.0-0v5 amd64 2.12.1-2 [12.8 kB]
Get:121 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglibmm-2.4-1t64 amd64 2.66.7-1build1 [629 kB]
Get:122 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libatkmm-1.6-1v5 amd64 2.28.4-1build4 [77.1 kB]
Get:123 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libboost-filesystem1.83.0 amd64 1.83.0-2.1ubuntu3.2 [284 kB]
Get:124 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libcairomm-1.0-1v5 amd64 1.14.5-1build1 [43.9 kB]
Get:125 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 librevenge-0.0-0 amd64 0.0.5-3build1 [211 kB]
Get:126 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libcdr-0.1-1 amd64 0.1.7-1build2 [389 kB]
Get:127 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgspell-1-common all 1.12.2-1build4 [6278 B]
Get:128 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgspell-1-2 amd64 1.12.2-1build4 [52.4 kB]
Get:129 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpangomm-1.4-1v5 amd64 2.46.4-1build3 [52.2 kB]
Get:130 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgtkmm-3.0-1t64 amd64 3.24.9-1 [983 kB]
Get:131 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmagick++-6.q16-9t64 amd64 8:6.9.12.98+dfsg1-5.2build2 [148 kB]
Get:132 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libpoppler134 amd64 24.02.0-1ubuntu9.9 [1118 kB]
Get:133 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libpoppler-glib8t64 amd64 24.02.0-1ubuntu9.9 [157 kB]
Get:134 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libsoup2.4-common all 2.74.3-6ubuntu1.7 [9554 B]
Get:135 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libsoup-2.4-1 amd64 2.74.3-6ubuntu1.7 [283 kB]
Get:136 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libvisio-0.1-1 amd64 0.1.7-1build9 [237 kB]
Get:137 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwpd-0.10-10 amd64 0.10.3-2build2 [206 kB]
Get:138 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwpg-0.3-3 amd64 0.3.4-3build1 [51.8 kB]
Get:139 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 inkscape amd64 1.2.2-2ubuntu12 [21.5 MB]
Get:140 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libxml-parser-perl amd64 2.47-1ubuntu0.24.04.1 [204 kB]
Get:141 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 intltool all 0.51.0-6 [44.6 kB]
Get:142 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libglib2.0-dev-bin amd64 2.80.0-6ubuntu3.8 [138 kB]
Get:143 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 uuid-dev amd64 2.39.3-9ubuntu6.6 [33.5 kB]
Get:144 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libblkid-dev amd64 2.39.3-9ubuntu6.6 [205 kB]
Get:145 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsepol-dev amd64 3.5-2build1 [384 kB]
Get:146 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libselinux1-dev amd64 3.5-2ubuntu2.1 [164 kB]
Get:147 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libmount-dev amd64 2.39.3-9ubuntu6.6 [14.9 kB]
Get:148 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgirepository-2.0-0 amd64 2.80.0-6ubuntu3.8 [73.6 kB]
Get:149 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libglib2.0-dev amd64 2.80.0-6ubuntu3.8 [1860 kB]
Get:150 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libatk1.0-dev amd64 2.52.0-1build1 [100 kB]
Get:151 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdbus-1-dev amd64 1.14.10-4ubuntu4.1 [190 kB]
Get:152 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xorg-sgml-doctools all 1:1.11-1.1 [10.9 kB]
Get:153 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 x11proto-dev all 2023.2-1 [602 kB]
Get:154 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxau-dev amd64 1:1.0.9-1build6 [9570 B]
Get:155 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxdmcp-dev amd64 1:1.1.3-0ubuntu6 [26.5 kB]
Get:156 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 xtrans-dev all 1.4.0-1 [68.9 kB]
Get:157 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpthread-stubs0-dev amd64 0.4-1build3 [4746 B]
Get:158 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb1-dev amd64 1.15-1ubuntu2 [85.8 kB]
Get:159 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libx11-dev amd64 2:1.8.7-1build1 [732 kB]
Get:160 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxext-dev amd64 2:1.3.4-1build2 [83.5 kB]
Get:161 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxfixes-dev amd64 1:6.0.0-2build1 [12.1 kB]
Get:162 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxi-dev amd64 2:1.8.1-1build1 [194 kB]
Get:163 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxtst-dev amd64 2:1.2.3-1.1build1 [15.9 kB]
Get:164 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libatspi2.0-dev amd64 2.52.0-1build1 [76.2 kB]
Get:165 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libatk-bridge2.0-dev amd64 2.52.0-1build1 [4284 B]
Get:166 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libboost1.83-dev amd64 1.83.0-2.1ubuntu3.2 [10.7 MB]
Get:167 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libboost-python1.83.0 amd64 1.83.0-2.1ubuntu3.2 [312 kB]
Get:168 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libboost-python1.83-dev amd64 1.83.0-2.1ubuntu3.2 [337 kB]
Get:169 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libboost-python-dev amd64 1.83.0.1ubuntu2 [4344 B]
Get:170 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libbrotli-dev amd64 1.1.0-2build2 [353 kB]
Get:171 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libmd-dev amd64 1.1.0-2build1.1 [45.5 kB]
Get:172 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libbsd-dev amd64 0.12.1-1build1.1 [169 kB]
Get:173 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libbz2-dev amd64 1.0.8-5.1ubuntu0.1 [33.6 kB]
Get:174 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libcairo-script-interpreter2 amd64 1.18.0-3build1 [60.3 kB]
Get:175 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libpng-dev amd64 1.6.43-5ubuntu0.6 [265 kB]
Get:176 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libfreetype-dev amd64 2.13.2+dfsg-1ubuntu0.1 [575 kB]
Get:177 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfontconfig-dev amd64 2.15.0-1.1ubuntu2 [161 kB]
Get:178 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpixman-1-dev amd64 0.42.2-1build1 [296 kB]
Get:179 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libice-dev amd64 2:1.0.10-1build3 [51.0 kB]
Get:180 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsm-dev amd64 2:1.2.3-1build3 [17.8 kB]
Get:181 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-render0-dev amd64 1.15-1ubuntu2 [19.6 kB]
Get:182 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-shm0-dev amd64 1.15-1ubuntu2 [8246 B]
Get:183 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxrender-dev amd64 1:0.9.10-1.1build1 [26.3 kB]
Get:184 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libcairo2-dev amd64 1.18.0-3build1 [41.1 kB]
Get:185 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libconfig-general-perl all 2.65-2 [57.1 kB]
Get:186 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libcss-dom-perl all 0.17-3 [108 kB]
Get:187 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libdatrie-dev amd64 0.2.13-3build1 [19.4 kB]
Get:188 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdeflate-dev amd64 1.19-1build1.1 [50.9 kB]
Get:189 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libedit-dev amd64 3.1-20230828-1build1 [119 kB]
Get:190 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libeditreadline-dev amd64 3.1-20230828-1build1 [2220 B]
Get:191 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libegl-mesa0 amd64 25.2.8-0ubuntu0.24.04.2 [117 kB]
Get:192 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libegl1 amd64 1.7.0-1build1 [28.7 kB]
Get:193 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglx-dev amd64 1.7.0-1build1 [14.2 kB]
Get:194 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgl-dev amd64 1.7.0-1build1 [102 kB]
Get:195 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libegl-dev amd64 1.7.0-1build1 [18.2 kB]
Get:196 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglvnd-core-dev amd64 1.7.0-1build1 [13.6 kB]
Get:197 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgles1 amd64 1.7.0-1build1 [11.6 kB]
Get:198 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgles2 amd64 1.7.0-1build1 [17.1 kB]
Get:199 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libgles-dev amd64 1.7.0-1build1 [50.5 kB]
Get:200 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libopengl0 amd64 1.7.0-1build1 [32.8 kB]
Get:201 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libopengl-dev amd64 1.7.0-1build1 [3454 B]
Get:202 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglvnd-dev amd64 1.7.0-1build1 [3198 B]
Get:203 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libegl1-mesa-dev amd64 25.2.8-0ubuntu0.24.04.2 [26.7 kB]
Get:204 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libepoxy-dev amd64 1.5.10-1build1 [132 kB]
Get:205 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libevent-2.1-7t64 amd64 2.1.12-stable-9ubuntu2.1 [146 kB]
Get:206 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libevent-pthreads-2.1-7t64 amd64 2.1.12-stable-9ubuntu2.1 [7984 B]
Get:207 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libevent-core-2.1-7t64 amd64 2.1.12-stable-9ubuntu2.1 [91.8 kB]
Get:208 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libfribidi-dev amd64 1.0.13-3build1 [64.8 kB]
Get:209 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgdk-pixbuf2.0-bin amd64 2.42.10+dfsg-3ubuntu3.3 [13.9 kB]
Get:210 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libjpeg-turbo8-dev amd64 2.1.5-2ubuntu2 [295 kB]
Get:211 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libjpeg8-dev amd64 8c-2ubuntu11 [1484 B]
Get:212 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libjpeg-dev amd64 8c-2ubuntu11 [1482 B]
Get:213 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libjbig-dev amd64 2.1-6.1ubuntu2 [27.9 kB]
Get:214 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 liblzma-dev amd64 5.6.1+really5.4.5-1ubuntu0.3 [176 kB]
Get:215 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwebpdecoder3 amd64 1.3.2-0.4build3 [114 kB]
Get:216 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsharpyuv-dev amd64 1.3.2-0.4build3 [16.0 kB]
Get:217 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwebp-dev amd64 1.3.2-0.4build3 [367 kB]
Get:218 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libtiffxx6 amd64 4.5.1+git230720-4ubuntu2.5 [5642 B]
Get:219 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 liblerc-dev amd64 4.0.0+ds-4ubuntu2 [182 kB]
Get:220 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libtiff-dev amd64 4.5.1+git230720-4ubuntu2.5 [338 kB]
Get:221 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgdk-pixbuf-2.0-dev amd64 2.42.10+dfsg-3ubuntu3.3 [47.9 kB]
Get:222 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglu1-mesa amd64 9.0.2-1.1build1 [152 kB]
Get:223 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libglu1-mesa-dev amd64 9.0.2-1.1build1 [237 kB]
Get:224 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgpiod2t64 amd64 1.6.3-1.1build1 [41.9 kB]
Get:225 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libgpiod-dev amd64 1.6.3-1.1build1 [60.2 kB]
Get:226 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgraphite2-dev amd64 1.3.14-2ubuntu0.24.04.1 [14.7 kB]
Get:227 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-icu0 amd64 8.3.0-2build2 [13.3 kB]
Get:228 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-subset0 amd64 8.3.0-2build2 [448 kB]
Get:229 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-cairo0 amd64 8.3.0-2build2 [26.2 kB]
Get:230 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libharfbuzz-dev amd64 8.3.0-2build2 [142 kB]
Get:231 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libthai-dev amd64 0.1.29-2build1 [26.6 kB]
Get:232 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxft-dev amd64 2.3.6-1build1 [64.3 kB]
Get:233 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 pango1.0-tools amd64 1.52.1+ds-1build1 [36.7 kB]
Get:234 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libpango1.0-dev amd64 1.52.1+ds-1build1 [147 kB]
Get:235 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwayland-server0 amd64 1.22.0-2.1build1 [33.9 kB]
Get:236 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwayland-bin amd64 1.22.0-2.1build1 [20.6 kB]
Get:237 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwayland-dev amd64 1.22.0-2.1build1 [71.3 kB]
Get:238 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcomposite-dev amd64 1:0.4.5-1build3 [9374 B]
Get:239 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcursor-dev amd64 1:1.2.1-1build1 [31.8 kB]
Get:240 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxdamage-dev amd64 1:1.1.6-1build1 [5270 B]
Get:241 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxinerama-dev amd64 2:1.1.4-3build1 [7988 B]
Get:242 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxkbcommon-dev amd64 1.6.0-1build1 [56.3 kB]
Get:243 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxrandr-dev amd64 2:1.5.2-2build1 [26.4 kB]
Get:244 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 wayland-protocols all 1.45-1~ubuntu0.24.04.2 [114 kB]
Get:245 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libgtk-3-dev amd64 3.24.41-4ubuntu1.3 [1096 kB]
Get:246 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libgtk2.0-dev amd64 2.24.33-4ubuntu1.1 [779 kB]
Get:247 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwacom-common all 2.10.0-2 [63.4 kB]
Get:248 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libwacom9 amd64 2.10.0-2 [23.9 kB]
Get:249 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libinput-bin amd64 1.25.0-1ubuntu3.6 [23.2 kB]
Get:250 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libmtdev1t64 amd64 1.1.6-1.1build1 [14.4 kB]
Get:251 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libinput10 amd64 1.25.0-1ubuntu3.6 [133 kB]
Get:252 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 liblocale-codes-perl all 3.77-1 [303 kB]
Get:253 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmd4c0 amd64 0.4.8-1build1 [42.3 kB]
Get:254 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libminizip1t64 amd64 1:1.3.dfsg-3.1ubuntu2.2 [22.2 kB]
Get:255 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libnet-ip-perl all 1.26-3ubuntu0.24.04.1 [27.4 kB]
Get:256 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libnetpbm11t64 amd64 2:11.05.02-1.1build1 [114 kB]
Get:257 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libopus0 amd64 1.4-1build1 [208 kB]
Get:258 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5core5t64 amd64 5.15.13+dfsg-1ubuntu1 [2011 kB]
Get:259 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5dbus5t64 amd64 5.15.13+dfsg-1ubuntu1 [220 kB]
Get:260 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5network5t64 amd64 5.15.13+dfsg-1ubuntu1 [723 kB]
Get:261 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-icccm4 amd64 0.4.1-1.1build3 [10.8 kB]
Get:262 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-util1 amd64 0.4.0-1build3 [10.7 kB]
Get:263 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-image0 amd64 0.4.0-2build1 [10.8 kB]
Get:264 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-keysyms1 amd64 0.4.0-1build4 [7956 B]
Get:265 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-render-util0 amd64 0.3.9-1build4 [9608 B]
Get:266 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-shape0 amd64 1.15-1ubuntu2 [6100 B]
Get:267 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-xinerama0 amd64 1.15-1ubuntu2 [5410 B]
Get:268 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-xinput0 amd64 1.15-1ubuntu2 [33.2 kB]
Get:269 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxcb-xkb1 amd64 1.15-1ubuntu2 [32.3 kB]
Get:270 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxkbcommon-x11-0 amd64 1.6.0-1build1 [14.5 kB]
Get:271 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5gui5t64 amd64 5.15.13+dfsg-1ubuntu1 [3748 kB]
Get:272 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5widgets5t64 amd64 5.15.13+dfsg-1ubuntu1 [2561 kB]
Get:273 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5xml5t64 amd64 5.15.13+dfsg-1ubuntu1 [124 kB]
Get:274 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5designer5 amd64 5.15.13-1 [2824 kB]
Get:275 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5sql5t64 amd64 5.15.13+dfsg-1ubuntu1 [122 kB]
Get:276 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5help5 amd64 5.15.13-1 [161 kB]
Get:277 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5positioning5 amd64 5.15.13+dfsg-1 [222 kB]
Get:278 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5printsupport5t64 amd64 5.15.13+dfsg-1ubuntu1 [208 kB]
Get:279 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5qml5 amd64 5.15.13+dfsg-1ubuntu0.1 [1482 kB]
Get:280 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5qmlmodels5 amd64 5.15.13+dfsg-1ubuntu0.1 [203 kB]
Get:281 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5quick5 amd64 5.15.13+dfsg-1ubuntu0.1 [1733 kB]
Get:282 http://azure.archive.ubuntu.com/ubuntu noble-updates/universe amd64 libqt5quickwidgets5 amd64 5.15.13+dfsg-1ubuntu0.1 [38.4 kB]
Get:283 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5test5t64 amd64 5.15.13+dfsg-1ubuntu1 [148 kB]
Get:284 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webchannel5 amd64 5.15.13-1 [61.9 kB]
Get:285 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webengine-data all 5.15.16+dfsg-3 [7622 kB]
Get:286 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libvpx9 amd64 1.14.0-1ubuntu2.3 [1143 kB]
Get:287 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webenginecore5 amd64 5.15.16+dfsg-3 [42.6 MB]
Get:288 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webengine5 amd64 5.15.16+dfsg-3 [169 kB]
Get:289 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libqt5webenginewidgets5 amd64 5.15.16+dfsg-3 [121 kB]
Get:290 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsource-highlight-common all 3.1.9-4.3build1 [64.2 kB]
Get:291 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libsource-highlight4t64 amd64 3.1.9-4.3build1 [258 kB]
Get:292 http://azure.archive.ubuntu.com/ubuntu noble-updates/main amd64 libudev-dev amd64 255.4-1ubuntu8.17 [22.0 kB]
Get:293 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libusb-1.0-0-dev amd64 2:1.0.27-1 [77.7 kB]
Get:294 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxt-dev amd64 1:1.2.1-1.2build1 [394 kB]
Get:295 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxmu-headers all 2:1.1.3-3build2 [53.0 kB]
Get:296 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxmu-dev amd64 2:1.1.3-3build2 [55.4 kB]
Get:297 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libxss-dev amd64 1:1.2.3-1build3 [12.1 kB]
Get:298 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 netpbm amd64 2:11.05.02-1.1build1 [2054 kB]
Get:299 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 po4a all 0.69-1 [2184 kB]
Get:300 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-lxml amd64 5.2.1-1 [1243 kB]
Get:301 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.sip amd64 12.13.0-1build3 [61.3 kB]
Get:302 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5 amd64 5.15.10+dfsg-1build6 [2753 kB]
Get:303 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtwebchannel amd64 5.15.10+dfsg-1build6 [15.1 kB]
Get:304 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-pyqt5.qtwebengine amd64 5.15.6-1build2 [119 kB]
Get:305 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 python3-tk amd64 3.12.3-0ubuntu1 [102 kB]
Get:306 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-yapps all 2.2.1-3.2 [16.2 kB]
Get:307 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 source-highlight amd64 3.1.9-4.3build1 [327 kB]
Get:308 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 tcl8.6-dev amd64 8.6.14+dfsg-1build1 [1000 kB]
Get:309 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 tclx8.4 amd64 8.4.1-4 [82.6 kB]
Get:310 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-font-utils all 2023.20240207-1 [7035 kB]
Get:311 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-lang-cyrillic all 2023.20240207-1 [20.8 MB]
Get:312 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-lang-european all 2023.20240207-1 [16.5 MB]
Get:313 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-lang-french all 2023.20240207-1 [91.5 MB]
Get:314 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-lang-german all 2023.20240207-1 [21.7 MB]
Get:315 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-lang-polish all 2023.20240207-1 [8617 kB]
Get:316 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 texlive-lang-spanish all 2023.20240207-1 [12.4 MB]
Get:317 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 tk8.6-dev amd64 8.6.14-1build1 [788 kB]
Get:318 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 w3c-linkchecker all 5.0.0-2 [58.5 kB]
Get:319 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 x11-xserver-utils amd64 7.7+10build2 [169 kB]
Get:320 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 yapps2 all 2.2.1-3.2 [41.4 kB]
Get:321 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmodbus5 amd64 3.1.10-1ubuntu1 [34.4 kB]
Get:322 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 libmodbus-dev amd64 3.1.10-1ubuntu1 [18.6 kB]
Get:323 http://azure.archive.ubuntu.com/ubuntu noble/main amd64 libtirpc-dev amd64 1.3.4+ds-1.1build1 [193 kB]
Get:324 http://azure.archive.ubuntu.com/ubuntu noble/universe amd64 python3-xlib all 0.33-2 [120 kB]
Preconfiguring packages ...
Fetched 765 MB in 29s (26.3 MB/s)
Selecting previously unselected package poppler-data.
(Reading database ... (Reading database ... 5%(Reading database ... 10%(Reading database ... 15%(Reading database ... 20%(Reading database ... 25%(Reading database ... 30%(Reading database ... 35%(Reading database ... 40%(Reading database ... 45%(Reading database ... 50%(Reading database ... 55%(Reading database ... 60%(Reading database ... 65%(Reading database ... 70%(Reading database ... 75%(Reading database ... 80%(Reading database ... 85%(Reading database ... 90%(Reading database ... 95%(Reading database ... 100%(Reading database ... 208197 files and directories currently installed.)
Preparing to unpack .../000-poppler-data_0.4.12-1_all.deb ...
Unpacking poppler-data (0.4.12-1) ...
Selecting previously unselected package asciidoc-common.
Preparing to unpack .../001-asciidoc-common_10.2.0-2_all.deb ...
Unpacking asciidoc-common (10.2.0-2) ...
Selecting previously unselected package docbook-xsl.
Preparing to unpack .../002-docbook-xsl_1.79.2+dfsg-7_all.deb ...
Unpacking docbook-xsl (1.79.2+dfsg-7) ...
Selecting previously unselected package libxml2-utils.
Preparing to unpack .../003-libxml2-utils_2.9.14+dfsg-1.3ubuntu3.8_amd64.deb ...
Unpacking libxml2-utils (2.9.14+dfsg-1.3ubuntu3.8) ...
Selecting previously unselected package xsltproc.
Preparing to unpack .../004-xsltproc_1.1.39-0exp1ubuntu0.24.04.3_amd64.deb ...
Unpacking xsltproc (1.1.39-0exp1ubuntu0.24.04.3) ...
Selecting previously unselected package asciidoc-base.
Preparing to unpack .../005-asciidoc-base_10.2.0-2_all.deb ...
Unpacking asciidoc-base (10.2.0-2) ...
Selecting previously unselected package asciidoc.
Preparing to unpack .../006-asciidoc_10.2.0-2_all.deb ...
Unpacking asciidoc (10.2.0-2) ...
Selecting previously unselected package sgml-data.
Preparing to unpack .../007-sgml-data_2.0.11+nmu1_all.deb ...
Unpacking sgml-data (2.0.11+nmu1) ...
Selecting previously unselected package docbook-xml.
Preparing to unpack .../008-docbook-xml_4.5-12_all.deb ...
Unpacking docbook-xml (4.5-12) ...
Selecting previously unselected package libpaper1:amd64.
Preparing to unpack .../009-libpaper1_1.1.29build1_amd64.deb ...
Unpacking libpaper1:amd64 (1.1.29build1) ...
Selecting previously unselected package libpaper-utils.
Preparing to unpack .../010-libpaper-utils_1.1.29build1_amd64.deb ...
Unpacking libpaper-utils (1.1.29build1) ...
Selecting previously unselected package libkpathsea6:amd64.
Preparing to unpack .../011-libkpathsea6_2023.20230311.66589-9build3_amd64.deb ...
Unpacking libkpathsea6:amd64 (2023.20230311.66589-9build3) ...
Selecting previously unselected package libptexenc1:amd64.
Preparing to unpack .../012-libptexenc1_2023.20230311.66589-9build3_amd64.deb ...
Unpacking libptexenc1:amd64 (2023.20230311.66589-9build3) ...
Selecting previously unselected package libsynctex2:amd64.
Preparing to unpack .../013-libsynctex2_2023.20230311.66589-9build3_amd64.deb ...
Unpacking libsynctex2:amd64 (2023.20230311.66589-9build3) ...
Selecting previously unselected package libtexlua53-5:amd64.
Preparing to unpack .../014-libtexlua53-5_2023.20230311.66589-9build3_amd64.deb ...
Unpacking libtexlua53-5:amd64 (2023.20230311.66589-9build3) ...
Selecting previously unselected package libpotrace0:amd64.
Preparing to unpack .../015-libpotrace0_1.16-2build1_amd64.deb ...
Unpacking libpotrace0:amd64 (1.16-2build1) ...
Selecting previously unselected package libteckit0:amd64.
Preparing to unpack .../016-libteckit0_2.5.12+ds1-1_amd64.deb ...
Unpacking libteckit0:amd64 (2.5.12+ds1-1) ...
Selecting previously unselected package libzzip-0-13t64:amd64.
Preparing to unpack .../017-libzzip-0-13t64_0.13.72+dfsg.1-1.2build1_amd64.deb ...
Unpacking libzzip-0-13t64:amd64 (0.13.72+dfsg.1-1.2build1) ...
Selecting previously unselected package texlive-binaries.
Preparing to unpack .../018-texlive-binaries_2023.20230311.66589-9build3_amd64.deb ...
Unpacking texlive-binaries (2023.20230311.66589-9build3) ...
Selecting previously unselected package texlive-base.
Preparing to unpack .../019-texlive-base_2023.20240207-1_all.deb ...
Unpacking texlive-base (2023.20240207-1) ...
Selecting previously unselected package texlive-fonts-recommended.
Preparing to unpack .../020-texlive-fonts-recommended_2023.20240207-1_all.deb ...
Unpacking texlive-fonts-recommended (2023.20240207-1) ...
Selecting previously unselected package fonts-lmodern.
Preparing to unpack .../021-fonts-lmodern_2.005-1_all.deb ...
Unpacking fonts-lmodern (2.005-1) ...
Selecting previously unselected package texlive-latex-base.
Preparing to unpack .../022-texlive-latex-base_2023.20240207-1_all.deb ...
Unpacking texlive-latex-base (2023.20240207-1) ...
Selecting previously unselected package texlive-latex-recommended.
Preparing to unpack .../023-texlive-latex-recommended_2023.20240207-1_all.deb ...
Unpacking texlive-latex-recommended (2023.20240207-1) ...
Selecting previously unselected package texlive.
Preparing to unpack .../024-texlive_2023.20240207-1_all.deb ...
Unpacking texlive (2023.20240207-1) ...
Selecting previously unselected package liblatex-tounicode-perl.
Preparing to unpack .../025-liblatex-tounicode-perl_0.54-2_all.deb ...
Unpacking liblatex-tounicode-perl (0.54-2) ...
Selecting previously unselected package libbibtex-parser-perl.
Preparing to unpack .../026-libbibtex-parser-perl_1.04+dfsg-1_all.deb ...
Unpacking libbibtex-parser-perl (1.04+dfsg-1) ...
Selecting previously unselected package texlive-bibtex-extra.
Preparing to unpack .../027-texlive-bibtex-extra_2023.20240207-1_all.deb ...
Unpacking texlive-bibtex-extra (2023.20240207-1) ...
Selecting previously unselected package libsombok3:amd64.
Preparing to unpack .../028-libsombok3_2.4.0-2build1_amd64.deb ...
Unpacking libsombok3:amd64 (2.4.0-2build1) ...
Selecting previously unselected package libmime-charset-perl.
Preparing to unpack .../029-libmime-charset-perl_1.013.1-2_all.deb ...
Unpacking libmime-charset-perl (1.013.1-2) ...
Selecting previously unselected package libunicode-linebreak-perl.
Preparing to unpack .../030-libunicode-linebreak-perl_0.0.20190101-1build7_amd64.deb ...
Unpacking libunicode-linebreak-perl (0.0.20190101-1build7) ...
Selecting previously unselected package libyaml-tiny-perl.
Preparing to unpack .../031-libyaml-tiny-perl_1.74-1_all.deb ...
Unpacking libyaml-tiny-perl (1.74-1) ...
Selecting previously unselected package xfonts-encodings.
Preparing to unpack .../032-xfonts-encodings_1%3a1.0.5-0ubuntu2_all.deb ...
Unpacking xfonts-encodings (1:1.0.5-0ubuntu2) ...
Selecting previously unselected package xfonts-utils.
Preparing to unpack .../033-xfonts-utils_1%3a7.7+6build3_amd64.deb ...
Unpacking xfonts-utils (1:7.7+6build3) ...
Selecting previously unselected package lmodern.
Preparing to unpack .../034-lmodern_2.005-1_all.deb ...
Unpacking lmodern (2.005-1) ...
Selecting previously unselected package texlive-luatex.
Preparing to unpack .../035-texlive-luatex_2023.20240207-1_all.deb ...
Unpacking texlive-luatex (2023.20240207-1) ...
Selecting previously unselected package texlive-plain-generic.
Preparing to unpack .../036-texlive-plain-generic_2023.20240207-1_all.deb ...
Unpacking texlive-plain-generic (2023.20240207-1) ...
Selecting previously unselected package texlive-extra-utils.
Preparing to unpack .../037-texlive-extra-utils_2023.20240207-1_all.deb ...
Unpacking texlive-extra-utils (2023.20240207-1) ...
Selecting previously unselected package libapache-pom-java.
Preparing to unpack .../038-libapache-pom-java_29-2_all.deb ...
Unpacking libapache-pom-java (29-2) ...
Selecting previously unselected package libcommons-parent-java.
Preparing to unpack .../039-libcommons-parent-java_56-1_all.deb ...
Unpacking libcommons-parent-java (56-1) ...
Selecting previously unselected package libcommons-logging-java.
Preparing to unpack .../040-libcommons-logging-java_1.3.0-1ubuntu1_all.deb ...
Unpacking libcommons-logging-java (1.3.0-1ubuntu1) ...
Selecting previously unselected package libfontbox-java.
Preparing to unpack .../041-libfontbox-java_1%3a1.8.16-5_all.deb ...
Unpacking libfontbox-java (1:1.8.16-5) ...
Selecting previously unselected package libpdfbox-java.
Preparing to unpack .../042-libpdfbox-java_1%3a1.8.16-5_all.deb ...
Unpacking libpdfbox-java (1:1.8.16-5) ...
Selecting previously unselected package preview-latex-style.
Preparing to unpack .../043-preview-latex-style_13.2-1_all.deb ...
Unpacking preview-latex-style (13.2-1) ...
Selecting previously unselected package texlive-pictures.
Preparing to unpack .../044-texlive-pictures_2023.20240207-1_all.deb ...
Unpacking texlive-pictures (2023.20240207-1) ...
Selecting previously unselected package texlive-latex-extra.
Preparing to unpack .../045-texlive-latex-extra_2023.20240207-1_all.deb ...
Unpacking texlive-latex-extra (2023.20240207-1) ...
Selecting previously unselected package fonts-gfs-baskerville.
Preparing to unpack .../046-fonts-gfs-baskerville_1.1-6_all.deb ...
Unpacking fonts-gfs-baskerville (1.1-6) ...
Selecting previously unselected package fonts-gfs-porson.
Preparing to unpack .../047-fonts-gfs-porson_1.1-7_all.deb ...
Unpacking fonts-gfs-porson (1.1-7) ...
Selecting previously unselected package texlive-lang-greek.
Preparing to unpack .../048-texlive-lang-greek_2023.20240207-1_all.deb ...
Unpacking texlive-lang-greek (2023.20240207-1) ...
Selecting previously unselected package texlive-science.
Preparing to unpack .../049-texlive-science_2023.20240207-1_all.deb ...
Unpacking texlive-science (2023.20240207-1) ...
Selecting previously unselected package dblatex.
Preparing to unpack .../050-dblatex_0.3.12py3-4_all.deb ...
Unpacking dblatex (0.3.12py3-4) ...
Selecting previously unselected package libosp5.
Preparing to unpack .../051-libosp5_1.5.2-15ubuntu2_amd64.deb ...
Unpacking libosp5 (1.5.2-15ubuntu2) ...
Selecting previously unselected package libostyle1t64.
Preparing to unpack .../052-libostyle1t64_1.4devel1-23.1build1_amd64.deb ...
Unpacking libostyle1t64 (1.4devel1-23.1build1) ...
Selecting previously unselected package openjade.
Preparing to unpack .../053-openjade_1.4devel1-23.1build1_amd64.deb ...
Unpacking openjade (1.4devel1-23.1build1) ...
Selecting previously unselected package docbook-dsssl.
Preparing to unpack .../054-docbook-dsssl_1.79-10_all.deb ...
Unpacking docbook-dsssl (1.79-10) ...
Selecting previously unselected package teckit.
Preparing to unpack .../055-teckit_2.5.12+ds1-1_amd64.deb ...
Unpacking teckit (2.5.12+ds1-1) ...
Selecting previously unselected package tipa.
Preparing to unpack .../056-tipa_2%3a1.3-21_all.deb ...
Unpacking tipa (2:1.3-21) ...
Selecting previously unselected package texlive-xetex.
Preparing to unpack .../057-texlive-xetex_2023.20240207-1_all.deb ...
Unpacking texlive-xetex (2023.20240207-1) ...
Selecting previously unselected package texlive-formats-extra.
Preparing to unpack .../058-texlive-formats-extra_2023.20240207-1_all.deb ...
Unpacking texlive-formats-extra (2023.20240207-1) ...
Selecting previously unselected package lynx-common.
Preparing to unpack .../059-lynx-common_2.9.0rel.0-2build2_all.deb ...
Unpacking lynx-common (2.9.0rel.0-2build2) ...
Selecting previously unselected package lynx.
Preparing to unpack .../060-lynx_2.9.0rel.0-2build2_amd64.deb ...
Unpacking lynx (2.9.0rel.0-2build2) ...
Selecting previously unselected package libsgmls-perl.
Preparing to unpack .../061-libsgmls-perl_1.03ii-38_all.deb ...
Unpacking libsgmls-perl (1.03ii-38) ...
Selecting previously unselected package sgmlspl.
Preparing to unpack .../062-sgmlspl_1.03ii-38_all.deb ...
Unpacking sgmlspl (1.03ii-38) ...
Selecting previously unselected package opensp.
Preparing to unpack .../063-opensp_1.5.2-15ubuntu2_amd64.deb ...
Unpacking opensp (1.5.2-15ubuntu2) ...
Selecting previously unselected package docbook-utils.
Preparing to unpack .../064-docbook-utils_0.6.14-4_all.deb ...
Unpacking docbook-utils (0.6.14-4) ...
Selecting previously unselected package asciidoc-dblatex.
Preparing to unpack .../065-asciidoc-dblatex_10.2.0-2_all.deb ...
Unpacking asciidoc-dblatex (10.2.0-2) ...
Selecting previously unselected package tk8.6-blt2.5.
Preparing to unpack .../066-tk8.6-blt2.5_2.5.3+dfsg-7build1_amd64.deb ...
Unpacking tk8.6-blt2.5 (2.5.3+dfsg-7build1) ...
Selecting previously unselected package blt.
Preparing to unpack .../067-blt_2.5.3+dfsg-7build1_amd64.deb ...
Unpacking blt (2.5.3+dfsg-7build1) ...
Selecting previously unselected package bwidget.
Preparing to unpack .../068-bwidget_1.9.16-1_all.deb ...
Unpacking bwidget (1.9.16-1) ...
Selecting previously unselected package desktop-file-utils.
Preparing to unpack .../069-desktop-file-utils_0.27-2build1_amd64.deb ...
Unpacking desktop-file-utils (0.27-2build1) ...
Selecting previously unselected package dh-python.
Preparing to unpack .../070-dh-python_6.20240401_all.deb ...
Unpacking dh-python (6.20240401) ...
Selecting previously unselected package fonts-urw-base35.
Preparing to unpack .../071-fonts-urw-base35_20200910-8_all.deb ...
Unpacking fonts-urw-base35 (20200910-8) ...
Selecting previously unselected package libgs-common.
Preparing to unpack .../072-libgs-common_10.02.1~dfsg1-0ubuntu7.8_all.deb ...
Unpacking libgs-common (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package libgs10-common.
Preparing to unpack .../073-libgs10-common_10.02.1~dfsg1-0ubuntu7.8_all.deb ...
Unpacking libgs10-common (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package libidn12:amd64.
Preparing to unpack .../074-libidn12_1.42-1ubuntu0.1_amd64.deb ...
Unpacking libidn12:amd64 (1.42-1ubuntu0.1) ...
Selecting previously unselected package libijs-0.35:amd64.
Preparing to unpack .../075-libijs-0.35_0.35-15.1build1_amd64.deb ...
Unpacking libijs-0.35:amd64 (0.35-15.1build1) ...
Selecting previously unselected package libjbig2dec0:amd64.
Preparing to unpack .../076-libjbig2dec0_0.20-1ubuntu0.24.04.1_amd64.deb ...
Unpacking libjbig2dec0:amd64 (0.20-1ubuntu0.24.04.1) ...
Selecting previously unselected package libgs10:amd64.
Preparing to unpack .../077-libgs10_10.02.1~dfsg1-0ubuntu7.8_amd64.deb ...
Unpacking libgs10:amd64 (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package ghostscript.
Preparing to unpack .../078-ghostscript_10.02.1~dfsg1-0ubuntu7.8_amd64.deb ...
Unpacking ghostscript (10.02.1~dfsg1-0ubuntu7.8) ...
Selecting previously unselected package dvipng.
Preparing to unpack .../079-dvipng_1.15-1.1_amd64.deb ...
Unpacking dvipng (1.15-1.1) ...
Selecting previously unselected package gir1.2-atk-1.0:amd64.
Preparing to unpack .../080-gir1.2-atk-1.0_2.52.0-1build1_amd64.deb ...
Unpacking gir1.2-atk-1.0:amd64 (2.52.0-1build1) ...
Selecting previously unselected package gir1.2-freedesktop:amd64.
Preparing to unpack .../081-gir1.2-freedesktop_1.80.1-1_amd64.deb ...
Unpacking gir1.2-freedesktop:amd64 (1.80.1-1) ...
Selecting previously unselected package gir1.2-atspi-2.0:amd64.
Preparing to unpack .../082-gir1.2-atspi-2.0_2.52.0-1build1_amd64.deb ...
Unpacking gir1.2-atspi-2.0:amd64 (2.52.0-1build1) ...
Selecting previously unselected package gir1.2-glib-2.0-dev:amd64.
Preparing to unpack .../083-gir1.2-glib-2.0-dev_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking gir1.2-glib-2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package gir1.2-freedesktop-dev:amd64.
Preparing to unpack .../084-gir1.2-freedesktop-dev_1.80.1-1_amd64.deb ...
Unpacking gir1.2-freedesktop-dev:amd64 (1.80.1-1) ...
Selecting previously unselected package gir1.2-gdkpixbuf-2.0:amd64.
Preparing to unpack .../085-gir1.2-gdkpixbuf-2.0_2.42.10+dfsg-3ubuntu3.3_amd64.deb ...
Unpacking gir1.2-gdkpixbuf-2.0:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Selecting previously unselected package libgtk2.0-common.
Preparing to unpack .../086-libgtk2.0-common_2.24.33-4ubuntu1.1_all.deb ...
Unpacking libgtk2.0-common (2.24.33-4ubuntu1.1) ...
Selecting previously unselected package libharfbuzz-gobject0:amd64.
Preparing to unpack .../087-libharfbuzz-gobject0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-gobject0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package gir1.2-harfbuzz-0.0:amd64.
Preparing to unpack .../088-gir1.2-harfbuzz-0.0_8.3.0-2build2_amd64.deb ...
Unpacking gir1.2-harfbuzz-0.0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libpangoxft-1.0-0:amd64.
Preparing to unpack .../089-libpangoxft-1.0-0_1.52.1+ds-1build1_amd64.deb ...
Unpacking libpangoxft-1.0-0:amd64 (1.52.1+ds-1build1) ...
Selecting previously unselected package gir1.2-pango-1.0:amd64.
Preparing to unpack .../090-gir1.2-pango-1.0_1.52.1+ds-1build1_amd64.deb ...
Unpacking gir1.2-pango-1.0:amd64 (1.52.1+ds-1build1) ...
Selecting previously unselected package libgtk2.0-0t64:amd64.
Preparing to unpack .../091-libgtk2.0-0t64_2.24.33-4ubuntu1.1_amd64.deb ...
Unpacking libgtk2.0-0t64:amd64 (2.24.33-4ubuntu1.1) ...
Selecting previously unselected package gir1.2-gtk-2.0:amd64.
Preparing to unpack .../092-gir1.2-gtk-2.0_2.24.33-4ubuntu1.1_amd64.deb ...
Unpacking gir1.2-gtk-2.0:amd64 (2.24.33-4ubuntu1.1) ...
Selecting previously unselected package gir1.2-gtk-3.0:amd64.
Preparing to unpack .../093-gir1.2-gtk-3.0_3.24.41-4ubuntu1.3_amd64.deb ...
Unpacking gir1.2-gtk-3.0:amd64 (3.24.41-4ubuntu1.3) ...
Selecting previously unselected package libproxy1v5:amd64.
Preparing to unpack .../094-libproxy1v5_0.5.4-4build1_amd64.deb ...
Unpacking libproxy1v5:amd64 (0.5.4-4build1) ...
Selecting previously unselected package glib-networking-common.
Preparing to unpack .../095-glib-networking-common_2.80.0-1build1_all.deb ...
Unpacking glib-networking-common (2.80.0-1build1) ...
Selecting previously unselected package glib-networking-services.
Preparing to unpack .../096-glib-networking-services_2.80.0-1build1_amd64.deb ...
Unpacking glib-networking-services (2.80.0-1build1) ...
Selecting previously unselected package session-migration.
Preparing to unpack .../097-session-migration_0.3.9build1_amd64.deb ...
Unpacking session-migration (0.3.9build1) ...
Selecting previously unselected package gsettings-desktop-schemas.
Preparing to unpack .../098-gsettings-desktop-schemas_46.1-0ubuntu1_all.deb ...
Unpacking gsettings-desktop-schemas (46.1-0ubuntu1) ...
Selecting previously unselected package glib-networking:amd64.
Preparing to unpack .../099-glib-networking_2.80.0-1build1_amd64.deb ...
Unpacking glib-networking:amd64 (2.80.0-1build1) ...
Selecting previously unselected package libann0.
Preparing to unpack .../100-libann0_1.1.2+doc-9build1_amd64.deb ...
Unpacking libann0 (1.1.2+doc-9build1) ...
Selecting previously unselected package libcdt5:amd64.
Preparing to unpack .../101-libcdt5_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libcdt5:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libcgraph6:amd64.
Preparing to unpack .../102-libcgraph6_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libcgraph6:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libgts-0.7-5t64:amd64.
Preparing to unpack .../103-libgts-0.7-5t64_0.7.6+darcs121130-5.2build1_amd64.deb ...
Unpacking libgts-0.7-5t64:amd64 (0.7.6+darcs121130-5.2build1) ...
Selecting previously unselected package libpathplan4:amd64.
Preparing to unpack .../104-libpathplan4_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libpathplan4:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libgvc6.
Preparing to unpack .../105-libgvc6_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libgvc6 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package libgvpr2:amd64.
Preparing to unpack .../106-libgvpr2_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking libgvpr2:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package liblab-gamut1:amd64.
Preparing to unpack .../107-liblab-gamut1_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking liblab-gamut1:amd64 (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package graphviz.
Preparing to unpack .../108-graphviz_2.42.2-9ubuntu0.1_amd64.deb ...
Unpacking graphviz (2.42.2-9ubuntu0.1) ...
Selecting previously unselected package groff.
Preparing to unpack .../109-groff_1.23.0-3build2_amd64.deb ...
Unpacking groff (1.23.0-3build2) ...
Selecting previously unselected package imagemagick-6.q16.
Preparing to unpack .../110-imagemagick-6.q16_8%3a6.9.12.98+dfsg1-5.2build2_amd64.deb ...
Unpacking imagemagick-6.q16 (8:6.9.12.98+dfsg1-5.2build2) ...
Selecting previously unselected package imagemagick.
Preparing to unpack .../111-imagemagick_8%3a6.9.12.98+dfsg1-5.2build2_amd64.deb ...
Unpacking imagemagick (8:6.9.12.98+dfsg1-5.2build2) ...
Selecting previously unselected package librsvg2-2:amd64.
Preparing to unpack .../112-librsvg2-2_2.58.0+dfsg-1build1_amd64.deb ...
Unpacking librsvg2-2:amd64 (2.58.0+dfsg-1build1) ...
Selecting previously unselected package librsvg2-common:amd64.
Preparing to unpack .../113-librsvg2-common_2.58.0+dfsg-1build1_amd64.deb ...
Unpacking librsvg2-common:amd64 (2.58.0+dfsg-1build1) ...
Selecting previously unselected package libdouble-conversion3:amd64.
Preparing to unpack .../114-libdouble-conversion3_3.3.0-1build1_amd64.deb ...
Unpacking libdouble-conversion3:amd64 (3.3.0-1build1) ...
Selecting previously unselected package libgslcblas0:amd64.
Preparing to unpack .../115-libgslcblas0_2.7.1+dfsg-6ubuntu2_amd64.deb ...
Unpacking libgslcblas0:amd64 (2.7.1+dfsg-6ubuntu2) ...
Selecting previously unselected package libgsl27:amd64.
Preparing to unpack .../116-libgsl27_2.7.1+dfsg-6ubuntu2_amd64.deb ...
Unpacking libgsl27:amd64 (2.7.1+dfsg-6ubuntu2) ...
Selecting previously unselected package lib2geom1.2.0t64:amd64.
Preparing to unpack .../117-lib2geom1.2.0t64_1.2.2-3.1build1_amd64.deb ...
Unpacking lib2geom1.2.0t64:amd64 (1.2.2-3.1build1) ...
Selecting previously unselected package libsigc++-2.0-0v5:amd64.
Preparing to unpack .../118-libsigc++-2.0-0v5_2.12.1-2_amd64.deb ...
Unpacking libsigc++-2.0-0v5:amd64 (2.12.1-2) ...
Selecting previously unselected package libglibmm-2.4-1t64:amd64.
Preparing to unpack .../119-libglibmm-2.4-1t64_2.66.7-1build1_amd64.deb ...
Unpacking libglibmm-2.4-1t64:amd64 (2.66.7-1build1) ...
Selecting previously unselected package libatkmm-1.6-1v5:amd64.
Preparing to unpack .../120-libatkmm-1.6-1v5_2.28.4-1build4_amd64.deb ...
Unpacking libatkmm-1.6-1v5:amd64 (2.28.4-1build4) ...
Selecting previously unselected package libboost-filesystem1.83.0:amd64.
Preparing to unpack .../121-libboost-filesystem1.83.0_1.83.0-2.1ubuntu3.2_amd64.deb ...
Unpacking libboost-filesystem1.83.0:amd64 (1.83.0-2.1ubuntu3.2) ...
Selecting previously unselected package libcairomm-1.0-1v5:amd64.
Preparing to unpack .../122-libcairomm-1.0-1v5_1.14.5-1build1_amd64.deb ...
Unpacking libcairomm-1.0-1v5:amd64 (1.14.5-1build1) ...
Selecting previously unselected package librevenge-0.0-0:amd64.
Preparing to unpack .../123-librevenge-0.0-0_0.0.5-3build1_amd64.deb ...
Unpacking librevenge-0.0-0:amd64 (0.0.5-3build1) ...
Selecting previously unselected package libcdr-0.1-1:amd64.
Preparing to unpack .../124-libcdr-0.1-1_0.1.7-1build2_amd64.deb ...
Unpacking libcdr-0.1-1:amd64 (0.1.7-1build2) ...
Selecting previously unselected package libgspell-1-common.
Preparing to unpack .../125-libgspell-1-common_1.12.2-1build4_all.deb ...
Unpacking libgspell-1-common (1.12.2-1build4) ...
Selecting previously unselected package libgspell-1-2:amd64.
Preparing to unpack .../126-libgspell-1-2_1.12.2-1build4_amd64.deb ...
Unpacking libgspell-1-2:amd64 (1.12.2-1build4) ...
Selecting previously unselected package libpangomm-1.4-1v5:amd64.
Preparing to unpack .../127-libpangomm-1.4-1v5_2.46.4-1build3_amd64.deb ...
Unpacking libpangomm-1.4-1v5:amd64 (2.46.4-1build3) ...
Selecting previously unselected package libgtkmm-3.0-1t64:amd64.
Preparing to unpack .../128-libgtkmm-3.0-1t64_3.24.9-1_amd64.deb ...
Unpacking libgtkmm-3.0-1t64:amd64 (3.24.9-1) ...
Selecting previously unselected package libmagick++-6.q16-9t64:amd64.
Preparing to unpack .../129-libmagick++-6.q16-9t64_8%3a6.9.12.98+dfsg1-5.2build2_amd64.deb ...
Unpacking libmagick++-6.q16-9t64:amd64 (8:6.9.12.98+dfsg1-5.2build2) ...
Selecting previously unselected package libpoppler134:amd64.
Preparing to unpack .../130-libpoppler134_24.02.0-1ubuntu9.9_amd64.deb ...
Unpacking libpoppler134:amd64 (24.02.0-1ubuntu9.9) ...
Selecting previously unselected package libpoppler-glib8t64:amd64.
Preparing to unpack .../131-libpoppler-glib8t64_24.02.0-1ubuntu9.9_amd64.deb ...
Unpacking libpoppler-glib8t64:amd64 (24.02.0-1ubuntu9.9) ...
Selecting previously unselected package libsoup2.4-common.
Preparing to unpack .../132-libsoup2.4-common_2.74.3-6ubuntu1.7_all.deb ...
Unpacking libsoup2.4-common (2.74.3-6ubuntu1.7) ...
Selecting previously unselected package libsoup-2.4-1:amd64.
Preparing to unpack .../133-libsoup-2.4-1_2.74.3-6ubuntu1.7_amd64.deb ...
Unpacking libsoup-2.4-1:amd64 (2.74.3-6ubuntu1.7) ...
Selecting previously unselected package libvisio-0.1-1:amd64.
Preparing to unpack .../134-libvisio-0.1-1_0.1.7-1build9_amd64.deb ...
Unpacking libvisio-0.1-1:amd64 (0.1.7-1build9) ...
Selecting previously unselected package libwpd-0.10-10:amd64.
Preparing to unpack .../135-libwpd-0.10-10_0.10.3-2build2_amd64.deb ...
Unpacking libwpd-0.10-10:amd64 (0.10.3-2build2) ...
Selecting previously unselected package libwpg-0.3-3:amd64.
Preparing to unpack .../136-libwpg-0.3-3_0.3.4-3build1_amd64.deb ...
Unpacking libwpg-0.3-3:amd64 (0.3.4-3build1) ...
Selecting previously unselected package inkscape.
Preparing to unpack .../137-inkscape_1.2.2-2ubuntu12_amd64.deb ...
Unpacking inkscape (1.2.2-2ubuntu12) ...
Selecting previously unselected package libxml-parser-perl.
Preparing to unpack .../138-libxml-parser-perl_2.47-1ubuntu0.24.04.1_amd64.deb ...
Unpacking libxml-parser-perl (2.47-1ubuntu0.24.04.1) ...
Selecting previously unselected package intltool.
Preparing to unpack .../139-intltool_0.51.0-6_all.deb ...
Unpacking intltool (0.51.0-6) ...
Selecting previously unselected package libglib2.0-dev-bin.
Preparing to unpack .../140-libglib2.0-dev-bin_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking libglib2.0-dev-bin (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package uuid-dev:amd64.
Preparing to unpack .../141-uuid-dev_2.39.3-9ubuntu6.6_amd64.deb ...
Unpacking uuid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Selecting previously unselected package libblkid-dev:amd64.
Preparing to unpack .../142-libblkid-dev_2.39.3-9ubuntu6.6_amd64.deb ...
Unpacking libblkid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Selecting previously unselected package libsepol-dev:amd64.
Preparing to unpack .../143-libsepol-dev_3.5-2build1_amd64.deb ...
Unpacking libsepol-dev:amd64 (3.5-2build1) ...
Selecting previously unselected package libselinux1-dev:amd64.
Preparing to unpack .../144-libselinux1-dev_3.5-2ubuntu2.1_amd64.deb ...
Unpacking libselinux1-dev:amd64 (3.5-2ubuntu2.1) ...
Selecting previously unselected package libmount-dev:amd64.
Preparing to unpack .../145-libmount-dev_2.39.3-9ubuntu6.6_amd64.deb ...
Unpacking libmount-dev:amd64 (2.39.3-9ubuntu6.6) ...
Selecting previously unselected package libgirepository-2.0-0:amd64.
Preparing to unpack .../146-libgirepository-2.0-0_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking libgirepository-2.0-0:amd64 (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package libglib2.0-dev:amd64.
Preparing to unpack .../147-libglib2.0-dev_2.80.0-6ubuntu3.8_amd64.deb ...
Unpacking libglib2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Selecting previously unselected package libatk1.0-dev:amd64.
Preparing to unpack .../148-libatk1.0-dev_2.52.0-1build1_amd64.deb ...
Unpacking libatk1.0-dev:amd64 (2.52.0-1build1) ...
Selecting previously unselected package libdbus-1-dev:amd64.
Preparing to unpack .../149-libdbus-1-dev_1.14.10-4ubuntu4.1_amd64.deb ...
Unpacking libdbus-1-dev:amd64 (1.14.10-4ubuntu4.1) ...
Selecting previously unselected package xorg-sgml-doctools.
Preparing to unpack .../150-xorg-sgml-doctools_1%3a1.11-1.1_all.deb ...
Unpacking xorg-sgml-doctools (1:1.11-1.1) ...
Selecting previously unselected package x11proto-dev.
Preparing to unpack .../151-x11proto-dev_2023.2-1_all.deb ...
Unpacking x11proto-dev (2023.2-1) ...
Selecting previously unselected package libxau-dev:amd64.
Preparing to unpack .../152-libxau-dev_1%3a1.0.9-1build6_amd64.deb ...
Unpacking libxau-dev:amd64 (1:1.0.9-1build6) ...
Selecting previously unselected package libxdmcp-dev:amd64.
Preparing to unpack .../153-libxdmcp-dev_1%3a1.1.3-0ubuntu6_amd64.deb ...
Unpacking libxdmcp-dev:amd64 (1:1.1.3-0ubuntu6) ...
Selecting previously unselected package xtrans-dev.
Preparing to unpack .../154-xtrans-dev_1.4.0-1_all.deb ...
Unpacking xtrans-dev (1.4.0-1) ...
Selecting previously unselected package libpthread-stubs0-dev:amd64.
Preparing to unpack .../155-libpthread-stubs0-dev_0.4-1build3_amd64.deb ...
Unpacking libpthread-stubs0-dev:amd64 (0.4-1build3) ...
Selecting previously unselected package libxcb1-dev:amd64.
Preparing to unpack .../156-libxcb1-dev_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb1-dev:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libx11-dev:amd64.
Preparing to unpack .../157-libx11-dev_2%3a1.8.7-1build1_amd64.deb ...
Unpacking libx11-dev:amd64 (2:1.8.7-1build1) ...
Selecting previously unselected package libxext-dev:amd64.
Preparing to unpack .../158-libxext-dev_2%3a1.3.4-1build2_amd64.deb ...
Unpacking libxext-dev:amd64 (2:1.3.4-1build2) ...
Selecting previously unselected package libxfixes-dev:amd64.
Preparing to unpack .../159-libxfixes-dev_1%3a6.0.0-2build1_amd64.deb ...
Unpacking libxfixes-dev:amd64 (1:6.0.0-2build1) ...
Selecting previously unselected package libxi-dev:amd64.
Preparing to unpack .../160-libxi-dev_2%3a1.8.1-1build1_amd64.deb ...
Unpacking libxi-dev:amd64 (2:1.8.1-1build1) ...
Selecting previously unselected package libxtst-dev:amd64.
Preparing to unpack .../161-libxtst-dev_2%3a1.2.3-1.1build1_amd64.deb ...
Unpacking libxtst-dev:amd64 (2:1.2.3-1.1build1) ...
Selecting previously unselected package libatspi2.0-dev:amd64.
Preparing to unpack .../162-libatspi2.0-dev_2.52.0-1build1_amd64.deb ...
Unpacking libatspi2.0-dev:amd64 (2.52.0-1build1) ...
Selecting previously unselected package libatk-bridge2.0-dev:amd64.
Preparing to unpack .../163-libatk-bridge2.0-dev_2.52.0-1build1_amd64.deb ...
Unpacking libatk-bridge2.0-dev:amd64 (2.52.0-1build1) ...
Selecting previously unselected package libboost1.83-dev:amd64.
Preparing to unpack .../164-libboost1.83-dev_1.83.0-2.1ubuntu3.2_amd64.deb ...
Unpacking libboost1.83-dev:amd64 (1.83.0-2.1ubuntu3.2) ...
Selecting previously unselected package libboost-python1.83.0.
Preparing to unpack .../165-libboost-python1.83.0_1.83.0-2.1ubuntu3.2_amd64.deb ...
Unpacking libboost-python1.83.0 (1.83.0-2.1ubuntu3.2) ...
Selecting previously unselected package libboost-python1.83-dev.
Preparing to unpack .../166-libboost-python1.83-dev_1.83.0-2.1ubuntu3.2_amd64.deb ...
Unpacking libboost-python1.83-dev (1.83.0-2.1ubuntu3.2) ...
Selecting previously unselected package libboost-python-dev.
Preparing to unpack .../167-libboost-python-dev_1.83.0.1ubuntu2_amd64.deb ...
Unpacking libboost-python-dev (1.83.0.1ubuntu2) ...
Selecting previously unselected package libbrotli-dev:amd64.
Preparing to unpack .../168-libbrotli-dev_1.1.0-2build2_amd64.deb ...
Unpacking libbrotli-dev:amd64 (1.1.0-2build2) ...
Selecting previously unselected package libmd-dev:amd64.
Preparing to unpack .../169-libmd-dev_1.1.0-2build1.1_amd64.deb ...
Unpacking libmd-dev:amd64 (1.1.0-2build1.1) ...
Selecting previously unselected package libbsd-dev:amd64.
Preparing to unpack .../170-libbsd-dev_0.12.1-1build1.1_amd64.deb ...
Unpacking libbsd-dev:amd64 (0.12.1-1build1.1) ...
Selecting previously unselected package libbz2-dev:amd64.
Preparing to unpack .../171-libbz2-dev_1.0.8-5.1ubuntu0.1_amd64.deb ...
Unpacking libbz2-dev:amd64 (1.0.8-5.1ubuntu0.1) ...
Selecting previously unselected package libcairo-script-interpreter2:amd64.
Preparing to unpack .../172-libcairo-script-interpreter2_1.18.0-3build1_amd64.deb ...
Unpacking libcairo-script-interpreter2:amd64 (1.18.0-3build1) ...
Selecting previously unselected package libpng-dev:amd64.
Preparing to unpack .../173-libpng-dev_1.6.43-5ubuntu0.6_amd64.deb ...
Unpacking libpng-dev:amd64 (1.6.43-5ubuntu0.6) ...
Selecting previously unselected package libfreetype-dev:amd64.
Preparing to unpack .../174-libfreetype-dev_2.13.2+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libfreetype-dev:amd64 (2.13.2+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libfontconfig-dev:amd64.
Preparing to unpack .../175-libfontconfig-dev_2.15.0-1.1ubuntu2_amd64.deb ...
Unpacking libfontconfig-dev:amd64 (2.15.0-1.1ubuntu2) ...
Selecting previously unselected package libpixman-1-dev:amd64.
Preparing to unpack .../176-libpixman-1-dev_0.42.2-1build1_amd64.deb ...
Unpacking libpixman-1-dev:amd64 (0.42.2-1build1) ...
Selecting previously unselected package libice-dev:amd64.
Preparing to unpack .../177-libice-dev_2%3a1.0.10-1build3_amd64.deb ...
Unpacking libice-dev:amd64 (2:1.0.10-1build3) ...
Selecting previously unselected package libsm-dev:amd64.
Preparing to unpack .../178-libsm-dev_2%3a1.2.3-1build3_amd64.deb ...
Unpacking libsm-dev:amd64 (2:1.2.3-1build3) ...
Selecting previously unselected package libxcb-render0-dev:amd64.
Preparing to unpack .../179-libxcb-render0-dev_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-render0-dev:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-shm0-dev:amd64.
Preparing to unpack .../180-libxcb-shm0-dev_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-shm0-dev:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxrender-dev:amd64.
Preparing to unpack .../181-libxrender-dev_1%3a0.9.10-1.1build1_amd64.deb ...
Unpacking libxrender-dev:amd64 (1:0.9.10-1.1build1) ...
Selecting previously unselected package libcairo2-dev:amd64.
Preparing to unpack .../182-libcairo2-dev_1.18.0-3build1_amd64.deb ...
Unpacking libcairo2-dev:amd64 (1.18.0-3build1) ...
Selecting previously unselected package libconfig-general-perl.
Preparing to unpack .../183-libconfig-general-perl_2.65-2_all.deb ...
Unpacking libconfig-general-perl (2.65-2) ...
Selecting previously unselected package libcss-dom-perl.
Preparing to unpack .../184-libcss-dom-perl_0.17-3_all.deb ...
Unpacking libcss-dom-perl (0.17-3) ...
Selecting previously unselected package libdatrie-dev:amd64.
Preparing to unpack .../185-libdatrie-dev_0.2.13-3build1_amd64.deb ...
Unpacking libdatrie-dev:amd64 (0.2.13-3build1) ...
Selecting previously unselected package libdeflate-dev:amd64.
Preparing to unpack .../186-libdeflate-dev_1.19-1build1.1_amd64.deb ...
Unpacking libdeflate-dev:amd64 (1.19-1build1.1) ...
Selecting previously unselected package libedit-dev:amd64.
Preparing to unpack .../187-libedit-dev_3.1-20230828-1build1_amd64.deb ...
Unpacking libedit-dev:amd64 (3.1-20230828-1build1) ...
Selecting previously unselected package libeditreadline-dev:amd64.
Preparing to unpack .../188-libeditreadline-dev_3.1-20230828-1build1_amd64.deb ...
Unpacking libeditreadline-dev:amd64 (3.1-20230828-1build1) ...
Selecting previously unselected package libegl-mesa0:amd64.
Preparing to unpack .../189-libegl-mesa0_25.2.8-0ubuntu0.24.04.2_amd64.deb ...
Unpacking libegl-mesa0:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Selecting previously unselected package libegl1:amd64.
Preparing to unpack .../190-libegl1_1.7.0-1build1_amd64.deb ...
Unpacking libegl1:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libglx-dev:amd64.
Preparing to unpack .../191-libglx-dev_1.7.0-1build1_amd64.deb ...
Unpacking libglx-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgl-dev:amd64.
Preparing to unpack .../192-libgl-dev_1.7.0-1build1_amd64.deb ...
Unpacking libgl-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libegl-dev:amd64.
Preparing to unpack .../193-libegl-dev_1.7.0-1build1_amd64.deb ...
Unpacking libegl-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libglvnd-core-dev:amd64.
Preparing to unpack .../194-libglvnd-core-dev_1.7.0-1build1_amd64.deb ...
Unpacking libglvnd-core-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgles1:amd64.
Preparing to unpack .../195-libgles1_1.7.0-1build1_amd64.deb ...
Unpacking libgles1:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgles2:amd64.
Preparing to unpack .../196-libgles2_1.7.0-1build1_amd64.deb ...
Unpacking libgles2:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libgles-dev:amd64.
Preparing to unpack .../197-libgles-dev_1.7.0-1build1_amd64.deb ...
Unpacking libgles-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libopengl0:amd64.
Preparing to unpack .../198-libopengl0_1.7.0-1build1_amd64.deb ...
Unpacking libopengl0:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libopengl-dev:amd64.
Preparing to unpack .../199-libopengl-dev_1.7.0-1build1_amd64.deb ...
Unpacking libopengl-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libglvnd-dev:amd64.
Preparing to unpack .../200-libglvnd-dev_1.7.0-1build1_amd64.deb ...
Unpacking libglvnd-dev:amd64 (1.7.0-1build1) ...
Selecting previously unselected package libegl1-mesa-dev:amd64.
Preparing to unpack .../201-libegl1-mesa-dev_25.2.8-0ubuntu0.24.04.2_amd64.deb ...
Unpacking libegl1-mesa-dev:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Selecting previously unselected package libepoxy-dev:amd64.
Preparing to unpack .../202-libepoxy-dev_1.5.10-1build1_amd64.deb ...
Unpacking libepoxy-dev:amd64 (1.5.10-1build1) ...
Selecting previously unselected package libevent-2.1-7t64:amd64.
Preparing to unpack .../203-libevent-2.1-7t64_2.1.12-stable-9ubuntu2.1_amd64.deb ...
Unpacking libevent-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Preparing to unpack .../204-libevent-pthreads-2.1-7t64_2.1.12-stable-9ubuntu2.1_amd64.deb ...
Unpacking libevent-pthreads-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) over (2.1.12-stable-9ubuntu2) ...
Preparing to unpack .../205-libevent-core-2.1-7t64_2.1.12-stable-9ubuntu2.1_amd64.deb ...
Unpacking libevent-core-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) over (2.1.12-stable-9ubuntu2) ...
Selecting previously unselected package libfribidi-dev:amd64.
Preparing to unpack .../206-libfribidi-dev_1.0.13-3build1_amd64.deb ...
Unpacking libfribidi-dev:amd64 (1.0.13-3build1) ...
Selecting previously unselected package libgdk-pixbuf2.0-bin.
Preparing to unpack .../207-libgdk-pixbuf2.0-bin_2.42.10+dfsg-3ubuntu3.3_amd64.deb ...
Unpacking libgdk-pixbuf2.0-bin (2.42.10+dfsg-3ubuntu3.3) ...
Selecting previously unselected package libjpeg-turbo8-dev:amd64.
Preparing to unpack .../208-libjpeg-turbo8-dev_2.1.5-2ubuntu2_amd64.deb ...
Unpacking libjpeg-turbo8-dev:amd64 (2.1.5-2ubuntu2) ...
Selecting previously unselected package libjpeg8-dev:amd64.
Preparing to unpack .../209-libjpeg8-dev_8c-2ubuntu11_amd64.deb ...
Unpacking libjpeg8-dev:amd64 (8c-2ubuntu11) ...
Selecting previously unselected package libjpeg-dev:amd64.
Preparing to unpack .../210-libjpeg-dev_8c-2ubuntu11_amd64.deb ...
Unpacking libjpeg-dev:amd64 (8c-2ubuntu11) ...
Selecting previously unselected package libjbig-dev:amd64.
Preparing to unpack .../211-libjbig-dev_2.1-6.1ubuntu2_amd64.deb ...
Unpacking libjbig-dev:amd64 (2.1-6.1ubuntu2) ...
Selecting previously unselected package liblzma-dev:amd64.
Preparing to unpack .../212-liblzma-dev_5.6.1+really5.4.5-1ubuntu0.3_amd64.deb ...
Unpacking liblzma-dev:amd64 (5.6.1+really5.4.5-1ubuntu0.3) ...
Selecting previously unselected package libwebpdecoder3:amd64.
Preparing to unpack .../213-libwebpdecoder3_1.3.2-0.4build3_amd64.deb ...
Unpacking libwebpdecoder3:amd64 (1.3.2-0.4build3) ...
Selecting previously unselected package libsharpyuv-dev:amd64.
Preparing to unpack .../214-libsharpyuv-dev_1.3.2-0.4build3_amd64.deb ...
Unpacking libsharpyuv-dev:amd64 (1.3.2-0.4build3) ...
Selecting previously unselected package libwebp-dev:amd64.
Preparing to unpack .../215-libwebp-dev_1.3.2-0.4build3_amd64.deb ...
Unpacking libwebp-dev:amd64 (1.3.2-0.4build3) ...
Selecting previously unselected package libtiffxx6:amd64.
Preparing to unpack .../216-libtiffxx6_4.5.1+git230720-4ubuntu2.5_amd64.deb ...
Unpacking libtiffxx6:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Selecting previously unselected package liblerc-dev:amd64.
Preparing to unpack .../217-liblerc-dev_4.0.0+ds-4ubuntu2_amd64.deb ...
Unpacking liblerc-dev:amd64 (4.0.0+ds-4ubuntu2) ...
Selecting previously unselected package libtiff-dev:amd64.
Preparing to unpack .../218-libtiff-dev_4.5.1+git230720-4ubuntu2.5_amd64.deb ...
Unpacking libtiff-dev:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Selecting previously unselected package libgdk-pixbuf-2.0-dev:amd64.
Preparing to unpack .../219-libgdk-pixbuf-2.0-dev_2.42.10+dfsg-3ubuntu3.3_amd64.deb ...
Unpacking libgdk-pixbuf-2.0-dev:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Selecting previously unselected package libglu1-mesa:amd64.
Preparing to unpack .../220-libglu1-mesa_9.0.2-1.1build1_amd64.deb ...
Unpacking libglu1-mesa:amd64 (9.0.2-1.1build1) ...
Selecting previously unselected package libglu1-mesa-dev:amd64.
Preparing to unpack .../221-libglu1-mesa-dev_9.0.2-1.1build1_amd64.deb ...
Unpacking libglu1-mesa-dev:amd64 (9.0.2-1.1build1) ...
Selecting previously unselected package libgpiod2t64:amd64.
Preparing to unpack .../222-libgpiod2t64_1.6.3-1.1build1_amd64.deb ...
Unpacking libgpiod2t64:amd64 (1.6.3-1.1build1) ...
Selecting previously unselected package libgpiod-dev:amd64.
Preparing to unpack .../223-libgpiod-dev_1.6.3-1.1build1_amd64.deb ...
Unpacking libgpiod-dev:amd64 (1.6.3-1.1build1) ...
Selecting previously unselected package libgraphite2-dev:amd64.
Preparing to unpack .../224-libgraphite2-dev_1.3.14-2ubuntu0.24.04.1_amd64.deb ...
Unpacking libgraphite2-dev:amd64 (1.3.14-2ubuntu0.24.04.1) ...
Selecting previously unselected package libharfbuzz-icu0:amd64.
Preparing to unpack .../225-libharfbuzz-icu0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-icu0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libharfbuzz-subset0:amd64.
Preparing to unpack .../226-libharfbuzz-subset0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-subset0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libharfbuzz-cairo0:amd64.
Preparing to unpack .../227-libharfbuzz-cairo0_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-cairo0:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libharfbuzz-dev:amd64.
Preparing to unpack .../228-libharfbuzz-dev_8.3.0-2build2_amd64.deb ...
Unpacking libharfbuzz-dev:amd64 (8.3.0-2build2) ...
Selecting previously unselected package libthai-dev:amd64.
Preparing to unpack .../229-libthai-dev_0.1.29-2build1_amd64.deb ...
Unpacking libthai-dev:amd64 (0.1.29-2build1) ...
Selecting previously unselected package libxft-dev:amd64.
Preparing to unpack .../230-libxft-dev_2.3.6-1build1_amd64.deb ...
Unpacking libxft-dev:amd64 (2.3.6-1build1) ...
Selecting previously unselected package pango1.0-tools.
Preparing to unpack .../231-pango1.0-tools_1.52.1+ds-1build1_amd64.deb ...
Unpacking pango1.0-tools (1.52.1+ds-1build1) ...
Selecting previously unselected package libpango1.0-dev:amd64.
Preparing to unpack .../232-libpango1.0-dev_1.52.1+ds-1build1_amd64.deb ...
Unpacking libpango1.0-dev:amd64 (1.52.1+ds-1build1) ...
Selecting previously unselected package libwayland-server0:amd64.
Preparing to unpack .../233-libwayland-server0_1.22.0-2.1build1_amd64.deb ...
Unpacking libwayland-server0:amd64 (1.22.0-2.1build1) ...
Selecting previously unselected package libwayland-bin.
Preparing to unpack .../234-libwayland-bin_1.22.0-2.1build1_amd64.deb ...
Unpacking libwayland-bin (1.22.0-2.1build1) ...
Selecting previously unselected package libwayland-dev:amd64.
Preparing to unpack .../235-libwayland-dev_1.22.0-2.1build1_amd64.deb ...
Unpacking libwayland-dev:amd64 (1.22.0-2.1build1) ...
Selecting previously unselected package libxcomposite-dev:amd64.
Preparing to unpack .../236-libxcomposite-dev_1%3a0.4.5-1build3_amd64.deb ...
Unpacking libxcomposite-dev:amd64 (1:0.4.5-1build3) ...
Selecting previously unselected package libxcursor-dev:amd64.
Preparing to unpack .../237-libxcursor-dev_1%3a1.2.1-1build1_amd64.deb ...
Unpacking libxcursor-dev:amd64 (1:1.2.1-1build1) ...
Selecting previously unselected package libxdamage-dev:amd64.
Preparing to unpack .../238-libxdamage-dev_1%3a1.1.6-1build1_amd64.deb ...
Unpacking libxdamage-dev:amd64 (1:1.1.6-1build1) ...
Selecting previously unselected package libxinerama-dev:amd64.
Preparing to unpack .../239-libxinerama-dev_2%3a1.1.4-3build1_amd64.deb ...
Unpacking libxinerama-dev:amd64 (2:1.1.4-3build1) ...
Selecting previously unselected package libxkbcommon-dev:amd64.
Preparing to unpack .../240-libxkbcommon-dev_1.6.0-1build1_amd64.deb ...
Unpacking libxkbcommon-dev:amd64 (1.6.0-1build1) ...
Selecting previously unselected package libxrandr-dev:amd64.
Preparing to unpack .../241-libxrandr-dev_2%3a1.5.2-2build1_amd64.deb ...
Unpacking libxrandr-dev:amd64 (2:1.5.2-2build1) ...
Selecting previously unselected package wayland-protocols.
Preparing to unpack .../242-wayland-protocols_1.45-1~ubuntu0.24.04.2_all.deb ...
Unpacking wayland-protocols (1.45-1~ubuntu0.24.04.2) ...
Selecting previously unselected package libgtk-3-dev:amd64.
Preparing to unpack .../243-libgtk-3-dev_3.24.41-4ubuntu1.3_amd64.deb ...
Unpacking libgtk-3-dev:amd64 (3.24.41-4ubuntu1.3) ...
Selecting previously unselected package libgtk2.0-dev:amd64.
Preparing to unpack .../244-libgtk2.0-dev_2.24.33-4ubuntu1.1_amd64.deb ...
Unpacking libgtk2.0-dev:amd64 (2.24.33-4ubuntu1.1) ...
Selecting previously unselected package libwacom-common.
Preparing to unpack .../245-libwacom-common_2.10.0-2_all.deb ...
Unpacking libwacom-common (2.10.0-2) ...
Selecting previously unselected package libwacom9:amd64.
Preparing to unpack .../246-libwacom9_2.10.0-2_amd64.deb ...
Unpacking libwacom9:amd64 (2.10.0-2) ...
Selecting previously unselected package libinput-bin.
Preparing to unpack .../247-libinput-bin_1.25.0-1ubuntu3.6_amd64.deb ...
Unpacking libinput-bin (1.25.0-1ubuntu3.6) ...
Selecting previously unselected package libmtdev1t64:amd64.
Preparing to unpack .../248-libmtdev1t64_1.1.6-1.1build1_amd64.deb ...
Unpacking libmtdev1t64:amd64 (1.1.6-1.1build1) ...
Selecting previously unselected package libinput10:amd64.
Preparing to unpack .../249-libinput10_1.25.0-1ubuntu3.6_amd64.deb ...
Unpacking libinput10:amd64 (1.25.0-1ubuntu3.6) ...
Selecting previously unselected package liblocale-codes-perl.
Preparing to unpack .../250-liblocale-codes-perl_3.77-1_all.deb ...
Unpacking liblocale-codes-perl (3.77-1) ...
Selecting previously unselected package libmd4c0:amd64.
Preparing to unpack .../251-libmd4c0_0.4.8-1build1_amd64.deb ...
Unpacking libmd4c0:amd64 (0.4.8-1build1) ...
Selecting previously unselected package libminizip1t64:amd64.
Preparing to unpack .../252-libminizip1t64_1%3a1.3.dfsg-3.1ubuntu2.2_amd64.deb ...
Unpacking libminizip1t64:amd64 (1:1.3.dfsg-3.1ubuntu2.2) ...
Selecting previously unselected package libnet-ip-perl.
Preparing to unpack .../253-libnet-ip-perl_1.26-3ubuntu0.24.04.1_all.deb ...
Unpacking libnet-ip-perl (1.26-3ubuntu0.24.04.1) ...
Selecting previously unselected package libnetpbm11t64:amd64.
Preparing to unpack .../254-libnetpbm11t64_2%3a11.05.02-1.1build1_amd64.deb ...
Unpacking libnetpbm11t64:amd64 (2:11.05.02-1.1build1) ...
Selecting previously unselected package libopus0:amd64.
Preparing to unpack .../255-libopus0_1.4-1build1_amd64.deb ...
Unpacking libopus0:amd64 (1.4-1build1) ...
Selecting previously unselected package libqt5core5t64:amd64.
Preparing to unpack .../256-libqt5core5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5core5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5dbus5t64:amd64.
Preparing to unpack .../257-libqt5dbus5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5dbus5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5network5t64:amd64.
Preparing to unpack .../258-libqt5network5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5network5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libxcb-icccm4:amd64.
Preparing to unpack .../259-libxcb-icccm4_0.4.1-1.1build3_amd64.deb ...
Unpacking libxcb-icccm4:amd64 (0.4.1-1.1build3) ...
Selecting previously unselected package libxcb-util1:amd64.
Preparing to unpack .../260-libxcb-util1_0.4.0-1build3_amd64.deb ...
Unpacking libxcb-util1:amd64 (0.4.0-1build3) ...
Selecting previously unselected package libxcb-image0:amd64.
Preparing to unpack .../261-libxcb-image0_0.4.0-2build1_amd64.deb ...
Unpacking libxcb-image0:amd64 (0.4.0-2build1) ...
Selecting previously unselected package libxcb-keysyms1:amd64.
Preparing to unpack .../262-libxcb-keysyms1_0.4.0-1build4_amd64.deb ...
Unpacking libxcb-keysyms1:amd64 (0.4.0-1build4) ...
Selecting previously unselected package libxcb-render-util0:amd64.
Preparing to unpack .../263-libxcb-render-util0_0.3.9-1build4_amd64.deb ...
Unpacking libxcb-render-util0:amd64 (0.3.9-1build4) ...
Selecting previously unselected package libxcb-shape0:amd64.
Preparing to unpack .../264-libxcb-shape0_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-shape0:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-xinerama0:amd64.
Preparing to unpack .../265-libxcb-xinerama0_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-xinerama0:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-xinput0:amd64.
Preparing to unpack .../266-libxcb-xinput0_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-xinput0:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxcb-xkb1:amd64.
Preparing to unpack .../267-libxcb-xkb1_1.15-1ubuntu2_amd64.deb ...
Unpacking libxcb-xkb1:amd64 (1.15-1ubuntu2) ...
Selecting previously unselected package libxkbcommon-x11-0:amd64.
Preparing to unpack .../268-libxkbcommon-x11-0_1.6.0-1build1_amd64.deb ...
Unpacking libxkbcommon-x11-0:amd64 (1.6.0-1build1) ...
Selecting previously unselected package libqt5gui5t64:amd64.
Preparing to unpack .../269-libqt5gui5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5gui5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5widgets5t64:amd64.
Preparing to unpack .../270-libqt5widgets5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5widgets5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5xml5t64:amd64.
Preparing to unpack .../271-libqt5xml5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5xml5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5designer5:amd64.
Preparing to unpack .../272-libqt5designer5_5.15.13-1_amd64.deb ...
Unpacking libqt5designer5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5sql5t64:amd64.
Preparing to unpack .../273-libqt5sql5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5sql5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5help5:amd64.
Preparing to unpack .../274-libqt5help5_5.15.13-1_amd64.deb ...
Unpacking libqt5help5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5positioning5:amd64.
Preparing to unpack .../275-libqt5positioning5_5.15.13+dfsg-1_amd64.deb ...
Unpacking libqt5positioning5:amd64 (5.15.13+dfsg-1) ...
Selecting previously unselected package libqt5printsupport5t64:amd64.
Preparing to unpack .../276-libqt5printsupport5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5printsupport5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5qml5:amd64.
Preparing to unpack .../277-libqt5qml5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5qml5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5qmlmodels5:amd64.
Preparing to unpack .../278-libqt5qmlmodels5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5qmlmodels5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5quick5:amd64.
Preparing to unpack .../279-libqt5quick5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5quick5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5quickwidgets5:amd64.
Preparing to unpack .../280-libqt5quickwidgets5_5.15.13+dfsg-1ubuntu0.1_amd64.deb ...
Unpacking libqt5quickwidgets5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Selecting previously unselected package libqt5test5t64:amd64.
Preparing to unpack .../281-libqt5test5t64_5.15.13+dfsg-1ubuntu1_amd64.deb ...
Unpacking libqt5test5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Selecting previously unselected package libqt5webchannel5:amd64.
Preparing to unpack .../282-libqt5webchannel5_5.15.13-1_amd64.deb ...
Unpacking libqt5webchannel5:amd64 (5.15.13-1) ...
Selecting previously unselected package libqt5webengine-data.
Preparing to unpack .../283-libqt5webengine-data_5.15.16+dfsg-3_all.deb ...
Unpacking libqt5webengine-data (5.15.16+dfsg-3) ...
Selecting previously unselected package libvpx9:amd64.
Preparing to unpack .../284-libvpx9_1.14.0-1ubuntu2.3_amd64.deb ...
Unpacking libvpx9:amd64 (1.14.0-1ubuntu2.3) ...
Selecting previously unselected package libqt5webenginecore5:amd64.
Preparing to unpack .../285-libqt5webenginecore5_5.15.16+dfsg-3_amd64.deb ...
Unpacking libqt5webenginecore5:amd64 (5.15.16+dfsg-3) ...
Selecting previously unselected package libqt5webengine5:amd64.
Preparing to unpack .../286-libqt5webengine5_5.15.16+dfsg-3_amd64.deb ...
Unpacking libqt5webengine5:amd64 (5.15.16+dfsg-3) ...
Selecting previously unselected package libqt5webenginewidgets5:amd64.
Preparing to unpack .../287-libqt5webenginewidgets5_5.15.16+dfsg-3_amd64.deb ...
Unpacking libqt5webenginewidgets5:amd64 (5.15.16+dfsg-3) ...
Selecting previously unselected package libsource-highlight-common.
Preparing to unpack .../288-libsource-highlight-common_3.1.9-4.3build1_all.deb ...
Unpacking libsource-highlight-common (3.1.9-4.3build1) ...
Selecting previously unselected package libsource-highlight4t64:amd64.
Preparing to unpack .../289-libsource-highlight4t64_3.1.9-4.3build1_amd64.deb ...
Unpacking libsource-highlight4t64:amd64 (3.1.9-4.3build1) ...
Selecting previously unselected package libudev-dev:amd64.
Preparing to unpack .../290-libudev-dev_255.4-1ubuntu8.17_amd64.deb ...
Unpacking libudev-dev:amd64 (255.4-1ubuntu8.17) ...
Selecting previously unselected package libusb-1.0-0-dev:amd64.
Preparing to unpack .../291-libusb-1.0-0-dev_2%3a1.0.27-1_amd64.deb ...
Unpacking libusb-1.0-0-dev:amd64 (2:1.0.27-1) ...
Selecting previously unselected package libxt-dev:amd64.
Preparing to unpack .../292-libxt-dev_1%3a1.2.1-1.2build1_amd64.deb ...
Unpacking libxt-dev:amd64 (1:1.2.1-1.2build1) ...
Selecting previously unselected package libxmu-headers.
Preparing to unpack .../293-libxmu-headers_2%3a1.1.3-3build2_all.deb ...
Unpacking libxmu-headers (2:1.1.3-3build2) ...
Selecting previously unselected package libxmu-dev:amd64.
Preparing to unpack .../294-libxmu-dev_2%3a1.1.3-3build2_amd64.deb ...
Unpacking libxmu-dev:amd64 (2:1.1.3-3build2) ...
Selecting previously unselected package libxss-dev:amd64.
Preparing to unpack .../295-libxss-dev_1%3a1.2.3-1build3_amd64.deb ...
Unpacking libxss-dev:amd64 (1:1.2.3-1build3) ...
Selecting previously unselected package netpbm.
Preparing to unpack .../296-netpbm_2%3a11.05.02-1.1build1_amd64.deb ...
Unpacking netpbm (2:11.05.02-1.1build1) ...
Selecting previously unselected package po4a.
Preparing to unpack .../297-po4a_0.69-1_all.deb ...
Unpacking po4a (0.69-1) ...
Selecting previously unselected package python3-lxml:amd64.
Preparing to unpack .../298-python3-lxml_5.2.1-1_amd64.deb ...
Unpacking python3-lxml:amd64 (5.2.1-1) ...
Selecting previously unselected package python3-pyqt5.sip.
Preparing to unpack .../299-python3-pyqt5.sip_12.13.0-1build3_amd64.deb ...
Unpacking python3-pyqt5.sip (12.13.0-1build3) ...
Selecting previously unselected package python3-pyqt5.
Preparing to unpack .../300-python3-pyqt5_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5 (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtwebchannel.
Preparing to unpack .../301-python3-pyqt5.qtwebchannel_5.15.10+dfsg-1build6_amd64.deb ...
Unpacking python3-pyqt5.qtwebchannel (5.15.10+dfsg-1build6) ...
Selecting previously unselected package python3-pyqt5.qtwebengine.
Preparing to unpack .../302-python3-pyqt5.qtwebengine_5.15.6-1build2_amd64.deb ...
Unpacking python3-pyqt5.qtwebengine (5.15.6-1build2) ...
Selecting previously unselected package python3-tk:amd64.
Preparing to unpack .../303-python3-tk_3.12.3-0ubuntu1_amd64.deb ...
Unpacking python3-tk:amd64 (3.12.3-0ubuntu1) ...
Selecting previously unselected package python3-yapps.
Preparing to unpack .../304-python3-yapps_2.2.1-3.2_all.deb ...
Unpacking python3-yapps (2.2.1-3.2) ...
Selecting previously unselected package source-highlight.
Preparing to unpack .../305-source-highlight_3.1.9-4.3build1_amd64.deb ...
Unpacking source-highlight (3.1.9-4.3build1) ...
Selecting previously unselected package tcl8.6-dev:amd64.
Preparing to unpack .../306-tcl8.6-dev_8.6.14+dfsg-1build1_amd64.deb ...
Unpacking tcl8.6-dev:amd64 (8.6.14+dfsg-1build1) ...
Selecting previously unselected package tclx8.4.
Preparing to unpack .../307-tclx8.4_8.4.1-4_amd64.deb ...
Unpacking tclx8.4 (8.4.1-4) ...
Selecting previously unselected package texlive-font-utils.
Preparing to unpack .../308-texlive-font-utils_2023.20240207-1_all.deb ...
Unpacking texlive-font-utils (2023.20240207-1) ...
Selecting previously unselected package texlive-lang-cyrillic.
Preparing to unpack .../309-texlive-lang-cyrillic_2023.20240207-1_all.deb ...
Unpacking texlive-lang-cyrillic (2023.20240207-1) ...
Selecting previously unselected package texlive-lang-european.
Preparing to unpack .../310-texlive-lang-european_2023.20240207-1_all.deb ...
Unpacking texlive-lang-european (2023.20240207-1) ...
Selecting previously unselected package texlive-lang-french.
Preparing to unpack .../311-texlive-lang-french_2023.20240207-1_all.deb ...
Unpacking texlive-lang-french (2023.20240207-1) ...
Selecting previously unselected package texlive-lang-german.
Preparing to unpack .../312-texlive-lang-german_2023.20240207-1_all.deb ...
Unpacking texlive-lang-german (2023.20240207-1) ...
Selecting previously unselected package texlive-lang-polish.
Preparing to unpack .../313-texlive-lang-polish_2023.20240207-1_all.deb ...
Unpacking texlive-lang-polish (2023.20240207-1) ...
Selecting previously unselected package texlive-lang-spanish.
Preparing to unpack .../314-texlive-lang-spanish_2023.20240207-1_all.deb ...
Unpacking texlive-lang-spanish (2023.20240207-1) ...
Selecting previously unselected package tk8.6-dev:amd64.
Preparing to unpack .../315-tk8.6-dev_8.6.14-1build1_amd64.deb ...
Unpacking tk8.6-dev:amd64 (8.6.14-1build1) ...
Selecting previously unselected package w3c-linkchecker.
Preparing to unpack .../316-w3c-linkchecker_5.0.0-2_all.deb ...
Unpacking w3c-linkchecker (5.0.0-2) ...
Selecting previously unselected package x11-xserver-utils.
Preparing to unpack .../317-x11-xserver-utils_7.7+10build2_amd64.deb ...
Unpacking x11-xserver-utils (7.7+10build2) ...
Selecting previously unselected package yapps2.
Preparing to unpack .../318-yapps2_2.2.1-3.2_all.deb ...
Unpacking yapps2 (2.2.1-3.2) ...
Selecting previously unselected package libmodbus5:amd64.
Preparing to unpack .../319-libmodbus5_3.1.10-1ubuntu1_amd64.deb ...
Unpacking libmodbus5:amd64 (3.1.10-1ubuntu1) ...
Selecting previously unselected package libmodbus-dev:amd64.
Preparing to unpack .../320-libmodbus-dev_3.1.10-1ubuntu1_amd64.deb ...
Unpacking libmodbus-dev:amd64 (3.1.10-1ubuntu1) ...
Selecting previously unselected package libtirpc-dev:amd64.
Preparing to unpack .../321-libtirpc-dev_1.3.4+ds-1.1build1_amd64.deb ...
Unpacking libtirpc-dev:amd64 (1.3.4+ds-1.1build1) ...
Selecting previously unselected package python3-xlib.
Preparing to unpack .../322-python3-xlib_0.33-2_all.deb ...
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
Setting up session-migration (0.3.9build1) ...
Created symlink /etc/systemd/user/graphical-session-pre.target.wants/session-migration.service → /usr/lib/systemd/user/session-migration.service.
Setting up libjpeg-turbo8-dev:amd64 (2.1.5-2ubuntu2) ...
Setting up libdouble-conversion3:amd64 (3.3.0-1build1) ...
Setting up libcss-dom-perl (0.17-3) ...
Setting up libmodbus5:amd64 (3.1.10-1ubuntu1) ...
Setting up tk8.6-blt2.5 (2.5.3+dfsg-7build1) ...
Setting up libboost1.83-dev:amd64 (1.83.0-2.1ubuntu3.2) ...
Setting up libproxy1v5:amd64 (0.5.4-4build1) ...
Setting up libsgmls-perl (1.03ii-38) ...
Setting up gir1.2-freedesktop:amd64 (1.80.1-1) ...
Setting up libconfig-general-perl (2.65-2) ...
Setting up libharfbuzz-icu0:amd64 (8.3.0-2build2) ...
Setting up libpixman-1-dev:amd64 (0.42.2-1build1) ...
Setting up desktop-file-utils (0.27-2build1) ...
Setting up libpangoxft-1.0-0:amd64 (1.52.1+ds-1build1) ...
Setting up libglvnd-core-dev:amd64 (1.7.0-1build1) ...
Setting up libqt5webengine-data (5.15.16+dfsg-3) ...
Setting up fonts-gfs-porson (1.1-7) ...
Setting up libxcb-xinput0:amd64 (1.15-1ubuntu2) ...
Setting up gir1.2-gdkpixbuf-2.0:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Setting up libgslcblas0:amd64 (2.7.1+dfsg-6ubuntu2) ...
Setting up libgspell-1-common (1.12.2-1build4) ...
Setting up sgmlspl (1.03ii-38) ...
Setting up libpoppler134:amd64 (24.02.0-1ubuntu9.9) ...
Setting up libgirepository-2.0-0:amd64 (2.80.0-6ubuntu3.8) ...
Setting up libsombok3:amd64 (2.4.0-2build1) ...
Setting up gir1.2-atk-1.0:amd64 (2.52.0-1build1) ...
Setting up libijs-0.35:amd64 (0.35-15.1build1) ...
Setting up libfribidi-dev:amd64 (1.0.13-3build1) ...
Setting up blt (2.5.3+dfsg-7build1) ...
Setting up preview-latex-style (13.2-1) ...
Setting up tcl8.6-dev:amd64 (8.6.14+dfsg-1build1) ...
Setting up libxkbcommon-dev:amd64 (1.6.0-1build1) ...
Setting up libgs-common (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up libfontbox-java (1:1.8.16-5) ...
Setting up liblatex-tounicode-perl (0.54-2) ...
Setting up liblab-gamut1:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libpng-dev:amd64 (1.6.43-5ubuntu0.6) ...
Setting up xsltproc (1.1.39-0exp1ubuntu0.24.04.3) ...
Setting up pango1.0-tools (1.52.1+ds-1build1) ...
Setting up libxcb-keysyms1:amd64 (0.4.0-1build4) ...
Setting up libxcb-shape0:amd64 (1.15-1ubuntu2) ...
Setting up libjbig-dev:amd64 (2.1-6.1ubuntu2) ...
Setting up libwebpdecoder3:amd64 (1.3.2-0.4build3) ...
Setting up libgsl27:amd64 (2.7.1+dfsg-6ubuntu2) ...
Setting up libusb-1.0-0-dev:amd64 (2:1.0.27-1) ...
Setting up libevent-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Setting up libxcb-render-util0:amd64 (0.3.9-1build4) ...
Setting up python3-tk:amd64 (3.12.3-0ubuntu1) ...
Setting up libxcb-icccm4:amd64 (0.4.1-1.1build3) ...
Setting up libharfbuzz-gobject0:amd64 (8.3.0-2build2) ...
Setting up gir1.2-atspi-2.0:amd64 (2.52.0-1build1) ...
Setting up libpaper-utils (1.1.29build1) ...
Setting up libboost-filesystem1.83.0:amd64 (1.83.0-2.1ubuntu3.2) ...
Setting up libbibtex-parser-perl (1.04+dfsg-1) ...
Setting up x11-xserver-utils (7.7+10build2) ...
Setting up libyaml-tiny-perl (1.74-1) ...
Setting up gir1.2-harfbuzz-0.0:amd64 (8.3.0-2build2) ...
Setting up libpthread-stubs0-dev:amd64 (0.4-1build3) ...
Setting up libnetpbm11t64:amd64 (2:11.05.02-1.1build1) ...
Setting up lib2geom1.2.0t64:amd64 (1.2.2-3.1build1) ...
Setting up libsource-highlight-common (3.1.9-4.3build1) ...
Setting up librevenge-0.0-0:amd64 (0.0.5-3build1) ...
Setting up libopengl0:amd64 (1.7.0-1build1) ...
Setting up libxcb-util1:amd64 (0.4.0-1build3) ...
Setting up poppler-data (0.4.12-1) ...
Setting up libxcb-xkb1:amd64 (1.15-1ubuntu2) ...
Setting up libxcb-image0:amd64 (0.4.0-2build1) ...
Setting up libosp5 (1.5.2-15ubuntu2) ...
Setting up librsvg2-2:amd64 (2.58.0+dfsg-1build1) ...
Setting up libpoppler-glib8t64:amd64 (24.02.0-1ubuntu9.9) ...
Setting up groff (1.23.0-3build2) ...
Setting up asciidoc-common (10.2.0-2) ...
Setting up xtrans-dev (1.4.0-1) ...
Setting up libqt5core5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libwayland-bin (1.22.0-2.1build1) ...
Setting up libgraphite2-dev:amd64 (1.3.14-2ubuntu0.24.04.1) ...
Setting up gir1.2-pango-1.0:amd64 (1.52.1+ds-1build1) ...
Setting up libegl-mesa0:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Setting up libxcb-xinerama0:amd64 (1.15-1ubuntu2) ...
Setting up libtirpc-dev:amd64 (1.3.4+ds-1.1build1) ...
Setting up libgles2:amd64 (1.7.0-1build1) ...
Setting up libzzip-0-13t64:amd64 (0.13.72+dfsg.1-1.2build1) ...
Setting up libharfbuzz-cairo0:amd64 (8.3.0-2build2) ...
Setting up libdbus-1-dev:amd64 (1.14.10-4ubuntu4.1) ...
Setting up libjbig2dec0:amd64 (0.20-1ubuntu0.24.04.1) ...
Setting up libsigc++-2.0-0v5:amd64 (2.12.1-2) ...
Setting up libteckit0:amd64 (2.5.12+ds1-1) ...
Setting up uuid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Setting up libpathplan4:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libapache-pom-java (29-2) ...
Setting up libann0 (1.1.2+doc-9build1) ...
Setting up libgles1:amd64 (1.7.0-1build1) ...
Setting up xfonts-encodings (1:1.0.5-0ubuntu2) ...
Setting up docbook-xsl (1.79.2+dfsg-7) ...
Setting up libopus0:amd64 (1.4-1build1) ...
Setting up libboost-python1.83-dev (1.83.0-2.1ubuntu3.2) ...
Setting up libtexlua53-5:amd64 (2023.20230311.66589-9build3) ...
Setting up libxkbcommon-x11-0:amd64 (1.6.0-1build1) ...
Setting up libidn12:amd64 (1.42-1ubuntu0.1) ...
Setting up intltool (0.51.0-6) ...
Setting up libudev-dev:amd64 (255.4-1ubuntu8.17) ...
Setting up libsepol-dev:amd64 (3.5-2build1) ...
Setting up liblerc-dev:amd64 (4.0.0+ds-4ubuntu2) ...
Setting up librsvg2-common:amd64 (2.58.0+dfsg-1build1) ...
Setting up netpbm (2:11.05.02-1.1build1) ...
Setting up lynx-common (2.9.0rel.0-2build2) ...
Setting up libkpathsea6:amd64 (2023.20230311.66589-9build3) ...
Setting up libsoup2.4-common (2.74.3-6ubuntu1.7) ...
Setting up libmagick++-6.q16-9t64:amd64 (8:6.9.12.98+dfsg1-5.2build2) ...
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
Setting up wayland-protocols (1.45-1~ubuntu0.24.04.2) ...
Setting up libdatrie-dev:amd64 (0.2.13-3build1) ...
Setting up libmtdev1t64:amd64 (1.1.6-1.1build1) ...
Setting up fonts-gfs-baskerville (1.1-6) ...
Setting up libminizip1t64:amd64 (1:1.3.dfsg-3.1ubuntu2.2) ...
Setting up gir1.2-glib-2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Setting up libgdk-pixbuf2.0-bin (2.42.10+dfsg-3ubuntu3.3) ...
Setting up python3-lxml:amd64 (5.2.1-1) ...
Setting up libmime-charset-perl (1.013.1-2) ...
Setting up tclx8.4 (8.4.1-4) ...
Setting up libmd-dev:amd64 (1.1.0-2build1.1) ...
Setting up libegl1:amd64 (1.7.0-1build1) ...
Setting up libqt5sql5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libmd4c0:amd64 (0.4.8-1build1) ...
Setting up libharfbuzz-subset0:amd64 (8.3.0-2build2) ...
Setting up fonts-lmodern (2.005-1) ...
Setting up xorg-sgml-doctools (1:1.11-1.1) ...
Setting up libgts-0.7-5t64:amd64 (0.7.6+darcs121130-5.2build1) ...
Setting up sgml-data (2.0.11+nmu1) ...
Setting up libgtk2.0-common (2.24.33-4ubuntu1.1) ...
Setting up libcdt5:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libcgraph6:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libevent-core-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Setting up libglu1-mesa:amd64 (9.0.2-1.1build1) ...
Setting up bwidget (1.9.16-1) ...
Setting up lynx (2.9.0rel.0-2build2) ...
update-alternatives: using /usr/bin/lynx to provide /usr/bin/www-browser (www-browser) in auto mode
Setting up libopengl-dev:amd64 (1.7.0-1build1) ...
Setting up libgpiod2t64:amd64 (1.6.3-1.1build1) ...
Setting up glib-networking-common (2.80.0-1build1) ...
Setting up libjpeg8-dev:amd64 (8c-2ubuntu11) ...
Setting up libxml2-utils (2.9.14+dfsg-1.3ubuntu3.8) ...
Setting up libsharpyuv-dev:amd64 (1.3.2-0.4build3) ...
Setting up libnet-ip-perl (1.26-3ubuntu0.24.04.1) ...
Setting up libtiffxx6:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Setting up libwpd-0.10-10:amd64 (0.10.3-2build2) ...
Setting up python3-yapps (2.2.1-3.2) ...
Setting up libdeflate-dev:amd64 (1.19-1build1.1) ...
Setting up libbsd-dev:amd64 (0.12.1-1build1.1) ...
Setting up libostyle1t64 (1.4devel1-23.1build1) ...
Setting up libbrotli-dev:amd64 (1.1.0-2build2) ...
Setting up libgspell-1-2:amd64 (1.12.2-1build4) ...
Setting up libsynctex2:amd64 (2023.20230311.66589-9build3) ...
Setting up libvisio-0.1-1:amd64 (0.1.7-1build9) ...
Setting up libwacom-common (2.10.0-2) ...
Setting up libbz2-dev:amd64 (1.0.8-5.1ubuntu0.1) ...
Setting up libpotrace0:amd64 (1.16-2build1) ...
Setting up libmodbus-dev:amd64 (3.1.10-1ubuntu1) ...
Setting up teckit (2.5.12+ds1-1) ...
Setting up gsettings-desktop-schemas (46.1-0ubuntu1) ...
Setting up glib-networking-services (2.80.0-1build1) ...
Setting up libblkid-dev:amd64 (2.39.3-9ubuntu6.6) ...
Setting up w3c-linkchecker (5.0.0-2) ...

Creating config file /etc/w3c/checklink.conf with new version
apache2_invoke: Enable configuration w3c-linkchecker
[0;1;31mapache2.service is not active, cannot reload.[0m
invoke-rc.d: initscript apache2, action "reload" failed.
Setting up libqt5dbus5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libpdfbox-java (1:1.8.16-5) ...
Setting up libwacom9:amd64 (2.10.0-2) ...
Setting up libselinux1-dev:amd64 (3.5-2ubuntu2.1) ...
Setting up libevent-pthreads-2.1-7t64:amd64 (2.1.12-stable-9ubuntu2.1) ...
Setting up libqt5positioning5:amd64 (5.15.13+dfsg-1) ...
Setting up libqt5network5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libcommons-parent-java (56-1) ...
Setting up gir1.2-gtk-3.0:amd64 (3.24.41-4ubuntu1.3) ...
Setting up libjpeg-dev:amd64 (8c-2ubuntu11) ...
Setting up libcommons-logging-java (1.3.0-1ubuntu1) ...
Setting up libqt5xml5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libsource-highlight4t64:amd64 (3.1.9-4.3build1) ...
Setting up opensp (1.5.2-15ubuntu2) ...
Setting up libcdr-0.1-1:amd64 (0.1.7-1build2) ...
Setting up libqt5test5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up xfonts-utils (1:7.7+6build3) ...
Setting up libwayland-dev:amd64 (1.22.0-2.1build1) ...
Setting up libboost-python-dev (1.83.0.1ubuntu2) ...
Setting up libinput-bin (1.25.0-1ubuntu3.6) ...
Setting up libfreetype-dev:amd64 (2.13.2+dfsg-1ubuntu0.1) ...
Setting up libcairomm-1.0-1v5:amd64 (1.14.5-1build1) ...
Setting up libglibmm-2.4-1t64:amd64 (2.66.7-1build1) ...
Setting up libwebp-dev:amd64 (1.3.2-0.4build3) ...
Setting up libptexenc1:amd64 (2023.20230311.66589-9build3) ...
Setting up libtiff-dev:amd64 (4.5.1+git230720-4ubuntu2.5) ...
Setting up libqt5qml5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up libunicode-linebreak-perl (0.0.20190101-1build7) ...
Setting up gir1.2-freedesktop-dev:amd64 (1.80.1-1) ...
Setting up libedit-dev:amd64 (3.1-20230828-1build1) ...
Setting up libgvc6 (2.42.2-9ubuntu0.1) ...
Setting up libgtk2.0-0t64:amd64 (2.24.33-4ubuntu1.1) ...
Setting up libqt5webchannel5:amd64 (5.15.13-1) ...
Setting up libpangomm-1.4-1v5:amd64 (2.46.4-1build3) ...
Setting up imagemagick (8:6.9.12.98+dfsg1-5.2build2) ...
Setting up libwpg-0.3-3:amd64 (0.3.4-3build1) ...
Setting up libthai-dev:amd64 (0.1.29-2build1) ...
Setting up libgvpr2:amd64 (2.42.2-9ubuntu0.1) ...
Setting up libgpiod-dev:amd64 (1.6.3-1.1build1) ...
Setting up texlive-binaries (2023.20230311.66589-9build3) ...
update-alternatives: using /usr/bin/xdvi-xaw to provide /usr/bin/xdvi.bin (xdvi.bin) in auto mode
update-alternatives: using /usr/bin/bibtex.original to provide /usr/bin/bibtex (bibtex) in auto mode
Setting up lmodern (2.005-1) ...
Setting up source-highlight (3.1.9-4.3build1) ...
Setting up libatkmm-1.6-1v5:amd64 (2.28.4-1build4) ...
Setting up yapps2 (2.2.1-3.2) ...
Setting up texlive-base (2023.20240207-1) ...
tl-paper: setting paper size for dvips to a4: /var/lib/texmf/dvips/config/config-paper.ps
tl-paper: setting paper size for dvipdfmx to a4: /var/lib/texmf/dvipdfmx/dvipdfmx-paper.cfg
tl-paper: setting paper size for xdvi to a4: /var/lib/texmf/xdvi/XDvi-paper
tl-paper: setting paper size for pdftex to a4: /var/lib/texmf/tex/generic/tex-ini-files/pdftexconfig.tex
Setting up openjade (1.4devel1-23.1build1) ...
Setting up libmount-dev:amd64 (2.39.3-9ubuntu6.6) ...
Setting up texlive-lang-german (2023.20240207-1) ...
Setting up graphviz (2.42.2-9ubuntu0.1) ...
Setting up libinput10:amd64 (1.25.0-1ubuntu3.6) ...
Setting up texlive-lang-spanish (2023.20240207-1) ...
Setting up libqt5qmlmodels5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up texlive-luatex (2023.20240207-1) ...
Setting up libfontconfig-dev:amd64 (2.15.0-1.1ubuntu2) ...
Setting up texlive-plain-generic (2023.20240207-1) ...
Setting up texlive-lang-greek (2023.20240207-1) ...
Setting up libeditreadline-dev:amd64 (3.1-20230828-1build1) ...
Setting up texlive-font-utils (2023.20240207-1) ...
Setting up fonts-urw-base35 (20200910-8) ...
Setting up libqt5gui5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libglib2.0-dev:amd64 (2.80.0-6ubuntu3.8) ...
Setting up texlive-lang-french (2023.20240207-1) ...
Setting up texlive-latex-base (2023.20240207-1) ...
Setting up texlive-extra-utils (2023.20240207-1) ...
Setting up gir1.2-gtk-2.0:amd64 (2.24.33-4ubuntu1.1) ...
Setting up texlive-latex-recommended (2023.20240207-1) ...
Setting up texlive-pictures (2023.20240207-1) ...
Setting up texlive-lang-cyrillic (2023.20240207-1) ...
Setting up libgtkmm-3.0-1t64:amd64 (3.24.9-1) ...
Setting up texlive-lang-polish (2023.20240207-1) ...
Setting up texlive-fonts-recommended (2023.20240207-1) ...
Setting up tipa (2:1.3-21) ...
Setting up texlive-lang-european (2023.20240207-1) ...
Setting up libqt5quick5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up libgs10-common (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up libqt5widgets5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up texlive (2023.20240207-1) ...
Setting up texlive-science (2023.20240207-1) ...
Setting up texlive-latex-extra (2023.20240207-1) ...
Setting up libqt5help5:amd64 (5.15.13-1) ...
Setting up libqt5quickwidgets5:amd64 (5.15.13+dfsg-1ubuntu0.1) ...
Setting up texlive-bibtex-extra (2023.20240207-1) ...
Setting up libqt5webenginecore5:amd64 (5.15.16+dfsg-3) ...
Setting up texlive-xetex (2023.20240207-1) ...
Setting up libqt5printsupport5t64:amd64 (5.15.13+dfsg-1ubuntu1) ...
Setting up libgs10:amd64 (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up libqt5designer5:amd64 (5.15.13-1) ...
Setting up ghostscript (10.02.1~dfsg1-0ubuntu7.8) ...
Setting up texlive-formats-extra (2023.20240207-1) ...
Setting up libqt5webengine5:amd64 (5.15.16+dfsg-3) ...
Setting up libqt5webenginewidgets5:amd64 (5.15.16+dfsg-3) ...
Setting up python3-pyqt5 (5.15.10+dfsg-1build6) ...
Setting up dvipng (1.15-1.1) ...
Setting up python3-pyqt5.qtwebchannel (5.15.10+dfsg-1build6) ...
Setting up python3-pyqt5.qtwebengine (5.15.6-1build2) ...
Processing triggers for udev (255.4-1ubuntu8.17) ...
Processing triggers for libgdk-pixbuf-2.0-0:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Processing triggers for sgml-base (1.31) ...
Processing triggers for install-info (7.1-3build2) ...
Setting up x11proto-dev (2023.2-1) ...
Processing triggers for fontconfig (2.15.0-1.1ubuntu2) ...
Setting up po4a (0.69-1) ...
Setting up libxau-dev:amd64 (1:1.0.9-1build6) ...
Processing triggers for hicolor-icon-theme (0.17-2) ...
Setting up libice-dev:amd64 (2:1.0.10-1build3) ...
Setting up libsm-dev:amd64 (2:1.2.3-1build3) ...
Setting up docbook-xml (4.5-12) ...
Processing triggers for libc-bin (2.39-0ubuntu8.8) ...
Processing triggers for man-db (2.12.0-4build2) ...
Not building database; man-db/auto-update is not 'true'.
Processing triggers for tex-common (6.18) ...
Running mktexlsr. This may take some time... done.
Running updmap-sys. This may take some time... done.
Running mktexlsr /var/lib/texmf ... done.
Building format(s) --all.
	This may take some time... done.
Setting up libxdmcp-dev:amd64 (1:1.1.3-0ubuntu6) ...
Setting up asciidoc-base (10.2.0-2) ...
Processing triggers for libglib2.0-0t64:amd64 (2.80.0-6ubuntu3.8) ...
Setting up glib-networking:amd64 (2.80.0-1build1) ...
Setting up libatk1.0-dev:amd64 (2.52.0-1build1) ...
Setting up libgdk-pixbuf-2.0-dev:amd64 (2.42.10+dfsg-3ubuntu3.3) ...
Setting up libharfbuzz-dev:amd64 (8.3.0-2build2) ...
Setting up libxcb1-dev:amd64 (1.15-1ubuntu2) ...
Setting up libx11-dev:amd64 (2:1.8.7-1build1) ...
Setting up asciidoc (10.2.0-2) ...
Setting up libxfixes-dev:amd64 (1:6.0.0-2build1) ...
Setting up libxcb-shm0-dev:amd64 (1.15-1ubuntu2) ...
Setting up libxt-dev:amd64 (1:1.2.1-1.2build1) ...
Setting up libxcb-render0-dev:amd64 (1.15-1ubuntu2) ...
Setting up libxext-dev:amd64 (2:1.3.4-1build2) ...
Setting up libglx-dev:amd64 (1.7.0-1build1) ...
Setting up libsoup-2.4-1:amd64 (2.74.3-6ubuntu1.7) ...
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
Setting up inkscape (1.2.2-2ubuntu12) ...
Setting up libglu1-mesa-dev:amd64 (9.0.2-1.1build1) ...
Setting up libxinerama-dev:amd64 (2:1.1.4-3build1) ...
Setting up tk8.6-dev:amd64 (8.6.14-1build1) ...
Setting up libcairo2-dev:amd64 (1.18.0-3build1) ...
Setting up libgles-dev:amd64 (1.7.0-1build1) ...
Setting up libglvnd-dev:amd64 (1.7.0-1build1) ...
Setting up libpango1.0-dev:amd64 (1.52.1+ds-1build1) ...
Setting up libgtk2.0-dev:amd64 (2.24.33-4ubuntu1.1) ...
Setting up libegl1-mesa-dev:amd64 (25.2.8-0ubuntu0.24.04.2) ...
Setting up libgtk-3-dev:amd64 (3.24.41-4ubuntu1.3) ...
Processing triggers for sgml-base (1.31) ...
Setting up dblatex (0.3.12py3-4) ...
Setting up docbook-dsssl (1.79-10) ...
Processing triggers for sgml-base (1.31) ...
Setting up docbook-utils (0.6.14-4) ...
Setting up asciidoc-dblatex (10.2.0-2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.8) ...

== Configure/build run-in-place userspace LinuxCNC ==
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
checking whether c++ supports C++17 features with -std=gnu++17... yes
checking build toplevel... /home/runner/work/_temp/linuxcnc-curriculum-stable
checking installation prefix... run in place
checking for grep... /usr/bin/grep
checking for egrep... /usr/bin/egrep
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
/home/runner/work/_temp/linuxcnc-curriculum-stable/rtlib
checking for glib... yes - 2.80.0
checking for GTK 3.22.4 or above... yes - 3.24.41
checking for GTK 2.4.0 or above... yes - 2.24.33
checking for libgnomeprintui-2.2... no -- printing from classicladder will not be possible
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
checking for Python site-packages path... /home/runner/work/_temp/linuxcnc-curriculum-stable/lib/python3.12/site-packages
checking for Python platform specific site-packages path... /home/runner/work/_temp/linuxcnc-curriculum-stable/lib/python3.12/site-packages
checking python extra libraries... -ldl -lm
checking python extra linking flags... -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions
checking consistency of all components of python development environment... yes
checking whether the Boost::Python library is available... yes
checking whether boost_python is the correct library... no
checking whether boost_python312 is the correct library... yes
checking whether to build documentation... no
checking for sys/io.h... yes
checking for sys/wait.h that is POSIX.1 compatible... yes
checking for semtimedop... yes
checking for optreset... no
checking for library containing dlopen... none required
checking for library containing clock_nanosleep... none required
checking for tcl... /usr/lib/tcl8.6/tclConfig.sh found
checking for tk... /usr/lib/tk8.6/tkConfig.sh found
checking whether to check for runtime dependencies... yes
checking for BWidget using /usr/bin/tclsh8.6... found
checking for BLT using /usr/bin/tclsh8.6... found
checking for tclX using /usr/bin/tclsh8.6... found
checking for python pango module... found
checking for X... libraries , headers 
checking for gethostbyname... yes
checking for connect... yes
checking for remove... yes
checking for shmat... yes
checking for IceConnectionNumber in -lICE... yes
checking for X11/extensions/Xinerama.h... yes
checking for XineramaQueryExtension in -lXinerama... yes
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
checking match between tk and Tkinter versions... 8.6
checking for site-package location... /usr/lib/python3/dist-packages
checking for working GLU quadrics... yes
checking for Xmu headers... checking for X11/Xmu/Xmu.h... yes
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
config.status: creating ../scripts/linuxcnc-checklink
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


make: Entering directory '/home/runner/work/_temp/linuxcnc-curriculum-stable/src'
Creating mesa_uart.mak
Creating mesa_7i65.mak
Creating serport.mak
Creating xyzab_tdr_kins.mak
Creating xor2.mak
Creating xhc_hb04_util.mak
Creating wcomp.mak
Creating userkins.mak
Creating updown.mak
Creating tristate_float.mak
Creating tristate_bit.mak
Creating tp.mak
Creating ton.mak
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
Creating radiobutton.mak
Creating plasmac.mak
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
Creating multiswitch.mak
Creating multiclick.mak
Creating mult2.mak
Creating moveoff.mak
Creating minmax.mak
Creating millturn.mak
Creating message.mak
Creating mesa_pktgyro_test.mak
Creating max31855.mak
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
Creating latencybins.mak
Creating knob2float.mak
Creating joyhandle.mak
Creating invert.mak
Creating integ.mak
Creating ilowpass.mak
Creating hypot.mak
Creating homecomp.mak
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
converting conv for conv_u32_s32.comp
converting conv for conv_u32_float.comp
converting conv for conv_u32_bit.comp
converting conv for conv_s32_u32.comp
converting conv for conv_s32_float.comp
converting conv for conv_s32_bit.comp
converting conv for conv_float_u32.comp
converting conv for conv_float_s32.comp
converting conv for conv_bit_u32.comp
converting conv for conv_bit_s32.comp
converting conv for conv_bit_float.comp
Creating constant.mak
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
Creating biquad.mak
Creating bin2gray.mak
Creating axistest.mak
Creating anglejog.mak
Creating and2.mak
Creating abs.mak
Creating abs_s32.mak
Creating conv_u32_s32.mak
Creating conv_u32_float.mak
Creating conv_u32_bit.mak
Creating conv_s32_u32.mak
Creating conv_s32_float.mak
Creating conv_s32_bit.mak
Creating conv_float_u32.mak
Creating conv_float_s32.mak
Creating conv_bit_u32.mak
Creating conv_bit_s32.mak
Creating conv_bit_float.mak
sed hal/drivers/mesa_uart.comp -e "1 s/mesa_uart/mesa_uart_test/" > ../tests/halcompile/serial-out-of-tree/mesa_uart_test.comp
Copying test input hal/components/lincurve.comp
Copying test input hal/components/logic.comp
Copying test input hal/components/bitslice.comp
sed ../docs/src/hal/rand.comp -e "1 s/rand/rand_test/" > ../tests/halcompile/userspace/rand_test.comp
cp ../scripts/rtapi.conf ../tests/uspace/spawnv-root/rtapi.conf
Compiling libnml/inifile/inifile.cc
Compiling libnml/inifile/inivar.cc
Compiling libnml/posemath/_posemath.c
Compiling libnml/posemath/posemath.cc
Compiling libnml/posemath/gomath.c
Compiling libnml/posemath/sincos.c
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
Compiling libnml/nml/nml_mod.cc
Compiling libnml/nml/nml_oi.cc
Compiling libnml/nml/nml_srv.cc
Compiling libnml/nml/nml.cc
Compiling libnml/nml/nmldiag.cc
Compiling libnml/nml/nmlmsg.cc
Compiling libnml/nml/stat_msg.cc
Compiling libnml/linklist/linklist.cc
Compiling hal/hal_lib.c
Compiling rtapi/uspace_ulapi.c
Compiling rtapi/uspace_rtapi_app.cc
Compiling rtapi/uspace_rtapi_parport.cc
Compiling rtapi/uspace_rtapi_string.c
Compiling rtapi/rtapi_pci.cc
./config.status --file=../docs/man/man1/linuxcnc.1:../docs/src/man/man1/linuxcnc.1.in
config.status: creating ../docs/man/man1/linuxcnc.1
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/emccalib.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/emccalib.1.adoc
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/halstreamer.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/halstreamer.1.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/emccalib.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/emccalib.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/emccalib.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/emccalib.1.xml"

Note: Writing emccalib.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/emccalib.1.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/hy_gt_vfd.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/hy_gt_vfd.1.adoc
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/mesambccc.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/mesambccc.1.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/halstreamer.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/halstreamer.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/halstreamer.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/halstreamer.1.xml"

Note: Writing halstreamer.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/halstreamer.1.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/mqtt-publisher.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/mqtt-publisher.1.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/hy_gt_vfd.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/hy_gt_vfd.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/hy_gt_vfd.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/hy_gt_vfd.1.xml"

Note: Writing hy_gt_vfd.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/hy_gt_vfd.1.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/sendkeys.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/sendkeys.1.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/mqtt-publisher.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mqtt-publisher.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mqtt-publisher.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mqtt-publisher.1.xml"

Note: Writing mqtt-publisher.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mqtt-publisher.1.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/svd-ps_vfd.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/svd-ps_vfd.1.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/mesambccc.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mesambccc.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mesambccc.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mesambccc.1.xml"

Note: Writing mesambccc.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mesambccc.1.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man1/xhc-whb04b-6.1` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man1/xhc-whb04b-6.1.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/sendkeys.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/sendkeys.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/sendkeys.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/sendkeys.1.xml"

Note: Writing sendkeys.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/sendkeys.1.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man3/hm2_pktuart.3` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man3/hm2_pktuart.3.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/svd-ps_vfd.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/svd-ps_vfd.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/svd-ps_vfd.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/svd-ps_vfd.1.xml"

Note: Writing svd-ps_vfd.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/svd-ps_vfd.1.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man9/enum.9` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man9/enum.9.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man3', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man3/hm2_pktuart.3.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man3/hm2_pktuart.3.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man3/hm2_pktuart.3.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man3
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man3/hm2_pktuart.3.xml"

Note: Writing hm2_pktuart.3

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man3/hm2_pktuart.3.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man9/hm2_modbus.9` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man9/hm2_modbus.9.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man9', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man9/enum.9.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/enum.9.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/enum.9.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/enum.9.xml"

Note: Writing enum.9

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/enum.9.xml
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man9/hm2_spix.9` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man9/hm2_spix.9.adoc
a2x -v --doctype manpage \
	--format manpage \
	--destination-dir `dirname ../docs/man/man9/streamer.9` \
	--xsltproc-opts="--nonet" \
	-a mansource=LinuxCNC \
	-a manmanual='LinuxCNC Documentation' \
	../docs/src/man/man9/streamer.9.adoc
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man1', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man1/xhc-whb04b-6.1.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/xhc-whb04b-6.1.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/xhc-whb04b-6.1.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/xhc-whb04b-6.1.xml"

Note: Writing xhc-whb04b-6.1

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/xhc-whb04b-6.1.xml
Compiling hal/components/streamer_usr.c
Compiling hal/components/sampler_usr.c
Compiling hal/components/panelui.c
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man9', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man9/hm2_modbus.9.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_modbus.9.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_modbus.9.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_modbus.9.xml"

Note: Writing hm2_modbus.9

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_modbus.9.xml
Compiling hal/user_comps/mb2hal/mb2hal.c
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man9', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man9/streamer.9.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/streamer.9.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/streamer.9.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/streamer.9.xml"

Note: Writing streamer.9

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/streamer.9.xml
Compiling hal/user_comps/mb2hal/mb2hal_init.c
Compiling hal/user_comps/mb2hal/mb2hal_modbus.c
Compiling hal/user_comps/mb2hal/mb2hal_hal.c
a2x: args: ['-v', '--doctype', 'manpage', '--format', 'manpage', '--destination-dir', '../docs/man/man9', '--xsltproc-opts=--nonet', '-a', 'mansource=LinuxCNC', '-a', 'manmanual=LinuxCNC Documentation', '../docs/src/man/man9/hm2_spix.9.adoc']
a2x: resource files: []
a2x: resource directories: ['/etc/asciidoc/stylesheets']
a2x: executing: asciidoc [('--doctype', 'manpage'), ('--attribute', 'mansource=LinuxCNC'), ('--attribute', 'manmanual=LinuxCNC Documentation'), ('--verbose',), ('--backend', 'docbook'), ('-a', 'a2x-format=manpage'), ('--out-file', '/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_spix.9.xml')]
a2x: executing: "xmllint" --nonet --noout --valid "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_spix.9.xml"


a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9
a2x: executing: "xsltproc" --nonet --nonet --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0  "/etc/asciidoc/docbook-xsl/manpage.xsl" "/home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_spix.9.xml"

Warn: meta author : no refentry/info/author                        hm2_spix
Note: meta author : see http://www.docbook.org/tdg5/en/html/autho  hm2_spix
Warn: meta author : no author data, so inserted a fixme            hm2_spix
Note: Writing hm2_spix.9

a2x: chdir /home/runner/work/_temp/linuxcnc-curriculum-stable/src
a2x: deleting /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_spix.9.xml
Compiling hal/user_comps/gs2_vfd.c
Compiling hal/user_comps/hy_gt_vfd.c
Compiling hal/user_comps/svd-ps_vfd.c
Compiling hal/user_comps/shuttle.c
Compiling hal/user_comps/xhc-hb04.cc
Compiling hal/user_comps/sendkeys.c
Compiling hal/user_comps/vfs11_vfd/vfs11_vfd.c
Compiling hal/classicladder/arithm_eval.c
Compiling hal/classicladder/arrays.c
Compiling hal/classicladder/calc.c
Compiling hal/classicladder/calc_sequential.c
Compiling hal/classicladder/classicladder.c
Compiling hal/classicladder/classicladder_gtk.c
Compiling hal/classicladder/config.c
Compiling hal/classicladder/config_gtk.c
Compiling hal/classicladder/drawing.c
Compiling hal/classicladder/drawing_sequential.c
Compiling hal/classicladder/edit.c
Compiling hal/classicladder/edit_gtk.c
Compiling hal/classicladder/edit_sequential.c
Compiling hal/classicladder/editproperties_gtk.c
Compiling hal/classicladder/emc_mods.c
Compiling hal/classicladder/files.c
Compiling hal/classicladder/files_project.c
Compiling hal/classicladder/files_sequential.c
Compiling hal/classicladder/manager.c
Compiling hal/classicladder/manager_gtk.c
Compiling hal/classicladder/protocol_modbus_master.c
Compiling hal/classicladder/protocol_modbus_slave.c
Compiling hal/classicladder/serial_linux.c
Compiling hal/classicladder/socket_modbus_master.c
Compiling hal/classicladder/socket_server.c
Compiling hal/classicladder/spy_vars_gtk.c
Compiling hal/classicladder/symbols.c
Compiling hal/classicladder/symbols_gtk.c
Compiling hal/classicladder/vars_names.c
Compiling hal/classicladder/vars_access.c
Compiling hal/utils/halcmd.c
Compiling hal/utils/halcmd_commands.cc
Compiling hal/utils/halsh.c
Compiling hal/utils/halcmd_main.c
Compiling hal/utils/halcmd_completion.c
Compiling hal/utils/halrmt.c
Compiling hal/utils/meter.c
Compiling hal/utils/miscgtk.c
Compiling hal/utils/scope.c
Compiling hal/utils/scope_horiz.c
Compiling hal/utils/scope_vert.c
Compiling hal/utils/scope_trig.c
Compiling hal/utils/scope_disp.c
Compiling hal/utils/scope_files.c
Syntax checking python script elbpcom
Syntax checking python script modcompile
Copying python script elbpcom
Copying Modbus template mesa_modbus.c.tmpl
Syntax checking python script mesambccc
Copying python script modcompile
Compiling hal/user_comps/vfdb_vfd/vfdb_vfd.c
Copying python script mesambccc
Compiling hal/user_comps/huanyang-vfd/hy_vfd.c
Compiling hal/user_comps/huanyang-vfd/hy_comm.c
Compiling hal/user_comps/xhc-whb04b-6/hal.cc
Compiling hal/user_comps/xhc-whb04b-6/usb.cc
Compiling hal/user_comps/xhc-whb04b-6/pendant-types.cc
Compiling hal/user_comps/xhc-whb04b-6/pendant.cc
Compiling hal/user_comps/xhc-whb04b-6/xhc-whb04b6.cc
Compiling hal/user_comps/xhc-whb04b-6/main.cc
Compiling emc/usr_intf/emcsh.cc
Compiling emc/usr_intf/shcom.cc
Compiling emc/nml_intf/emcglb.c
Compiling emc/rs274ngc/modal_state.cc
Compiling emc/nml_intf/emc.cc
Compiling emc/nml_intf/emcpose.c
Compiling emc/nml_intf/emcargs.cc
Compiling emc/nml_intf/emcops.cc
Compiling emc/nml_intf/canon_position.cc
Compiling emc/ini/emcIniFile.cc
Compiling emc/ini/iniaxis.cc
Compiling emc/ini/inijoint.cc
Compiling emc/ini/inispindle.cc
Compiling emc/ini/initraj.cc
Compiling emc/ini/inihal.cc
Compiling emc/nml_intf/interpl.cc
Compiling emc/usr_intf/emcrsh.cc
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
Compiling emc/task/taskmodule.cc
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
Compiling emc/iotask/ioControl.cc
Compiling emc/iotask/ioControl_v2.cc
Compiling emc/kinematics/ugenserkins.c
Compiling emc/kinematics/genserfuncs.c
Compiling emc/canterp/canterp.cc
Compiling emc/sai/saicanon.cc
Compiling emc/sai/driver.cc
Compiling emc/sai/dummyemcstat.cc
Compiling emc/motion-logger/motion-logger.c
Compiling emc/motion/axis.c
Compiling emc/motion/simple_tp.c
Compiling module_helper/module_helper.c
Compiling localized message catalog ../share/locale/cs/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/da/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/de/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/es/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/fi/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/fr/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/hu/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/it/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/ja/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/nb/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/pl/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/pt_BR/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/ro/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/ru/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/sk/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/sr/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/sv/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/vi/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/zh_CN/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/zh_HK/LC_MESSAGES/linuxcnc.mo
Compiling localized message catalog ../share/locale/zh_TW/LC_MESSAGES/linuxcnc.mo
Compiling localized gmoccapy message catalog ../share/locale/cs/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/da/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/de/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/es/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/fr/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/hu/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/it/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/nb/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/pl/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/sk/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/sr/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/vi/LC_MESSAGES/gmoccapy.mo
Compiling localized gmoccapy message catalog ../share/locale/zh_CN/LC_MESSAGES/gmoccapy.mo
cp emc/linuxcnc.h ../include/linuxcnc.h
cp emc/ini/emcIniFile.hh ../include/emcIniFile.hh
cp emc/ini/iniaxis.hh ../include/iniaxis.hh
cp emc/ini/inijoint.hh ../include/inijoint.hh
cp emc/ini/inispindle.hh ../include/inispindle.hh
cp emc/ini/initraj.hh ../include/initraj.hh
cp emc/ini/inihal.hh ../include/inihal.hh
cp emc/kinematics/cubic.h ../include/cubic.h
cp emc/kinematics/kinematics.h ../include/kinematics.h
cp emc/kinematics/switchkins.h ../include/switchkins.h
cp emc/kinematics/genhexkins.h ../include/genhexkins.h
cp emc/kinematics/genserkins.h ../include/genserkins.h
cp emc/kinematics/pentakins.h ../include/pentakins.h
cp emc/kinematics/pumakins.h ../include/pumakins.h
cp emc/tp/tc.h ../include/tc.h
cp emc/tp/tc_types.h ../include/tc_types.h
cp emc/tp/tcq.h ../include/tcq.h
cp emc/tp/tp.h ../include/tp.h
cp emc/tp/tp_types.h ../include/tp_types.h
cp emc/tp/spherical_arc.h ../include/spherical_arc.h
cp emc/tp/blendmath.h ../include/blendmath.h
cp emc/motion/emcmotcfg.h ../include/emcmotcfg.h
cp emc/motion/motion.h ../include/motion.h
cp emc/motion/homing.h ../include/homing.h
cp emc/motion/simple_tp.h ../include/simple_tp.h
cp emc/motion/state_tag.h ../include/state_tag.h
cp emc/motion/usrmotintf.h ../include/usrmotintf.h
cp emc/motion/axis.h ../include/axis.h
cp emc/nml_intf/canon.hh ../include/canon.hh
cp emc/nml_intf/canon_position.hh ../include/canon_position.hh
cp emc/nml_intf/emctool.h ../include/emctool.h
cp emc/nml_intf/emc.hh ../include/emc.hh
cp emc/nml_intf/emc_nml.hh ../include/emc_nml.hh
cp emc/nml_intf/emccfg.h ../include/emccfg.h
cp emc/nml_intf/emcglb.h ../include/emcglb.h
cp emc/nml_intf/emcpos.h ../include/emcpos.h
cp emc/nml_intf/emcpose.h ../include/emcpose.h
cp emc/nml_intf/interp_return.hh ../include/interp_return.hh
cp emc/nml_intf/interpl.hh ../include/interpl.hh
cp emc/nml_intf/motion_types.h ../include/motion_types.h
cp emc/nml_intf/debugflags.h ../include/debugflags.h
cp emc/rs274ngc/interp_internal.hh ../include/interp_internal.hh
cp emc/rs274ngc/interp_fwd.hh ../include/interp_fwd.hh
cp emc/rs274ngc/interp_base.hh ../include/interp_base.hh
cp emc/rs274ngc/modal_state.hh ../include/modal_state.hh
cp emc/rs274ngc/rs274ngc.hh ../include/rs274ngc.hh
cp emc/sai/saicanon.hh ../include/saicanon.hh
cp hal/hal.h ../include/hal.h
cp hal/hal_parport.h ../include/hal_parport.h
cp hal/drivers/mesa-hostmot2/hostmot2-serial.h ../include/hostmot2-serial.h
cp libnml/buffer/locmem.hh ../include/locmem.hh
cp libnml/buffer/memsem.hh ../include/memsem.hh
cp libnml/buffer/phantom.hh ../include/phantom.hh
cp libnml/buffer/physmem.hh ../include/physmem.hh
cp libnml/buffer/recvn.h ../include/recvn.h
cp libnml/buffer/rem_msg.hh ../include/rem_msg.hh
cp libnml/buffer/sendn.h ../include/sendn.h
cp libnml/buffer/shmem.hh ../include/shmem.hh
cp libnml/buffer/tcpmem.hh ../include/tcpmem.hh
cp libnml/cms/cms.hh ../include/cms.hh
cp libnml/cms/cms_aup.hh ../include/cms_aup.hh
cp libnml/cms/cms_cfg.hh ../include/cms_cfg.hh
cp libnml/cms/cms_dup.hh ../include/cms_dup.hh
cp libnml/cms/cms_srv.hh ../include/cms_srv.hh
cp libnml/cms/cms_up.hh ../include/cms_up.hh
cp libnml/cms/cms_user.hh ../include/cms_user.hh
cp libnml/cms/cms_xup.hh ../include/cms_xup.hh
cp libnml/cms/cmsdiag.hh ../include/cmsdiag.hh
cp libnml/cms/tcp_opts.hh ../include/tcp_opts.hh
cp libnml/cms/tcp_srv.hh ../include/tcp_srv.hh
cp libnml/inifile/inifile.h ../include/inifile.h
cp libnml/inifile/inifile.hh ../include/inifile.hh
cp libnml/linklist/linklist.hh ../include/linklist.hh
cp libnml/nml/cmd_msg.hh ../include/cmd_msg.hh
cp libnml/nml/nml.hh ../include/nml.hh
cp libnml/nml/nml_mod.hh ../include/nml_mod.hh
cp libnml/nml/nml_oi.hh ../include/nml_oi.hh
cp libnml/nml/nml_srv.hh ../include/nml_srv.hh
cp libnml/nml/nml_type.hh ../include/nml_type.hh
cp libnml/nml/nmldiag.hh ../include/nmldiag.hh
cp libnml/nml/nmlmsg.hh ../include/nmlmsg.hh
cp libnml/nml/stat_msg.hh ../include/stat_msg.hh
cp libnml/os_intf/_sem.h ../include/_sem.h
cp libnml/os_intf/sem.hh ../include/sem.hh
cp libnml/os_intf/_shm.h ../include/_shm.h
cp libnml/os_intf/shm.hh ../include/shm.hh
cp libnml/os_intf/_timer.h ../include/_timer.h
cp libnml/os_intf/timer.hh ../include/timer.hh
cp libnml/posemath/posemath.h ../include/posemath.h
cp libnml/posemath/gotypes.h ../include/gotypes.h
cp libnml/posemath/gomath.h ../include/gomath.h
cp libnml/posemath/sincos.h ../include/sincos.h
cp libnml/rcs/rcs.hh ../include/rcs.hh
cp libnml/rcs/rcs_exit.hh ../include/rcs_exit.hh
cp libnml/rcs/rcs_print.hh ../include/rcs_print.hh
cp libnml/rcs/rcsversion.h ../include/rcsversion.h
cp rtapi/rtapi.h ../include/rtapi.h
cp rtapi/rtapi_app.h ../include/rtapi_app.h
cp rtapi/rtapi_atomic.h ../include/rtapi_atomic.h
cp rtapi/rtapi_bitops.h ../include/rtapi_bitops.h
cp rtapi/rtapi_bool.h ../include/rtapi_bool.h
cp rtapi/rtapi_byteorder.h ../include/rtapi_byteorder.h
cp rtapi/rtapi_device.h ../include/rtapi_device.h
cp rtapi/rtapi_firmware.h ../include/rtapi_firmware.h
cp rtapi/rtapi_gfp.h ../include/rtapi_gfp.h
cp rtapi/rtapi_io.h ../include/rtapi_io.h
cp rtapi/rtapi_limits.h ../include/rtapi_limits.h
cp rtapi/rtapi_list.h ../include/rtapi_list.h
cp rtapi/rtapi_math.h ../include/rtapi_math.h
cp rtapi/rtapi_math_i386.h ../include/rtapi_math_i386.h
cp rtapi/rtapi_math64.h ../include/rtapi_math64.h
cp rtapi/rtapi_mutex.h ../include/rtapi_mutex.h
cp rtapi/rtapi_parport.h ../include/rtapi_parport.h
cp rtapi/rtapi_pci.h ../include/rtapi_pci.h
cp rtapi/rtapi_slab.h ../include/rtapi_slab.h
cp rtapi/rtapi_stdint.h ../include/rtapi_stdint.h
cp rtapi/rtapi_ctype.h ../include/rtapi_ctype.h
cp rtapi/rtapi_errno.h ../include/rtapi_errno.h
cp rtapi/rtapi_string.h ../include/rtapi_string.h
cp rtapi/rtapi_vsnprintf.h ../include/rtapi_vsnprintf.h
Compiling localized message catalog objects/cs.msg
Compiling localized message catalog objects/da.msg
Compiling localized message catalog objects/de.msg
Compiling localized message catalog objects/es.msg
Compiling localized message catalog objects/fi.msg
Compiling localized message catalog objects/fr.msg
Compiling localized message catalog objects/hu.msg
Compiling localized message catalog objects/it.msg
Compiling localized message catalog objects/ja.msg
Compiling localized message catalog objects/nb.msg
Compiling localized message catalog objects/pl.msg
Compiling localized message catalog objects/pt_BR.msg
Compiling localized message catalog objects/ro.msg
Compiling localized message catalog objects/ru.msg
Compiling localized message catalog objects/sk.msg
Compiling localized message catalog objects/sr.msg
Compiling localized message catalog objects/sv.msg
Compiling localized message catalog objects/vi.msg
Compiling localized message catalog objects/zh_CN.msg
Compiling localized message catalog objects/zh_HK.msg
Compiling localized message catalog objects/zh_TW.msg
Syntax checking python script pyvcp
Syntax checking python script hal_input
Syntax checking python script gladevcp
Syntax checking python script scorbot-er-3
Copying python script pyvcp
Copying python script hal_input
Copying python script scorbot-er-3
Syntax checking python script mitsub_vfd
Syntax checking python script pmx485
Copying python script gladevcp
Syntax checking python script sim-torch
Syntax checking python script z_level_compensation
Copying python script pmx485
Copying python script mitsub_vfd
Copying python script sim-torch
Syntax checking python script mqtt-publisher
Syntax checking python script pumagui
Copying python script z_level_compensation
Syntax checking python script puma560gui
Syntax checking python script lineardelta
Copying python script mqtt-publisher
Copying python script puma560gui
Copying python script pumagui
Syntax checking python script scaragui
Syntax checking python script hexagui
Syntax checking python script 5axisgui
Copying python script lineardelta
Syntax checking python script max5gui
Copying python script scaragui
Copying python script 5axisgui
Copying python script hexagui
Syntax checking python script maho600gui
Syntax checking python script hbmgui
Syntax checking python script rotarydelta
Copying python script max5gui
Syntax checking python script melfagui
Copying python script maho600gui
Copying python script rotarydelta
Syntax checking python script millturngui
Syntax checking python script xyzac-trt-gui
Copying python script hbmgui
Copying python script melfagui
Syntax checking python script xyzbc-trt-gui
Syntax checking python script xyzab-tdr-gui
Copying python script millturngui
Copying python script xyzac-trt-gui
Compiling hal/halmodule.cc
Compiling emc/usr_intf/axis/extensions/emcmodule.cc
Copying python script xyzab-tdr-gui
Copying python script xyzbc-trt-gui
Compiling emc/usr_intf/axis/extensions/_toglmodule.c
Syntax checking python script axis
Copying python script axis
Syntax checking python script axis-remote
Copying python script axis-remote
Syntax checking python script linuxcnctop
Copying python script linuxcnctop
Syntax checking python script hal_manualtoolchange
Copying python script hal_manualtoolchange
Syntax checking python script mdi
Copying python script mdi
Syntax checking python script image-to-gcode
Copying python script image-to-gcode
Syntax checking python script lintini
Copying python script lintini
Syntax checking python script debuglevel
Syntax checking python script teach-in
Copying python script teach-in
Copying python script debuglevel
Syntax checking python script tracking-test
Syntax checking python script touchy
Copying python script tracking-test
Syntax checking python script mdi.py
Copying python script touchy
Syntax checking python script emc_interface.py
Copying python script mdi.py
Syntax checking python script hal_interface.py
Copying python script emc_interface.py
Syntax checking python script filechooser.py
Copying python script hal_interface.py
Syntax checking python script listing.py
Copying python script filechooser.py
Syntax checking python script preferences.py
Copying python script listing.py
Copying glade file touchy.glade
Syntax checking python script stepconf
Copying python script preferences.py
building python init __init__.py
Copying linuxcnc-wizard.gif
Syntax checking python script pages.py
Copying python script stepconf
Copying python script pages.py
Syntax checking python script build_INI.py
Syntax checking python script build_HAL.py
Copying python script build_INI.py
Syntax checking python script import_mach.py
Copying python script build_HAL.py
Copying glade file main_page.glade
Copying glade file base.glade
Copying glade file start.glade
Copying glade file pport1.glade
Copying glade file pport2.glade
Copying glade file spindle.glade
Copying python script import_mach.py
Copying glade file options.glade
Copying glade file halui_page.glade
Copying glade file ubuttons.glade
Copying glade file thcad.glade
Copying glade file axisx.glade
Copying glade file axisy.glade
Copying glade file axisz.glade
Copying glade file axisu.glade
Copying glade file axisv.glade
Copying glade file axisa.glade
Copying glade file finished.glade
Syntax checking python script pncconf
building python init __init__.py
Syntax checking python script pages.py
Copying python script pages.py
Syntax checking python script build_INI.py
Copying python script pncconf
Syntax checking python script build_HAL.py
Copying python script build_INI.py
Syntax checking python script private_data.py
Syntax checking python script tests.py
Copying python script build_HAL.py
Syntax checking python script data.py
Copying python script private_data.py
Copying python script tests.py
Copying glade file main_page.glade
Copying python script data.py
Copying glade file help.glade
Copying glade file mesa0.glade
Copying glade file mesa1.glade
Copying glade file start.glade
Copying glade file external.glade
Copying glade file base.glade
Copying glade file screen.glade
Copying glade file vcp.glade
Copying glade file ubuttons.glade
Copying glade file thcad.glade
Copying glade file x_axis.glade
Copying glade file x_motor.glade
Copying glade file y_axis.glade
Copying glade file y_motor.glade
Copying glade file z_axis.glade
Copying glade file z_motor.glade
Copying glade file a_axis.glade
Copying glade file a_motor.glade
Copying glade file s_motor.glade
Copying glade file options.glade
Copying glade file realtime.glade
Copying glade file pport1.glade
Copying glade file pport2.glade
Copying glade file dialogs.glade
Copying glade file finished.glade
Syntax checking python script gremlin
Syntax checking python script gremlin.py
Syntax checking python script qt5_graphics.py
Copying python script gremlin
Syntax checking python script gscreen
Copying python script gremlin.py
Copying python script qt5_graphics.py
Syntax checking python script mdi.py
Syntax checking python script emc_interface.py
Copying python script mdi.py
Syntax checking python script preferences.py
Copying python script emc_interface.py
Syntax checking python script keybindings.py
Copying python script gscreen
Copying glade file gscreen.glade
Copying glade file gscreen2.glade
Syntax checking python script pyui
Copying python script preferences.py
Syntax checking python script master.py
Copying python script keybindings.py
Syntax checking python script widgets.py
Copying python script pyui
Syntax checking python script __init__.py
Copying python script master.py
Syntax checking python script commands.py
Copying python script widgets.py
Syntax checking python script panelui_validate.py
Copying python script __init__.py
Copying INI script panelui_spec.ini
cp emc/usr_intf/pyui/panelui_spec.ini ../lib/python/pyui/panelui_spec.ini
Copying INI script _panelui.ini
cp emc/usr_intf/pyui/_panelui.ini ../lib/python/pyui/_panelui.ini
Copying python script commands.py
Syntax checking python script qtvcp
Copying python script panelui_validate.py
Syntax checking python script gmoccapy
Syntax checking python script dialogs.py
Copying python script qtvcp
Syntax checking python script getiniinfo.py
Copying python script dialogs.py
Syntax checking python script notification.py
Copying python script getiniinfo.py
Syntax checking python script player.py
Copying python script notification.py
Copying python script gmoccapy
Syntax checking python script preferences.py
Syntax checking python script widgets.py
Copying python script player.py
Syntax checking python script icon_theme_helper.py
Copying python script preferences.py
Copying python script widgets.py
Copying glade file gmoccapy.glade
Syntax checking python script qtplasmac-materials
Syntax checking python script qtplasmac-plasmac2qt
Copying python script icon_theme_helper.py
Syntax checking python script qtplasmac-cfg2prefs
Copying python script qtplasmac-materials
Copying python script qtplasmac-plasmac2qt
Syntax checking python script qtplasmac_gcode
Syntax checking python script pmx485-test
Copying python script qtplasmac-cfg2prefs
Syntax checking python script M190
Copying python script pmx485-test
Copying python script qtplasmac_gcode
Syntax checking python script mdro
Copying python script M190
Compiling emc/kinematics/lineardeltakins.cc
Compiling emc/kinematics/rotarydeltakins.cc
Copying python script mdro
Syntax checking python script update_ini
Copying python script update_ini
Compiling emc/rs274ngc/gcodemodule.cc
Compiling realtime hal/components/boss_plc.c
Compiling realtime hal/components/debounce.c
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
Compiling realtime hal/drivers/mesa-hostmot2/hm2_spi.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_rpspi.c
Compiling realtime hal/drivers/mesa-hostmot2/hm2_spix.c
Compiling realtime hal/drivers/mesa-hostmot2/spix_rpi5.c
Compiling realtime hal/drivers/mesa-hostmot2/spix_rpi3.c
Compiling realtime hal/drivers/mesa-hostmot2/spix_spidev.c
Compiling realtime hal/drivers/mesa-hostmot2/llio_info.c
Compiling realtime hal/drivers/mesa-hostmot2/eshellf.c
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
Compiling realtime libnml/posemath/_posemath.c
Compiling realtime libnml/posemath/sincos.c
Compiling realtime emc/kinematics/rotarydeltakins.c
Compiling realtime emc/kinematics/rosekins.c
Compiling realtime emc/kinematics/scorbot-kins.c
Compiling realtime emc/kinematics/genhexkins.c
Compiling realtime emc/kinematics/switchkins.c
Compiling realtime emc/kinematics/userkfuncs.c
Compiling realtime emc/kinematics/genserkins.c
Compiling realtime emc/kinematics/genserfuncs.c
Compiling realtime libnml/posemath/gomath.c
Compiling realtime emc/kinematics/xyzac-trt-kins.c
Compiling realtime emc/kinematics/trtfuncs.c
Compiling realtime emc/kinematics/xyzbc-trt-kins.c
Compiling realtime emc/kinematics/scarakins.c
Compiling realtime emc/kinematics/pumakins.c
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
Compiling realtime emc/motion/homemod.c
Compiling realtime emc/motion/homing.c
Compiling realtime emc/tp/tpmod.c
Compiling realtime emc/tp/tc.c
Compiling realtime emc/tp/tcq.c
Compiling realtime emc/tp/tp.c
Compiling realtime emc/tp/spherical_arc.c
Compiling realtime emc/tp/blendmath.c
Compiling realtime emc/nml_intf/emcpose.c
config.status: creating ../scripts/setup_designer
Creating shared library liblinuxcncini.so.0
Creating shared library libposemath.so.0
Creating shared library liblinuxcnchal.so.0
Linking rtapi_app
Syntax checking python script halcompile
Linking halstreamer
Copying python script halcompile
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
Linking classicladder
Linking hal.so
Linking halcmd
Linking halrmt
Linking halmeter
Linking halscope
Linking vfdb_vfd
Preprocessing wj200_vfd.comp
Preprocessing pi500_vfd.comp
Linking hy_vfd
Linking xhc-whb04b-6
Linking liblinuxcnc.a
tooldata: depends: objects/emc/tooldata/tooldata_mmap.o objects/emc/tooldata/tooldata_common.o objects/emc/tooldata/tooldata_db.o
tooldata: Linking: libtooldata.so.0
Linking linuxcnc_module_helper
gcc -Wl,-z,relro -o ../bin/linuxcnc_module_helper objects/module_helper/module_helper.o
Linking python module _togl.so
Linking python module lineardeltakins.so
c++ -std=gnu++17 -L/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -ltirpc  -lgpiod  -shared -o ../lib/python/lineardeltakins.so objects/emc/kinematics/lineardeltakins.o -lboost_python312
Linking python module rotarydeltakins.so
c++ -std=gnu++17 -L/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -ltirpc  -lgpiod  -shared -o ../lib/python/rotarydeltakins.so objects/emc/kinematics/rotarydeltakins.o -lboost_python312
Preprocessing abs.comp
Preprocessing abs_s32.comp
Preprocessing and2.comp
Preprocessing anglejog.comp
Preprocessing axistest.comp
Preprocessing bin2gray.comp
Preprocessing biquad.comp
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
Preprocessing constant.comp
Preprocessing conv_bit_float.comp
Preprocessing conv_bit_s32.comp
Preprocessing conv_bit_u32.comp
Preprocessing conv_float_s32.comp
Preprocessing conv_float_u32.comp
Preprocessing conv_s32_bit.comp
Preprocessing conv_s32_float.comp
Preprocessing conv_s32_u32.comp
Preprocessing conv_u32_bit.comp
Preprocessing conv_u32_float.comp
Preprocessing conv_u32_s32.comp
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
Preprocessing homecomp.comp
Preprocessing hypot.comp
Preprocessing ilowpass.comp
Preprocessing integ.comp
Preprocessing invert.comp
Preprocessing joyhandle.comp
Preprocessing knob2float.comp
Preprocessing latencybins.comp
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
Preprocessing max31855.comp
Preprocessing mesa_pktgyro_test.comp
Preprocessing message.comp
Preprocessing millturn.comp
Preprocessing minmax.comp
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
Preprocessing plasmac.comp
Preprocessing radiobutton.comp
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
Preprocessing serport.comp
Preprocessing mesa_7i65.comp
Preprocessing mesa_uart.comp
Compiling realtime objects/hal/components/abs.c
Compiling realtime objects/hal/components/abs_s32.c
Compiling realtime objects/hal/components/and2.c
Compiling realtime objects/hal/components/anglejog.c
Compiling realtime objects/hal/components/axistest.c
Compiling realtime objects/hal/components/bin2gray.c
Compiling realtime objects/hal/components/biquad.c
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
Compiling realtime objects/hal/components/constant.c
Compiling realtime objects/hal/components/conv_bit_float.c
Compiling realtime objects/hal/components/conv_bit_s32.c
Compiling realtime objects/hal/components/conv_bit_u32.c
Compiling realtime objects/hal/components/conv_float_s32.c
Compiling realtime objects/hal/components/conv_float_u32.c
Compiling realtime objects/hal/components/conv_s32_bit.c
Compiling realtime objects/hal/components/conv_s32_float.c
Compiling realtime objects/hal/components/conv_s32_u32.c
Compiling realtime objects/hal/components/conv_u32_bit.c
Compiling realtime objects/hal/components/conv_u32_float.c
Compiling realtime objects/hal/components/conv_u32_s32.c
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
Compiling realtime objects/hal/components/homecomp.c
Compiling realtime objects/hal/components/hypot.c
Compiling realtime objects/hal/components/ilowpass.c
Compiling realtime objects/hal/components/integ.c
Compiling realtime objects/hal/components/invert.c
Compiling realtime objects/hal/components/joyhandle.c
Compiling realtime objects/hal/components/knob2float.c
Compiling realtime objects/hal/components/latencybins.c
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
Compiling realtime objects/hal/components/max31855.c
Compiling realtime objects/hal/components/mesa_pktgyro_test.c
Compiling realtime objects/hal/components/message.c
Compiling realtime objects/hal/components/millturn.c
Compiling realtime objects/hal/components/minmax.c
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
Compiling realtime objects/hal/components/plasmac.c
Compiling realtime objects/hal/components/radiobutton.c
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
Compiling realtime objects/hal/drivers/serport.c
Compiling realtime objects/hal/drivers/mesa_7i65.c
Compiling realtime objects/hal/drivers/mesa_uart.c
Linking ../rtlib/boss_plc.so
Linking ../rtlib/debounce.so
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
Linking ../rtlib/5axiskins.so
Linking ../rtlib/motmod.so
Linking ../rtlib/homemod.so
Linking ../rtlib/tpmod.so
ln -sf liblinuxcncini.so.0 ../lib/liblinuxcncini.so
Linking inivar
ln -sf libposemath.so.0 ../lib/libposemath.so
ln -sf liblinuxcnchal.so.0 ../lib/liblinuxcnchal.so
Making halcompile manpage abs.9
Making halcompile manpage abs_s32.9
Making halcompile manpage and2.9
Making halcompile manpage anglejog.9
rm -f ../docs/man/man9/abs.9.new
rm -f ../docs/man/man9/abs_s32.9.new
Making halcompile manpage axistest.9
Making halcompile manpage bin2gray.9
rm -f ../docs/man/man9/and2.9.new
Making halcompile manpage biquad.9
rm -f ../docs/man/man9/anglejog.9.new
Making halcompile manpage bitslice.9
rm -f ../docs/man/man9/bin2gray.9.new
rm -f ../docs/man/man9/axistest.9.new
Making halcompile manpage bitwise.9
Making halcompile manpage bldc.9
rm -f ../docs/man/man9/biquad.9.new
Making halcompile manpage blend.9
rm -f ../docs/man/man9/bitslice.9.new
Making halcompile manpage carousel.9
rm -f ../docs/man/man9/bitwise.9.new
Making halcompile manpage charge_pump.9
rm -f ../docs/man/man9/blend.9.new
rm -f ../docs/man/man9/bldc.9.new
Making halcompile manpage clarke2.9
Making halcompile manpage clarke3.9
rm -f ../docs/man/man9/carousel.9.new
Making halcompile manpage clarkeinv.9
rm -f ../docs/man/man9/charge_pump.9.new
Making halcompile manpage comp.9
rm -f ../docs/man/man9/clarke2.9.new
rm -f ../docs/man/man9/clarke3.9.new
Making halcompile manpage constant.9
Making halcompile manpage conv_bit_float.9
rm -f ../docs/man/man9/clarkeinv.9.new
Making halcompile manpage conv_bit_s32.9
rm -f ../docs/man/man9/comp.9.new
Making halcompile manpage conv_bit_u32.9
rm -f ../docs/man/man9/constant.9.new
rm -f ../docs/man/man9/conv_bit_float.9.new
Making halcompile manpage conv_float_s32.9
Making halcompile manpage conv_float_u32.9
rm -f ../docs/man/man9/conv_bit_s32.9.new
Making halcompile manpage conv_s32_bit.9
rm -f ../docs/man/man9/conv_bit_u32.9.new
Making halcompile manpage conv_s32_float.9
rm -f ../docs/man/man9/conv_float_s32.9.new
rm -f ../docs/man/man9/conv_float_u32.9.new
Making halcompile manpage conv_s32_u32.9
Making halcompile manpage conv_u32_bit.9
rm -f ../docs/man/man9/conv_s32_bit.9.new
Making halcompile manpage conv_u32_float.9
rm -f ../docs/man/man9/conv_s32_float.9.new
Making halcompile manpage conv_u32_s32.9
rm -f ../docs/man/man9/conv_u32_bit.9.new
rm -f ../docs/man/man9/conv_s32_u32.9.new
Making halcompile manpage corexy_by_hal.9
Making halcompile manpage dbounce.9
rm -f ../docs/man/man9/conv_u32_float.9.new
Making halcompile manpage ddt.9
rm -f ../docs/man/man9/conv_u32_s32.9.new
Making halcompile manpage deadzone.9
rm -f ../docs/man/man9/corexy_by_hal.9.new
rm -f ../docs/man/man9/dbounce.9.new
Making halcompile manpage demux.9
Making halcompile manpage differential.9
rm -f ../docs/man/man9/ddt.9.new
Making halcompile manpage div2.9
rm -f ../docs/man/man9/deadzone.9.new
Making halcompile manpage edge.9
rm -f ../docs/man/man9/demux.9.new
rm -f ../docs/man/man9/differential.9.new
Making halcompile manpage eoffset_per_angle.9
Making halcompile manpage estop_latch.9
rm -f ../docs/man/man9/div2.9.new
Making halcompile manpage feedcomp.9
rm -f ../docs/man/man9/edge.9.new
rm -f ../docs/man/man9/estop_latch.9.new
Making halcompile manpage filter_kalman.9
rm -f ../docs/man/man9/eoffset_per_angle.9.new
Making halcompile manpage flipflop.9
Making halcompile manpage gantry.9
rm -f ../docs/man/man9/feedcomp.9.new
Making halcompile manpage gearchange.9
rm -f ../docs/man/man9/flipflop.9.new
rm -f ../docs/man/man9/filter_kalman.9.new
Making halcompile manpage gray2bin.9
Making halcompile manpage histobins.9
rm -f ../docs/man/man9/gantry.9.new
Making halcompile manpage homecomp.9
rm -f ../docs/man/man9/gearchange.9.new
Making halcompile manpage hypot.9
rm -f ../docs/man/man9/gray2bin.9.new
rm -f ../docs/man/man9/histobins.9.new
rm -f ../docs/man/man9/homecomp.9.new
Making halcompile manpage ilowpass.9
Making halcompile manpage integ.9
Making halcompile manpage invert.9
rm -f ../docs/man/man9/hypot.9.new
Making halcompile manpage joyhandle.9
rm -f ../docs/man/man9/ilowpass.9.new
rm -f ../docs/man/man9/integ.9.new
rm -f ../docs/man/man9/invert.9.new
Making halcompile manpage knob2float.9
Making halcompile manpage latencybins.9
Making halcompile manpage limit1.9
rm -f ../docs/man/man9/joyhandle.9.new
Making halcompile manpage limit2.9
rm -f ../docs/man/man9/knob2float.9.new
rm -f ../docs/man/man9/limit1.9.new
rm -f ../docs/man/man9/latencybins.9.new
Making halcompile manpage limit3.9
Making halcompile manpage limit_axis.9
Making halcompile manpage lincurve.9
rm -f ../docs/man/man9/limit2.9.new
Making halcompile manpage logic.9
rm -f ../docs/man/man9/limit3.9.new
rm -f ../docs/man/man9/lincurve.9.new
rm -f ../docs/man/man9/limit_axis.9.new
Making halcompile manpage lowpass.9
Making halcompile manpage lut5.9
Making halcompile manpage maj3.9
rm -f ../docs/man/man9/logic.9.new
Making halcompile manpage match8.9
rm -f ../docs/man/man9/lowpass.9.new
rm -f ../docs/man/man9/lut5.9.new
Making halcompile manpage max31855.9
rm -f ../docs/man/man9/maj3.9.new
Making halcompile manpage mesa_pktgyro_test.9
Making halcompile manpage message.9
rm -f ../docs/man/man9/match8.9.new
Making halcompile manpage millturn.9
rm -f ../docs/man/man9/mesa_pktgyro_test.9.new
rm -f ../docs/man/man9/max31855.9.new
Making halcompile manpage minmax.9
rm -f ../docs/man/man9/message.9.new
Making halcompile manpage moveoff.9
Making halcompile manpage mult2.9
rm -f ../docs/man/man9/millturn.9.new
Making halcompile manpage multiclick.9
rm -f ../docs/man/man9/minmax.9.new
Making halcompile manpage multiswitch.9
rm -f ../docs/man/man9/mult2.9.new
rm -f ../docs/man/man9/moveoff.9.new
Making halcompile manpage mux16.9
Making halcompile manpage mux2.9
rm -f ../docs/man/man9/multiclick.9.new
Making halcompile manpage mux4.9
rm -f ../docs/man/man9/multiswitch.9.new
rm -f ../docs/man/man9/mux2.9.new
rm -f ../docs/man/man9/mux16.9.new
Making halcompile manpage mux8.9
Making halcompile manpage near.9
Making halcompile manpage not.9
rm -f ../docs/man/man9/mux4.9.new
Making halcompile manpage offset.9
rm -f ../docs/man/man9/not.9.new
rm -f ../docs/man/man9/mux8.9.new
Making halcompile manpage ohmic.9
rm -f ../docs/man/man9/near.9.new
Making halcompile manpage oneshot.9
Making halcompile manpage or2.9
rm -f ../docs/man/man9/offset.9.new
Making halcompile manpage orient.9
rm -f ../docs/man/man9/ohmic.9.new
rm -f ../docs/man/man9/oneshot.9.new
rm -f ../docs/man/man9/or2.9.new
Making halcompile manpage plasmac.9
Making halcompile manpage radiobutton.9
Making halcompile manpage sample_hold.9
rm -f ../docs/man/man9/orient.9.new
Making halcompile manpage scale.9
rm -f ../docs/man/man9/radiobutton.9.new
Making halcompile manpage scaled_s32_sums.9
rm -f ../docs/man/man9/sample_hold.9.new
Making halcompile manpage select8.9
rm -f ../docs/man/man9/plasmac.9.new
Making halcompile manpage sim_axis_hardware.9
rm -f ../docs/man/man9/scale.9.new
Making halcompile manpage sim_home_switch.9
rm -f ../docs/man/man9/scaled_s32_sums.9.new
rm -f ../docs/man/man9/select8.9.new
Making halcompile manpage sim_matrix_kb.9
Making halcompile manpage sim_parport.9
rm -f ../docs/man/man9/sim_axis_hardware.9.new
rm -f ../docs/man/man9/sim_home_switch.9.new
Making halcompile manpage sim_spindle.9
Making halcompile manpage simple_tp.9
rm -f ../docs/man/man9/sim_matrix_kb.9.new
Making halcompile manpage sphereprobe.9
rm -f ../docs/man/man9/sim_parport.9.new
Making halcompile manpage spindle.9
rm -f ../docs/man/man9/sim_spindle.9.new
rm -f ../docs/man/man9/simple_tp.9.new
Making halcompile manpage spindle_monitor.9
Making halcompile manpage steptest.9
rm -f ../docs/man/man9/sphereprobe.9.new
Making halcompile manpage sum2.9
rm -f ../docs/man/man9/spindle.9.new
Making halcompile manpage thc.9
rm -f ../docs/man/man9/spindle_monitor.9.new
Making halcompile manpage thcud.9
rm -f ../docs/man/man9/steptest.9.new
rm -f ../docs/man/man9/sum2.9.new
Making halcompile manpage threadtest.9
Making halcompile manpage time.9
rm -f ../docs/man/man9/thc.9.new
Making halcompile manpage timedelay.9
rm -f ../docs/man/man9/thcud.9.new
Making halcompile manpage timedelta.9
rm -f ../docs/man/man9/threadtest.9.new
rm -f ../docs/man/man9/time.9.new
Making halcompile manpage tof.9
Making halcompile manpage toggle.9
rm -f ../docs/man/man9/timedelay.9.new
Making halcompile manpage toggle2nist.9
rm -f ../docs/man/man9/timedelta.9.new
rm -f ../docs/man/man9/tof.9.new
Making halcompile manpage ton.9
Making halcompile manpage tp.9
rm -f ../docs/man/man9/toggle.9.new
Making halcompile manpage tristate_bit.9
rm -f ../docs/man/man9/toggle2nist.9.new
Making halcompile manpage tristate_float.9
rm -f ../docs/man/man9/ton.9.new
rm -f ../docs/man/man9/tp.9.new
Making halcompile manpage updown.9
rm -f ../docs/man/man9/tristate_bit.9.new
Making halcompile manpage userkins.9
Making halcompile manpage wcomp.9
rm -f ../docs/man/man9/tristate_float.9.new
Making halcompile manpage xhc_hb04_util.9
rm -f ../docs/man/man9/updown.9.new
rm -f ../docs/man/man9/userkins.9.new
Making halcompile manpage xor2.9
Making halcompile manpage xyzab_tdr_kins.9
rm -f ../docs/man/man9/wcomp.9.new
Making halcompile manpage tpcomp.9
rm -f ../docs/man/man9/xhc_hb04_util.9.new
Making halcompile manpage serport.9
rm -f ../docs/man/man9/xor2.9.new
rm -f ../docs/man/man9/xyzab_tdr_kins.9.new
Making halcompile manpage mesa_7i65.9
rm -f ../docs/man/man9/tpcomp.9.new
Making halcompile manpage mesa_uart.9
Making halcompile manpage thermistor.1
Compiling objects/hal/user_comps/thermistor.c
Compiling hal/user_comps/wj200_vfd/wj200_vfd.c
Compiling hal/user_comps/pi500_vfd/pi500_vfd.c
Linking libpyplugin.so.0
c++ -std=gnu++17 -g -L/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -ltirpc  -lgpiod  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-soname,libpyplugin.so.0 -shared -o ../lib/libpyplugin.so.0 objects/emc/pythonplugin/python_plugin.o ../lib/liblinuxcncini.so -lstdc++ -lboost_python312 -L/usr/lib/x86_64-linux-gnu -lpython3.12 -ldl -lm
emc/Submakefile:Linking genserkins
ln -sf libtooldata.so.0 ../lib/libtooldata.so
Linking python module _hal.so
Linking ../rtlib/abs.so
Linking ../rtlib/abs_s32.so
Linking ../rtlib/and2.so
Linking ../rtlib/anglejog.so
Linking ../rtlib/axistest.so
Linking ../rtlib/bin2gray.so
Linking ../rtlib/biquad.so
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
Linking ../rtlib/constant.so
Linking ../rtlib/conv_bit_float.so
Linking ../rtlib/conv_bit_s32.so
Linking ../rtlib/conv_bit_u32.so
Linking ../rtlib/conv_float_s32.so
Linking ../rtlib/conv_float_u32.so
Linking ../rtlib/conv_s32_bit.so
Linking ../rtlib/conv_s32_float.so
Linking ../rtlib/conv_s32_u32.so
Linking ../rtlib/conv_u32_bit.so
Linking ../rtlib/conv_u32_float.so
Linking ../rtlib/conv_u32_s32.so
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
Linking ../rtlib/homecomp.so
Linking ../rtlib/hypot.so
Linking ../rtlib/ilowpass.so
Linking ../rtlib/integ.so
Linking ../rtlib/invert.so
Linking ../rtlib/joyhandle.so
Linking ../rtlib/knob2float.so
Linking ../rtlib/latencybins.so
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
Linking ../rtlib/max31855.so
Linking ../rtlib/mesa_pktgyro_test.so
Linking ../rtlib/message.so
Linking ../rtlib/millturn.so
Linking ../rtlib/minmax.so
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
Linking ../rtlib/plasmac.so
Linking ../rtlib/radiobutton.so
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
Linking ../rtlib/serport.so
Linking ../rtlib/mesa_7i65.so
Linking ../rtlib/mesa_uart.so
Creating shared library libnml.so.0
Linking thermistor
Linking wj200_vfd
Linking pi500_vfd
ln -sf libpyplugin.so.0 ../lib/libpyplugin.so
Linking librs274.so.0
c++ -std=gnu++17 -g -L/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -ltirpc  -lgpiod  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-soname,librs274.so.0 -shared -o ../lib/librs274.so.0 objects/emc/rs274ngc/interp_arc.o objects/emc/rs274ngc/interp_array.o objects/emc/rs274ngc/interp_base.o objects/emc/rs274ngc/interp_check.o objects/emc/rs274ngc/interp_convert.o objects/emc/rs274ngc/interp_queue.o objects/emc/rs274ngc/interp_cycles.o objects/emc/rs274ngc/interp_execute.o objects/emc/rs274ngc/interp_find.o objects/emc/rs274ngc/interp_internal.o objects/emc/rs274ngc/interp_inverse.o objects/emc/rs274ngc/interp_read.o objects/emc/rs274ngc/interp_write.o objects/emc/rs274ngc/interp_o_word.o objects/emc/rs274ngc/interp_g7x.o objects/emc/rs274ngc/modal_state.o objects/emc/rs274ngc/nurbs_additional_functions.o objects/emc/rs274ngc/interp_namedparams.o objects/emc/rs274ngc/interp_python.o objects/emc/rs274ngc/interp_remap.o objects/emc/rs274ngc/interp_setup.o objects/emc/rs274ngc/canonmodule.o objects/emc/rs274ngc/pyparamclass.o objects/emc/rs274ngc/pyemctypes.o objects/emc/rs274ngc/pyinterp1.o objects/emc/rs274ngc/pyblock.o objects/emc/rs274ngc/pyarrays.o objects/emc/rs274ngc/interpmodule.o objects/emc/rs274ngc/rs274ngc_pre.o objects/emc/rs274ngc/interp_inspection.o ../lib/liblinuxcncini.so ../lib/libpyplugin.so ../lib/liblinuxcnchal.so.0 ../lib/libtooldata.so.0 -lstdc++ -lboost_python312 -L/usr/lib/x86_64-linux-gnu -lpython3.12 -ldl -lm
ln -sf libnml.so.0 ../lib/libnml.so
Linking linuxcnc.so
Linking linuxcncrsh
Linking schedrmt
Linking linuxcnclcd
Linking halui
Linking linuxcncsvr
Linking io
Linking iov2
Linking motion-logger
Linking python module linuxcnc.so
ln -sf librs274.so.0 ../lib/librs274.so
Linking milltask
c++ -std=gnu++17 -o ../bin/milltask objects/emc/motion/emcmotglb.o objects/emc/task/emctask.o objects/emc/task/emccanon.o objects/emc/task/emctaskmain.o objects/emc/motion/usrmotintf.o objects/emc/motion/emcmotutil.o objects/emc/task/taskintf.o objects/emc/motion/dbuf.o objects/emc/motion/stashf.o objects/emc/task/taskmodule.o objects/emc/task/taskclass.o objects/emc/task/backtrace.o ../lib/librs274.so.0 ../lib/liblinuxcnc.a ../lib/libnml.so.0 ../lib/liblinuxcncini.so.0 ../lib/libposemath.so.0 ../lib/liblinuxcnchal.so.0 ../lib/libpyplugin.so.0 ../lib/libtooldata.so.0 -L/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -ltirpc  -lgpiod  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -lboost_python312 -L/usr/lib/x86_64-linux-gnu -lpython3.12 -ldl -lm
Linking rs274
Linking python module gcode.so
c++ -std=gnu++17 -L/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -Wl,-rpath,/home/runner/work/_temp/linuxcnc-curriculum-stable/lib -ltirpc  -lgpiod  -shared -o ../lib/python/gcode.so objects/emc/rs274ngc/gcodemodule.o ../lib/librs274.so.0 -lstdc++
Linking canterp.so
You now need to run 'sudo make setuid' in order to run in place with access to hardware.
make: Leaving directory '/home/runner/work/_temp/linuxcnc-curriculum-stable/src'

== Enter stable RIP environment ==
/home/runner/work/_temp/linuxcnc-curriculum-stable/scripts/linuxcnc
/home/runner/work/_temp/linuxcnc-curriculum-stable/bin/halcmd
/home/runner/work/_temp/linuxcnc-curriculum-stable/scripts/halrun
/home/runner/work/_temp/linuxcnc-curriculum-stable/bin/halcompile
/home/runner/work/_temp/linuxcnc-curriculum-stable/scripts/runtests
linuxcnc: Run LinuxCNC

Usage:
  $ linuxcnc -h
    This help

  $ linuxcnc [Options]
    Choose the configuration INI file graphically

  $ linuxcnc [Options] path/to/your_ini_file
    Name the configuration INI file using its path

  $ linuxcnc [Options] -l
    Use the previously used configuration INI file

Options:
    -d: Turn on "debug" mode
    -v: Turn on "verbose" mode
    -r: Disable redirection of stdout and stderr to ~/linuxcnc_print.txt and
        ~/linuxcnc_debug.txt when stdin is not a tty.
        Used when running linuxcnc tests non-interactively.
    -l: Use the last-used INI file
    -k: Continue in the presence of errors in HAL files
    -t "tpmodulename [parameters]"
            specify custom trajectory_planning_module
            overrides optional INI setting [TRAJ]TPMOD
    -m "homemodulename [parameters]"
            specify custom homing_module
            overrides optional INI setting [EMCMOT]HOMEMOD
    -H "dirname": search dirname for HAL files before searching
                  INI directory and system library:
                  /home/runner/work/_temp/linuxcnc-curriculum-stable/lib/hallib
Note:
    The -H "dirname" option may be specified multiple times

== Pre-test shared-memory state (observation only) ==

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status      


== Selected stable upstream test definition ==
tests/realtime-math/README:

This test verifies that all the realtime math functions declared in
rtapi_math.h are available at link-time.

This test should be kept in sync with src/rtapi/rtapi_math.h


tests/realtime-math/test.sh:
#!/bin/sh
set -xe
${SUDO} halcompile --install rtmath.comp
halrun dotest.hal

== Execute through stable upstream runtests harness ==
Runtest: 1 tests run, 1 successful, 0 failed + 0 expected, 0 skipped
runtests exit status: 0

== Preserved per-test result ==
Compiling realtime rtmath.c
Linking rtmath.so
cp rtmath.so /home/runner/work/_temp/linuxcnc-curriculum-stable/rtlib/

== Preserved per-test stderr ==
+ set -xe
+ halcompile --install rtmath.comp
+ halrun dotest.hal
Note: Using POSIX non-realtime
Note: Using POSIX non-realtime

== Post-test shared-memory state (observation only) ==

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status      


Stable v2.9.10 baseline completed successfully.
UTC finish: 2026-09-05T07:21:02Z
```

## Standard error
```text

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
Cloning into '/home/runner/work/_temp/linuxcnc-curriculum-stable'...
Updating files:   0% (1/9526)Updating files:   1% (96/9526)Updating files:   2% (191/9526)Updating files:   3% (286/9526)Updating files:   4% (382/9526)Updating files:   5% (477/9526)Updating files:   6% (572/9526)Updating files:   7% (667/9526)Updating files:   8% (763/9526)Updating files:   9% (858/9526)Updating files:  10% (953/9526)Updating files:  11% (1048/9526)Updating files:  12% (1144/9526)Updating files:  13% (1239/9526)Updating files:  14% (1334/9526)Updating files:  15% (1429/9526)Updating files:  16% (1525/9526)Updating files:  17% (1620/9526)Updating files:  18% (1715/9526)Updating files:  19% (1810/9526)Updating files:  20% (1906/9526)Updating files:  21% (2001/9526)Updating files:  22% (2096/9526)Updating files:  23% (2191/9526)Updating files:  23% (2193/9526)Updating files:  24% (2287/9526)Updating files:  25% (2382/9526)Updating files:  26% (2477/9526)Updating files:  27% (2573/9526)Updating files:  28% (2668/9526)Updating files:  29% (2763/9526)Updating files:  30% (2858/9526)Updating files:  31% (2954/9526)Updating files:  32% (3049/9526)Updating files:  33% (3144/9526)Updating files:  34% (3239/9526)Updating files:  35% (3335/9526)Updating files:  36% (3430/9526)Updating files:  37% (3525/9526)Updating files:  38% (3620/9526)Updating files:  39% (3716/9526)Updating files:  40% (3811/9526)Updating files:  41% (3906/9526)Updating files:  42% (4001/9526)Updating files:  43% (4097/9526)Updating files:  44% (4192/9526)Updating files:  45% (4287/9526)Updating files:  46% (4382/9526)Updating files:  47% (4478/9526)Updating files:  48% (4573/9526)Updating files:  49% (4668/9526)Updating files:  50% (4763/9526)Updating files:  51% (4859/9526)Updating files:  52% (4954/9526)Updating files:  53% (5049/9526)Updating files:  54% (5145/9526)Updating files:  55% (5240/9526)Updating files:  56% (5335/9526)Updating files:  57% (5430/9526)Updating files:  58% (5526/9526)Updating files:  59% (5621/9526)Updating files:  60% (5716/9526)Updating files:  61% (5811/9526)Updating files:  62% (5907/9526)Updating files:  63% (6002/9526)Updating files:  64% (6097/9526)Updating files:  65% (6192/9526)Updating files:  66% (6288/9526)Updating files:  67% (6383/9526)Updating files:  68% (6478/9526)Updating files:  69% (6573/9526)Updating files:  70% (6669/9526)Updating files:  71% (6764/9526)Updating files:  72% (6859/9526)Updating files:  73% (6954/9526)Updating files:  74% (7050/9526)Updating files:  75% (7145/9526)Updating files:  76% (7240/9526)Updating files:  77% (7336/9526)Updating files:  78% (7431/9526)Updating files:  79% (7526/9526)Updating files:  80% (7621/9526)Updating files:  81% (7717/9526)Updating files:  82% (7812/9526)Updating files:  83% (7907/9526)Updating files:  84% (8002/9526)Updating files:  85% (8098/9526)Updating files:  86% (8193/9526)Updating files:  87% (8288/9526)Updating files:  88% (8383/9526)Updating files:  89% (8479/9526)Updating files:  90% (8574/9526)Updating files:  91% (8669/9526)Updating files:  92% (8764/9526)Updating files:  93% (8860/9526)Updating files:  94% (8955/9526)Updating files:  95% (9050/9526)Updating files:  96% (9145/9526)Updating files:  97% (9241/9526)Updating files:  98% (9336/9526)Updating files:  99% (9431/9526)Updating files: 100% (9526/9526)Updating files: 100% (9526/9526), done.
HEAD is now at 86cdca76f 2.9.10 Release

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
Reading 0/205 dependency files
Done reading dependencies
Reading 0/123 realtime dependency files
Done reading realtime dependencies
Reading 0/205 dependency files
Done reading dependencies
Reading 0/246 realtime dependency files
Done reading realtime dependencies
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/emccalib.1.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/emccalib.1.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/halstreamer.1.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/halstreamer.1.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/hy_gt_vfd.1.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/mesambccc.1.adoc
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/hy_gt_vfd.1.xml
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mesambccc.1.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/mqtt-publisher.1.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/mqtt-publisher.1.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/sendkeys.1.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/sendkeys.1.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/svd-ps_vfd.1.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/svd-ps_vfd.1.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man1/xhc-whb04b-6.1.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man1/xhc-whb04b-6.1.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man3/hm2_pktuart.3.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man3/hm2_pktuart.3.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man9/enum.9.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/enum.9.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man9/hm2_modbus.9.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_modbus.9.xml
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /etc/asciidoc/asciidoc.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man9/streamer.9.adoc
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
asciidoc: reading: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/src/man/man9/hm2_spix.9.adoc
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: reading: /etc/asciidoc/docbook45.conf
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/streamer.9.xml
asciidoc: reading: /etc/asciidoc/filters/source/source-highlight-filter.conf
asciidoc: reading: /etc/asciidoc/filters/code/code-filter.conf
asciidoc: reading: /etc/asciidoc/filters/latex/latex-filter.conf
asciidoc: reading: /etc/asciidoc/filters/music/music-filter.conf
asciidoc: reading: /etc/asciidoc/filters/graphviz/graphviz-filter.conf
asciidoc: reading: /etc/asciidoc/lang-en.conf
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
<unknown>:1: SyntaxWarning: invalid escape sequence '\S'
asciidoc: writing: /home/runner/work/_temp/linuxcnc-curriculum-stable/docs/man/man9/hm2_spix.9.xml
emc/rs274ngc/interp_remap.cc: In member function ‘int Interp::add_parameters(setup_pointer, block_pointer, char*)’:
emc/rs274ngc/interp_remap.cc:297:16: warning: ‘char* __builtin___strncat_chk(char*, const char*, long unsigned int, long unsigned int)’ output truncated before terminating nul copying 1 byte from a string of the same length [-Wstringop-truncation]
  297 |         strncat(tail,&c,1);
      |                ^
/home/runner/work/_temp/linuxcnc-curriculum-stable/scripts/linuxcnc: illegal option -- -
Running test: tests/realtime-math
```
