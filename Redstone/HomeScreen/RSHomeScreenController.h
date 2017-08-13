#import <UIKit/UIKit.h>

@class RSHomeScreenWallpaperView, RSHomeScreenScrollView, RSStartScreenController, RSAppListController, RSLaunchScreenController;

@interface RSHomeScreenController : NSObject <UIScrollViewDelegate> {
	RSHomeScreenWallpaperView* wallpaperView;
	RSHomeScreenScrollView* homeScreenScrollView;
	
	RSStartScreenController* startScreenController;
	RSAppListController* appListController;
	RSLaunchScreenController* launchScreenController;
}

@property (nonatomic, strong) UIView* view;

- (RSHomeScreenWallpaperView*)wallpaperView;
- (RSStartScreenController*)startScreenController;
- (RSAppListController*)appListController;
- (RSLaunchScreenController*)launchScreenController;

- (void)deviceHasBeenUnlocked;
- (CGFloat)launchApplication;

- (void)setScrollEnabled:(BOOL)scrollEnabled;
- (BOOL)isScrollEnabled;
- (void)setContentOffset:(CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (CGPoint)contentOffset;

@end
