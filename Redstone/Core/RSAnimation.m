#import "Redstone.h"

@implementation RSAnimation

+ (void)startScreenAnimateOut {
	RSStartScreenScrollView* startScreen = [[[[RSCore sharedInstance] homeScreenController] startScreenController] view];
	
	NSMutableArray* tiles = [NSMutableArray new];
	for (UIView* view in startScreen.subviews) {
		if ([view isKindOfClass:[RSTile class]]) {
			[tiles addObject:view];
		}
	}
	
	NSMutableArray* tilesInView = [NSMutableArray new];
	NSMutableArray* tilesNotInView = [NSMutableArray new];
	
	for (RSTile* tile in tiles) {
		[tile.layer removeAllAnimations];
		[tile setTransform:CGAffineTransformIdentity];
		
		if (CGRectIntersectsRect(startScreen.bounds, tile.basePosition)) {
			[tilesInView addObject:tile];
		} else {
			[tilesNotInView addObject:tile];
		}
	}
	
	for (RSTile* tile in tilesNotInView) {
		[tile setHidden:YES];
	}
	
	CGFloat sizeForPosition = [RSMetrics sizeForPosition];
	
	int minX = INT_MAX, maxX = INT_MIN, minY = INT_MAX, maxY = INT_MIN;
	for (RSTile* tile in tilesInView) {
		minX = MIN(tile.basePosition.origin.x / sizeForPosition, minX);
		maxX = MAX(tile.basePosition.origin.x / sizeForPosition, maxX);
		
		minY = MIN(tile.basePosition.origin.y / sizeForPosition, minY);
		maxY = MAX(tile.basePosition.origin.y / sizeForPosition, maxY);
	}
	
	//float maxDelay = ((maxY - minY) * 0.01) + (maxX * 0.01);
	
	for (RSTile* tile in tilesInView) {
		CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
															  function:CubicEaseIn
															 fromValue:1.0
															   toValue:4.0];
		[scale setDuration:0.225];
		[scale setRemovedOnCompletion:NO];
		[scale setFillMode:kCAFillModeForwards];
		
		CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
																function:CubicEaseIn
															   fromValue:1.0
																 toValue:0.0];
		[opacity setDuration:0.2];
		[opacity setRemovedOnCompletion:NO];
		[opacity setFillMode:kCAFillModeForwards];
		
		[tile.layer setShouldRasterize:YES];
		[tile.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
		[tile.layer setContentsScale:[[UIScreen mainScreen] scale]];
		
		int tileX = tile.basePosition.origin.x / sizeForPosition;
		int tileY = tile.basePosition.origin.y / sizeForPosition;
		CGFloat delay = (tileX * 0.01) + (tileY - minY) * 0.01;
		
		[scale setBeginTime:CACurrentMediaTime() + delay];
		[opacity setBeginTime:CACurrentMediaTime() + delay];
		
		[tile.layer addAnimation:scale forKey:@"scale"];
		[tile.layer addAnimation:opacity forKey:@"opacity"];
	}
}

@end
