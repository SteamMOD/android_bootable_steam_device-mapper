LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_CFLAGS := -Os

LOCAL_SRC_FILES :=	dmsetup.c \
	lvm.c \
	lvm2cmd-static.c \
	lvm2cmd.c \
	lvmcmdlib.c

LOCAL_MODULE := libsteam_dmsetup
LOCAL_MODULE_TAGS := eng

LOCAL_C_INCLUDES := bootable/steam/device-mapper/tools \
										bootable/steam/device-mapper/libdm \
										bootable/steam/device-mapper/libdm/misc \
										bootable/steam/device-mapper/libdm/ioctl \
										bootable/steam/device-mapper/include

LOCAL_CFLAGS := -Os -g -W -Wall \
	-DHAVE_UNISTD_H \
	-DHAVE_ERRNO_H \
	-DHAVE_NETINET_IN_H \
	-DHAVE_SYS_IOCTL_H \
	-DHAVE_SYS_MMAN_H \
	-DHAVE_SYS_MOUNT_H \
	-DHAVE_SYS_PRCTL_H \
	-DHAVE_SYS_RESOURCE_H \
	-DHAVE_SYS_SELECT_H \
	-DHAVE_SYS_STAT_H \
	-DHAVE_SYS_TYPES_H \
	-DHAVE_STDLIB_H \
	-DHAVE_STRDUP \
	-DHAVE_MMAP \
	-DHAVE_UTIME_H \
	-DHAVE_GETPAGESIZE \
	-DHAVE_LSEEK64 \
	-DHAVE_LSEEK64_PROTOTYPE \
	-DHAVE_EXT2_IOCTLS \
	-DHAVE_LINUX_FD_H \
	-DHAVE_TYPE_SSIZE_T \
	-DDM_IOCTLS \
	-DDM_DEVICE_MODE=0600 -DDM_DEVICE_UID=0 -DDM_DEVICE_GID=0 \
	-Dmain=steam_dmsetup_main

include $(BUILD_STATIC_LIBRARY)

