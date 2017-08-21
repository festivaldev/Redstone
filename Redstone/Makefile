export THEOS_DEVICE_IP=192.168.178.38
export THEOS_DEVICE_PORT=22

#export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.internal.$(shell date +%y%m%d)-$(shell date +%H%M)"
export PACKAGE_VERSION="$(shell date +%y)w$(shell date +%W)a.rs-internal.$(shell date +%y%m%d)"

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Redstone
Redstone_CFLAGS = -fobjc-arc -I./headers -I ./
Redstone_PRIVATE_FRAMEWORKS = AppSupport
Redstone_FRAMEWORKS = MediaPlayer
Redstone_LIBRARIES = objcipc
Redstone_FILES = $(wildcard *.xm) $(wildcard Libraries/*.c) $(wildcard Libraries/*.m) $(wildcard Core/*.m) $(wildcard UI/*.m) $(wildcard HomeScreen/*.m) $(wildcard StartScreen/*.m) $(wildcard AppList/*.m) $(wildcard LaunchScreen/*.m) $(wildcard VolumeControls/*.m)

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

after-package::
	@rm -rf $(PROJECT_DIR)/Packages $(PROJECT_DIR)/Packages.bz2
	@cd $(PROJECT_DIR) && dpkg-scanpackages -m . /dev/null > $(PROJECT_DIR)/Packages
	@bzip2 -k $(PROJECT_DIR)/Packages

SUBPROJECTS += Redstone_UIKit
include $(THEOS_MAKE_PATH)/aggregate.mk
