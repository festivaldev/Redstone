#import "Redstone.h"

@implementation RSAnimation

+ (CGFloat)startScreenAnimationDelay {
	RSStartScreenScrollView* startScreen = [[[[RSCore sharedInstance] homeScreenController] startScreenController] view];
	
	NSMutableArray* tiles = [NSMutableArray new];
	for (UIView* view in startScreen.subviews) {
		if ([view isKindOfClass:[RSTile class]]) {
			[tiles addObject:view];
		}
	}
	
	NSMutableArray* tilesInView = [NSMutableArray new];
	
	for (RSTile* tile in tiles) {
		if (CGRectIntersectsRect(startScreen.bounds, tile.basePosition)) {
			[tilesInView addObject:tile];
		}
	}
	
	CGFloat sizeForPosition = [RSMetrics sizeForPosition];
	
	int minX = INT_MAX, maxX = INT_MIN, minY = INT_MAX, maxY = INT_MIN;
	for (RSTile* tile in tilesInView) {
		minX = MIN(tile.basePosition.origin.x / sizeForPosition, minX);
		maxX = MAX(tile.basePosition.origin.x / sizeForPosition, maxX);
		
		minY = MIN(tile.basePosition.origin.y / sizeForPosition, minY);
		maxY = MAX(tile.basePosition.origin.y / sizeForPosition, maxY);
	}
	
	return ((maxY - minY) * 0.01) + (maxX * 0.01);
}

+ (void)startScreenAnimateOut {
	RSStartScreenScrollView* startScreen = [[[[RSCore sharedInstance] homeScreenController] startScreenController] view];
	RSTile* sender = [[[[RSCore sharedInstance] homeScreenController] startScreenController] tileForLeafIdentifier:[[[[RSCore sharedInstance] homeScreenController] launchScreenController] launchIdentifier]];
	
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
	
	float maxDelay = ((maxY - minY) * 0.01) + (maxX * 0.01);
	
	for (RSTile* tile in tilesInView) {
		int tileX = tile.basePosition.origin.x / sizeForPosition;
		int tileY = tile.basePosition.origin.y / sizeForPosition;
		CGFloat delay = (tileX * 0.01) + (tileY - minY) * 0.01;

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
		
		if (tile == sender) {
			[tile.superview sendSubviewToBack:tile];
			[scale setBeginTime:CACurrentMediaTime() + delay + 0.1];
			[opacity setBeginTime:CACurrentMediaTime() + delay + 0.1];
		} else {
			[scale setBeginTime:CACurrentMediaTime() + delay];
			[opacity setBeginTime:CACurrentMediaTime() + delay];
		}
		
		[tile.layer setShouldRasterize:YES];
		[tile.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
		[tile.layer setContentsScale:[[UIScreen mainScreen] scale]];
		
		CGFloat layerX = -(tile.basePosition.origin.x - CGRectGetMidX(startScreen.bounds))/tile.basePosition.size.width;
		CGFloat layerY = -(tile.basePosition.origin.y - CGRectGetMidY(startScreen.bounds))/tile.basePosition.size.height;
		
		[tile setCenter:CGPointMake(CGRectGetMidX(startScreen.bounds),
									CGRectGetMidY(startScreen.bounds))];
		[tile.layer setAnchorPoint:CGPointMake(layerX, layerY)];
		
		[tile.layer addAnimation:scale forKey:@"scale"];
		[tile.layer addAnimation:opacity forKey:@"opacity"];
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxDelay + 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		for (RSTile* tile in tiles) {
			[tile setHidden:NO];
			[tile.layer setOpacity:0];
			[tile.layer removeAllAnimations];
			[tile.layer setAnchorPoint:CGPointMake(0.5,0.5)];
			[tile setCenter:[tile originalCenter]];
		}
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			for (RSTile* tile in tiles) {
				[tile.layer setOpacity:1];
			}
		});
	});
}

+ (void)startScreenAnimateIn {
	
}

@end
