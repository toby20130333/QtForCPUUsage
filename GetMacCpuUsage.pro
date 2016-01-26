#-------------------------------------------------
#
# Project created by QtCreator 2015-08-06T11:09:49
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = GetMacCpuUsage
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h \
    yscpuobj.h

FORMS    += mainwindow.ui

OBJECTIVE_SOURCES += \
    yscpuobj.mm
LIBS += -framework Cocoa
#QMAKE_LFLAGS += -framework Cocoa
