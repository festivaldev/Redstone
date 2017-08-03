#import <UIKit/UIKit.h>

@class RSHomeScreenScrollView;

@interface RSHomeScreenController : NSObject {
	UIView* wallpaperView;
	RSHomeScreenScrollView* homeScreenScrollView;
}

@property (nonatomic, retain) UIView* view;

@end
