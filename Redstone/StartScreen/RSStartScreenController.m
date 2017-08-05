#import "../Redstone.h"

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
	
	CGFloat sizeForPosition = [RSMetrics tileDimensionsForSize:1].width + [RSMetrics tileBorderSpacing];
	
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
			[tile setBackgroundColor:[UIColor greenColor]];
			
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

@end
