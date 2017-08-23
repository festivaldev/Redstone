#import "Redstone.h"

@implementation RSMetrics

/*
 TILE SIZES
 1: small
 2: medium
 3: wide
 4: large (wide width, wide height)
 5: extra-wide (3 columns only, medium height)
 6: vertical wide (medium width, wide height)
 */

+ (int)columns {
	if (screenWidth > 375) {
		return 3;
	}
	
	return [[[RSPreferences preferences] objectForKey:@"showMoreTiles"] boolValue] ? 3 : 2;
}

+ (CGFloat)tileBorderSpacing {
	return 5.0;
}

+ (CGSize)tileDimensionsForSize:(int)size {
	CGFloat baseTileWidth = 0;
	if ([self columns] == 3) {
		baseTileWidth = (screenWidth - 8 - ([self tileBorderSpacing] * 5)) / 6;
	} else if ([self columns] == 2) {
		baseTileWidth = (screenWidth - 8 - ([self tileBorderSpacing] * 3)) / 4;
	}
	
	switch (size) {
		case 1:
			return CGSizeMake(baseTileWidth, baseTileWidth);
		case 2:
			return CGSizeMake(baseTileWidth*2 + [self tileBorderSpacing], baseTileWidth * 2 + [self tileBorderSpacing]);
		case 3:
			return CGSizeMake((baseTileWidth * 4) + ([self tileBorderSpacing] * 3), baseTileWidth * 2 + [self tileBorderSpacing]);
	}
	
	return CGSizeZero;
}

+ (CGSize)tileIconDimensionsForSize:(int)size {
	CGSize tileSize = [self tileDimensionsForSize:size];
	
	switch (size) {
		case 1:
			return CGSizeMake(tileSize.height * 0.5, tileSize.height * 0.5);
		case 2:
		case 3:
			return CGSizeMake(tileSize.height * 0.33333, tileSize.height * 0.33333);
	}
	
	return CGSizeZero;
}

+ (CGFloat)sizeForPosition {
	return [self tileDimensionsForSize:1].width + [self tileBorderSpacing];
}

@end
