BUNDLE_NAME = LiddellPreferences
LiddellPreferences_FILES = $(wildcard *.m)
LiddellPreferences_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
LiddellPreferences_INSTALL_PATH = /Library/PreferenceBundles
LiddellPreferences_FRAMEWORKS = UIKit
LiddellPreferences_PRIVATE_FRAMEWORKS = Preferences
LiddellPreferences_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
LiddellPreferences_LIBRARIES = gcuniversal

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LiddellPreferences.plist$(ECHO_END)
