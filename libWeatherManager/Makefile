export SYSROOT=$(THEOS)/sdks/iPhoneOS10.1.sdk
export TARGET=iphone:latest
export THEOS_DEVICE_IP=192.168.178.38
export PACKAGE_VERSION=0.0.1

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libWeatherManager
libWeatherManager_FILES = RSWeatherInfoManager.m RSWeatherCity.m
libWeatherManager_FRAMEWORKS = CoreLocation
libWeatherManager_PRIVATE_FRAMEWORKS = Weather
libWeatherManager_INSTALL_PATH = /usr/lib/

TOOL_NAME = weathermanagerd
weathermanagerd_FILES = main.mm RSWeatherInfoService.m RSWeatherInfoUpdater.m RSWeatherInfoWorker.m RSWeatherCity.m
weathermanagerd_FRAMEWORKS = CoreLocation QuartzCore IOKit
weathermanagerd_PRIVATE_FRAMEWORKS = Weather
weathermanagerd_CODESIGN_FLAGS = -S./entitlements.xml
weathermanagerd_INSTALL_PATH = /usr/libexec/

ADDITIONAL_CFLAGS = -I./headers -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/tool.mk

internal-library-compile:
	cp ./.theos/obj/debug/libWeatherManager.dylib $(THEOS_LIBRARY_PATH)
