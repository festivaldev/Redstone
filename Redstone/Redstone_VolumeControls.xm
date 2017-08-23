#import "Redstone.h"

%group volume

%hook VolumeControl

- (void)increaseVolume {
	%orig;
	
	NSString* categoryName;
	[[%c(AVSystemController) sharedAVSystemController] getActiveCategoryVolume:nil andName:&categoryName];
	
	[[[RSCore sharedInstance] audioController] volumeIncreasedForCategory:categoryName];
}

- (void)decreaseVolume {
	%orig;
	
	NSString* categoryName;
	[[%c(AVSystemController) sharedAVSystemController] getActiveCategoryVolume:nil andName:&categoryName];
	
	[[[RSCore sharedInstance] audioController] volumeDecreasedForCategory:categoryName];
}

- (float)volumeStepUp {
	/*if (![[RSSoundController sharedInstance] isShowingVolumeHUD]) {
		return 0;
	}*/
	
	return %orig;
}

- (float)volumeStepDown {
	/*if (![[RSSoundController sharedInstance] isShowingVolumeHUD]) {
		return 0;
	}*/
	
	return %orig;
}

%end // %hook VolumeControl

%end // %group volume

%ctor {
	if ([[[RSPreferences preferences] objectForKey:@"enabled"] boolValue] && [[[RSPreferences preferences] objectForKey:@"volumeControlsEnabled"] boolValue]) {
		%init(volume);
	}
}
