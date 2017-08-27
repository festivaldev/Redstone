#import "Redstone.h"

%group volume

%hook SBVolumeHUDView

- (void)layoutSubviews {
	%orig;
	[self setHidden:YES];
}

%end // %hook SBVolumeHUDView

%hook VolumeControl

- (void)increaseVolume {
	%orig;
	
	float currentVolume;
	NSString* categoryName;
	[[%c(AVSystemController) sharedAVSystemController] getActiveCategoryVolume:&currentVolume andName:&categoryName];
	
	[[[RSCore sharedInstance] audioController] volumeIncreasedForCategory:categoryName volumeValue:currentVolume];
}

- (void)decreaseVolume {
	%orig;
	
	float currentVolume;
	NSString* categoryName;
	[[%c(AVSystemController) sharedAVSystemController] getActiveCategoryVolume:&currentVolume andName:&categoryName];
	
	[[[RSCore sharedInstance] audioController] volumeDecreasedForCategory:categoryName volumeValue:currentVolume];
}

- (float)volumeStepUp {
	if ([[[RSCore sharedInstance] audioController] canDisplayHUD] && ![[[RSCore sharedInstance] audioController] isShowingVolumeHUD]) {
		return 0;
	}
	
	return %orig;
}

- (float)volumeStepDown {
	if ([[[RSCore sharedInstance] audioController] canDisplayHUD] && ![[[RSCore sharedInstance] audioController] isShowingVolumeHUD]) {
		return 0;
	}
	
	return %orig;
}

%end // %hook VolumeControl

%hook SBMediaController

- (void)_nowPlayingInfoChanged {
	%orig;
	
	[[[RSCore sharedInstance] audioController] nowPlayingInfoDidChange];
}

- (void)_nowPlayingAppIsPlayingDidChange {
	%orig;
	
	[[[RSCore sharedInstance] audioController] nowPlayingInfoDidChange];
}

%end // %hook SBMediaController

static void AVHeadphonesConnectedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[[RSCore sharedInstance] audioController] nowPlayingInfoDidChange];
}

%end // %group volume

%ctor {
	if ([[RSPreferences preferences] enabled] && [[RSPreferences preferences] volumeControlsEnabled]) {
		%init(volume);
		
		CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &AVHeadphonesConnectedNotification, CFSTR("AVSystemController_HeadphoneJackIsConnectedDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	}
}
