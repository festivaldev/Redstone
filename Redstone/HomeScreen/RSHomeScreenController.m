#import "Redstone.h"

@implementation RSHomeScreenController

- (id)init {
	if (self = [super init]) {
		self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		
		wallpaperView = [[RSHomeScreenWallpaperView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[self.view addSubview:wallpaperView];
		
		homeScreenScrollView = [[RSHomeScreenScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[homeScreenScrollView setDelegate:self];
		[self.view addSubview:homeScreenScrollView];
		
		startScreenController = [RSStartScreenController new];
		[homeScreenScrollView addSubview:startScreenController.view];
		
		appListController = [RSAppListController new];
		[homeScreenScrollView addSubview:appListController.view];
		
		launchScreenController = [[RSLaunchScreenController alloc] init];
	}
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat progress = scrollView.contentOffset.x / scrollView.bounds.size.width;
	
	[homeScreenScrollView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:MIN(progress, 0.75)]];
	[wallpaperView setHorizontalParallax:progress];
	
	[appListController setSectionOverlayAlpha:MIN(progress, 0.75)];
	[appListController updateSectionsWithOffset:appListController.view.contentOffset.y];
}

- (RSHomeScreenWallpaperView*)wallpaperView {
	return wallpaperView;
}

- (RSStartScreenController*)startScreenController {
	return startScreenController;
}

- (RSAppListController*)appListController {
	return appListController;
}

- (RSLaunchScreenController*)launchScreenController {
	return launchScreenController;
}

- (CGFloat)launchApplication {
	if (homeScreenScrollView.contentOffset.x < screenWidth/2) {
		[RSAnimation startScreenAnimateOut];
		
		return [RSAnimation startScreenAnimationDelay];
	} else if (homeScreenScrollView.contentOffset.x > screenWidth/2) {
		[RSAnimation appListAnimateOut];
		
		return [RSAnimation appListAnimationDelay];
	}
	
	return 0;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
	[homeScreenScrollView setScrollEnabled:scrollEnabled];
}

- (BOOL)isScrollEnabled {
	return [homeScreenScrollView isScrollEnabled];
}

- (void)setContentOffset:(CGPoint)contentOffset {
	[homeScreenScrollView setContentOffset:contentOffset];
}

- (CGPoint)contentOffset {
	return [homeScreenScrollView contentOffset];
}

@end
