#import <UIKit/UIKit.h>

@class _UILegibilitySettings, RSTiltView;

@interface RSStartScreenScrollView : UIScrollView {
	_UILegibilitySettings* wallpaperLegibilitySettings;
}

@property (nonatomic, strong) RSTiltView* allAppsButton;

@end
