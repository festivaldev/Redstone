#import "Redstone.h"

@implementation RSVolumeHUD

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor colorWithWhite:0.22 alpha:1.0]];
		[self setClipsToBounds:YES];
		[self.layer setAnchorPoint:CGPointMake(0.5, 0)];
		[self setFrame:frame];
		
		ringerVolumeView = [[RSVolumeView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100) forCategory:@"Ringtone"];
		[self addSubview:ringerVolumeView];
	}
	
	return self;
}

- (void)appear {
	self.isVisible = YES;
	[self setFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
	
	[UIView animateWithDuration:0.3 animations:^{
		[self setEasingFunction:easeOutCubic forKeyPath:@"frame"];
		[self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	} completion:^(BOOL finished) {
		[self removeEasingFunctionForKeyPath:@"frame"];
	}];
}

- (void)disappear {
	[self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	[UIView animateWithDuration:0.3 animations:^{
		[self setEasingFunction:easeInCubic forKeyPath:@"frame"];
		[self setFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
	} completion:^(BOOL finished) {
		[self removeEasingFunctionForKeyPath:@"frame"];
		self.isVisible = NO;
		
		[self.superview setHidden:YES];
	}];
}

- (void)resetAnimationTimer {
	[animationTimer invalidate];
	animationTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(disappear) userInfo:nil repeats:NO];
}

@end
