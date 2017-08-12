#import "Redstone.h"

@implementation RSHomeScreenScrollView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setContentSize:CGSizeMake(screenWidth*2, screenHeight)];
		[self setPagingEnabled:YES];
		[self setBounces:NO];
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
	}
	
	return self;
}

@end
