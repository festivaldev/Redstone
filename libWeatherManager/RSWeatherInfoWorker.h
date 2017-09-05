#import <Foundation/Foundation.h>
#import "RSWeatherInfoWorkerInterface.h"

@class RSWeatherInfoService, RSWeatherCity;

@interface RSWeatherInfoWorker : NSObject <RSWeatherInfoWorkerInterface>

- (id)initWithConnection:(NSXPCConnection*)connection infoService:(RSWeatherInfoService*)infoService;
- (void)didUpdateCity:(RSWeatherCity *)city;
- (void)didFailWithError:(NSError *)error;

@end
