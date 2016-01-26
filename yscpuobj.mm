#include "yscpuobj.h"

YSCpuObj::YSCpuObj(QObject *parent) : QObject(parent)
{
    int mib[2U] = { CTL_HW, HW_NCPU };
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    if(status)
        numCPUs = 1;
    ysTimer = new QTimer(this);
    connect(ysTimer, SIGNAL(timeout()), this, SLOT(updateCpuUsage()));
    ysTimer->start(5000);
}

void YSCpuObj::updateCpuUsage()
{
    ysTimer->stop();
    natural_t numCPUsU = 0U;
    float usageRate = 0.0;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);
    if(err == KERN_SUCCESS) {
        qDebug("updateing............");
        for(unsigned i = 0U; i < numCPUs; ++i) {
            float inUse, total;
            if(prevCpuInfo) {
                inUse = (
                         (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                         );
                total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            usageRate += inUse/total;
            QString cpuInfo = QString(" Core: %1 Usage: %2 ").arg(i).arg(usageRate);
            qDebug()<<" inUse "<<inUse<<"\n total:"<<usageRate;
        }
        emit signalSendCpuInfo(QString::number(usageRate));
        ysTimer->start(5000);
        if(prevCpuInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCpuInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)prevCpuInfo, prevCpuInfoSize);
        }
        prevCpuInfo = cpuInfo;
        numPrevCpuInfo = numCpuInfo;

        cpuInfo = NULL;
        numCpuInfo = 0U;
    } else {
        emit signalSendCpuInfo("error");
        ysTimer->start(5000);
        qDebug()<<" Error!!!!! ";
    }
}

