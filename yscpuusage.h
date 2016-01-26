#include <sys/sysctl.h>
#include <sys/types.h>
#include <mach/mach.h>
#include <mach/processor_info.h>
#include <mach/mach_host.h>
#include <Cocoa/Cocoa.h>
#include <QObject>

processor_info_array_t cpuInfo,prevCpuInfo;
mach_msg_type_number_t numCpuInfo,numPrevCpuInfo;
unsigned numCPUs;
NSTimer *updateTimer;
NSLock *CPUUsageLock;

