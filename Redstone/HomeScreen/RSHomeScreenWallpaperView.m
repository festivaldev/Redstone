#import "Redstone.h"

@implementation RSHomeScreenWallpaperView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setImage:[RSAesthetics homeScreenWallpaper]];
	}
	
	return self;
}

- (void)setHorizontalParallax:(CGFloat)progress {
	
}

- (void)setVerticalParallax:(CGFloat)progress {
	
}

@end
