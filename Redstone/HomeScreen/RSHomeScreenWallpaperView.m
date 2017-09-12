#import "Redstone.h"

@implementation RSHomeScreenWallpaperView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setImage:[RSAesthetics homeScreenWallpaper]];
		[self setBackgroundColor:[RSAesthetics colorForCurrentThemeByCategory:@"solidBackgroundColor"]];
		[self setContentMode:UIViewContentModeScaleAspectFill];
		[self setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
	}
	
	return self;
}

- (void)calculateHorizontalParallax {
	CGFloat viewPosition = [[[[RSCore sharedInstance] homeScreenController] homeScreenScrollView] contentOffset].x;
	
	horizontalParallaxPosition = -(MIN(viewPosition / screenWidth, 0.5) * ((screenWidth * 1.5) - screenWidth));
	[self setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(horizontalParallaxPosition, verticalParallaxPosition))];
}

- (void)calculateVerticalParallax {
	CGFloat viewPosition = [[[[[RSCore sharedInstance] homeScreenController] startScreenController] view] contentOffset].y;
	CGFloat viewHeight = MAX([[[[[RSCore sharedInstance] homeScreenController] startScreenController] view] contentSize].height, screenHeight);
	
	verticalParallaxPosition = -((viewPosition / viewHeight) * ((screenWidth * 1.5) - screenWidth));
	[self setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(horizontalParallaxPosition, verticalParallaxPosition))];
}

- (CGPoint)parallaxPosition {
	return CGPointMake(horizontalParallaxPosition, verticalParallaxPosition);
}

@end
