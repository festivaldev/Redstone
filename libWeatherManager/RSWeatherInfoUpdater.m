#import "RSWeatherInfoUpdater.h"

@implementation RSWeatherInfoUpdater

- (id)init {
	if (self = [super init]) {
		NSLog(@"[WeatherManager | InfoUpdater] init");
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			[self setDelegate:self];
		}
		
		_updatingCities = [NSMutableArray new];
		_pendingCities = [NSMutableArray new];
	}
	
	return self;
}

- (void)cleanUp {
	[_updatingCities removeAllObjects];
	[_pendingCities removeAllObjects];
	[self cancel];
}

- (void)updateWeatherForLocation:(CLLocation *)location {
	NSLog(@"[WeatherManager | InfoUpdater] updating weather for location %@", location);
	if (location != nil) {
		City* city = [[City alloc] init];
		[city setLocation:location];
		
		if (_updatingCities.count > 0) {
			if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
				[_pendingCities addObject:city];
			} else {
				[self addCityToPendingQueue:city];
			}
		} else {
			[self updateWeatherForCity:city];
		}
	}
}

- (void)_updateNextPendingCity {
	City* city = [_pendingCities firstObject];
	if (city != nil) {
		[self updateWeatherForCity:city];
		[_pendingCities removeObjectAtIndex:0];
	}
}

// iOS 9
- (void)parsedResultCity:(City*)city {
	if ([self.infoDelegate respondsToSelector:@selector(infoUpdater: didUpdateCity: forLocation:)]) {
		CLLocationCoordinate2D coordinate = city.location.coordinate;
		if (city.locationID == nil) {
			city.locationID = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
		}
		[self.infoDelegate infoUpdater:self didUpdateCity:city forLocation:city.location];
	}
}

// iOS 9
- (void)failCity:(City*)city {
	NSLog(@"[WeatherManager | InfoUpdater] city %@ failed to update (reason not known on iOS 9)", city);
	if ([self.infoDelegate respondsToSelector:@selector(infoUpdater: updateFailedForLocation:)]) {
		[self.infoDelegate infoUpdater:self updateFailedForLocation:city.location];
	}
}

// iOS 10
- (void)cityDidUpdateWeather:(City*)city {
	if ([self.infoDelegate respondsToSelector:@selector(infoUpdater:didUpdateCity:forLocation:)]) {
		[self.infoDelegate infoUpdater:self didUpdateCity:city forLocation:city.location];
	}
}

// iOS 10
- (void)city:(City*)city failedToUpdateWithError:(id)arg2 {
	NSLog(@"[WeatherManager | InfoUpdater] city %@ failed to update (reason: %@)", city, arg2);
	if ([self.infoDelegate respondsToSelector:@selector(infoUpdater: updateFailedForLocation:)]) {
		[self.infoDelegate infoUpdater:self updateFailedForLocation:city.location];
	}
}
@end
