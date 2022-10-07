NULL_NAME := libswift
INSTALL_PATH := /usr/lib/libswift/stable
OBJ_PATH = $(THEOS_OBJ_DIR)
TMP_PATH = $(PWD)/.tmp

XCODE ?= $(shell xcode-select -p)
XCODE_USR = $(XCODE)/Toolchains/XcodeDefault.xctoolchain/usr

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

all::
	$(ECHO_NOTHING)rm -rf $(OBJ_PATH)$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(OBJ_PATH) $(TMP_PATH)$(ECHO_END)
	$(ECHO_NOTHING)rsync -a "$(XCODE_USR)"/lib/swift/iphoneos/libswift*.a $(TMP_PATH)$(ECHO_END)
	$(ECHO_NOTHING)for i in $(TMP_PATH)/*.a; do clang -fpic -shared -Wl,-all_load "$i" -o "$(basename $i .a)".dylib; done$(ECHO_END)
	$(ECHO_NOTHING)find $(TMP_PATH) -type f -name "*.dylib" -exec ldid -S {} \; -exec mv {} $(OBJ_PATH) \;$(ECHO_END)
	$(ECHO_NOTHING)rm -rf $(TMP_PATH)$(ECHO_END)

stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/$(INSTALL_PATH)$(ECHO_END)
	$(ECHO_NOTHING)rsync -ra $(OBJ_PATH)/ $(THEOS_STAGING_DIR)/$(INSTALL_PATH) $(_THEOS_RSYNC_EXCLUDE_COMMANDLINE)$(ECHO_END)
	$(ECHO_NOTHING)cp NOTICE.txt $(THEOS_STAGING_DIR)/$(INSTALL_PATH)$(ECHO_END)
