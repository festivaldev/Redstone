#import "RSWeatherTile.h"
#import <libWeatherManager/RSWeatherCity.h>
#import <dlfcn.h>

@implementation RSWeatherTile

- (id)initWithFrame:(CGRect)frame tile:(RSTile*)tile {
	if (self = [super initWithFrame:frame]) {
		dlopen("/Systen/Library/PrivateFrameworks/Weather.framework/Weather", RTLD_NOW);
		self.tile = tile;
		
		NSBundle* tileBundle = [NSBundle bundleForClass:[self class]];
		shortLookView = [[tileBundle loadNibNamed:@"ShortLookView" owner:self options:nil] objectAtIndex:0];
		conditionView = [[tileBundle loadNibNamed:@"ConditionView" owner:self options:nil] objectAtIndex:0];
		hourlyForecastView = [[tileBundle loadNibNamed:@"HourlyForecastView" owner:self options:nil] objectAtIndex:0];
		dayForecastView = [[tileBundle loadNibNamed:@"DayForecastView" owner:self options:nil] objectAtIndex:0];
		
		weatherPreferences = [objc_getClass("WeatherPreferences") sharedPreferences];
		weatherManager = [[RSWeatherInfoManager alloc] initWithDelegate:self];
	}
	
	return self;
}

- (void)hasStarted {
	if (currentCity != nil) {
		
		[shortLookView updateForCity:currentCity];
		[conditionView updateForCity:currentCity];
		[hourlyForecastView updateForCity:currentCity];
		[dayForecastView updateForCity:currentCity];
	}
	
	if (lastUpdateTime && [[NSDate date] compare:[lastUpdateTime dateByAddingTimeInterval:900]] != NSOrderedDescending) {
		return;
	}
	
	if ([weatherPreferences isLocalWeatherEnabled]) {
		currentSelectedCity = nil;
		if (localCity != nil) {
			currentCity = localCity;
		}
		
		[weatherManager startMonitoringCurrentLocationWeatherChanges];
	} else {
		currentSelectedCity = [[weatherPreferences loadSavedCities] objectAtIndex:[weatherPreferences loadActiveCity]];
		[weatherManager startMonitoringWeatherChangesForLocation:[currentSelectedCity location]];
	}
}

- (void)hasStopped {
	if (currentSelectedCity) {
		[weatherManager stopMonitoringWeatherChangesForLocation:[currentSelectedCity location]];
	}
	
	[weatherManager stopMonitoringCurrentLocationWeatherChanges];
}

- (void)weatherInfoManager:(RSWeatherInfoManager*)weatherInfoManager didUpdateWeather:(RSWeatherCity*)city {
	[weatherInfoManager stopMonitoringCurrentLocationWeatherChanges];
	
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:[city location] completionHandler:^(NSArray *placemarks, NSError *error) {
		if (placemarks && placemarks.count > 0) {
			CLPlacemark *placemark = placemarks[0];
			NSDictionary *addressDictionary = placemark.addressDictionary;
			
			[city setName:[addressDictionary objectForKey:@"City"]];
			
			[shortLookView updateForCity:city];
			[conditionView updateForCity:city];
			[hourlyForecastView updateForCity:city];
			[dayForecastView updateForCity:city];
			
			if (currentCity == nil) {
				[self.tile setLiveTileHidden:NO animated:YES];
			}
			
			currentCity = city;
			
			lastUpdateTime = [NSDate date];
		}
	}];
}
- (void)weatherInfoManager:(RSWeatherInfoManager*)weatherInfoManager didFailWithError:(NSError*)error {
	[weatherInfoManager stopMonitoringCurrentLocationWeatherChanges];
	currentCity = nil;
	
}

- (NSArray*)viewsForSize:(int)size {
	switch (size) {
		case 1:
			return @[shortLookView];
		case 2:
			return @[conditionView, hourlyForecastView];
		case 3:
			return @[conditionView, dayForecastView];
		default:
			break;
	}
	
	return nil;
}
- (CGFloat)updateInterval {
	return -1;
}

- (BOOL)isReadyForDisplay {
	return currentCity != nil;
}

@end
