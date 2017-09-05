@protocol RSWeatherInfoManagerInterface <NSObject>

@required
- (void)didUpdateWeather:(RSWeatherCity *)city;
- (void)didFailWithError:(NSError *)error;

@end
