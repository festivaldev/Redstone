#import "Redstone.h"

@implementation RSVolumeHUD

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor colorWithWhite:0.22 alpha:1.0]];
		[self setClipsToBounds:YES];
		[self.layer setAnchorPoint:CGPointMake(0.5, 0)];
		[self setFrame:frame];
	}
	
	return self;
}

@end
