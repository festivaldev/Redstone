#import <Foundation/Foundation.h>
#import "NSXPCListenerDelegate.h"
#import "RSWeatherInfoUpdater.h"
#import "RSWeatherInfoUpdaterDelegate.h"
#import "RSWeatherInfoWorker.h"
#import "RSWeatherInfoWorkerDelegate.h"
#import "RSWeatherCity.h"

@interface RSWeatherInfoService : NSObject <NSXPCListenerDelegate, RSWeatherInfoUpdaterDelegate, RSWeatherInfoWorkerDelegate, CLLocationManagerDelegate>

- (id)initWithServiceName:(NSString*)serviceName;
- (void)systemWillPowerOn;
- (void)systemWillSleep;
- (void)registerWorker:(RSWeatherInfoWorker*)worker forLocationUpdates:(CLLocation*)location;
- (void)registerWorkerForCurrentLocationUpdates:(RSWeatherInfoWorker*)worker;
- (void)unregisterWorker:(RSWeatherInfoWorker*)worker forLocationUpdates:(CLLocation*)location;
- (void)unregisterWorkerForCurrentLocationUpdates:(RSWeatherInfoWorker*)worker;
- (void)invalidateWorker:(RSWeatherInfoWorker*)worker;

@end
