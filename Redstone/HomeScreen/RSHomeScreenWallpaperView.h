#import <UIKit/UIKit.h>

@interface RSHomeScreenWallpaperView : UIImageView {
	CGFloat horizontalParallaxPosition;
	CGFloat verticalParallaxPosition;
}

- (void)calculateHorizontalParallax;
- (void)calculateVerticalParallax;
- (CGPoint)parallaxPosition;

@end
