LIBNAME                     ?= u8_compat
TESTAPP                     ?= test_$(LIBNAME)

MKDIR_P                     ?= mkdir -p
RM_RF                       ?= rm -rf
FIND                        ?= find

SRC_DIR                     ?= 
INCLUDE_DIR                 ?= include
OUT_DIR                     ?= _out
TEST_DIR                    ?= tests
MAKEFILES_DIR               ?= build/makefiles
CATCH_DIR                   ?= external/catch2

DEBUG                       ?= 0
ARCH_NAME                   ?= x86_64-linux-gnu
STDC                        ?= -std=c99
STDCXX                      ?= -std=c++17

TARGET_SRC_DIRS             ?= $(SRC_DIR) $(TEST_DIR)
TARGET_SRC_DIRS_EXCLUDE     ?= $(CATCH_DIR)
TARGET_INC_DIRS             ?= $(INCLUDE_DIR) $(CATCH_DIR)/single_include $(TARGET_SRC_DIRS)

ifeq ($(DEBUG),1)
  TARGET_DIR                = $(OUT_DIR)/$(ARCH_NAME)-debug
else
  TARGET_DIR                = $(OUT_DIR)/$(ARCH_NAME)
endif

WARN_FLAGS                  ?= -Wall -Wextra -Werror
WARN_CFLAGS                 ?= $(WARN_FLAGS)
WARN_CXXFLAGS               ?= $(WARN_FLAGS) -Wno-noexcept-type

DEBUGFLAGS                  ?= -g
RELEASEFLAGS                ?= -O2 -DNDEBUG
ifeq ($(DEBUG),1)
  DRFLAGS                   = $(DEBUGFLAGS)
else
  DRFLAGS                   = $(RELEASEFLAGS)
endif

CPPFLAGS                    = -MMD -MP
CFLAGS                      = $(DRFLAGS) $(WARN_CFLAGS) $(STDC)
CXXFLAGS                    = $(DRFLAGS) $(WARN_CXXFLAGS) $(STDCXX)
INCFLAGS                    = $(addprefix -I,$(TARGET_INC_DIRS))

FIND_EXPR_BASE              = \( -name \*.cpp -or -name \*.c \) -and -print
FIND_EXPR_SUB1              = $(and $(TARGET_SRC_DIRS_EXCLUDE),$(patsubst %,-path % -or,$(TARGET_SRC_DIRS_EXCLUDE)))
FIND_EXPR_SUB2              = $(and $(FIND_EXPR_SUB1),\( -type d -and \( $(FIND_EXPR_SUB1) ! -type d \) -and -prune \) -or )
FIND_EXPR                   = $(FIND_EXPR_SUB2) $(FIND_EXPR_BASE)

SRCS                        = $(shell $(FIND) $(TARGET_SRC_DIRS) $(FIND_EXPR))
OBJS                        = $(SRCS:%=$(TARGET_DIR)/%.o)
DEPS                        = $(OBJS:.o=.d)

-include $(MAKEFILES_DIR)/$(ARCH_NAME).mk

-include $(DEPS)


.DEFAULT_GOAL := all

.PHONY: all
all: runtest

.PHONY: test
test: $(TARGET_DIR)/$(TESTAPP)

.PHONY: runtest
runtest: test
	$(TARGET_DIR)/$(TESTAPP)

.PHONY: clean
clean:
	$(RM_RF) $(OUT_DIR)

# C Sources
$(TARGET_DIR)/%.c.o: %.c
	@$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INCFLAGS) -c $< -o $@
 
# C++ Sources
$(TARGET_DIR)/%.cpp.o: %.cpp
	@$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCFLAGS) -c $< -o $@

# Test application
$(TARGET_DIR)/$(TESTAPP): $(OBJS)
	@$(MKDIR_P) $(dir $@)
	$(CXX) -o $@ $(OBJS)
