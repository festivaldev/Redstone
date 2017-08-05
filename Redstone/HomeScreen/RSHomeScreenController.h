#import <UIKit/UIKit.h>

@class RSHomeScreenScrollView, RSStartScreenController, RSAppListController;

@interface RSHomeScreenController : NSObject {
	UIView* wallpaperView;
	RSHomeScreenScrollView* homeScreenScrollView;
	
	RSStartScreenController* startScreenController;
	RSAppListController* appListController;
}

@property (nonatomic, strong) UIView* view;

- (RSStartScreenController*)startScreenController;

@end
