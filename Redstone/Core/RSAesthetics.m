#import "Redstone.h"

@implementation RSAesthetics

+ (UIColor*)accentColor {
	return [self colorFromHexString:[[RSPreferences preferences] objectForKey:@"accentColor"]];
}

+ (UIColor*)accentColorForTile:(RSTileInfo*)tileInfo {
	if (tileInfo.tileAccentColor) {
		return [self colorFromHexString:tileInfo.tileAccentColor];
	} else if (tileInfo.accentColor) {
		return [self colorFromHexString:tileInfo.accentColor];
	} else {
		return [[self accentColor] colorWithAlphaComponent:[self tileOpacity]];
	}
}

+ (CGFloat)tileOpacity {
	return [[[RSPreferences preferences] objectForKey:@"tileOpacity"] floatValue];
}

+ (UIImage*)imageForTileWithBundleIdentifier:(NSString*)bundleIdentifier {
	NSString* imagePath = [NSString stringWithFormat:@"%@/Tiles/%@/tile", RESOURCES_PATH, bundleIdentifier];
	UIImage* tileImage = [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	
	if (!tileImage) {
		UIImage* defaultAppIcon = [[[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:bundleIdentifier] getUnmaskedIconImage:2];
		
		if (!defaultAppIcon) {
			return [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Tiles/default_icon", RESOURCES_PATH]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}
		
		return defaultAppIcon;
	}
	
	return tileImage;
}

+ (UIImage*)imageForTileWithBundleIdentifier:(NSString*)bundleIdentifier size:(int)size colored:(BOOL)colored {
	NSString* iconFileName = @"";
	
	switch (size) {
		case 1:
			iconFileName = @"tile-70x70";
			break;
		case 2:
			iconFileName = @"tile-132x132";
			break;
		case 3:
			iconFileName = @"tile-269x132";
			break;
		case 4:
			iconFileName = @"tile-269x269";
			break;
		case 5:
			iconFileName = @"tile-AppList";
			break;
		case 6:
			iconFileName = @"splash";
			
		default:
			break;
	}
	
	NSString* imagePath = [NSString stringWithFormat:@"%@/Tiles/%@/%@", RESOURCES_PATH, bundleIdentifier, iconFileName];
	UIImage* tileImage = [UIImage imageWithContentsOfFile:imagePath];
	
	if (!tileImage) {
		if (colored) {
			return [[self imageForTileWithBundleIdentifier:bundleIdentifier] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		} else {
			return [self imageForTileWithBundleIdentifier:bundleIdentifier];
		}
	}
	
	if (!colored) {
		return [tileImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	}
	
	return tileImage;
}

+ (UIColor*)colorFromHexString:(NSString*)arg1 {
	NSString *cleanString = [arg1 stringByReplacingOccurrencesOfString:@"#" withString:@""];
	
	if ([cleanString length] == 3) {
		cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
					   [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
					   [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
					   [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
	}
	
	if ([cleanString length] == 6) {
		cleanString = [cleanString stringByAppendingString:@"ff"];
	}
	
	unsigned int baseValue;
	[[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
	
	float red = ((baseValue >> 24) & 0xFF)/255.0f;
	float green = ((baseValue >> 16) & 0xFF)/255.0f;
	float blue = ((baseValue >> 8) & 0xFF)/255.0f;
	float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
