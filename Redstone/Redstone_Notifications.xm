#import "Redstone.h"
#import "substrate.h"

%group notifications

%hook BBServer

- (void)_addBulletin:(BBBulletin*)arg1 {
	%orig;
}

- (void)_removeBulletin:(BBBulletin*)arg1 rescheduleTimerIfAffected:(BOOL)arg2 shouldSync:(BOOL)arg3 {
	%orig;
	
	if ([[RSCore sharedInstance] notificationController]) {
		[[[RSCore sharedInstance] notificationController] removeBulletin:arg1];
	}
}

%end	// %hook BBServer

%hook SBLockScreenManager

- (BOOL)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
	if ([[RSCore sharedInstance] notificationController]) {
		[[[RSCore sharedInstance] notificationController] clearBulletins];
	}
	
	return %orig;
}

%end	// %hook SBLockScreenManager

%hook SBBulletinBannerController

-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 {
	%orig;
}

%new
- (id)observer {
	return MSHookIvar<BBObserver*>(self, "_observer");
}

%end	// %hook SBBulletinBannerController

%hook NCNotificationDispatcher

- (void)postNotificationWithRequest:(NCNotificationRequest*)arg1 {
	%orig;
	
	NSArray* bulletinDestinations = [[arg1 requestDestinations] allObjects];
	
	if (bulletinDestinations.count > 1 && [[RSCore sharedInstance] notificationController]) {
		[[[RSCore sharedInstance] notificationController] addBulletin:[arg1 bulletin]];
	}
}

%end	// %hook NCNotificationDispatcher

%end	// %group notifications



%group notifications_visuals

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

%end	// %hook SBNotificationBannerWindow

// iOS 9
%hook SBBannerContainerView

- (id)initWithFrame:(CGRect)arg1 {
	self = %orig(CGRectZero);
	[self setHidden:YES];
	return self;
}

- (void)setFrame:(CGRect)arg1 {
	%orig(CGRectZero);
	[self setHidden:YES];
}

- (CGRect)frame {
	return CGRectZero;
}

- (void)setHidden:(BOOL)arg1 {
	%orig(YES);
}

%end	// %hook SBBannerContainerView

%end	// %group notifications_visuals

%ctor {
	if ([[[RSPreferences preferences] objectForKey:@"enabled"] boolValue]) {
		if (([[[RSPreferences preferences] objectForKey:@"notificationsEnabled"] boolValue] || [[[RSPreferences preferences] objectForKey:@"lockScreenEnabled"] boolValue])) {
			
			%init(notifications);
		}
		
		if ([[[RSPreferences preferences] objectForKey:@"notificationsEnabled"] boolValue]) {
			%init(notifications_visuals);
		}
	}
}
