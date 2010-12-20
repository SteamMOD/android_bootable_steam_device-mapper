#
# Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
# Copyright (C) 2004-2010 Red Hat, Inc. All rights reserved.
#
# This file is part of LVM2.
#
# This copyrighted material is made available to anyone wishing to use,
# modify, copy, or redistribute it subject to the terms and conditions
# of the GNU General Public License v.2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

srcdir = .
top_srcdir = .
top_builddir = .

SUBDIRS = doc include man scripts

ifeq ("no", "yes")
  SUBDIRS += udev
endif

ifeq ("no", "yes")
  SUBDIRS += po
endif

SUBDIRS += lib tools daemons libdm

ifeq ("no", "yes")
  SUBDIRS += liblvm
endif

ifeq ($(MAKECMDGOALS),distclean)
  SUBDIRS = doc include man scripts \
    lib tools daemons libdm \
    udev po liblvm test/api test
endif
DISTCLEAN_DIRS += lcov_reports*
DISTCLEAN_TARGETS += config.cache config.log config.status make.tmpl

include make.tmpl

libdm: include
lib: libdm
liblvm: lib
daemons: lib tools
tools: lib device-mapper
po: tools daemons

lib.device-mapper: include.device-mapper
libdm.device-mapper: include.device-mapper
liblvm.device-mapper: include.device-mapper
daemons.device-mapper: libdm.device-mapper
tools.device-mapper: libdm.device-mapper
device-mapper: tools.device-mapper daemons.device-mapper man.device-mapper

ifeq ("no", "yes")
lib.pofile: include.pofile
tools.pofile: lib.pofile
daemons.pofile: lib.pofile
po.pofile: tools.pofile daemons.pofile
pofile: po.pofile
endif

ifneq ("$(CFLOW_CMD)", "")
tools.cflow: libdm.cflow lib.cflow
daemons.cflow: tools.cflow
cflow: include.cflow
endif

ifneq ("", "")
cscope.out:
	 -b -R -s$(top_srcdir)
all: cscope.out
endif
DISTCLEAN_TARGETS += cscope.out

check check_cluster check_local: all
	$(MAKE) -C test $(@)

install_system_dirs:
	$(INSTALL_ROOT_DIR) $(DESTDIR)$(DEFAULT_SYS_DIR)
	$(INSTALL_ROOT_DIR) $(DESTDIR)$(DEFAULT_ARCHIVE_DIR)
	$(INSTALL_ROOT_DIR) $(DESTDIR)$(DEFAULT_BACKUP_DIR)
	$(INSTALL_ROOT_DIR) $(DESTDIR)$(DEFAULT_CACHE_DIR)
	$(INSTALL_ROOT_DIR) $(DESTDIR)$(DEFAULT_LOCK_DIR)
	$(INSTALL_ROOT_DIR) $(DESTDIR)$(DEFAULT_RUN_DIR)
	$(INSTALL_ROOT_DATA) /dev/null $(DESTDIR)$(DEFAULT_CACHE_DIR)/.cache

install_initscripts: 
	$(MAKE) -C scripts install_initscripts

LCOV_TRACES = libdm.info lib.info tools.info \
	daemons/dmeventd.info daemons/clvmd.info
CLEAN_TARGETS += $(LCOV_TRACES)

ifneq ("$(LCOV)", "")
.PHONY: lcov-reset lcov lcov-dated $(LCOV_TRACES)

ifeq ($(MAKECMDGOALS),lcov-dated)
LCOV_REPORTS_DIR := lcov_reports-$(shell date +%Y%m%d%k%M%S)
lcov-dated: lcov
else
LCOV_REPORTS_DIR := lcov_reports
endif

lcov-reset:
	$(LCOV) --zerocounters $(addprefix -d , $(basename $(LCOV_TRACES)))

# maybe use subdirs processing to create tracefiles...
$(LCOV_TRACES):
	$(LCOV) -b $(top_srcdir)/$(basename $@) \
		-d $(basename $@) -c -o - | $(SED) \
		-e "s/\(dmeventd_lvm.[ch]\)/plugins\/lvm2\/\1/" \
		-e "s/\(dmeventd_mirror.c\)/plugins\/mirror\/\1/" \
		-e "s/\(dmeventd_snapshot.c\)/plugins\/snapshot\/\1/" \
		>$@

ifneq ("$(GENHTML)", "")
lcov: $(LCOV_TRACES)
	$(RM) -r $(LCOV_REPORTS_DIR)
	$(MKDIR_P) $(LCOV_REPORTS_DIR)
	for i in $(LCOV_TRACES); do \
		test -s $$i && lc="$$lc $$i"; \
	done; \
	test -z "$$lc" || $(GENHTML) -p /home/kernel/Android/bootable/steam/device-mapper \
		-o $(LCOV_REPORTS_DIR) $$lc
endif

endif

ifeq ("$(TESTING)", "yes")
# testing and report generation
RUBY=ruby1.9 -Ireport-generators/lib -Ireport-generators/test

.PHONEY: unit-test ruby-test test-programs

# FIXME: put dependencies on libdm and liblvm
test-programs:
	cd unit-tests/regex && $(MAKE)
	cd unit-tests/datastruct && $(MAKE)
	cd unit-tests/mm && $(MAKE)

unit-test: test-programs
	$(RUBY) report-generators/unit_test.rb $(shell find . -name TESTS)
	$(RUBY) report-generators/title_page.rb

memcheck: test-programs
	$(RUBY) report-generators/memcheck.rb $(shell find . -name TESTS)
	$(RUBY) report-generators/title_page.rb

ruby-test:
	$(RUBY) report-generators/test/ts.rb
endif
