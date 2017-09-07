#import "Redstone.h"

@implementation RSPreferences

static RSPreferences* sharedInstance;

+ (id)preferences {
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		sharedInstance = self;
		
#if (!TARGET_OS_SIMULATOR)
		preferences = [[HBPreferences alloc] initWithIdentifier:@"ml.festival.redstone"];
		
		[preferences registerDefaults:@{
										@"enabled": @YES,
										@"homeScreenEnabled": @YES,
										@"notificationsEnabled": @YES,
										@"lockScreenEnabled": @NO,
										@"volumeControlsEnabled": @YES,
										@"accentColor": @"#0078D7",
										@"tileOpacity": @0.8f,
										@"showWallpaper": @YES,
										@"showMoreTiles": @YES,
										@"liveTilesEnabled": @YES,
										@"2ColumnLayout": [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/2ColumnDefaultLayout.plist", RESOURCES_PATH]],
										@"3ColumnLayout": [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/3ColumnDefaultLayout.plist", RESOURCES_PATH]],
										@"lockDetailApp": @"com.apple.mobilecal",
										@"lockApp1": @"com.apple.mobilephone",
										@"lockApp2": @"com.apple.MobileSMS",
										@"lockApp3": @"com.apple.mobilemail"
										}];
#else
		preferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
#endif
		
		/*if (!preferences) {
			preferences = [NSMutableDictionary new];
		}
		
		// Main Switch
		if (![preferences objectForKey:@"enabled"]) {
			[preferences setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
		}
		
		// Home Screen
		if (![preferences objectForKey:@"homeScreenEnabled"]) {
			[preferences setValue:[NSNumber numberWithBool:YES] forKey:@"homeScreenEnabled"];
		}
		
		// Volume Controls
		if (![preferences objectForKey:@"volumeControlsEnabled"]) {
			[preferences setValue:[NSNumber numberWithBool:YES] forKey:@"volumeControlsEnabled"];
		}
		
		// Lock Screen
		if (![preferences objectForKey:@"lockScreenEnabled"]) {
			[preferences setValue:[NSNumber numberWithBool:NO] forKey:@"lockScreenEnabled"];
		}
		
		// Accent Color
		if (![preferences objectForKey:@"accentColor"]) {
			[preferences setValue:@"#0078D7" forKey:@"accentColor"];
		}
		
		// Tile Opacity
		if (![preferences objectForKey:@"tileOpacity"]) {
			[preferences setValue:[NSNumber numberWithFloat:0.8] forKey:@"tileOpacity"];
		}
		
		// Columns
		if (![preferences objectForKey:@"showMoreTiles"]) {
			[preferences setValue:[NSNumber numberWithBool:YES] forKey:@"showMoreTiles"];
		}
		
		// Default tile layout - 2 columns
		if (![preferences objectForKey:@"2ColumnLayout"]) {
			[preferences setObject:[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/2ColumnDefaultLayout.plist", RESOURCES_PATH]] forKey:@"2ColumnLayout"];
		}
		
		// Default tile layout - 3 columns
		if (![preferences objectForKey:@"3ColumnLayout"]) {
			[preferences setObject:[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/3ColumnDefaultLayout.plist", RESOURCES_PATH]] forKey:@"3ColumnLayout"];
		}
		
		_enabled = [[preferences objectForKey:@"enabled"] boolValue];
		_homeScreenEnabled = [[preferences objectForKey:@"homeScreenEnabled"] boolValue];
		_volumeControlsEnabled = [[preferences objectForKey:@"volumeControlsEnabled"] boolValue];
		_lockScreenEnabled = [[preferences objectForKey:@"lockScreenEnabled"] boolValue];
		
		[preferences writeToFile:PREFERENCES_PATH atomically:YES];*/
	}
	
	return self;
}

- (id)objectForKey:(NSString*)key {
	return [preferences objectForKey:key];
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey {
	[preferences setObject:anObject forKey:aKey];
}

@end
