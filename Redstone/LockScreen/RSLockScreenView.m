#import "Redstone.h"

@implementation RSLockScreenView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[RSAesthetics colorForCurrentThemeByCategory:@"solidBackgroundColor"]];
		
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
		[wallpaperOverlay setBackgroundColor:[[RSAesthetics colorForCurrentThemeByCategory:@"solidBackgroundColor"] colorWithAlphaComponent:0.75]];
		[wallpaperOverlay setHidden:YES];
		[wallpaperOverlay setAlpha:0];
		[self addSubview:wallpaperOverlay];
		
		unlockScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[unlockScrollView setContentSize:CGSizeMake(0, screenHeight * 2)];
		[unlockScrollView setDelegate:self];
		[unlockScrollView setPagingEnabled:YES];
		[unlockScrollView setBounces:NO];
		[unlockScrollView setDelaysContentTouches:NO];
		[unlockScrollView setShowsVerticalScrollIndicator:NO];
		[unlockScrollView setShowsHorizontalScrollIndicator:NO];
		[self addSubview:unlockScrollView];
		
		wallpaperLegibilitySettings = [[objc_getClass("SBWallpaperController") sharedInstance] legibilitySettingsForVariant:0];
		
		timeAndDateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[unlockScrollView addSubview:timeAndDateView];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[timeLabel setFont:[UIFont fontWithName:@"SegoeUI-Light" size:90]];
		[timeLabel setTextColor:[wallpaperLegibilitySettings primaryColor]];
		[timeLabel sizeToFit];
		[timeAndDateView addSubview:timeLabel];
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[dateLabel setFont:[UIFont fontWithName:@"SegoeUI-Semilight" size:30]];
		[dateLabel setTextColor:[wallpaperLegibilitySettings primaryColor]];
		[dateLabel sizeToFit];
		[timeAndDateView addSubview:dateLabel];
		
		if (screenWidth < 375) {
			[timeLabel setFont:[UIFont fontWithName:@"SegoeUI-Light" size:80]];
			[dateLabel setFont:[UIFont fontWithName:@"SegoeUI-Semilight" size:24]];
		}
		
		nowPlayingControls = [[RSNowPlayingControls alloc] initWithFrame:CGRectMake(24, 40, screenWidth - 48, 120)];
		[nowPlayingControls updateWithLegibilitySettings:wallpaperLegibilitySettings];
		[timeAndDateView addSubview:nowPlayingControls];
		
		notificationArea = [[RSLockScreenNotificationArea alloc] initWithFrame:CGRectMake(20, screenHeight-180, screenWidth - 40, 180)];
		[timeAndDateView addSubview:notificationArea];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wallpaperChanged) name:@"RedstoneWallpaperChanged" object:nil];
		
		[self reset];
	}
	
	return self;
}

- (void)wallpaperChanged {
	[wallpaperView setImage:[RSAesthetics lockScreenWallpaper]];
	
	wallpaperLegibilitySettings = [[objc_getClass("SBWallpaperController") sharedInstance] legibilitySettingsForVariant:0];
	[timeLabel setTextColor:[wallpaperLegibilitySettings primaryColor]];
	[dateLabel setTextColor:[wallpaperLegibilitySettings primaryColor]];
	
	[nowPlayingControls updateWithLegibilitySettings:wallpaperLegibilitySettings];
	[notificationArea wallpaperChanged];
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
	
	[wallpaperOverlay setHidden:![[[[RSCore sharedInstance] lockScreenController] securityController] deviceIsPasscodeLocked]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.isScrolling = NO;
	
	if (scrollView.contentOffset.y >= scrollView.frame.size.height) {
		if ([[[[RSCore sharedInstance] lockScreenController] securityController] deviceIsPasscodeLocked]) {
			self.isUnlocking = YES;
			
			if ([[objc_getClass("SBLockScreenManager") sharedInstance] respondsToSelector:@selector(_setPasscodeVisible:animated:)]) {
				[[objc_getClass("SBLockScreenManager") sharedInstance] _setPasscodeVisible:YES animated:NO];
			}
		} else {
			[(SBLockScreenManager*)[objc_getClass("SBLockScreenManager") sharedInstance] attemptUnlockWithPasscode:nil];
		}
	} else {
		self.isUnlocking = NO;
	}
}

- (UIScrollView*)unlockScrollView {
	return unlockScrollView;
}

- (RSLockScreenNotificationArea*)notificationArea {
	return notificationArea;
}

- (UIView<RSPasscodeLockViewKeypadDelegate>*)passcodeKeyboard {
	return passcodeKeyboard;
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
	[attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:8.0] range:[time rangeOfString:@":"]];
	
	[timeLabel setAttributedText:attributedString];
	[timeLabel sizeToFit];
	[timeLabel setFrame:CGRectMake(21, screenHeight - timeLabel.frame.size.height - 115 - (notificationArea.isShowingDetailedStatus ? 100 : 0), timeLabel.frame.size.width, timeLabel.frame.size.height)];
}

- (void)setDate:(NSString *)date {
	[dateLabel setText:date];
	[dateLabel sizeToFit];
	[dateLabel setFrame:CGRectMake(21, screenHeight - dateLabel.frame.size.height - 80 - (notificationArea.isShowingDetailedStatus ? 100 : 0), dateLabel.frame.size.width, dateLabel.frame.size.height)];
}

- (void)reset {
	self.isScrolling = NO;
	self.isUnlocking = NO;
	
	[nowPlayingControls updateNowPlayingInfo];
	[unlockScrollView setContentOffset:CGPointZero];
	[wallpaperView setAlpha:1.0];
	
	if ([[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsPasscodeLocked]) {
		if ([[objc_getClass("SBLockScreenManager") sharedInstance] respondsToSelector:@selector(_setPasscodeVisible:animated:)]) {
			[[objc_getClass("SBLockScreenManager") sharedInstance] _setPasscodeVisible:YES animated:NO];
		}
	}
	
	[self updatePasscodeKeyboard];
}

- (void)notificationsUpdated {
	[timeLabel setFrame:CGRectMake(21, screenHeight - timeLabel.frame.size.height - 115 - (notificationArea.isShowingDetailedStatus ? 100 : 0), timeLabel.frame.size.width, timeLabel.frame.size.height)];
	[dateLabel setFrame:CGRectMake(21, screenHeight - dateLabel.frame.size.height - 80 - (notificationArea.isShowingDetailedStatus ? 100 : 0), dateLabel.frame.size.width, dateLabel.frame.size.height)];
}

//- (void)setStockPasscodeKeyboard:(SBPasscodeKeyboard *)stockPasscodeKeyboard {
//	if (_stockPasscodeKeyboard) {
//		[_stockPasscodeKeyboard removeFromSuperview];
//	}
//	
//	_stockPasscodeKeyboard = stockPasscodeKeyboard;
//	[passcodeKeyboard addSubview:stockPasscodeKeyboard];
//}

- (void)updatePasscodeKeyboard {
	RSPasscodeLockViewType passcodeLockViewType = [[RSLockScreenSecurityController sharedInstance] passcodeLockViewType];
	
	if (passcodeLockViewType == RSPasscodeLockViewTypeNone || ![[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsPasscodeLocked]) {
		[passcodeKeyboard removeFromSuperview];
		passcodeKeyboard = nil;
		return;
	}
	
	//if (!passcodeKeyboard || [passcodeKeyboard passcodeLockViewType] != passcodeLockViewType) {
		if (passcodeKeyboard) {
			[passcodeKeyboard removeFromSuperview];
		}
	
		if (passcodeLockViewType == RSPasscodeLockViewTypeFixedDigit) {
			passcodeKeyboard = [[RSPasscodeLockViewSimpleFixedDigitKeypad alloc] initWithFrame:CGRectMake(0, screenHeight*2 - 415, screenWidth, 415)];
		} else if (passcodeLockViewType == RSPasscodeLockViewTypeLongNumeric) {
			passcodeKeyboard = [[RSPasscodeLockViewLongNumericKeypad alloc] initWithFrame:CGRectMake(0, screenHeight*2 - 415, screenWidth, 415)];
		} else if (passcodeLockViewType == RSPasscodeLockViewTypeAlphanumeric) {
			CGRect keyboardFrame = [[objc_getClass("SBPasscodeKeyboard") storedPasscodeKeyboard] frame];
			
			[[objc_getClass("SBPasscodeKeyboard") storedPasscodeKeyboard] removeFromSuperview];
			passcodeKeyboard = [[RSPasscodeLockViewAlphanumericKeyboard alloc] initWithFrame:CGRectMake(0, screenHeight*2 - (keyboardFrame.size.height + 60), screenWidth, keyboardFrame.size.height + 60) passcodeKeyboard:[objc_getClass("SBPasscodeKeyboard") storedPasscodeKeyboard]];
		}
		
		[unlockScrollView addSubview:passcodeKeyboard];
	//}
	
	if ([passcodeKeyboard respondsToSelector:@selector(setPasscodeText:)]) {
		[passcodeKeyboard setPasscodeText:@""];
	}
}

- (void)handlePasscodeTextChanged {
	[passcodeKeyboard setPasscodeText:[[objc_getClass("SBUIPasscodeLockViewBase") currentPasscodeView] passcode]];
}

@end
