#import "RSWeatherCity.h"
#import "City.h"
#import <CoreLocation/CoreLocation.h>

@implementation RSWeatherHourlyForecast

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithWAHourlyForecast:(WAHourlyForecast*)hourlyForecast {
	if (self = [super init]) {
		self.time = hourlyForecast.time;
		self.hourIndex = hourlyForecast.hourIndex;
		self.forecastDetail = hourlyForecast.forecastDetail;
		self.temperature = hourlyForecast.temperature;
		self.conditionCode = hourlyForecast.conditionCode;
		self.percentPrecipitation = hourlyForecast.percentPrecipitation;
	}
	
	return self;
}

- (id)initWithHourlyForecast:(HourlyForecast*)hourlyForecast {
	if (self = [super init]) {
		self.time = hourlyForecast.time;
		self.hourIndex = hourlyForecast.hourIndex;
		self.detail = hourlyForecast.detail;
		self.conditionCode = hourlyForecast.conditionCode;
		self.percentPrecipitation = hourlyForecast.percentPrecipitation;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.time = [decoder decodeObjectOfClass:[NSString class] forKey:@"time"];
		self.hourIndex = [decoder decodeIntForKey:@"hourIndex"];
		self.conditionCode = [decoder decodeIntForKey:@"conditionCode"];
		self.percentPrecipitation = [decoder decodeFloatForKey:@"percentPrecipitation"];
		
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			self.forecastDetail = [decoder decodeObjectOfClass:[NSString class] forKey:@"forecastDetail"];
			self.temperature = [decoder decodeObjectOfClass:NSClassFromString(@"WFTemperature") forKey:@"temperature"];
		} else {
			self.detail = [decoder decodeObjectOfClass:[NSString class] forKey:@"detail"];
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.time forKey:@"time"];
	[encoder encodeInt:self.hourIndex forKey:@"hourIndex"];
	[encoder encodeInt:self.conditionCode forKey:@"conditionCode"];
	[encoder encodeFloat:self.percentPrecipitation forKey:@"percentPrecipitation"];
	
	if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
		[encoder encodeObject:self.forecastDetail forKey:@"forecastDetail"];
		[encoder encodeObject:self.temperature forKey:@"temperature"];
	} else {
		[encoder encodeObject:self.detail forKey:@"detail"];
	}
}

@end

@implementation RSWeatherDayForecast

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithWADayForecast:(WADayForecast*)dayForecast {
	if (self = [super init]) {
		self.high = dayForecast.high;
		self.low = dayForecast.low;
		self.icon = dayForecast.icon;
		self.dayOfWeek = dayForecast.dayOfWeek;
		self.dayNumber = dayForecast.dayNumber;
	}
	
	return self;
}

- (id)initWithDayForecast:(DayForecast*)dayForecast {
	if (self = [super init]) {
		self.high = dayForecast.high;
		self.low = dayForecast.low;
		self.icon = dayForecast.icon;
		self.dayOfWeek = dayForecast.dayOfWeek;
		self.dayNumber = dayForecast.dayNumber;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.icon = [decoder decodeIntForKey:@"icon"];
		self.dayOfWeek = [decoder decodeIntForKey:@"dayOfWeek"];
		self.dayNumber = [decoder decodeIntForKey:@"dayNumber"];
		
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			self.high = [decoder decodeObjectOfClass:NSClassFromString(@"WFTemperature") forKey:@"high"];
			self.low = [decoder decodeObjectOfClass:NSClassFromString(@"WFTemperature") forKey:@"low"];
		} else {
			self.high = [decoder decodeObjectOfClass:[NSString class] forKey:@"high"];
			self.low = [decoder decodeObjectOfClass:[NSString class] forKey:@"low"];
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.high forKey:@"high"];
	[encoder encodeObject:self.low forKey:@"low"];
	[encoder encodeInt:self.icon forKey:@"icon"];
	[encoder encodeInt:self.dayOfWeek forKey:@"dayOfWeek"];
	[encoder encodeInt:self.dayNumber forKey:@"dayNumber"];
}

@end

@implementation RSWeatherCity

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCity:(City*)city {
	if (self = [super init]) {
		self.location = city.location;
		self.name = city.name;
		self.temperature = city.temperature;
		self.conditionCode = city.conditionCode;
		self.windDirection = city.windDirection;
		self.windSpeed = city.windSpeed;
		
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			NSMutableArray* hourlyForecasts = [NSMutableArray arrayWithCapacity:[city hourlyForecasts].count];
			for (WAHourlyForecast* hourlyForecast in [city hourlyForecasts]) {
				RSWeatherHourlyForecast* weatherInfoHourlyForecast = [[RSWeatherHourlyForecast alloc] initWithWAHourlyForecast:hourlyForecast];
				[hourlyForecasts addObject:weatherInfoHourlyForecast];
			}
			
			[self setHourlyForecasts:[hourlyForecasts copy]];
			
			NSMutableArray* dayForecasts = [NSMutableArray arrayWithCapacity:[city dayForecasts].count];
			for (WADayForecast* dayForecast in [city dayForecasts]) {
				RSWeatherDayForecast* weatherInfoDayForecast = [[RSWeatherDayForecast alloc] initWithWADayForecast:dayForecast];
				[dayForecasts addObject:weatherInfoDayForecast];
			}
			
			[self setDayForecasts:[dayForecasts copy]];
		} else {
			self.dataCelsius = city.dataCelsius;
			
			NSMutableArray* hourlyForecasts = [NSMutableArray arrayWithCapacity:[city hourlyForecasts].count];
			for (HourlyForecast* hourlyForecast in [city hourlyForecasts]) {
				RSWeatherHourlyForecast* weatherInfoHourlyForecast = [[RSWeatherHourlyForecast alloc] initWithHourlyForecast:hourlyForecast];
				[hourlyForecasts addObject:weatherInfoHourlyForecast];
			}
			
			[self setHourlyForecasts:[hourlyForecasts copy]];
			
			NSMutableArray* dayForecasts = [NSMutableArray arrayWithCapacity:[city dayForecasts].count];
			for (DayForecast* dayForecast in [city dayForecasts]) {
				RSWeatherDayForecast* weatherInfoDayForecast = [[RSWeatherDayForecast alloc] initWithDayForecast:dayForecast];
				[dayForecasts addObject:weatherInfoDayForecast];
			}
			
			[self setDayForecasts:[dayForecasts copy]];
		}
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.location = [decoder decodeObjectOfClass:[CLLocation class] forKey:@"location"];
		self.name = [decoder decodeObjectOfClass:[NSString class] forKey:@"name"];
		
		self.conditionCode = [decoder decodeIntForKey:@"conditionCode"];
		self.windDirection = [decoder decodeFloatForKey:@"windDirection"];
		self.windSpeed = [decoder decodeFloatForKey:@"windSpeed"];
		
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			self.temperature = [decoder decodeObjectOfClass:NSClassFromString(@"WFTemperature") forKey:@"temperature"];
			
			NSSet* hourlyForecastClasses = [NSSet setWithObjects:[NSArray class], [RSWeatherHourlyForecast class], NSClassFromString(@"WFTemperature"), nil];
			[self setHourlyForecasts:[decoder decodeObjectOfClasses:hourlyForecastClasses forKey:@"hourlyForecasts"]];
			
			NSSet* dayForecastClasses = [NSSet setWithObjects:[NSArray class], [RSWeatherDayForecast class], NSClassFromString(@"WFTemperature"), nil];
			[self setDayForecasts:[decoder decodeObjectOfClasses:dayForecastClasses forKey:@"dayForecasts"]];
		} else {
			self.temperature = [decoder decodeObjectOfClass:[NSString class] forKey:@"temperature"];
			self.dataCelsius = [decoder decodeBoolForKey:@"dataCelsius"];

			NSSet* hourlyForecastClasses = [NSSet setWithObjects:[NSArray class], [RSWeatherHourlyForecast class], nil];
			[self setHourlyForecasts:[decoder decodeObjectOfClasses:hourlyForecastClasses forKey:@"hourlyForecasts"]];
			
			NSSet* dayForecastClasses = [NSSet setWithObjects:[NSArray class], [RSWeatherDayForecast class], nil];
			[self setDayForecasts:[decoder decodeObjectOfClasses:dayForecastClasses forKey:@"dayForecasts"]];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.location forKey:@"location"];
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.temperature forKey:@"temperature"];
	[encoder encodeInt:self.conditionCode forKey:@"conditionCode"];
	[encoder encodeFloat:self.windDirection forKey:@"windDirection"];
	[encoder encodeFloat:self.windSpeed forKey:@"windSpeed"];
	[encoder encodeObject:self.hourlyForecasts forKey:@"hourlyForecasts"];
	[encoder encodeObject:self.dayForecasts forKey:@"dayForecasts"];
	[encoder encodeBool:self.dataCelsius forKey:@"dataCelsius"];
}

@end
