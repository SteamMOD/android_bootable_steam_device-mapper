#
# Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
# Copyright (C) 2004-2005, 2008-2010 Red Hat, Inc. All rights reserved.
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
top_srcdir = ../../../..
top_builddir = ../../../..

INCLUDES += -I$(top_srcdir)/tools -I$(top_srcdir)/daemons/dmeventd/plugins/lvm2
CLDFLAGS += -L$(top_builddir)/tools -L$(top_builddir)/daemons/dmeventd/plugins/lvm2

SOURCES = dmeventd_mirror.c

LIB_NAME = libdevmapper-event-lvm2mirror
LIB_SHARED = $(LIB_NAME).$(LIB_SUFFIX)
LIB_VERSION = $(LIB_VERSION_LVM)

CFLOW_LIST = $(SOURCES)
CFLOW_LIST_TARGET = $(LIB_NAME).cflow

include $(top_builddir)/make.tmpl

LIBS += -ldevmapper-event-lvm2 -ldevmapper

install_lvm2: install_dm_plugin

install: install_lvm2

DISTCLEAN_TARGETS += .exported_symbols_generated
