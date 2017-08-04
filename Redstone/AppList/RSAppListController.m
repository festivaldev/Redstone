#import "../Redstone.h"

@implementation RSAppListController

- (id)init {
	if (self = [super init]) {
		self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
	}
	
	return self;
}

@end
