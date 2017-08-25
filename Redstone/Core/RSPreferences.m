#import "Redstone.h"

@implementation RSPreferences

static RSPreferences* sharedInstance;

+ (id)preferences {
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		sharedInstance = self;
		
		/*preferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
		
		if (!preferences) {
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
		
		[preferences writeToFile:PREFERENCES_PATH atomically:YES];*/
		
		[self loadPreferences];
		
		if (!preferences) {
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
		
		[self savePreferences];
	}
	
	return self;
}

- (NSString*)settingsFilePath {
	return @"/var/mobile/Library/Preferences/ml.festival.redstone.plist";
}

- (NSString*)settingsIdentifier {
	return @"ml.festival.redstone";
}

- (void)loadPreferences {
	CFPreferencesAppSynchronize((__bridge CFStringRef)[self settingsIdentifier]);
	CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)[self settingsIdentifier], kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	if (keyList) {
		preferences = [(NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)[self settingsIdentifier], kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)) mutableCopy];
	} else {
		preferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	}
}

- (void)savePreferences {
	CFPreferencesSetMultiple((CFDictionaryRef)preferences, NULL, (__bridge CFStringRef)[self settingsIdentifier], kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	CFPreferencesAppSynchronize((__bridge CFStringRef)[self settingsIdentifier]);
	
	NSData *data = [NSPropertyListSerialization dataWithPropertyList:preferences format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
	[data writeToFile:[self settingsFilePath] atomically:YES];
}

- (id)objectForKey:(NSString*)key {
	return [preferences objectForKey:key];
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey {
	[preferences setValue:anObject forKey:aKey];
	
	[self savePreferences];
}

@end
