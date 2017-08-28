#import "Redstone.h"
#import "substrate.h"

%group lockscreen

SBPagedScrollView* dashboardScrollView;

%hook SBDashBoardScrollGestureController

- (id)initWithDashBoardView:(id)arg1 systemGestureManager:(id)arg2 {
	id r = %orig;
	
	dashboardScrollView = MSHookIvar<SBPagedScrollView*>(r, "_scrollView");
	
	return r;
}

%end // %hook SBDashBoardScrollGestureController

%hook SBPagedScrollView

- (void)layoutSubviews {
	if (self == dashboardScrollView) {
		[self setScrollEnabled:NO];
		[self setUserInteractionEnabled:NO];
		[self setContentOffset:CGPointMake(-screenWidth, 0)];
	} else {
		%orig;
	}
}

%end // %hook SBDashBoardScrollGestureController

%hook SBDashBoardViewController

- (void)startLockScreenFadeInAnimationForSource:(int)arg1 {
	[[[[RSCore sharedInstance] lockScreenController] view] reset];
	
	%orig(arg1);
}

%end // %hook SBDashBoardViewController

%hook SBDashBoardView

- (void)layoutSubviews {
	[MSHookIvar<UIView*>(self, "_pageControl") removeFromSuperview];
	[self setHidden:YES];
	
	if (![self.superview.subviews containsObject:[[[RSCore sharedInstance] lockScreenController] view]]) {
		[self.superview addSubview:[[[RSCore sharedInstance] lockScreenController] view]];
	}
	
	[self.superview bringSubviewToFront:[[[RSCore sharedInstance] lockScreenController] view]];
}

%end // %hook SBDashboardView

// iOS 10
%hook SBFLockScreenDateView

- (void)layoutSubviews {
	%orig;
	
	[MSHookIvar<SBUILegibilityLabel *>(self,"_timeLabel") removeFromSuperview];
	[MSHookIvar<SBUILegibilityLabel *>(self,"_dateSubtitleView") removeFromSuperview];
	[MSHookIvar<SBUILegibilityLabel *>(self,"_customSubtitleView") removeFromSuperview];
	
	[[[[RSCore sharedInstance] lockScreenController] view] setTime:[MSHookIvar<SBUILegibilityLabel *>(self,"_timeLabel") string]];
	[[[[RSCore sharedInstance] lockScreenController] view] setDate:[MSHookIvar<SBUILegibilityLabel *>(self,"_dateSubtitleView") string]];
}

%end // %hook SBFLockScreenDateView

%hook SBLockScreenManager

- (BOOL)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[[[RSCore sharedInstance] lockScreenController] view] reset];
		[[[[RSCore sharedInstance] lockScreenController] securityController] setCurrentLockView:nil];
	});
	
	return %orig;
}

%end // %hook SBLockScreenManager

%hook SBBacklightController

- (void)_startFadeOutAnimationFromLockSource:(int)arg1 {
	if ([[[[RSCore sharedInstance] lockScreenController] view] isScrolling] || [[[[RSCore sharedInstance] lockScreenController] view] isUnlocking]) {
		[self resetIdleTimer];
		return;
	}
	
	%orig(arg1);
}

%end // %hook SBBacklightController

%hook SBUIPasscodeLockViewBase

- (void)layoutSubviews {
	[[[[RSCore sharedInstance] lockScreenController] securityController] setCurrentLockView:self];
	%orig;
}

%end // %hook SBUIPasscodeLockViewBase

%hook SBUIPasscodeLockViewWithKeypad

- (void)passcodeEntryFieldTextDidChange:(id)arg1 {
	%log;
	[[[[[RSCore sharedInstance] lockScreenController] view] passcodeEntryView] handlePasscodeTextChanged];
	
	%orig;
}

%end // %hook SBUIPasscodeLockViewWithKeypad

%hook SBFUserAuthenticationController

-(void)_handleSuccessfulAuthentication:(id)arg1 responder:(id)arg2 {
	//[[[RSLockScreenController sharedInstance] passcodeEntryController] handleSuccessfulAuthentication];
	%orig;
}

- (void)_handleFailedAuthentication:(id)arg1 error:(id)arg2 responder:(id)arg3 {
	[[[[[RSCore sharedInstance] lockScreenController] view] passcodeEntryView] handleFailedAuthentication];
	%orig;
}

%end // %hook SBFUserAuthenticationController

%hook SBDashBoardMesaUnlockBehavior

- (void)handleBiometricEvent:(unsigned long long)arg1 {
	%orig;
	
	if(arg1 == 10) {
		[[[[[RSCore sharedInstance] lockScreenController] view] passcodeEntryView] handleFailedMesaAuthentication];
	}
}

%end // %hook SBDashBoardMesaUnlockBehavior

%end // %group lockscreen

%ctor {
	if ([[RSPreferences preferences] enabled] && [[RSPreferences preferences] lockScreenEnabled]) {
		
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			%init(lockscreen);
		}
	}
}
