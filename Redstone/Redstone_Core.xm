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

%end // %group core

%ctor {
	id preferences = [[RSPreferences alloc] init];
	
	if ([[preferences objectForKey:@"enabled"] boolValue]) {
		%init(core);
	}
}
