#import <UIKit/UIKit.h>

@class RSHomeScreenWallpaperView, RSHomeScreenScrollView, RSStartScreenController, RSAppListController;

@interface RSHomeScreenController : NSObject {
	RSHomeScreenWallpaperView* wallpaperView;
	RSHomeScreenScrollView* homeScreenScrollView;
	
	RSStartScreenController* startScreenController;
	RSAppListController* appListController;
}

@property (nonatomic, strong) UIView* view;

- (RSHomeScreenWallpaperView*)wallpaperView;
- (RSStartScreenController*)startScreenController;
- (RSAppListController*)appListController;
- (void)setScrollEnabled:(BOOL)scrollEnabled;

@end
