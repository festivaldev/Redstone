#import "RSWeatherShortLookView.h"

@implementation RSWeatherShortLookView

- (void)updateForCity:(RSWeatherCity*)city {
	if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
		int userTemperatureUnit = [[objc_getClass("WeatherPreferences") sharedPreferences] userTemperatureUnit];
		int currentTemperatureValue = (int)[[city temperature] temperatureForUnit:userTemperatureUnit];
		
		[currentTemperature setText:[NSString stringWithFormat:@"%i°", currentTemperatureValue]];
		
		[cityName setText:[city name]];
	} else {
		[currentTemperature setText:[city temperature]];
		
		[cityName setText:[city name]];
	}
}

@end
