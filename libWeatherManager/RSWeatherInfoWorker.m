#import "RSWeatherInfoWorker.h"
#import "RSWeatherInfoService.h"
#import "RSWeatherInfoManagerInterface.h"

@interface RSWeatherInfoWorker ()
@property (nonatomic, strong) RSWeatherInfoService* infoService;
@property (nonatomic, strong) id<RSWeatherInfoManagerInterface> remoteObject;
@end


@implementation RSWeatherInfoWorker

- (id)initWithConnection:(NSXPCConnection*)connection infoService:(RSWeatherInfoService*)infoService {
	if (self = [super init]) {
		NSLog(@"[WeatherManager | InfoWorker] init");
		NSXPCInterface *serverInterface = [NSXPCInterface interfaceWithProtocol:@protocol(RSWeatherInfoWorkerInterface)];
		NSXPCInterface *clientInterface = [NSXPCInterface interfaceWithProtocol:@protocol(RSWeatherInfoManagerInterface)];
		[clientInterface setClass:[RSWeatherCity class] forSelector:@selector(didUpdateWeather:) argumentIndex:0 ofReply:NO];
		[clientInterface setClass:[NSError class] forSelector:@selector(didFailWithError:) argumentIndex:0 ofReply:NO];
		
		[connection setRemoteObjectInterface:clientInterface];
		[connection setExportedInterface:serverInterface];
		[connection setExportedObject:self];
		[connection resume];
		
		self.remoteObject = [connection remoteObjectProxy];
		self.infoService = infoService;
		
		__weak NSXPCConnection* weakConnection = connection;
		connection.invalidationHandler = ^(){
			[self.infoService invalidateWorker:self];
			[weakConnection setExportedObject:nil];
			self.remoteObject = nil;
		};
	}
	
	return self;
}

- (void)startMonitoringCurrentLocationWeatherChanges {
	NSLog(@"[WeatherManager | InfoWorker] start monitoring current location");
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.infoService registerWorkerForCurrentLocationUpdates:self];
	});
}

- (void)startMonitoringWeatherChangesForLocation:(CLLocation *)location {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.infoService registerWorker:self forLocationUpdates:location];
	});
}

- (void)stopMonitoringCurrentLocationWeatherChanges {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.infoService unregisterWorkerForCurrentLocationUpdates:self];
	});
}

- (void)stopMonitoringWeatherChangesForLocation:(CLLocation *)location {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.infoService unregisterWorker:self forLocationUpdates:location];
	});
}

- (void)didUpdateCity:(RSWeatherCity *)city {
	[self.remoteObject didUpdateWeather:city];
}

- (void)didFailWithError:(NSError *)error {
	[self.remoteObject didFailWithError:error];
}

@end
