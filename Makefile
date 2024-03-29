CP_PATH=$(abspath ../..)/CrossCompiler
CROSS_COMPILE=$(CP_PATH)/gcc-linaro-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
ROOTFS=$(CP_PATH)/sysroots/cortexa15t2hf-vfp-neon-linux-gnueabi

ARCH=arm
CC=$(CROSS_COMPILE)gcc
CXX=$(CROSS_COMPILE)g++

INC += -I protocol
INC += -I$(ROOTFS)/include
INC += -I$(ROOTFS)/usr/include
INC += -I$(ROOTFS)/usr/include/omap
INC += -I$(ROOTFS)/usr/include/libdrm
INC += -I$(ROOTFS)/usr/include/gbm
LIBDIR := $(ROOTFS)/usr/lib


CFLAGS := -O1 -g -Wall -fPIC -mfloat-abi=hard -mfpu=neon -Wl,-rpath,$(ROOTFS)/lib -Wl,-rpath,$(ROOTFS)/usr/lib $(INC)
CXXFLAGS = -Wall -ansi -g -fPIC -mfloat-abi=hard -mfpu=neon $(INC) -I$(ROOTFS)/include/c++/4.7.3/

LDFLAGS = -lm -lpthread -L$(LIBDIR) -lrt -ldrm -lmtdev -ldrm_omap -lstdc++ -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_objdetect
TARGET = laneTrace

all: $(TARGET)

clean:
	rm -f *.a *.o $(TARGET) *.lo

$(TARGET): main.c v4l2.lo display-kms.lo util.lo vpe-common.lo input_cmd.lo drawing.lo exam_cv.lo car_lib.lo laneDetection.lo stop_when_accident.lo koo_driving.lo passing_master.lo
	$(CC) $(CFLAGS) -o $@ main.c v4l2.lo display-kms.lo util.lo vpe-common.lo input_cmd.lo drawing.lo exam_cv.lo car_lib.lo laneDetection.lo stop_when_accident.lo koo_driving.lo passing_master.lo$(LDFLAGS)

v4l2.lo: v4l2.c v4l2.h
	$(CC) -c $(CFLAGS) -o $@ v4l2.c

display-kms.lo: display-kms.c display-kms.h
	$(CC) -c $(CFLAGS) -o $@ display-kms.c

util.lo: util.c util.h
	$(CC) -c $(CFLAGS) -o $@ util.c

vpe-common.lo: vpe-common.c vpe-common.h
	$(CC) -c $(CFLAGS) -o $@ vpe-common.c

drawing.lo: drawing.c drawing.h font_8x8.h
	$(CC) -c $(CFLAGS) -o $@ drawing.c

input_cmd.lo: input_cmd.cpp input_cmd.h
	$(CXX) -c $(CXXFLAGS) -o $@ input_cmd.cpp

exam_cv.lo: exam_cv.cpp exam_cv.h stop_when_accident.h
	$(CXX) -c $(CXXFLAGS) -o $@ exam_cv.cpp -Lmydir

car_lib.lo: car_lib.c car_lib.h
	$(CC) -c $(CFLAGS) -o $@ car_lib.c

laneDetection.lo: laneDetection.cpp laneDetection.h
	$(CXX) -c $(CXXFLAGS) -o $@ laneDetection.cpp

stop_when_accident.lo: stop_when_accident.h
	$(CXX) -c $(CXXFLAGS) -o $@ stop_when_accident.cpp -Lmydir

koo_driving.lo: koo_driving.c koo_driving.h
	$(CC) -c $(CFLAGS) -o $@ koo_driving.c

passing_master.lo: passing_master.cpp passing_master.h
	$(CXX) -c $(CXXFLAGS) -o $@ passing_master.cpp

#edit

