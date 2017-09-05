#import <Foundation/Foundation.h>

@class City;

@protocol WeatherUpdaterDelegate <NSObject>
@required

// iOS 10
- (void)cityDidUpdateWeather:(City*)city;
- (void)city:(City*)city failedToUpdateWithError:(id)arg2;

// iOS 9 and before
- (void)parsedResultCity:(City*)city;
- (void)failCity:(City*)city;

@end
