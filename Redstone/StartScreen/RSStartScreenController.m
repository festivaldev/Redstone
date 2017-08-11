#import "Redstone.h"

@implementation RSStartScreenController

- (id)init {
	if (self = [super init]) {
		self.view = [[RSStartScreenScrollView alloc] initWithFrame:CGRectMake(4, 0, screenWidth-8, screenHeight)];
		
		pinnedTiles = [NSMutableArray new];
		pinnedIdentifiers = [NSMutableArray new];
		
		[self loadTiles];
	}
	
	return self;
}

#pragma mark Tile Management

- (void)loadTiles {
	NSArray* tileLayout = [[RSPreferences preferences] objectForKey:[NSString stringWithFormat:@"%iColumnLayout", 3]];
	
	CGFloat sizeForPosition = [RSMetrics sizeForPosition];
	
	for (int i=0; i<tileLayout.count; i++) {
		SBLeafIcon* icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:[tileLayout objectAtIndex:i][@"bundleIdentifier"]];
		
		if (icon && [icon applicationBundleID] && ![[icon applicationBundleID] isEqualToString:@""]) {
			CGSize tileSize = [RSMetrics tileDimensionsForSize:[[tileLayout objectAtIndex:i][@"size"] intValue]];
			CGRect tileFrame = CGRectMake(sizeForPosition * [[tileLayout objectAtIndex:i][@"column"] intValue],
										  sizeForPosition * [[tileLayout objectAtIndex:i][@"row"] intValue],
										  tileSize.width,
										  tileSize.height);
			
			RSTile* tile = [[RSTile alloc] initWithFrame:tileFrame
													size:[[tileLayout objectAtIndex:i][@"size"] intValue]
										bundleIdentifier:[tileLayout objectAtIndex:i][@"bundleIdentifier"]];
			
			[pinnedTiles addObject:tile];
			[pinnedIdentifiers addObject:[tileLayout objectAtIndex:i][@"bundleIdentifier"]];
			[self.view addSubview:tile];
		}
	}
	 
	[self updateStartScreenContentSize];
}

- (void)saveTiles {}

- (void)updateStartScreenContentSize {
	if (pinnedTiles.count < 1) {
		[self.view setContentSize:CGSizeMake(self.view.bounds.size.width, 0)];
		return;
	}
	
	RSTile* lastTile = [pinnedTiles objectAtIndex:0];
	for (RSTile* tile in pinnedTiles) {
		CGRect lastTileFrame = lastTile.frame;
		CGRect currentTileFrame = tile.frame;
		
		if (currentTileFrame.origin.y > lastTileFrame.origin.y || (currentTileFrame.origin.y == lastTileFrame.origin.y && currentTileFrame.size.height > lastTileFrame.size.height)) {
			lastTile = tile;
		}
	}
	
	CGSize contentSize = CGSizeMake(self.view.bounds.size.width, lastTile.frame.origin.y + lastTile.frame.size.height);
	
	if (contentSize.height > screenHeight) {
		[UIView animateWithDuration:.1 animations:^{
			[self.view setContentSize:contentSize];
		}];
	} else {
		[self.view setContentSize:contentSize];
	}
}

#pragma mark Editing Mode

- (void)setIsEditing:(BOOL)isEditing {
	if (!_isEditing && isEditing) {
		AudioServicesPlaySystemSound(1520);
	}
	
	_isEditing = isEditing;
	[[RSCore.sharedInstance homeScreenController] setScrollEnabled:!isEditing];
	
	if (isEditing) {
		[UIView animateWithDuration:.2 animations:^{
			[self.view setEasingFunction:easeOutQuint forKeyPath:@"frame"];
			
			[self.view setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
		} completion:^(BOOL finished) {
			[self.view removeEasingFunctionForKeyPath:@"frame"];
		}];
	} else {
		[self setSelectedTile:nil];
		
		[UIView animateWithDuration:.2 animations:^{
			[self.view setEasingFunction:easeOutQuint forKeyPath:@"frame"];
			
			[self.view setTransform:CGAffineTransformIdentity];
		} completion:^(BOOL finished) {
			[self.view removeEasingFunctionForKeyPath:@"frame"];
		}];
	}
}

- (void)setSelectedTile:(RSTile*)selectedTile {
	_selectedTile = selectedTile;
	for (RSTile* tile in pinnedTiles) {
		[tile setIsSelectedTile:(tile == selectedTile)];
	}
}

- (void)snapTile:(RSTile*)tile withTouchPosition:(CGPoint)touchPosition {
	CGFloat step = [RSMetrics sizeForPosition];
	CGFloat maxPositionX = self.view.bounds.size.width - tile.basePosition.size.width;
	CGFloat maxPositionY = self.view.contentSize.height + [RSMetrics tileBorderSpacing];
	
	CGPoint newCenter = CGPointMake(MIN(MAX(step * roundf(tile.basePosition.origin.x / step), 0), maxPositionX) + tile.basePosition.size.width/2,
									MIN(MAX(step * roundf(tile.basePosition.origin.y / step), 0), maxPositionY) + tile.basePosition.size.height/2);
	
	[tile setNextCenterUpdate:newCenter];
	[tile setNextFrameUpdate:CGRectMake(newCenter.x - (tile.basePosition.size.width/2),
										newCenter.y - (tile.basePosition.size.height/2),
										tile.basePosition.size.width,
										tile.basePosition.size.height)];
	
	[self moveAffectedTilesForTile:tile];
}

- (void)moveAffectedTilesForTile:(RSTile *)movedTile {
	// This algorithm is based on Daniel T.'s answer here:
	// http://stackoverflow.com/questions/43825803/get-all-uiviews-affected-by-moving-another-uiview-above-them/
	
	pinnedTiles = [self sortPinnedTiles];
	
	NSMutableArray* stack = [NSMutableArray new];
	BOOL didMoveTileIntoPosition = NO;
	
	[stack addObject:movedTile];
	
	while ([stack count] > 0) {
		RSTile* current = [stack objectAtIndex:0];
		[stack removeObject:current];
		
		for (RSTile* tile in pinnedTiles) {
			if (tile != movedTile && CGRectIntersectsRect(tile.basePosition, movedTile.nextFrameUpdate) && tile.basePosition.origin.y < movedTile.nextFrameUpdate.origin.y && !didMoveTileIntoPosition) {
				CGFloat moveDistance = (CGRectGetMaxY(tile.basePosition) - CGRectGetMinY(movedTile.nextFrameUpdate)) + [RSMetrics tileBorderSpacing];
				
				CGPoint newCenter = CGPointMake(movedTile.nextCenterUpdate.x,
												movedTile.nextCenterUpdate.y + moveDistance);
				
				[movedTile setNextCenterUpdate:newCenter];
				[movedTile setNextFrameUpdate:CGRectMake(newCenter.x - movedTile.basePosition.size.width/2,
														 newCenter.y - movedTile.basePosition.size.height/2,
														 movedTile.basePosition.size.width,
														 movedTile.basePosition.size.height)];
				
				didMoveTileIntoPosition = YES;
			} else if (tile != current) {
				CGRect currentFrame, tileFrame;
				if (!CGRectEqualToRect(current.nextFrameUpdate, CGRectZero)) {
					currentFrame = current.nextFrameUpdate;
				} else {
					currentFrame = current.basePosition;
				}
				
				if (!CGRectEqualToRect(tile.nextFrameUpdate, CGRectZero)) {
					tileFrame = tile.nextFrameUpdate;
				} else {
					tileFrame = tile.basePosition;
				}
				
				if (CGRectIntersectsRect(currentFrame, tileFrame)) {
					[stack addObject:tile];
					
					CGFloat moveDistance = (CGRectGetMaxY(currentFrame) - CGRectGetMinY(tileFrame)) + [RSMetrics tileBorderSpacing];
					
					CGPoint newCenter = CGPointMake(CGRectGetMidX(tileFrame),
													CGRectGetMidY(tileFrame) + moveDistance);
					
					[tile setNextCenterUpdate:newCenter];
					[tile setNextFrameUpdate:CGRectMake(newCenter.x - tile.basePosition.size.width/2,
														newCenter.y - tile.basePosition.size.height/2,
														tile.basePosition.size.width,
														tile.basePosition.size.height)];
				}
			}
		}
	}
	
	[self eliminateEmptyRows];
}

- (void)eliminateEmptyRows {
	pinnedTiles = [self sortPinnedTiles];
	
	CGFloat sizeForPosition = [RSMetrics sizeForPosition];
	
	for (RSTile* tile in pinnedTiles) {
		CGRect tileFrame;
		
		if (!CGRectEqualToRect(tile.nextFrameUpdate, CGRectZero)) {
			tileFrame = tile.nextFrameUpdate;
		} else {
			tileFrame = tile.basePosition;
		}
		
		int yPosition = tileFrame.origin.y / sizeForPosition;
		for (int i=0; i<yPosition; i++) {
			CGRect testFrame = CGRectMake(tileFrame.origin.x,
										  i * sizeForPosition,
										  tileFrame.size.width,
										  tileFrame.origin.y - (i * sizeForPosition));
			
			BOOL canSetFrame = YES;
			for (RSTile* view in pinnedTiles) {
				if (view != tile) {
					CGRect viewFrame;
					if (!CGRectEqualToRect(view.nextFrameUpdate, CGRectZero)) {
						viewFrame = view.nextFrameUpdate;
					} else {
						viewFrame = view.basePosition;
					}
					
					if (CGRectIntersectsRect(testFrame, viewFrame)) {
						canSetFrame = NO;
						break;
					}
				}
			}
			
			if (canSetFrame) {
				CGPoint newCenter = CGPointMake(CGRectGetMidX(tileFrame),
												CGRectGetMidY(tileFrame) - testFrame.size.height);
				
				[tile setNextCenterUpdate:newCenter];
				[tile setNextFrameUpdate:CGRectMake(newCenter.x - tile.basePosition.size.width/2,
													newCenter.y - tile.basePosition.size.height/2,
													tile.basePosition.size.width,
													tile.basePosition.size.height)];
				
				break;
			}
		}
	}
	
	[self applyPendingFrameUpdates];
}

- (void)applyPendingFrameUpdates {
	[UIView animateWithDuration:.3 animations:^{
		for (RSTile* tile in pinnedTiles) {
			if (!CGPointEqualToPoint(tile.nextCenterUpdate, CGPointZero)) {
				[tile setEasingFunction:easeOutQuint forKeyPath:@"frame"];
				[tile setCenter:tile.nextCenterUpdate];
			}
		}
	} completion:^(BOOL finished) {
		for (RSTile* tile in pinnedTiles) {
			[tile removeEasingFunctionForKeyPath:@"frame"];
			[tile setOriginalCenter:tile.center];
			
			[tile setNextCenterUpdate:CGPointZero];
			[tile setNextFrameUpdate:CGRectZero];
		}
	}];
	
	[self updateStartScreenContentSize];
}

- (NSMutableArray*)sortPinnedTiles {
	pinnedIdentifiers = [NSMutableArray new];
	
	NSArray* sortedTiles = [pinnedTiles sortedArrayUsingComparator:^NSComparisonResult(RSTile* tile1, RSTile* tile2) {
		CGRect firstTileFrame, secondTileFrame;
		
		if (!CGRectEqualToRect(tile1.nextFrameUpdate, CGRectZero)) {
			firstTileFrame = tile1.nextFrameUpdate;
		} else {
			firstTileFrame = tile1.basePosition;
		}
		
		if (!CGRectEqualToRect(tile2.nextFrameUpdate, CGRectZero)) {
			secondTileFrame = tile2.nextFrameUpdate;
		} else {
			secondTileFrame = tile2.basePosition;
		}
		
		if (firstTileFrame.origin.y == secondTileFrame.origin.y) {
			return [[NSNumber numberWithFloat:firstTileFrame.origin.x] compare:[NSNumber numberWithFloat:secondTileFrame.origin.x]];
		} else {
			return [[NSNumber numberWithFloat:firstTileFrame.origin.y] compare:[NSNumber numberWithFloat:secondTileFrame.origin.y]];
		}
	}];
	
	for (RSTile* tile in sortedTiles) {
		[pinnedIdentifiers addObject:[tile.icon applicationBundleID]];
	}
	
	return [sortedTiles mutableCopy];
}

@end
