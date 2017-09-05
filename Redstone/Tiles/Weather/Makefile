include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Weather
Weather_BUNDLE_NAME = com.apple.weather
Weather_BUNDLE_EXTENSION = tile
Weather_CFLAGS =  -fobjc-arc -I../../headers -I ../../
Weather_FILES =  $(wildcard *.m)
Weather_INSTALL_PATH = /var/mobile/Library/FESTIVAL/Redstone/Live Tiles/

include $(THEOS_MAKE_PATH)/bundle.mk
