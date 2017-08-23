#import "Redstone.h"

RSCore* redstone;
RSPreferences* preferences;

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

- (void)initialButtonUp:(id)arg1 {
	if ([redstone homeButtonPressed]) {
		//%orig;
	}
	%orig;
}

%end // %hook SBHomeHardwareButton

%end // %group core

%ctor {
	preferences = [RSPreferences new];
	
	if ([[[RSPreferences preferences] objectForKey:@"enabled"] boolValue]) {
		%init(core);
	}
}
