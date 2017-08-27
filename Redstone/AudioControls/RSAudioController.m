#import "Redstone.h"

@implementation RSAudioController

- (id)init {
	if (self = [super init]) {
		if ([[RSPreferences preferences] volumeControlsEnabled]) {
			audioVideoController = [objc_getClass("AVSystemController") sharedAVSystemController];
			
			[audioVideoController getVolume:&ringerVolume forCategory:@"Ringtone"];
			[audioVideoController getVolume:&mediaVolume forCategory:@"Audio/Video"];
			
			if ([[objc_getClass("SBMediaController") sharedInstance]  isRingerMuted]) {
				ringerVolume = 0.0;
			}
			
			self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
			[self.window setWindowLevel:2200];
			
			volumeHUD = [[RSVolumeHUD alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
			[self.window addSubview:volumeHUD];
		}
	}
	
	return self;
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
	NSLog(@"[Redstone] volume increased for %@ (volume at %f)", category, volumeValue);
	
	if ([category isEqualToString:@"Ringtone"]) {
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

	[volumeHUD updateVolumeValues];
	[self displayHUDIfPossible];
}

- (void)volumeDecreasedForCategory:(NSString*)category volumeValue:(float)volumeValue {
	NSLog(@"[Redstone] volume decreased for %@ (volume at %f)", category, volumeValue);
	
	if ([category isEqualToString:@"Ringtone"]) {
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
	
	[volumeHUD updateVolumeValues];
	[self displayHUDIfPossible];
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
