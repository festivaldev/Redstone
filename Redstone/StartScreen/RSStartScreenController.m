#import "../Redstone.h"

@implementation RSStartScreenController

- (id)init {
	if (self = [super init]) {
		self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		
		pinnedTiles = [NSMutableArray new];
		pinnedIdentifiers = [NSMutableArray new];
	}
	
	return self;
}

#pragma mark Tile Management

- (void)loadTiles {}

- (void)saveTiles {}

@end
