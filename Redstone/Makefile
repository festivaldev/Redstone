export THEOS_DEVICE_IP=192.168.178.38
export THEOS_DEVICE_PORT=22

#export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.internal.$(shell date +%y%m%d)-$(shell date +%H%M)"
export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.rs-internal.$(shell date +%y%m%d)"

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Redstone
Redstone_CFLAGS = -fobjc-arc -I./headers -I ./
Redstone_PRIVATE_FRAMEWORKS = AppSupport
Redstone_FILES = Redstone_Core.xm Redstone_HomeScreen.xm

# Libraries
Redstone_FILES += Libraries/CAKeyframeAnimation+AHEasing.m Libraries/easing.c Libraries/UIFont+WDCustomLoader.m Libraries/UIImageAverageColorAddition.m Libraries/UIView+Easing.m

# Core
Redstone_FILES += Core/RSCore.m Core/RSPreferences.m Core/RSMetrics.m Core/RSAesthetics.m Core/RSAnimation.m

# Home Screen
Redstone_FILES += HomeScreen/RSHomeScreenController.m HomeScreen/RSHomeScreenScrollView.m HomeScreen/RSHomeScreenWallpaperView.m

# Start Screen
Redstone_FILES += StartScreen/RSStartScreenController.m StartScreen/RSStartScreenScrollView.m StartScreen/RSTile.m StartScreen/RSTileButton.m StartScreen/RSTileInfo.m

# App List
Redstone_FILES += AppList/RSAppListController.m

# Launch Screen
Redstone_FILES += LaunchScreen/RSLaunchScreenController.m

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

after-package::
	@rm -rf $(PROJECT_DIR)/Packages $(PROJECT_DIR)/Packages.bz2
	@cd $(PROJECT_DIR) && dpkg-scanpackages -m . /dev/null > $(PROJECT_DIR)/Packages
	@bzip2 -k $(PROJECT_DIR)/Packages
