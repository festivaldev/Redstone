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
	
	RSTile* sender = [[[[RSCore sharedInstance] homeScreenController] startScreenController] tileForBundleIdentifier:[[[[RSCore sharedInstance] homeScreenController] launchScreenController] launchIdentifier]];
	
	[startScreen setUserInteractionEnabled:NO];
	[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:NO];
	
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
		[tile setTiltEnabled:NO];
		[tile setUserInteractionEnabled:NO];
		
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
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseIn
														   fromValue:1.0
															 toValue:0.0];
	[opacity setDuration:0.2];
	[opacity setRemovedOnCompletion:NO];
	[opacity setFillMode:kCAFillModeForwards];
	
	[startScreen.allAppsButton.layer addAnimation:opacity forKey:@"opacity"];
	
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
			[startScreen setUserInteractionEnabled:YES];
			[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:YES];
			[startScreen.allAppsButton.layer removeAllAnimations];
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				for (RSTile* tile in tiles) {
					[tile setUserInteractionEnabled:YES];
				}
			});
		});
	});
}

+ (void)startScreenAnimateIn {
	RSStartScreenScrollView* startScreen = [[[[RSCore sharedInstance] homeScreenController] startScreenController] view];
	[startScreen setUserInteractionEnabled:NO];
	[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:NO];
	
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
			
			[tile setHidden:NO];
			[tile.layer setOpacity:0];
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
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseIn
														   fromValue:0.0
															 toValue:1.0];
	[opacity setDuration:0.3];
	[opacity setRemovedOnCompletion:NO];
	[opacity setFillMode:kCAFillModeForwards];
	
	[startScreen.allAppsButton.layer addAnimation:opacity forKey:@"opacity"];
	
	for (RSTile* tile in tilesInView) {
		int tileX = tile.basePosition.origin.x / sizeForPosition;
		int tileY = tile.basePosition.origin.y / sizeForPosition;
		CGFloat delay = (tileX * 0.01) + (tileY - minY) * 0.01;
		
		CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
															  function:CubicEaseOut
															 fromValue:0.8
															   toValue:1.0];
		[scale setDuration:0.4];
		[scale setRemovedOnCompletion:NO];
		[scale setFillMode:kCAFillModeForwards];
		
		CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
																function:CubicEaseOut
															   fromValue:0.0
																 toValue:1.0];
		[opacity setDuration:0.3];
		[opacity setRemovedOnCompletion:NO];
		[opacity setFillMode:kCAFillModeForwards];
		
		[scale setBeginTime:CACurrentMediaTime() + delay];
		[opacity setBeginTime:CACurrentMediaTime() + delay];
		
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
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxDelay + 0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[startScreen setUserInteractionEnabled:YES];
		[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:YES];
		[startScreen.allAppsButton.layer removeAllAnimations];
		
		for (RSTile* tile in tiles) {
			[tile.layer removeAllAnimations];
			[tile.layer setOpacity:1];
			[tile setAlpha:1.0];
			[tile setHidden:NO];
			[tile.layer setAnchorPoint:CGPointMake(0.5,0.5)];
			[tile setCenter:[tile originalCenter]];
			[tile setTiltEnabled:YES];
			[tile setUserInteractionEnabled:YES];
		}
	});
}

+ (CGFloat)appListAnimationDelay {
	RSAppListScrollView* appList = [[[[RSCore sharedInstance] homeScreenController] appListController] view];
	
	NSMutableArray* viewsInView = [NSMutableArray new];
	
	for (UIView* view in appList.subviews) {
		if ([view isKindOfClass:[RSApp class]] || [view isKindOfClass:[RSAppListSection class]]) {
			if (CGRectIntersectsRect(appList.bounds, view.frame)) {
				[viewsInView addObject:view];
			}
		}
	}
	
	return [viewsInView count] * 0.01;
}

+ (void)appListAnimateOut {
	RSAppListController* appListController = [[[RSCore sharedInstance] homeScreenController] appListController];
	RSAppListScrollView* appList = appListController.view;
	
	RSApp* sender = [appListController appForBundleIdentifier:[[[[RSCore sharedInstance] homeScreenController] launchScreenController] launchIdentifier]];
	
	[appList setUserInteractionEnabled:NO];
	[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:NO];
	
	NSMutableArray* viewsInView = [NSMutableArray new];
	NSMutableArray* viewsNotInView = [NSMutableArray new];
	
	for (UIView* view in appList.subviews) {
		if ([view isKindOfClass:[RSApp class]] || [view isKindOfClass:[RSAppListSection class]]) {
			[(RSApp*)view setTiltEnabled:NO];
			[view setUserInteractionEnabled:NO];
			[view.layer removeAllAnimations];
			[view setTransform:CGAffineTransformIdentity];
			if (CGRectIntersectsRect(appList.bounds, view.frame)) {
				[viewsInView addObject:view];
			} else {
				[viewsNotInView addObject:view];
			}
		}
	}
	
	viewsInView = [[viewsInView sortedArrayUsingComparator:^NSComparisonResult(UIView* view1, UIView* view2) {
		return [[NSNumber numberWithFloat:view1.frame.origin.y] compare:[NSNumber numberWithFloat:view2.frame.origin.y]];
	}] mutableCopy];
	
	for (UIView* view in viewsNotInView) {
		[view setHidden:YES];
	}
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseIn
														   fromValue:1.0
															 toValue:0.0];
	[opacity setDuration:0.2];
	[opacity setRemovedOnCompletion:NO];
	[opacity setFillMode:kCAFillModeForwards];
	
	[appListController.searchBar.layer addAnimation:opacity forKey:@"opacity"];
	
	float maxDelay = [viewsInView count] * 0.01;
	
	for (UIView* view in viewsInView) {
		CGFloat delay = [viewsInView indexOfObject:view] * 0.01;
		
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
		
		if (view == sender) {
			[view.superview sendSubviewToBack:view];
			[scale setBeginTime:CACurrentMediaTime() + delay + 0.1];
			[opacity setBeginTime:CACurrentMediaTime() + delay + 0.1];
		} else if ([view isKindOfClass:NSClassFromString(@"RSAppListSection")]) {
			[opacity setDuration:0.1];
		} else {
			[scale setBeginTime:CACurrentMediaTime() + delay];
			[opacity setBeginTime:CACurrentMediaTime() + delay];
		}
		
		[view.layer setShouldRasterize:YES];
		[view.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
		[view.layer setContentsScale:[[UIScreen mainScreen] scale]];
		
		float width = view.bounds.size.width;
		float height = view.bounds.size.height;
		
		CGRect basePosition = CGRectMake(view.layer.position.x - (width/2),
										 view.layer.position.y - (height/2),
										 width,
										 height);
		
		CGFloat layerX = -(basePosition.origin.x - CGRectGetMidX(appList.bounds))/basePosition.size.width;
		CGFloat layerY = -(basePosition.origin.y - CGRectGetMidY(appList.bounds))/basePosition.size.height;
		
		[view setCenter:CGPointMake(CGRectGetMidX(appList.bounds),
									CGRectGetMidY(appList.bounds))];
		[view.layer setAnchorPoint:CGPointMake(layerX, layerY)];
		
		[view.layer addAnimation:scale forKey:@"scale"];
		[view.layer addAnimation:opacity forKey:@"opacity"];
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxDelay + 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		for (UIView* view in appList.subviews) {
			if ([view isKindOfClass:[RSApp class]] || [view isKindOfClass:[RSAppListSection class]]) {
				[view.layer setOpacity:0];
				[view.layer removeAllAnimations];
				[view.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
				
				[view setCenter:[(RSApp*)view originalCenter]];
			}
		}
		
		[appList setUserInteractionEnabled:YES];
		[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:YES];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[appListController.searchBar setText:@""];
			[appListController showAppsFittingQuery];
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				for (UIView* view in appList.subviews) {
					[view setUserInteractionEnabled:YES];
				}
			});
		});
	});
}

+ (void)appListAnimateIn {
	RSAppListController* appListController = [[[RSCore sharedInstance] homeScreenController] appListController];
	RSAppListScrollView* appList = appListController.view;
	
	[appList setUserInteractionEnabled:NO];
	[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:NO];
	
	NSMutableArray* viewsInView = [NSMutableArray new];
	NSMutableArray* viewsNotInView = [NSMutableArray new];
	
	for (UIView* view in appList.subviews) {
		if ([view isKindOfClass:[RSApp class]] || [view isKindOfClass:[RSAppListSection class]]) {
			[view.layer removeAllAnimations];
			[view setTransform:CGAffineTransformIdentity];
			if (CGRectIntersectsRect(appList.bounds, view.frame)) {
				[viewsInView addObject:view];
			} else {
				[viewsNotInView addObject:view];
			}
		}
	}
	
	viewsInView = [[viewsInView sortedArrayUsingComparator:^NSComparisonResult(UIView* view1, UIView* view2) {
		return [[NSNumber numberWithFloat:view1.frame.origin.y] compare:[NSNumber numberWithFloat:view2.frame.origin.y]];
	}] mutableCopy];
	
	for (UIView* view in viewsNotInView) {
		[view setHidden:YES];
	}
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseIn
														   fromValue:0.0
															 toValue:1.0];
	[opacity setDuration:0.3];
	[opacity setRemovedOnCompletion:NO];
	[opacity setFillMode:kCAFillModeForwards];
	
	[appListController.searchBar.layer addAnimation:opacity forKey:@"opacity"];
	
	float maxDelay = [viewsInView count] * 0.01;
	
	for (UIView* view in viewsInView) {
		CGFloat delay = [viewsInView indexOfObject:view] * 0.01;
		
		CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
															  function:CubicEaseOut
															 fromValue:0.8
															   toValue:1.0];
		[scale setDuration:0.4];
		[scale setRemovedOnCompletion:NO];
		[scale setFillMode:kCAFillModeForwards];
		
		CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
																function:CubicEaseOut
															   fromValue:0.0
																 toValue:1.0];
		[opacity setDuration:0.3];
		[opacity setRemovedOnCompletion:NO];
		[opacity setFillMode:kCAFillModeForwards];
		
		[scale setBeginTime:CACurrentMediaTime() + delay];
		[opacity setBeginTime:CACurrentMediaTime() + delay];
		
		[view.layer setShouldRasterize:YES];
		[view.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
		[view.layer setContentsScale:[[UIScreen mainScreen] scale]];
		
		float width = view.bounds.size.width;
		float height = view.bounds.size.height;
		
		CGRect basePosition = CGRectMake(view.layer.position.x - (width/2),
										 view.layer.position.y - (height/2),
										 width,
										 height);
		
		CGFloat layerX = -(basePosition.origin.x - CGRectGetMidX(appList.bounds))/basePosition.size.width;
		CGFloat layerY = -(basePosition.origin.y - CGRectGetMidY(appList.bounds))/basePosition.size.height;
		
		[view setCenter:CGPointMake(CGRectGetMidX(appList.bounds),
									CGRectGetMidY(appList.bounds))];
		[view.layer setAnchorPoint:CGPointMake(layerX, layerY)];
		
		[view.layer addAnimation:scale forKey:@"scale"];
		[view.layer addAnimation:opacity forKey:@"opacity"];
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxDelay + 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[appList setUserInteractionEnabled:YES];
		[[[[RSCore sharedInstance] homeScreenController] view] setUserInteractionEnabled:YES];
		
		for (UIView* view in appList.subviews) {
			if ([view isKindOfClass:[RSApp class]] || [view isKindOfClass:[RSAppListSection class]]) {
				[view setUserInteractionEnabled:YES];
				[view.layer removeAllAnimations];
				[view.layer setOpacity:1];
				[view setAlpha:1.0];
				[view setHidden:NO];
				[view.layer setAnchorPoint:CGPointMake(0.5,0.5)];
				[view setCenter:[(RSApp*)view originalCenter]];
				[(RSApp*)view setTiltEnabled:YES];
				[view setUserInteractionEnabled:YES];
			}
		}
	});
}

@end
