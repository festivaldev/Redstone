#import "RSWeatherInfoService.h"

@interface RSWeatherInfoService ()
@property (nonatomic) BOOL isFirstLocationUpdate;
@property (nonatomic, strong) RSWeatherInfoUpdater* infoUpdater;
@property (nonatomic, strong) NSTimer* updateTimer;
@property (nonatomic) time_t lastUpdateTime;
@property (nonatomic, strong) NSMutableArray* locations;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, retain) NSMutableDictionary* locationWorkers;
@property (nonatomic, strong) NSMutableArray* currentLocationWorkers;
@end

@implementation RSWeatherInfoService

+ (float)updateInterval {
	return 1800.0;
}

+ (float)exitDelay {
	return 60.0;
}

- (id)initWithServiceName:(NSString*)serviceName {
	if (self = [super init]) {
		NSLog(@"[WeatherManager | InfoService] init");
		self.infoUpdater = [[RSWeatherInfoUpdater alloc] init];
		[self.infoUpdater setInfoDelegate:self];
		
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		self.locationManager.distanceFilter = 3000.0f;
		[self.locationManager setDelegate:self];
		
		self.locations = [NSMutableArray array];
		self.currentLocationWorkers = [NSMutableArray new];
		self.locationWorkers = [NSMutableDictionary new];
		
		self.lastUpdateTime = time(NULL);
	}
	
	return self;
}

- (void)systemWillPowerOn {
	float updateInterval = [RSWeatherInfoService updateInterval];
	time_t timeSinceLastUpdate = time(NULL) - self.lastUpdateTime;
	
	if (timeSinceLastUpdate >= updateInterval) {
		[self updateWeatherInfo];
		[self startUpdateTimerIfNeeded];
	} else {
		NSDate* fireDate = [NSDate dateWithTimeIntervalSinceNow:updateInterval - timeSinceLastUpdate];
		self.updateTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:updateInterval target:self selector:@selector(updateWeatherInfo) userInfo:nil repeats:YES];
		self.updateTimer.tolerance = 0.5f * updateInterval;
		[[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
	}
}

- (void)systemWillSleep {
	[self stopUpdateTimer];
}

- (void)startUpdateTimerIfNeeded {
	if (self.updateTimer == nil) {
		float updateInterval = [RSWeatherInfoService updateInterval];
		self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval target:self selector:@selector(updateWeatherInfo) userInfo:nil repeats:YES];
		[self updateWeatherInfo];
		
		self.updateTimer.tolerance = 0.5f * updateInterval;
	}
}

- (void)stopUpdateTimerIfNeeded {
	if (self.updateTimer != nil && self.currentLocationWorkers.count == 0 && self.locations.count == 0) {
		[self stopUpdateTimer];
		
		float exitDelay = [RSWeatherInfoService exitDelay];
		[self performSelector:@selector(exit) withObject:nil afterDelay:exitDelay];
		
	}
}

- (void)stopUpdateTimer {
	[self.updateTimer invalidate];
	self.updateTimer = nil;
}

- (void)updateWeatherInfo {
	NSLog(@"[WeatherManager | InfoService] attempting to update weather info");
	[self.infoUpdater cleanUp];
	
	if ([CLLocationManager significantLocationChangeMonitoringAvailable] == NO) {
		[self.locationManager startUpdatingLocation];
	} else {
		self.currentLocation = [self.locationManager location];
		[self.infoUpdater updateWeatherForLocation:self.currentLocation];
	}
	
	for (CLLocation* location in self.locations) {
		[self.infoUpdater updateWeatherForLocation:location];
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		self.lastUpdateTime = time(NULL);
	});
}

- (void)exit {
	CFRunLoopStop(CFRunLoopGetMain());
}

#pragma mark NSXPCListenerDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
- (BOOL)listener:(NSXPCListener*)listener shouldAcceptNewConnection:(NSXPCConnection*)connection {
	NSLog(@"[WeatherManager | NSXPCListener] attempting to accept new connection");
	[[RSWeatherInfoWorker alloc] initWithConnection:connection infoService:self];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(exit) object:nil];
	});
	return YES;
}
#pragma clang diagnostic pop

#pragma mark RSWeatherInfoWorkerDelegate

- (void)registerWorker:(RSWeatherInfoWorker*)worker forLocationUpdates:(CLLocation*)location {
	NSUInteger index = [self _indexForLocation:location];
	if (index == NSNotFound) {
		NSValue* key = [self _keyForLocation:location];
		NSMutableArray* workers = [NSMutableArray arrayWithObject:worker];
		[self.locationWorkers setObject:workers forKey:key];
		[self.locations addObject:location];
		
	} else {
		CLLocation* location = [self.locations objectAtIndex:index];
		NSValue* key = [self _keyForLocation:location];
		NSMutableArray* workers = [self.locationWorkers objectForKey:key];
		
		if ([workers containsObject:worker] == NO) {
			[workers addObject:worker];
		}
	}
	
	[self.infoUpdater performSelectorOnMainThread:@selector(updateWeatherForLocation:) withObject:location waitUntilDone:YES];
	[self startUpdateTimerIfNeeded];
}

- (void)registerWorkerForCurrentLocationUpdates:(RSWeatherInfoWorker*)worker {
	NSLog(@"[WeatherManager | InfoService] register worker for current location");
	if ([self.currentLocationWorkers containsObject:worker] == NO) {
		[self.currentLocationWorkers addObject:worker];
	}
	
	if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		[self.locationManager startMonitoringSignificantLocationChanges];
	}
	self.isFirstLocationUpdate = YES;
	
	[self.locationManager stopUpdatingLocation];
	[self.locationManager startUpdatingLocation];
	[self startUpdateTimerIfNeeded];
}

- (void)unregisterWorker:(RSWeatherInfoWorker*)worker forLocationUpdates:(CLLocation*)location {
	NSUInteger index = [self _indexForLocation:location];
	if (index != NSNotFound) {
		CLLocation* location = [self.locations objectAtIndex:index];
		NSValue* key = [self _keyForLocation:location];
		NSMutableArray* workers = [self.locationWorkers objectForKey:key];
		if ([workers containsObject:worker]) {
			if (workers.count == 1) {
				[self.locationWorkers removeObjectForKey:key];
				[self.locations removeObject:location];
			} else {
				[workers removeObject:worker];
			}
		}
	}
	[self stopUpdateTimerIfNeeded];
}

- (void)unregisterWorkerForCurrentLocationUpdates:(RSWeatherInfoWorker*)worker {
	[self.currentLocationWorkers removeObject:worker];
	
	if (self.currentLocationWorkers.count == 0) {
		if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
			[self.locationManager stopMonitoringSignificantLocationChanges];
		} else {
			[self.locationManager stopUpdatingLocation];
		}
	}
	[self stopUpdateTimerIfNeeded];
}

- (void)invalidateWorker:(RSWeatherInfoWorker*)worker {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self unregisterWorkerForCurrentLocationUpdates:worker];
		for (int i=self.locations.count - 1; i >= 0; i--) {
			CLLocation* location = [self.locations objectAtIndex:i];
			[self unregisterWorker:worker forLocationUpdates:location];
		}
	});
}

#pragma mark CLLocationManagerDelegate

- (NSValue*)_keyForLocation:(CLLocation*)location {
	CLLocationCoordinate2D coordinate = location.coordinate;
	return [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
}

- (NSUInteger)_indexForLocation:(CLLocation*)location {
	return [self.locations indexOfObjectPassingTest:^BOOL(CLLocation* otherLocation, NSUInteger index, BOOL* stop) {
		return [location distanceFromLocation:otherLocation] < 3000.0f;
	}];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations {
	NSLog(@"[WeatherManager | InfoService] location manager did update location");
	if (self.isFirstLocationUpdate || ![CLLocationManager significantLocationChangeMonitoringAvailable]) {
		[self.locationManager stopUpdatingLocation];
		self.currentLocation = [locations lastObject];
		
		[self.infoUpdater performSelectorOnMainThread:@selector(updateWeatherForLocation:) withObject:self.currentLocation waitUntilDone:NO];
	}
	
	self.isFirstLocationUpdate = NO;
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
	NSLog(@"[WeatherManager | InfoService] location manager failed with error: %@", error);
	[self.currentLocationWorkers makeObjectsPerformSelector:@selector(didFailWithError:) withObject:error];
}

#pragma mark RSWeatherInfoUpdaterDelegate

- (void)infoUpdater:(RSWeatherInfoUpdater*)infoUpdater didUpdateCity:(City*)city forLocation:(CLLocation*)location {
	RSWeatherCity* infoCity = [[RSWeatherCity alloc] initWithCity:city];
	NSArray* workers = [NSArray new];
	
	/// TODO: Differentiate between local cities and specific locations
	
	//NSLog(@"[Redstone | WeatherManager] %@ (%f == %f): %d, (%f == %f): %d, ", city.name, self.currentLocation.coordinate.longitude, location.coordinate.longitude, self.currentLocation.coordinate.longitude == location.coordinate.longitude, self.currentLocation.coordinate.latitude, location.coordinate.latitude, self.currentLocation.coordinate.latitude == location.coordinate.latitude);
	
	// current location weather was updated
	if (self.currentLocation.coordinate.longitude == location.coordinate.longitude && self.currentLocation.coordinate.latitude == location.coordinate.latitude) {
		workers = self.currentLocationWorkers;
		self.currentLocation = nil;
	} else {
		// specific location weather was updated
		NSValue* key = [self _keyForLocation:location];
		workers = [self.locationWorkers objectForKey:key];
	}
	
	[workers makeObjectsPerformSelector:@selector(didUpdateCity:) withObject:infoCity];
}

- (void)infoUpdater:(RSWeatherInfoUpdater*)infoUpdater updateFailedForLocation:(CLLocation*)location {
	NSArray* workers;
	if (self.currentLocation == location) {
		workers = self.currentLocationWorkers;
		self.currentLocation = nil;
	} else {
		NSValue* key = [self _keyForLocation:location];
		workers = [self.locationWorkers objectForKey:key];
	}
	NSError* error = [NSError errorWithDomain:NSOSStatusErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
	[workers makeObjectsPerformSelector:@selector(didFailWithError:) withObject:error];
}

@end
