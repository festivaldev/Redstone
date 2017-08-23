#import "Redstone.h"

@implementation RSAudioController

- (id)init {
	if (self = [super init]) {
		audioVideoController = [objc_getClass("MPVolumeController") new];
		[audioVideoController setVolumeAudioCategory:@"Audio/Video"];
		
		ringerController = [objc_getClass("MPVolumeController") new];
		[ringerController setVolumeAudioCategory:@"Ringtone"];
		
		self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
		[self.window setWindowLevel:2200];
		
		volumeHUD = [[RSVolumeHUD alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
		[self.window addSubview:volumeHUD];
	}
	
	return self;
}

- (BOOL)canDisplayHUD {
	if ([[objc_getClass("SpringBoard") sharedApplication] _isDim]) {
		return NO;
	}
	
	if (![[objc_getClass("VolumeControl") sharedVolumeControl] _HUDIsDisplayableForCategory:nil]) {
		return NO;
	}
	
	if ([volumeHUD isVisible]) {
		return NO;
	}
	
	return YES;
	// return NO;
}

- (void)displayHUDIfPossible {
	if ([self canDisplayHUD]) {
		[self.window makeKeyAndVisible];
		[volumeHUD appear];
		[volumeHUD resetAnimationTimer];
	} else if ([volumeHUD isVisible]) {
		[volumeHUD resetAnimationTimer];
	}
}

- (void)volumeIncreasedForCategory:(NSString*)category {
	NSLog(@"[Redstone] volume increased for %@", category);
	
	[self displayHUDIfPossible];
}

- (void)volumeDecreasedForCategory:(NSString*)category {
	NSLog(@"[Redstone] volume decreased for %@", category);
	
	[self displayHUDIfPossible];
}

@end
