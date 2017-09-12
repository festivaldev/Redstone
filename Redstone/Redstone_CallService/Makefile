include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Redstone_CallService
Redstone_CallService_FILES = Tweak.xm
Redstone_CallService_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
