#import <Foundation/Foundation.h>

@class CLLocation;

@interface City : NSObject

@property (nonatomic,copy) CLLocation* location;
@property (nonatomic,copy) NSString* locationID;

@property (nonatomic,copy) NSString* name;
@property (nonatomic,retain) id temperature;
@property (assign,nonatomic) long long conditionCode;
@property (assign,nonatomic) float windDirection;
@property (assign,nonatomic) float windSpeed;

-(NSArray*)hourlyForecasts;
-(void)setHourlyForecasts:(id)arg1;
-(NSArray*)dayForecasts;
-(void)setDayForecasts:(id)arg1;

@end
