#ifndef YSCPUOBJ_H
#define YSCPUOBJ_H

#include <QObject>
#include <QTimer>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <mach/mach.h>
#include <mach/processor_info.h>
#include <mach/mach_host.h>
//#include <Cocoa/Cocoa.h>
#include <QDebug>

class YSCpuObj : public QObject
{
    Q_OBJECT
public:
    explicit YSCpuObj(QObject *parent = 0);
    QTimer * ysTimer;


    processor_info_array_t cpuInfo,prevCpuInfo;
    mach_msg_type_number_t numCpuInfo,numPrevCpuInfo;
    unsigned numCPUs;
//    NSTimer *updateTimer;
//    NSLock *CPUUsageLock;
signals:
    void signalSendCpuInfo(const QString& msg);
public slots:
    void updateCpuUsage();
};

#endif // YSCPUOBJ_H
