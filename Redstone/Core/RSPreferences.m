#import "../Redstone.h"

@implementation RSPreferences

static RSPreferences* sharedInstance;

+ (id)preferences {
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		sharedInstance = self;
		
		preferences = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
		
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
		
		// Default tile layout - 2 columns
		if (![preferences objectForKey:@"2ColumnLayout"]) {
			[preferences setObject:[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/2ColumnDefaultLayout.plist", RESOURCES_PATH]] forKey:@"2ColumnLayout"];
		}
			 
		// Default tile layout - 3 columns
		if (![preferences objectForKey:@"3ColumnLayout"]) {
			[preferences setObject:[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/3ColumnDefaultLayout.plist", RESOURCES_PATH]] forKey:@"3ColumnLayout"];
		}
		
		[preferences writeToFile:PREFERENCES_PATH atomically:YES];
		
	}
	
	return self;
}

- (id)objectForKey:(NSString*)key {
	return [preferences objectForKey:key];
}

@end
