#import "Redstone.h"

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
	CGFloat progress = scrollView.contentOffset.x / scrollView.bounds.size.width;
	
	[scrollView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:MIN(progress, 0.75)]];
	[[[[RSCore sharedInstance] homeScreenController] wallpaperView] setHorizontalParallax:progress];
}

@end
