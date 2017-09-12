#import "Redstone.h"

extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);
NSBundle* redstoneBundle;

@implementation RSAesthetics

+ (NSString*)localizedStringForKey:(NSString*)key {
	if (!redstoneBundle) {
		redstoneBundle = [NSBundle bundleWithPath:RESOURCES_PATH];
	}
	
	return [redstoneBundle localizedStringForKey:key value:key table:nil];
}

+ (UIImage*)lockScreenWallpaper {
	if (![[[RSPreferences preferences] objectForKey:@"showWallpaper"] boolValue]) {
		return [self imageFromColor:[self colorForCurrentThemeByCategory:@"solidBackgroundColor"]];
	} else{
		NSData* lockScreenWallpaper = [NSData dataWithContentsOfFile:LOCK_WALLPAPER_PATH];
		
		CFDataRef lockWallpaperDataRef = (__bridge CFDataRef)lockScreenWallpaper;
		NSArray* imageArray = (__bridge NSArray*)CPBitmapCreateImagesFromData(lockWallpaperDataRef, NULL, 1, NULL);
		UIImage* lockWallpaper = [UIImage imageWithCGImage:(CGImageRef)imageArray[0]];
		
		return lockWallpaper;
	}
}

+ (UIImage*)homeScreenWallpaper {
	NSData* homeScreenWallpaper = [NSData dataWithContentsOfFile:HOME_WALLPAPER_PATH];
	
	if (![[[RSPreferences preferences] objectForKey:@"showWallpaper"] boolValue]) {
		return [self imageFromColor:[self colorForCurrentThemeByCategory:@"solidBackgroundColor"]];
	} else if (homeScreenWallpaper) {
		CFDataRef homeWallpaperDataRef = (__bridge CFDataRef)homeScreenWallpaper;
		NSArray* imageArray = (__bridge NSArray*)CPBitmapCreateImagesFromData(homeWallpaperDataRef, NULL, 1, NULL);
		UIImage* homeWallpaper = [UIImage imageWithCGImage:(CGImageRef)imageArray[0]];
		
		return homeWallpaper;
	} else {
		return [self lockScreenWallpaper];
	}
}

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

+ (UIColor*)colorForCurrentThemeByCategory:(NSString*)colorCategory {
	if ([[[RSPreferences preferences] objectForKey:@"themeColor"] isEqualToString:@"dark"]) {
		NSDictionary* colors = @{
								 @"foregroundColor": [UIColor whiteColor],
								 @"backgroundColor": [UIColor colorWithWhite:0.22 alpha:1.0],
								 @"invertedForegroundColor": [UIColor blackColor],
								 @"invertedBackgroundColor": [UIColor whiteColor],
								 @"opaqueBackgroundColor": [UIColor colorWithWhite:0.0 alpha:0.75],
								 @"solidBackgroundColor": [UIColor blackColor],
								 @"borderColor": [UIColor colorWithWhite:0.46 alpha:1.0],
								 @"trackColor": [UIColor colorWithWhite:0.43 alpha:1.0],
								 @"disabledColor": [UIColor colorWithWhite:0.3 alpha:1.0],
								 @"buttonBackgroundColor": [UIColor colorWithWhite:0.38 alpha:1.0],
								 @"textFieldBackgroundColor": [UIColor blackColor],
								 @"textFieldPlaceholderColor": [UIColor colorWithWhite:0.6 alpha:1.0],
								 };
		
		if ([colors objectForKey:colorCategory]) {
			return [colors objectForKey:colorCategory];
		}
	} else if ([[[RSPreferences preferences] objectForKey:@"themeColor"] isEqualToString:@"light"]) {
		NSDictionary* colors = @{
								 @"foregroundColor": [UIColor blackColor],
								 @"backgroundColor": [UIColor colorWithWhite:0.95 alpha:1.0],
								 @"invertedForegroundColor": [UIColor whiteColor],
								 @"invertedBackgroundColor": [UIColor colorWithWhite:0.22 alpha:1.0],
								 @"opaqueBackgroundColor": [UIColor colorWithWhite:1.0 alpha:0.75],
								 @"solidBackgroundColor": [UIColor whiteColor],
								 @"borderColor": [UIColor colorWithWhite:0.50 alpha:1.0],
								 @"trackColor": [UIColor colorWithWhite:0.66 alpha:1.0],
								 @"disabledColor": [UIColor colorWithWhite:0.7 alpha:1.0],
								 @"buttonColor": [UIColor colorWithWhite:0.72 alpha:1.0],
								 @"textFieldBackgroundColor": [UIColor colorWithWhite:0.9 alpha:0.85],
								 @"textFieldPlaceholderColor": [UIColor colorWithWhite:0.33 alpha:1.0],
								 
								 };
		
		if ([colors objectForKey:colorCategory]) {
			return [colors objectForKey:colorCategory];
		}
	}
	
	return nil;
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


+ (UIImage *)imageFromColor:(UIColor *)color {
	CGRect rect = CGRectMake(0, 0, 1, 1);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIColor *)readableForegroundColorForBackgroundColor:(UIColor*)backgroundColor {
	size_t count = CGColorGetNumberOfComponents(backgroundColor.CGColor);
	const CGFloat *componentColors = CGColorGetComponents(backgroundColor.CGColor);
	
	CGFloat darknessScore = 0;
	if (count == 2) {
		darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
	} else if (count == 4) {
		darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
	}
	
	if (darknessScore >= 180) {
		return [UIColor blackColor];
	}
	
	return [UIColor whiteColor];
}

@end
