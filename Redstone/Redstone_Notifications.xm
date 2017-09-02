#import "Redstone.h"

%group notifications

// iOS 10
%hook SBNotificationBannerWindow

- (id)initWithFrame:(CGRect)arg1 {
	self = %orig(CGRectZero);
	return self;
}

- (void)setFrame:(CGRect)arg1 {
	%orig(CGRectZero);
}

- (CGRect)frame {
	return CGRectZero;
}

%end // %hook SBNotificationBannerWindow

// iOS 9
%hook SBBannerContainerView

- (id)initWithFrame:(CGRect)arg1 {
	self = %orig(CGRectZero);
	//[self setHidden:YES];
	return self;
}

- (void)setFrame:(CGRect)arg1 {
	%orig(CGRectZero);
	//[self setHidden:YES];
}

- (CGRect)frame {
	return CGRectZero;
}

- (void)setHidden:(BOOL)arg1 {
	%orig(YES);
}

%end // %hook SBBannerContainerView

%hook BBServer

- (void)_addBulletin:(BBBulletin*)arg1 {
	%orig;
	
	if ([[RSCore sharedInstance] notificationController]) {
		[[[RSCore sharedInstance] notificationController] addBulletin:arg1];
	}
}

- (void)_removeBulletin:(BBBulletin*)arg1 rescheduleTimerIfAffected:(BOOL)arg2 shouldSync:(BOOL)arg3 {
	%orig;
	
	if ([[RSCore sharedInstance] notificationController]) {
		[[[RSCore sharedInstance] notificationController] removeBulletin:arg1];
	}
}

%end // %hook BBServer

%hook SBLockScreenManager

- (BOOL)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
	if ([[RSCore sharedInstance] notificationController]) {
		[[[RSCore sharedInstance] notificationController] clearBulletins];
	}
	
	return %orig;
}

%end // %hook SBLockScreenManager

%hook SBBulletinBannerController

%new
- (id)observer {
	return MSHookIvar<BBObserver*>(self, "_observer");
}

%end // %hook SBBulletinBannerController

%end // %group notifications

%ctor {
	if ([[[RSPreferences preferences] objectForKey:@"notificationsEnabled"] boolValue] || [[[RSPreferences preferences] objectForKey:@"lockScreenEnabled"] boolValue]) {
		
		%init(notifications);
	}
}
