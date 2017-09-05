#import <Foundation/Foundation.h>
#import "WeatherUpdaterDelegate.h"
#import "RSWeatherInfoUpdaterDelegate.h"
#import "TWCCityUpdater.h"
#import "City.h"

@interface RSWeatherInfoUpdater : TWCCityUpdater <WeatherUpdaterDelegate> {
	NSMutableArray* _updatingCities;
	NSMutableArray* _pendingCities;
}

@property (nonatomic, strong) id <RSWeatherInfoUpdaterDelegate> infoDelegate;

- (void)updateWeatherForLocation:(CLLocation *)location;
- (void)cleanUp;

@end
