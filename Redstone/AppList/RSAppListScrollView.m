#import "Redstone.h"

@implementation RSAppListScrollView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setClipsToBounds:YES];
		[self setContentInset:UIEdgeInsetsMake(0, 0, 80, 0)];
		//[self setDelaysContentTouches:NO];
		[self setShowsVerticalScrollIndicator:NO];
		[self setShowsHorizontalScrollIndicator:NO];
	}
	
	return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
	return YES;
}

@end
