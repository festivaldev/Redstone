#define	err_system(x)                   (((x)&0x3f)<<26)
#define err_sub(x)                      (((x)&0xfff)<<14)

#define sys_iokit                       err_system(0x38)
#define sub_iokit_common                err_sub(0)

#define iokit_common_msg(message)       (UInt32)(sys_iokit|sub_iokit_common|message)
#define kIOMessageCanSystemSleep        iokit_common_msg(0x270)
#define kIOMessageSystemWillSleep       iokit_common_msg(0x280)
#define kIOMessageSystemWillPowerOn     iokit_common_msg(0x320)
#define kIOMessageSystemHasPoweredOn    iokit_common_msg(0x300)

typedef struct IONotificationPort *IONotificationPortRef;

typedef	kern_return_t IOReturn;
typedef mach_port_t	io_object_t;
typedef io_object_t	io_connect_t;
typedef io_object_t	io_service_t;

typedef void (*IOServiceInterestCallback)(void *refcon, io_service_t service, uint32_t messageType, void *messageArgument);

extern "C" CFRunLoopSourceRef IONotificationPortGetRunLoopSource(IONotificationPortRef	notify);
extern "C" io_connect_t IORegisterForSystemPower(void *refcon, IONotificationPortRef *thePortRef, IOServiceInterestCallback callback,io_object_t * notifier);
extern "C" IOReturn IODeregisterForSystemPower (io_object_t *notifier);
extern "C" kern_return_t IOServiceClose(io_connect_t connect);
extern "C" void IONotificationPortDestroy(IONotificationPortRef notify);
extern "C" IOReturn IOAllowPowerChange (io_connect_t kernelPort, long notificationID);
