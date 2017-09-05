#import "City.h"

@interface WeatherPreferences : NSObject

+(id)sharedPreferences;
-(id)loadSavedCities;
-(int)loadActiveCity;
-(BOOL)isLocalWeatherEnabled;
-(int)userTemperatureUnit;

@end
