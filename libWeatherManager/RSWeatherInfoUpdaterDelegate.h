#import <CoreLocation/CoreLocation.h>

@class RSWeatherInfoUpdater, City;

@protocol RSWeatherInfoUpdaterDelegate <NSObject>
@required
- (void)infoUpdater:(RSWeatherInfoUpdater *)infoUpdater didUpdateCity:(City *)city forLocation:(CLLocation *)location;
- (void)infoUpdater:(RSWeatherInfoUpdater *)infoUpdater updateFailedForLocation:(CLLocation *)location;

@end
