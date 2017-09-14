#import "Redstone.h"

RSCore* redstone;
BOOL isAllowedToPressHomeButton = YES;

%group core

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;
	
	redstone = [[RSCore alloc] initWithWindow:[[%c(SBUIController) sharedInstance] window]];
}

// iOS 9
- (void)_handleMenuButtonEvent {
	if ([redstone homeButtonPressed]) {
		//%orig;
	}
	%orig;
}

%end // %hook SpringBoard

// iOS 10
%hook SBHomeHardwareButton

- (void)singlePressUp:(id)arg1 {
	if (isAllowedToPressHomeButton) {
		%orig;
	}
}

- (void)initialButtonUp:(id)arg1 {
	isAllowedToPressHomeButton = [redstone homeButtonPressed];
	%orig;
}

%end // %hook SBHomeHardwareButton

%hook SBWallpaperController

- (void)_handleWallpaperChangedForVariant:(int)arg1 {
	%orig(arg1);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneWallpaperChanged" object:nil];
}

%end // %hook SBWallpaperController

static void DeviceLockedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneDeviceLocked" object:nil];
}

static void SettingsChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneSettingsChanged" object:nil];
}

static void AccentColorChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneAccentColorChanged" object:nil];
}

static void WallpaperChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneWallpaperChanged" object:nil];
}

%end // %group core

%ctor {
	id preferences = [[RSPreferences alloc] init];
	
	if ([[preferences objectForKey:@"enabled"] boolValue]) {
		%init(core);
		
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, DeviceLockedCallback, CFSTR("com.apple.springboard.lockcomplete"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, SettingsChangedCallback, CFSTR("ml.festival.redstone.PreferencesChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, AccentColorChangedCallback, CFSTR("ml.festival.redstone.AccentColorChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, WallpaperChangedCallback, CFSTR("ml.festival.redstone.WallpaperChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}
