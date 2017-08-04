export THEOS_DEVICE_IP=192.168.178.38
export THEOS_DEVICE_PORT=22

#export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.internal.$(shell date +%y%m%d)-$(shell date +%H%M)"
export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.rs-internal.$(shell date +%y%m%d)"

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Redstone
Redstone_CFLAGS = -fobjc-arc
Redstone_FILES = Redstone_Core.xm

# Core
Redstone_FILES += Core/RSCore.m Core/RSPreferences.m Core/RSMetrics.m

# Home Screen
Redstone_FILES += HomeScreen/RSHomeScreenController.m HomeScreen/RSHomeScreenScrollView.m

# Start Screen
Redstone_FILES += StartScreen/RSStartScreenController.m

# App List
Redstone_FILES += AppList/RSAppListController.m

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

after-package::
	@cd $(PROJECT_DIR)
	@rm -rf $(PROJECT_DIR)/Packages $(PROJECT_DIR)/Packages.bz2
	@dpkg-scanpackages -m . /dev/null > $(PROJECT_DIR)/Packages
	@bzip2 $(PROJECT_DIR)/Packages
