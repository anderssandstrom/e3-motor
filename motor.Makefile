#
#  Copyright (c) 2019            Jeong Han Lee
#  Copyright (c) 2017 - 2019     European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Author  : Jeong Han Lee
# email   : han.lee@esss.se
# Date    : Monday, April  1 15:00:44 CEST 2019
# version : 0.0.5

# LEGACY_RSET should be defined before driver.makefile
# require-ess from 3.0.1

#USR_CPPFLAGS += -DUSE_TYPED_RSET


LEGACY_RSET = YES


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS


ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif


APP:=motorApp
APPDB:=$(APP)/Db


TEMPLATES += $(wildcard $(APPDB)/*.db)
TEMPLATES += $(wildcard $(APPDB)/*.template)
TEMPLATES += $(wildcard $(APPDB)/*.req)


MOTOR_SRC:=$(APP)/MotorSrc
SOFTMOTOR_SRC:=$(APP)/SoftMotorSrc


USR_INCLUDES += -I$(where_am_I)$(MOTOR_SRC)
USR_INCLUDES += -I$(where_am_I)$(SOFTMOTOR_SRC)
USR_INCLUDES += -I$(where_am_I)$(MOTORSIM_SRC)


USR_CFLAGS   += -Wno-unused-variable
USR_CFLAGS   += -Wno-unused-function
USR_CFLAGS   += -Wno-unused-but-set-variable
USR_CPPFLAGS += -Wno-unused-variable
USR_CPPFLAGS += -Wno-unused-function
USR_CPPFLAGS += -Wno-unused-but-set-variable



## MOTOR_SRC
DBDINC_SRCS = $(MOTOR_SRC)/motorRecord.cc
DBDINC_DBDS = $(subst .cc,.dbd,   $(DBDINC_SRCS:$(MOTOR_SRC)/%=%))
DBDINC_HDRS = $(subst .cc,.h,     $(DBDINC_SRCS:$(MOTOR_SRC)/%=%))
DBDINC_DEPS = $(subst .cc,$(DEP), $(DBDINC_SRCS:$(MOTOR_SRC)/%=%))


HEADERS += $(MOTOR_SRC)/motor.h
HEADERS += $(MOTOR_SRC)/motordevCom.h
HEADERS += $(MOTOR_SRC)/motordrvCom.h
HEADERS += $(MOTOR_SRC)/motordrvComCode.h
# ASYN
HEADERS += $(MOTOR_SRC)/motor_interface.h
HEADERS += $(MOTOR_SRC)/paramLib.h
HEADERS += $(MOTOR_SRC)/asynMotorController.h
HEADERS += $(MOTOR_SRC)/asynMotorAxis.h

# ASYN
SOURCES += $(MOTOR_SRC)/asynMotorAxis.cpp
SOURCES += $(MOTOR_SRC)/asynMotorController.cpp
SOURCES += $(MOTOR_SRC)/paramLib.c
SOURCES += $(MOTOR_SRC)/devMotorAsyn.c
SOURCES += $(MOTOR_SRC)/drvMotorAsyn.c


# MOTOR
SOURCES += $(MOTOR_SRC)/motorUtilAux.cc
SOURCES += $(MOTOR_SRC)/motorUtil.cc
SOURCES += $(MOTOR_SRC)/motorDevSup.c
SOURCES += $(MOTOR_SRC)/motordrvCom.cc
SOURCES += $(MOTOR_SRC)/motordevCom.cc


DBDS    += $(MOTOR_SRC)/motorSupport.dbd


## SOFTMOTOR_SRC
SOURCES += $(SOFTMOTOR_SRC)/devSoft.cc
SOURCES += $(SOFTMOTOR_SRC)/devSoftAux.cc
DBDS    += $(SOFTMOTOR_SRC)/devSoftMotor.dbd



HEADERS += $(DBDINC_HDRS)
SOURCES += $(DBDINC_SRCS)


$(DBDINC_DEPS): $(DBDINC_HDRS)

.dbd.h:
	$(DBTORECORDTYPEH)  $(USR_DBDFLAGS) -o $@ $<


# db, vlibs rules are the default in RULES_E3, so add the empty one

db:

vlibs:
