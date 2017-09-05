#import "RSWeatherInfoManager.h"
#import "RSWeatherInfoManagerInterface.h"
#import "RSWeatherInfoWorkerInterface.h"
#import "NSXPCConnection.h"
#import <CoreLocation/CoreLocation.h>

@interface RSWeatherInfoManager ()
@property (readwrite, nonatomic) BOOL isMonitoringCurrentLocationWeatherChanges;
@property (nonatomic, retain) NSMutableArray* monitoredLocations;
@property (nonatomic, retain) id remoteObject;
@property (nonatomic, retain) NSXPCConnection* connection;
@end

@implementation RSWeatherInfoManager

- (id)initWithDelegate:(id<RSWeatherInfoManagerDelegate>)delegate {
	if (self = [super init]) {
		NSLog(@"[WeatherManager | InfoManager] init");
		self.monitoredLocations = [NSMutableArray array];
		self.delegate = delegate;
		
		NSSet *classes = [NSSet setWithObjects:[CLLocation class], nil];
		NSXPCInterface *serverInterface = [NSXPCInterface interfaceWithProtocol:@protocol(RSWeatherInfoWorkerInterface)];
		NSXPCInterface *clientInterface = [NSXPCInterface interfaceWithProtocol:@protocol(RSWeatherInfoManagerInterface)];
		[serverInterface setClasses:classes forSelector:@selector(startMonitoringWeatherChangesForLocation:) argumentIndex:0 ofReply:NO];
		[serverInterface setClasses:classes forSelector:@selector(stopMonitoringWeatherChangesForLocation:) argumentIndex:0 ofReply:NO];
	
		self.connection = [[NSXPCConnection alloc] initWithMachServiceName:@"ml.festival.weathermanagerd" options:NSXPCConnectionPrivileged];
		[self.connection setRemoteObjectInterface:serverInterface];
		[self.connection setExportedInterface:clientInterface];
		[self.connection resume];
	}
	
	return self;
}

- (void)_startConnectionIfNeeded {
	NSLog(@"[WeatherManager | InfoManager] starting connection");
	if (self.remoteObject == nil) {
		__weak RSWeatherInfoManager* weakSelf = self;
		
		self.connection.interruptionHandler = ^(){
			[weakSelf _reestablishConnection];
		};
		self.remoteObject = [self.connection remoteObjectProxyWithErrorHandler:^(NSError *error) {
			NSLog(@"[WeatherManager | InfoManager] failed with error: %@", error);
			if ([weakSelf.delegate respondsToSelector:@selector(weatherInfoManager: didFailWithError:)]) {
				[weakSelf.delegate weatherInfoManager:self didFailWithError:error];
			}
		}];
		[self.connection setExportedObject:self];
	}
}

- (void)_stopConnectionIfNeeded {
	NSLog(@"[WeatherManager | InfoManager] stopping connection");
	if (self.isMonitoringCurrentLocationWeatherChanges == NO && self.monitoredLocations.count == 0) {
		[self.connection setExportedObject:nil];
		self.connection.interruptionHandler = nil;
		self.remoteObject = nil;
	}
}

- (void)_reestablishConnection {
	NSLog(@"[WeatherManager | InfoManager] restarting connection");
	NSMutableArray *monitoredLocationsCopy = [self.monitoredLocations mutableCopy];
	BOOL isMonitoringCurrentLocationWeatherChangesCopy = self.isMonitoringCurrentLocationWeatherChanges;
	
	self.isMonitoringCurrentLocationWeatherChanges = NO;
	[self.monitoredLocations removeAllObjects];
	
	if (isMonitoringCurrentLocationWeatherChangesCopy) {
		[self startMonitoringCurrentLocationWeatherChanges];
	}
	for (CLLocation *location in monitoredLocationsCopy) {
		[self startMonitoringWeatherChangesForLocation:location];
	}
}

- (NSUInteger)_indexForLocation:(CLLocation *)location {
	return [self.monitoredLocations indexOfObjectPassingTest:^BOOL(CLLocation *otherLocation, NSUInteger index, BOOL *stop) {
		return [location distanceFromLocation:otherLocation] < 3000.0f;
	}];
}

- (BOOL)isMonitoringWeatherChangesForLocation:(CLLocation*)location {
	return [self _indexForLocation:location] != NSNotFound;
}

- (void)startMonitoringCurrentLocationWeatherChanges {
	NSLog(@"[WeatherManager | InfoManager] start monitoring current location");
	if (!self.isMonitoringCurrentLocationWeatherChanges) {
		[self _startConnectionIfNeeded];
		
		[self.remoteObject startMonitoringCurrentLocationWeatherChanges];
		self.isMonitoringCurrentLocationWeatherChanges = YES;
	}
}

- (void)startMonitoringWeatherChangesForLocation:(CLLocation*)location {
	NSUInteger index = [self _indexForLocation:location];
	if (index == NSNotFound) {
		[self _startConnectionIfNeeded];
		
		[self.remoteObject startMonitoringWeatherChangesForLocation:location];
		[self.monitoredLocations addObject:location];
	}
}

- (void)stopMonitoringCurrentLocationWeatherChanges {
	if (self.isMonitoringCurrentLocationWeatherChanges) {
		[self.remoteObject stopMonitoringCurrentLocationWeatherChanges];
		self.isMonitoringCurrentLocationWeatherChanges = NO;
		[self _stopConnectionIfNeeded];
	}
}

- (void)stopMonitoringWeatherChangesForLocation:(CLLocation*)location {
	NSUInteger index = [self _indexForLocation:location];
	if (index != NSNotFound) {
		[self.remoteObject stopMonitoringWeatherChangesForLocation:location];
		[self.monitoredLocations removeObject:location];
		[self _stopConnectionIfNeeded];
	}
}

- (void)didUpdateWeather:(RSWeatherCity *)city {
	NSLog(@"[WeatherManager | InfoManager] did update city: %@", city);
	if ([self.delegate respondsToSelector:@selector(weatherInfoManager:didUpdateWeather:)]) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self.delegate weatherInfoManager:self didUpdateWeather:city];
		});
	}
}

- (void)didFailWithError:(NSError *)error {
	NSLog(@"[WeatherManager | InfoManager] update failed with error: %@", error);
	if ([self.delegate respondsToSelector:@selector(weatherInfoManager:didFailWithError:)]) {
		[self.delegate weatherInfoManager:self didFailWithError:error];
	}
}

@end
