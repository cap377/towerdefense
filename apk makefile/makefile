##
## This section has common project settings you may need to change.
##

ifeq ($(OS),Windows_NT)
   FLEX_SDK=c:/Flex
   ANDROID_SDK=c:/android-sdk
else
   FLEX_SDK=C:/Flex
   ANDROID_SDK=/opt/android-sdk
endif



APP=td
APP_XML=$(APP).xml
ADL=$(FLEX_SDK)/bin/adl
AMXMLC=$(FLEX_SDK)/bin/amxmlc
SOURCES=src/Startup.hx src/Root.hx

##
## It's less common that you would need to change anything after this line.
##

SIGN_CERT=sign.pfx

SIGN_PWD=abc123

SWF_VERSION=11.8

ADL=$(FLEX_SDK)/bin/adl

ADT=$(FLEX_SDK)/bin/adt.bat

AMXMLC=$(FLEX_SDK)/bin/amxmlc

##
## Build rules
##

all: $(APP).swf 

apk: $(APP).apk

clean:
	rm -rf $(APP).swf $(APP).apk

test: $(APP).swf
	$(ADL) -profile tv -screensize 640x360:640x360 $(APP_XML)

testHi: $(APP).swf
	$(ADL) -profile tv -screensize 1280x720:1280x720 $(APP_XML)

sign.pfx:
	$(ADT) -certificate -validityPeriod 25 -cn SelfSigned 1024-RSA $(SIGN_CERT) $(SIGN_PWD)

install: $(APP).apk
	$(ADT) -installApp -platform android -platformsdk $(ANDROID_SDK) -package $(APP).apk



all: $(APP).swf
$(APP).swf: $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 \
	-swf-header 640:640:60:0 \
	-main Startup \
	-swf $(APP).swf \
	-swf-lib vendor/starling.swc --macro "patchTypes('vendor/starling.patch')"

$(APP).apk: $(APP).swf sign.pfx
	$(ADT) -package -target apk-captive-runtime -storetype pkcs12 -keystore $(SIGN_CERT) $(APP).apk $(APP_XML) $(APP).swf assets game_icon.png
