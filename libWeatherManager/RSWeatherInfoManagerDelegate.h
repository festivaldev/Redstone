#import "RSWeatherCity.h"

@class RSWeatherInfoManager;

@protocol RSWeatherInfoManagerDelegate <NSObject>

@required
- (void)weatherInfoManager:(RSWeatherInfoManager*)weatherInfoManager didUpdateWeather:(RSWeatherCity*)city;
- (void)weatherInfoManager:(RSWeatherInfoManager*)weatherInfoManager didFailWithError:(NSError*)error;

@end
