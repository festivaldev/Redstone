#import "Redstone.h"

@implementation RSLockScreenView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor blackColor]];
		
		if ([[RSCore sharedInstance] homeScreenController]) {
			fakeHomeScreenWallpaperView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
			[fakeHomeScreenWallpaperView setImage:[RSAesthetics homeScreenWallpaper]];
			[fakeHomeScreenWallpaperView setContentMode:UIViewContentModeScaleAspectFill];
			
			CGPoint parallaxPosition = [[[[RSCore sharedInstance] homeScreenController] wallpaperView] parallaxPosition];
			[fakeHomeScreenWallpaperView setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(parallaxPosition.x, parallaxPosition.y))];
			[self addSubview:fakeHomeScreenWallpaperView];
		}
		
		wallpaperView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[wallpaperView setImage:[RSAesthetics lockScreenWallpaper]];
		[wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
		[self addSubview:wallpaperView];
		
		wallpaperOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[wallpaperOverlay setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
		[wallpaperOverlay setHidden:YES];
		[wallpaperOverlay setAlpha:0];
		[self addSubview:wallpaperOverlay];
		
		unlockScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[unlockScrollView setContentSize:CGSizeMake(0, screenHeight * 2)];
		[unlockScrollView setDelegate:self];
		[unlockScrollView setPagingEnabled:YES];
		[unlockScrollView setBounces:NO];
		[unlockScrollView setDelaysContentTouches:NO];
		[self addSubview:unlockScrollView];
		
		timeAndDateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[unlockScrollView addSubview:timeAndDateView];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[timeLabel setFont:[UIFont fontWithName:@"SegoeUI-Light" size:75]];
		[timeLabel setTextColor:[UIColor whiteColor]];
		[timeLabel sizeToFit];
		[timeAndDateView addSubview:timeLabel];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[dateLabel setFont:[UIFont fontWithName:@"SegoeUI-Semilight" size:24]];
		[dateLabel setTextColor:[UIColor whiteColor]];
		[dateLabel sizeToFit];
		[timeAndDateView addSubview:dateLabel];
		
		nowPlayingControls = [[RSNowPlayingControls alloc] initWithFrame:CGRectMake(24, 40, screenWidth - 48, 120)];
		[timeAndDateView addSubview:nowPlayingControls];
	}
	
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	self.isScrolling = YES;
	
	CGFloat alpha = 1 - MIN(scrollView.contentOffset.y / (scrollView.bounds.size.height * 0.6), 1);
	[timeAndDateView setAlpha:alpha];
	[wallpaperOverlay setAlpha:1-alpha];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([[RSCore sharedInstance] homeScreenController]) {
		CGPoint parallaxPosition = [[[[RSCore sharedInstance] homeScreenController] wallpaperView] parallaxPosition];
		[fakeHomeScreenWallpaperView setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(parallaxPosition.x, parallaxPosition.y))];
	}
	
	//[wallpaperOverlay setHidden:![[[[RSCore sharedInstance] lockScreenController] securityController] deviceIsPasscodeLocked]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.isScrolling = NO;
	
	if (scrollView.contentOffset.y >= scrollView.frame.size.height) {
		self.isUnlocking = YES;
		
		[(SBLockScreenManager*)[objc_getClass("SBLockScreenManager") sharedInstance] attemptUnlockWithPasscode:nil];
	} else {
		self.isUnlocking = NO;
	}
}

- (UIScrollView*)unlockScrollView {
	return unlockScrollView;
}

- (void)setContentOffset:(CGPoint)contentOffset {
	[unlockScrollView setContentOffset:contentOffset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
	[unlockScrollView setContentOffset:contentOffset animated:animated];
}

- (CGPoint)contentOffset {
	return [unlockScrollView contentOffset];
}

- (void)setTime:(NSString *)time {
	NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:time];
	[attributedString addAttributes:@{
									  NSBaselineOffsetAttributeName: @8.0
									  }range:[time rangeOfString:@":"]];
	
	[timeLabel setAttributedText:attributedString];
	[timeLabel sizeToFit];
	[timeLabel setFrame:CGRectMake(21, screenHeight - timeLabel.frame.size.height - (140 - 42), timeLabel.frame.size.width, timeLabel.frame.size.height)];
}

- (void)setDate:(NSString *)date {
	[dateLabel setText:date];
	[dateLabel sizeToFit];
	[dateLabel setFrame:CGRectMake(21, screenHeight - dateLabel.frame.size.height - (110 - 42), dateLabel.frame.size.width, dateLabel.frame.size.height)];
}

- (void)reset {
	self.isScrolling = NO;
	self.isUnlocking = NO;
	
	[nowPlayingControls updateNowPlayingInfo];
	[unlockScrollView setContentOffset:CGPointZero];
	[wallpaperView setAlpha:1.0];
}

@end
