#import <Foundation/Foundation.h>

@class WFTemperature, City, WAHourlyForecast, HourlyForecast, WADayForecast, DayForecast, CLLocation;

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

@interface RSWeatherCity : NSObject <NSSecureCoding>
@property (nonatomic,copy) CLLocation* location;
@property (nonatomic,copy) NSString* locationID;

@property (nonatomic,copy) NSString* name;
@property (nonatomic,retain) id temperature;
@property (assign,nonatomic) long long conditionCode;
@property (assign,nonatomic) float windDirection;
@property (assign,nonatomic) float windSpeed;

@property (assign,nonatomic,getter=isDataCelsius) BOOL dataCelsius;

- (id)initWithCity:(City*)city;
-(NSArray*)hourlyForecasts;
-(void)setHourlyForecasts:(id)arg1;
-(NSArray*)dayForecasts;
-(void)setDayForecasts:(id)arg1;
-(BOOL)isDataCelsius;
@end
