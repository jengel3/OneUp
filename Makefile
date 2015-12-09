ARCHS = armv7 arm64
TARGET = iphone:clang:latest:8.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
THEOS_PACKAGE_DIR_NAME = debs
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = OneUp
OneUp_FILES = Tweak.xm
OneUp_LDFLAGS += -Wl,-segalign,4000
OneUp_FRAMEWORKS = UIKit Foundation CoreGraphics
OneUp_PRIVATE_FRAMEWORKS = BulletinBoard AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
include theos/makefiles/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += oneupprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
