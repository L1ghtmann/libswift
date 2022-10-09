NULL_NAME := libswift
INSTALL_PATH := /usr/lib/libswift/stable
OBJ_PATH = $(THEOS_OBJ_DIR)

XCODE ?= $(shell xcode-select -p)
# XCODE ?= /Applications/Xcode_13.0.app/Contents/Developer
XCODE_USR = $(XCODE)/Toolchains/XcodeDefault.xctoolchain/usr

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

all::
	$(ECHO_NOTHING)rm -rf $(OBJ_PATH)$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(OBJ_PATH)$(ECHO_END)
	$(ECHO_NOTHING)rsync -rav "$(XCODE_USR)"/lib/swift-5.0/iphoneos/libswift*.dylib $(OBJ_PATH)$(ECHO_END)
	$(ECHO_NOTHING)ldid -S $(OBJ_PATH)/*$(ECHO_END)

stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/$(INSTALL_PATH)$(ECHO_END)
	$(ECHO_NOTHING)rsync -ra $(OBJ_PATH)/ $(THEOS_STAGING_DIR)/$(INSTALL_PATH) $(_THEOS_RSYNC_EXCLUDE_COMMANDLINE)$(ECHO_END)
	$(ECHO_NOTHING)cp NOTICE.txt $(THEOS_STAGING_DIR)/$(INSTALL_PATH)$(ECHO_END)
