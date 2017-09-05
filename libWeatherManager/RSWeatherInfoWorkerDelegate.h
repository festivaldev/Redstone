#import <CoreLocation/CoreLocation.h>

@class RSWeatherInfoWorker;

@protocol RSWeatherInfoWorkerDelegate <NSObject>
@required
- (void)registerWorker:(RSWeatherInfoWorker *)worker forLocationUpdates:(CLLocation *)location;
- (void)registerWorkerForCurrentLocationUpdates:(RSWeatherInfoWorker *)worker;
- (void)unregisterWorker:(RSWeatherInfoWorker *)worker forLocationUpdates:(CLLocation *)location;
- (void)unregisterWorkerForCurrentLocationUpdates:(RSWeatherInfoWorker *)worker;
- (void)invalidateWorker:(RSWeatherInfoWorker *)worker;

@end
