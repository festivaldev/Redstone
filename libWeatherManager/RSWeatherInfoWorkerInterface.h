@class CLLocation;

@protocol RSWeatherInfoWorkerInterface <NSObject>

@required
- (void)startMonitoringCurrentLocationWeatherChanges;
- (void)startMonitoringWeatherChangesForLocation:(CLLocation *)location;
- (void)stopMonitoringCurrentLocationWeatherChanges;
- (void)stopMonitoringWeatherChangesForLocation:(CLLocation *)location;

@end
