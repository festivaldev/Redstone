#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StartScreen/RSLiveTileInterface.h"
#import "RSWeatherShortLookView.h"
#import "RSWeatherConditionView.h"
#import "RSWeatherHourlyForecastView.h"
#import "RSWeatherDayForecastView.h"

@class RSWeatherInfoManager, RSWeatherCity, WeatherPreferences;

@protocol RSWeatherInfoManagerDelegate <NSObject>
@required
- (void)weatherInfoManager:(RSWeatherInfoManager *)weatherInfoManager didUpdateWeather:(RSWeatherCity *)city;
- (void)weatherInfoManager:(RSWeatherInfoManager *)weatherInfoManager didFailWithError:(NSError *)error;
@end

@interface RSWeatherInfoManager : NSObject
@property (nonatomic, assign) id <RSWeatherInfoManagerDelegate>delegate;

- (id)initWithDelegate:(id <RSWeatherInfoManagerDelegate>)delegate;
- (BOOL)isMonitoringWeatherChangesForLocation:(CLLocation *)location;
- (void)startMonitoringCurrentLocationWeatherChanges;
- (void)startMonitoringWeatherChangesForLocation:(CLLocation *)location;
- (void)stopMonitoringCurrentLocationWeatherChanges;
- (void)stopMonitoringWeatherChangesForLocation:(CLLocation *)location;
@end

@interface RSWeatherTile : UIView <RSLiveTileInterface, RSWeatherInfoManagerDelegate> {
	WeatherPreferences* weatherPreferences;
	RSWeatherInfoManager* weatherManager;
	RSWeatherCity* currentCity;
	RSWeatherCity* localCity;
	City* currentSelectedCity;
	
	NSDate* lastUpdateTime;
	
	RSWeatherShortLookView* shortLookView;
	RSWeatherConditionView* conditionView;
	RSWeatherHourlyForecastView* hourlyForecastView;
	RSWeatherDayForecastView* dayForecastView;
}

@property (nonatomic, assign) BOOL started;
@property (nonatomic, strong) RSTile* tile;

@end
