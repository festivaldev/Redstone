#import "Redstone.h"

@implementation RSHomeScreenController

- (id)init {
	if (self = [super init]) {
		self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		
		wallpaperView = [[RSHomeScreenWallpaperView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[self.view addSubview:wallpaperView];
		
		homeScreenScrollView = [[RSHomeScreenScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[self.view addSubview:homeScreenScrollView];
		
		startScreenController = [RSStartScreenController new];
		[homeScreenScrollView addSubview:startScreenController.view];
		
		appListController = [RSAppListController new];
		[homeScreenScrollView addSubview:appListController.view];
		
		launchScreenController = [[RSLaunchScreenController alloc] init];
	}
	return self;
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
		
	}
	
	return 0;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
	[homeScreenScrollView setScrollEnabled:scrollEnabled];
}

- (void)setContentOffset:(CGPoint)contentOffset {
	[homeScreenScrollView setContentOffset:contentOffset];
}

@end
