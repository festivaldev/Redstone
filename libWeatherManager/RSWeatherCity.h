#import <Foundation/Foundation.h>
#import "City.h"
#import "WAHourlyForecast.h"
#import "HourlyForecast.h"
#import "WADayForecast.h"
#import "DayForecast.h"

@class WFTemperature;

@interface RSWeatherHourlyForecast : NSObject <NSSecureCoding>
@property (nonatomic,copy) NSString * time;
@property (assign,nonatomic) long long hourIndex;
@property (nonatomic,copy) NSString * forecastDetail;
@property (nonatomic,copy) NSString * detail;
@property (nonatomic,retain) id temperature;
@property (assign,nonatomic) long long conditionCode;
@property (assign,nonatomic) float percentPrecipitation;

- (id)initWithWAHourlyForecast:(WAHourlyForecast*)hourlyForecast;
- (id)initWithHourlyForecast:(HourlyForecast*)hourlyForecast;
@end

@interface RSWeatherDayForecast : NSObject <NSSecureCoding>
@property (nonatomic,copy) id high;
@property (nonatomic,copy) id low;
@property (assign,nonatomic) unsigned long long icon;
@property (assign,nonatomic) unsigned long long dayOfWeek;
@property (assign,nonatomic) unsigned long long dayNumber;

- (id)initWithWADayForecast:(WADayForecast*)dayForecast;
- (id)initWithDayForecast:(DayForecast*)dayForecast;
@end

@interface RSWeatherCity : City <NSSecureCoding>
- (id)initWithCity:(City*)city;
@end
