#import "../Redstone.h"

@implementation RSStartScreenController

- (id)init {
	if (self = [super init]) {
		self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 0, screenWidth-8, screenHeight)];
		[self.view setContentInset:UIEdgeInsetsMake(24, 0, 70, 0)];
		[self.view setContentOffset:CGPointMake(0, -24)];
		
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
		CGSize tileSize = [RSMetrics tileDimensionsForSize:[[tileLayout objectAtIndex:i][@"size"] intValue]];
		CGRect tileFrame = CGRectMake(sizeForPosition * [[tileLayout objectAtIndex:i][@"column"] intValue],
									  sizeForPosition * [[tileLayout objectAtIndex:i][@"row"] intValue],
									  tileSize.width,
									  tileSize.height);
		
		UIView* tile = [[UIView alloc] initWithFrame:tileFrame];
		[tile setBackgroundColor:[UIColor greenColor]];
		[self.view addSubview:tile];
	}
}

- (void)saveTiles {}

@end
