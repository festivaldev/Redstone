#import "Redstone.h"

@implementation RSAudioController

- (id)init {
	if (self = [super init]) {
		if ([[[RSPreferences preferences] objectForKey:@"volumeControlsEnabled"] boolValue]) {
			audioVideoController = [objc_getClass("AVSystemController") sharedAVSystemController];
			
			[audioVideoController getVolume:&ringerVolume forCategory:@"Ringtone"];
			[audioVideoController getVolume:&mediaVolume forCategory:@"Audio/Video"];
			
			if ([[objc_getClass("SBMediaController") sharedInstance]  isRingerMuted]) {
				ringerVolume = 0.0;
			}
			
			self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
			[self.window setRootViewController:self];
			[self.window setWindowLevel:2200];
			[self.window setClipsToBounds:YES];
		}
	}
	
	return self;
}

- (void)viewDidLoad {
	volumeHUD = [[RSVolumeHUD alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
	[self.view addSubview:volumeHUD];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:nil completion:^(id context) {
		[UIView setAnimationsEnabled:YES];
	}];
	[UIView setAnimationsEnabled:NO];
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (float)mediaVolume {
	return mediaVolume;
}

- (void)setMediaVolume:(float)_mediaVolume {
	mediaVolume = _mediaVolume;
}

- (float)ringerVolume {
	return ringerVolume;
}

- (void)setRingerVolume:(float)_ringerVolume {
	ringerVolume = _ringerVolume;
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
		
		SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
		
		if (frontApp) {
			[[UIDevice currentDevice] setValue:[NSNumber numberWithLongLong:[frontApp statusBarOrientation]] forKey:@"orientation"];
			
			if ([frontApp statusBarOrientation] == UIDeviceOrientationPortrait || [frontApp statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown) {
				[self.window setFrame:CGRectMake(0, 0, screenWidth, 100)];
				[self.view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
				[volumeHUD setFrame:CGRectMake(0, self.view.frame.origin.y, screenWidth, self.view.frame.size.height)];
			} else {
				[self.window setFrame:CGRectMake(0, 0, screenHeight, 100)];
				[self.view setFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
				[volumeHUD setFrame:CGRectMake(0, self.view.frame.origin.y, screenHeight, self.view.frame.size.height)];
			}
		} else {
			[[UIDevice currentDevice] setValue:[NSNumber numberWithInt:1] forKey:@"orientation"];
			[self.window setFrame:CGRectMake(0, 0, screenWidth, 100)];
			[self.view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
			[volumeHUD setFrame:CGRectMake(0, self.view.frame.origin.y, screenWidth, self.view.frame.size.height)];
		}
		
		[UIView setAnimationsEnabled:YES];
		[volumeHUD appear];
		[volumeHUD resetAnimationTimer];
	} else if ([volumeHUD isVisible]) {
		[volumeHUD resetAnimationTimer];
	}
}

- (void)hideVolumeHUD {
	[volumeHUD disappear];
}

- (BOOL)isShowingVolumeHUD {
	return [volumeHUD isVisible];
}

- (void)volumeIncreasedForCategory:(NSString*)category volumeValue:(float)volumeValue {
	if (![self isShowingVolumeHUD]) {
		[volumeHUD updateVolumeValues];
		[self displayHUDIfPossible];
		return;
	}
	
	if ([category isEqualToString:@"Ringtone"]) {
		if ([[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked]) {
			return;
		}
		
		if (ringerVolume == 0.0) {
			ringerVolume = 1.0/16.0;
			
			[[objc_getClass("SBMediaController") sharedInstance] setRingerMuted:NO];
			[audioVideoController setVolumeTo:ringerVolume forCategory:@"Ringtone"];
		} else {
			ringerVolume = volumeValue;
		}
	} else if ([category isEqualToString:@"Audio/Video"]) {
		mediaVolume = volumeValue;
	}

	[self displayHUDIfPossible];
	[volumeHUD updateVolumeValues];
}

- (void)volumeDecreasedForCategory:(NSString*)category volumeValue:(float)volumeValue {
	if (![self isShowingVolumeHUD]) {
		[self displayHUDIfPossible];
		[volumeHUD updateVolumeValues];
		return;
	}
	
	if ([category isEqualToString:@"Ringtone"]) {
		if ([[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked]) {
			return;
		}
		
		if (volumeValue == 1.0/16.0 && (ringerVolume == volumeValue || ringerVolume == 0.0)) {
			ringerVolume = 0.0;
			
			[[objc_getClass("SBMediaController") sharedInstance] setRingerMuted:YES];
			[audioVideoController setVolumeTo:ringerVolume forCategory:@"Ringtone"];
		} else {
			ringerVolume = volumeValue;
		}
	} else if ([category isEqualToString:@"Audio/Video"]) {
		mediaVolume = volumeValue;
	}
	
	[self displayHUDIfPossible];
	[volumeHUD updateVolumeValues];
}

- (void)nowPlayingInfoDidChange {
	if (volumeHUD) {
		[audioVideoController getVolume:&ringerVolume forCategory:@"Ringtone"];
		[audioVideoController getVolume:&mediaVolume forCategory:@"Audio/Video"];
		
		if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted]) {
			ringerVolume = 0.0;
		}
		
		BOOL isShowingHeadphones = [[audioVideoController attributeForKey:@"AVSystemController_HeadphoneJackIsConnectedAttribute"] boolValue];
		[volumeHUD setIsShowingHeadphoneVolume:isShowingHeadphones];
	}
	
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		isPlaying = [[(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoPlaybackRate"] boolValue];
		artist = [(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoArtist"];
		title = [(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoTitle"];
		album = [(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoAlbum"];
		
		artwork = [UIImage imageWithData:[(__bridge NSDictionary*)information objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"]];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneNowPlayingUpdateFinished" object:nil];
		
		if (volumeHUD) {
			if (!isPlaying && !artwork) {
				[volumeHUD setIsShowingNowPlayingControls:NO];
			} else {
				[volumeHUD setIsShowingNowPlayingControls:YES];
			}
		}
	});
}

#pragma mark Now Playing Info

- (BOOL)isPlaying {
	return isPlaying;
}

- (UIImage*)artwork {
	return artwork;
}

- (NSString*)artist {
	return artist;
}

- (NSString*)title {
	return title;
}

- (NSString*)album {
	return album;
}

@end
