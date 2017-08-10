#import "../Redstone.h"

@implementation RSTileInfo

- (id)initWithBundleIdentifier:(NSString*)bundleIdentifier {
	if (self = [super init]) {
		tileInfo = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Tiles/%@/tile.plist", RESOURCES_PATH, bundleIdentifier]];
		tileBundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/Tiles/%@/", RESOURCES_PATH, bundleIdentifier]];
		
		if ([tileInfo objectForKey:@"FullSizeArtwork"]) {
			_fullSizeArtwork = [[tileInfo objectForKey:@"FullSizeArtwork"] boolValue];
		}
		
		if ([tileInfo objectForKey:@"TileHidesLabel"]) {
			_tileHidesLabel = [[tileInfo objectForKey:@"TileHidesLabel"] boolValue];
		}
		
		if ([tileInfo objectForKey:@"UsesCornerBadge"]) {
			_usesCornerBadge = [[tileInfo objectForKey:@"UsesCornerBadge"] boolValue];
		}
		
		if ([tileInfo objectForKey:@"HasColoredIcon"]) {
			_hasColoredIcon = [[tileInfo objectForKey:@"HasColoredIcon"] boolValue];
		}
		
		if ([tileInfo objectForKey:@"DisplaysNotificationsOnTile"]) {
			_displaysNotificationsOnTile = [[tileInfo objectForKey:@"DisplaysNotificationsOnTile"] boolValue];
		}
		
		
		if ([tileInfo objectForKey:@"DisplayName"]) {
			_displayName = [tileInfo objectForKey:@"DisplayName"];
		}
		
		if ([tileInfo objectForKey:@"LocalizedDisplayName"] && [[tileInfo objectForKey:@"LocalizedDisplayName"] boolValue]) {
			_localizedDisplayName = [tileBundle localizedStringForKey:@"DisplayName" value:nil table:nil];
		}
		
		if ([tileInfo objectForKey:@"AccentColor"]) {
			_accentColor = [tileInfo objectForKey:@"AccentColor"];
		}
		
		if ([tileInfo objectForKey:@"TileAccentColor"]) {
			_tileAccentColor = [tileInfo objectForKey:@"TileAccentColor"];
		}
		
		if ([tileInfo objectForKey:@"LaunchScreenAccentColor"]) {
			_launchScreenAccentColor = [tileInfo objectForKey:@"LaunchScreenAccentColor"];
		}
		
		if ([tileInfo objectForKey:@"SupportedSizes"]) {
			NSMutableArray* sizes = [NSMutableArray new];
			for (int i=0; i<[[tileInfo objectForKey:@"SupportedSizes"] count]; i++) {
				[sizes addObject:[NSNumber numberWithInt:[[[tileInfo objectForKey:@"SupportedSizes"] objectAtIndex:i] intValue]]];
			}
			_supportedSizes = [sizes copy];
		} else {
			_supportedSizes = @[@1, @2, @3];
		}
		
		if ([tileInfo objectForKey:@"LabelHiddenForSizes"]) {
			NSMutableDictionary* sizes = [NSMutableDictionary new];
			for (int i=1; i<=3; i++) {
				if ([[tileInfo objectForKey:@"LabelHiddenForSizes"] objectForKey:[NSString stringWithFormat:@"%d", i]]) {
					[sizes setObject:[[tileInfo objectForKey:@"LabelHiddenForSizes"] objectForKey:[NSString stringWithFormat:@"%d", i]]
							  forKey:[NSString stringWithFormat:@"%d", i]];
				} else {
					[sizes setObject:@NO forKey:[NSString stringWithFormat:@"%d", i]];
				}
			}
			
			_labelHiddenForSizes = [sizes copy];
		} else {
			NSMutableDictionary* sizes = [NSMutableDictionary new];
			for (int i=1; i<=3; i++) {
				[sizes setObject:@NO forKey:[NSString stringWithFormat:@"%d", i]];
			}
			
			_labelHiddenForSizes = [sizes copy];
		}
		
		if ([tileInfo objectForKey:@"CornerBadgeForSizes"]) {
			NSMutableDictionary* sizes = [NSMutableDictionary new];
			for (int i=1; i<=3; i++) {
				if ([[tileInfo objectForKey:@"CornerBadgeForSizes"] objectForKey:[NSString stringWithFormat:@"%d", i]]) {
					[sizes setObject:[[tileInfo objectForKey:@"CornerBadgeForSizes"] objectForKey:[NSString stringWithFormat:@"%d", i]]
							  forKey:[NSString stringWithFormat:@"%d", i]];
				} else {
					[sizes setObject:@NO forKey:[NSString stringWithFormat:@"%d", i]];
				}
			}
			
			_cornerBadgeForSizes = [sizes copy];
		} else {
			NSMutableDictionary* sizes = [NSMutableDictionary new];
			for (int i=1; i<=3; i++) {
				[sizes setObject:@NO forKey:[NSString stringWithFormat:@"%d", i]];
			}
			
			_cornerBadgeForSizes = [sizes copy];
		}
	}
	
	return self;
}

@end
