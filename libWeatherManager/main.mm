#import "IOKit.h"
#import "RSWeatherInfoService.h"
#import "NSXPCListener.h"

io_connect_t  root_port;
RSWeatherInfoService *infoService = nil;

void SystemPowerDidChange(void* refCon, io_service_t service, natural_t messageType, void* messageArgument) {
	
	switch (messageType) {
		case kIOMessageSystemWillSleep:
			[infoService systemWillSleep];
		case kIOMessageCanSystemSleep:
			IOAllowPowerChange(root_port, (long)messageArgument);
			break;
		case kIOMessageSystemWillPowerOn:
			[infoService systemWillPowerOn];
			break;
	}
}

int main(int argc, char **argv, char **envp) {
	@autoreleasepool {
		NSLog(@"[WeatherManager] init");
		
		IONotificationPortRef notifyPortRef;
		io_object_t notifierObject;
		void* refCon = NULL;
		
		root_port = IORegisterForSystemPower(refCon, &notifyPortRef, SystemPowerDidChange, &notifierObject);
		
		NSString *serviceName = @"ml.festival.weathermanagerd";
		NSXPCListener *listener = [[NSXPCListener alloc] initWithMachServiceName:serviceName];
		infoService = [[RSWeatherInfoService alloc] initWithServiceName:serviceName];
		listener.delegate = infoService;
		[listener resume];
		
		CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(notifyPortRef), kCFRunLoopCommonModes);
		CFRunLoopRun();
		
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(notifyPortRef), kCFRunLoopCommonModes);
		IODeregisterForSystemPower( &notifierObject );
		IOServiceClose(root_port);
		IONotificationPortDestroy(notifyPortRef);
		
		[listener invalidate];
	}
	
	return 0;
}

// vim:ft=objc
