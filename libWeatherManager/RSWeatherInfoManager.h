#import <Foundation/Foundation.h>
#import "RSWeatherInfoManagerDelegate.h"

@class CLLocation;

@interface RSWeatherInfoManager : NSObject

@property (nonatomic, assign) id<RSWeatherInfoManagerDelegate> delegate;
@property (readonly, nonatomic) BOOL isMonitoringCurrentLocationWeatherChanges;

- (id)initWithDelegate:(id <RSWeatherInfoManagerDelegate>)delegate;
- (BOOL)isMonitoringWeatherChangesForLocation:(CLLocation *)location;

- (void)startMonitoringCurrentLocationWeatherChanges;
- (void)startMonitoringWeatherChangesForLocation:(CLLocation *)location;
- (void)stopMonitoringCurrentLocationWeatherChanges;
- (void)stopMonitoringWeatherChangesForLocation:(CLLocation *)location;

@end
