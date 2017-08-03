#import "../Redstone.h"

@implementation RSHomeScreenScrollView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setContentSize:CGSizeMake(screenWidth*2, screenHeight)];
		[self setDelegate:self];
		[self setPagingEnabled:YES];
		[self setBounces:NO];
		[self setShowsVerticalScrollIndicator:NO];
	}
	
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat progress = MIN(scrollView.contentOffset.x / scrollView.bounds.size.width, 0.75);
	[scrollView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:progress]];
}

@end
