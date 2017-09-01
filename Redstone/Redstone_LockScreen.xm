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
	});
	
	return %orig;
}

%end // %hook SBLockScreenManager

%hook SBBacklightController

- (void)_startFadeOutAnimationFromLockSource:(int)arg1 {
	return;
	/*if ([[[[RSCore sharedInstance] lockScreenController] view] isScrolling] || [[[[RSCore sharedInstance] lockScreenController] view] isUnlocking]) {
		[self resetIdleTimer];
		return;
	}
	
	%orig(arg1);*/
}

- (double)defaultLockScreenDimInterval {
	return -1;
}
- (void)_lockScreenDimTimerFired {
	return;
}

%end // %hook SBBacklightController

%hook SBApplication

- (void)setBadge:(id)arg1 {
	%orig(arg1);
	
	[[[[[RSCore sharedInstance] lockScreenController] view] notificationArea] setBadgeForApp:[self bundleIdentifier] value:[arg1 intValue]];
}

%end // %hook SBApplication

%end // %group lockscreen

%ctor {
	if ([[[RSPreferences preferences] objectForKey:@"enabled"] boolValue] && [[[RSPreferences preferences] objectForKey:@"lockScreenEnabled"] boolValue]) {
		
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			%init(lockscreen);
		}
	}
}
