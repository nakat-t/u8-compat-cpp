CC        = mingw32-gcc
CXX       = mingw32-g++
AR        = mingw32-gcc-ar

BUSYBOX   = busybox64.exe

MKDIR_P   = $(BUSYBOX) mkdir -p
RM_RF     = $(BUSYBOX) rm -rf
FIND      = $(BUSYBOX) find

CFLAGS    += -m32
CXXFLAGS  += -m32
