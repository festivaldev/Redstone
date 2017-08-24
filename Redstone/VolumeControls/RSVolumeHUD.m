#import "Redstone.h"

@implementation RSVolumeHUD

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor colorWithWhite:0.22 alpha:1.0]];
		[self setClipsToBounds:YES];
		[self.layer setAnchorPoint:CGPointMake(0.5, 0)];
		[self setFrame:frame];
		
		ringerVolumeView = [[RSVolumeView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100) forCategory:@"Ringtone"];
		[self addSubview:ringerVolumeView];
		
		ringerSlider = [[RSSlider alloc] initWithFrame:CGRectMake(screenWidth/2 - 280/2, 37, 280, 24)];
		[ringerSlider addTarget:self action:@selector(ringerVolumeChanged) forControlEvents:UIControlEventValueChanged];
		[ringerVolumeView addSubview:ringerSlider];
		
		ringerMuteButton = [[RSTiltView alloc] initWithFrame:CGRectMake(10, 31, 36, 36)];
		[ringerMuteButton.titleLabel setTextColor:[UIColor whiteColor]];
		[ringerMuteButton.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:24]];
		[ringerMuteButton setHighlightEnabled:YES];
		[ringerMuteButton addTarget:self action:@selector(toggleRingerMuted)];
		[ringerVolumeView addSubview:ringerMuteButton];
		
		mediaVolumeView = [[RSVolumeView alloc] initWithFrame:CGRectMake(0, 110, screenWidth, 100) forCategory:@"Audio/Video"];
		[self addSubview:mediaVolumeView];
		
		mediaSlider = [[RSSlider alloc] initWithFrame:CGRectMake(screenWidth/2 - 280/2, 37, 280, 24)];
		[mediaSlider addTarget:self action:@selector(mediaVolumeChanged) forControlEvents:UIControlEventValueChanged];
		[mediaVolumeView addSubview:mediaSlider];
		
		mediaMuteButton = [[RSTiltView alloc] initWithFrame:CGRectMake(10, 31, 36, 36)];
		[mediaMuteButton.titleLabel setTextColor:[UIColor whiteColor]];
		[mediaMuteButton.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:24]];
		[mediaMuteButton setHighlightEnabled:YES];
		[mediaMuteButton addTarget:self action:@selector(toggleMediaMuted)];
		[mediaVolumeView addSubview:mediaMuteButton];
		
		headphoneVolumeView = [[RSVolumeView alloc] initWithFrame:CGRectMake(0, 110, screenWidth, 100) forCategory:@"Headphones"];
		[self addSubview:headphoneVolumeView];
		
		headphoneSlider = [[RSSlider alloc] initWithFrame:CGRectMake(screenWidth/2 - 280/2, 37, 280, 24)];
		[headphoneSlider addTarget:self action:@selector(mediaVolumeChanged) forControlEvents:UIControlEventValueChanged];
		[headphoneVolumeView addSubview:headphoneSlider];
		
		headphoneMuteButton = [[RSTiltView alloc] initWithFrame:CGRectMake(10, 31, 36, 36)];
		[headphoneMuteButton.titleLabel setTextColor:[UIColor whiteColor]];
		[headphoneMuteButton.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:24]];
		[headphoneMuteButton setTitle:@"\uE7F6"];
		[headphoneMuteButton setUserInteractionEnabled:NO];
		[headphoneVolumeView addSubview:headphoneMuteButton];
		
		extendButton = [[RSTiltView alloc] initWithFrame:CGRectMake(self.frame.size.width - 46, 10, 36, 18)];
		[extendButton setTiltEnabled:NO];
		[extendButton.titleLabel setTextColor:[UIColor whiteColor]];
		[extendButton.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:18]];
		[extendButton setTitle:@"\uE70D"];
		[extendButton addTarget:self action:@selector(toggleExtended)];
		[self addSubview:extendButton];
		
		vibrationButton = [UIButton buttonWithType:UIButtonTypeSystem];
		[vibrationButton addTarget:self action:@selector(toggleVibrationEnabled) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:vibrationButton];
		[self updateVibrateButtonStatus];
		
		nowPlayingControls = [[RSNowPlayingControls alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 120)];
		[self addSubview:nowPlayingControls];
		[nowPlayingControls setHidden:YES];
	}
	
	return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	[self resetAnimationTimer];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	[self resetAnimationTimer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	[self resetAnimationTimer];
}

- (void)updateVolumeValues {
	[ringerVolumeView setVolumeValue:[[[RSCore sharedInstance] audioController] ringerVolume]];
	[ringerSlider setValue:[[[RSCore sharedInstance] audioController] ringerVolume]];
	
	if ([[[RSCore sharedInstance] audioController] ringerVolume] >= 1.0/16.0) {
		[ringerMuteButton setTitle:@"\uEA8F"];
	} else {
		if ([self getVibrationEnabled]) {
			[ringerMuteButton setTitle:@"\uE877"];
		} else {
			[ringerMuteButton setTitle:@"\uE7ED"];
		}
	}
	
	[mediaVolumeView setVolumeValue:[[[RSCore sharedInstance] audioController] mediaVolume]];
	[mediaSlider setValue:[[[RSCore sharedInstance] audioController] mediaVolume]];
	
	if ([[[RSCore sharedInstance] audioController] mediaVolume] >= 1.0/16.0) {
		[mediaMuteButton setTitle:@"\uE767"];
	} else {
		[mediaMuteButton setTitle:@"\uE74F"];
	}
	
	[headphoneVolumeView setVolumeValue:[[[RSCore sharedInstance] audioController] mediaVolume]];
	[headphoneSlider setValue:[[[RSCore sharedInstance] audioController] mediaVolume]];
}

#pragma mark Animations

- (void)appear {
	self.isExtended = NO;
	self.isVisible = YES;
	[self setFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
	
	[UIView animateWithDuration:0.3 animations:^{
		[self setEasingFunction:easeOutCubic forKeyPath:@"frame"];
		[self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	} completion:^(BOOL finished) {
		[self removeEasingFunctionForKeyPath:@"frame"];
	}];
}

- (void)disappear {
	[animationTimer invalidate];
	animationTimer = nil;
	self.isVisible = NO;
	
	[self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	[UIView animateWithDuration:0.3 animations:^{
		[self setEasingFunction:easeInCubic forKeyPath:@"frame"];
		[self setFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
	} completion:^(BOOL finished) {
		[self removeEasingFunctionForKeyPath:@"frame"];
		
		[self.superview setHidden:YES];
	}];
}

- (void)resetAnimationTimer {
	[animationTimer invalidate];
	animationTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(disappear) userInfo:nil repeats:NO];
}

- (void)toggleExtended {
	[self resetAnimationTimer];
	[self setIsExtended:!self.isExtended];
}

- (void)setIsExtended:(BOOL)isExtended {
	_isExtended = isExtended;
	
	if (isExtended) {
		if (self.isShowingHeadphoneVolume) {
			[mediaVolumeView setHidden:YES];
			[headphoneVolumeView setHidden:NO];
		} else {
			[mediaVolumeView setHidden:NO];
			[headphoneVolumeView setHidden:YES];
		}
		
		if (self.isShowingNowPlayingControls) {
			[nowPlayingControls setHidden:YES];
			[extendButton setFrame:CGRectMake(self.frame.size.width - 46, 162, 36, 18)];
			[vibrationButton setFrame:CGRectMake(10, 110, vibrationButton.frame.size.width, 18)];
		} else {
			[extendButton setFrame:CGRectMake(self.frame.size.width - 46, 216, 36, 18)];
			[vibrationButton setFrame:CGRectMake(10, 216, vibrationButton.frame.size.width, 18)];
		}
		
		[extendButton setTransform:CGAffineTransformMakeRotation(deg2rad(180))];
		
		[vibrationButton setHidden:NO];
	} else {
		if (self.isShowingNowPlayingControls) {
			if (self.isShowingHeadphoneVolume) {
				[mediaVolumeView setHidden:YES];
				[headphoneVolumeView setHidden:NO];
			} else {
				[mediaVolumeView setHidden:NO];
				[headphoneVolumeView setHidden:YES];
			}
			
			[nowPlayingControls setHidden:NO];
			[vibrationButton setHidden:YES];
		} else {
			[mediaVolumeView setHidden:YES];
			[headphoneVolumeView setHidden:YES];
		}
		
		[extendButton setFrame:CGRectMake(self.frame.size.width - 46, 10, 36, 18)];
		[extendButton setTransform:CGAffineTransformIdentity];
	}
	
	if (self.isVisible) {
		[UIView animateWithDuration:0.25 animations:^{
			[self setEasingFunction:easeOutExpo forKeyPath:@"frame"];
			
			if (self.isShowingNowPlayingControls) {
				if (self.isExtended) {
					[self setBounds:CGRectMake(0, 0, screenWidth, 190)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 190)];
				} else {
					[self setBounds:CGRectMake(0, 0, screenWidth, 220)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 220)];
				}
			} else {
				if (self.isExtended) {
					[self setBounds:CGRectMake(0, 0, screenWidth, 244)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 244)];
				} else {
					[self setBounds:CGRectMake(0, 0, screenWidth, 100)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 100)];
				}
			}
		} completion:^(BOOL finished){
			[self removeEasingFunctionForKeyPath:@"frame"];
		}];
	} else {
		if (self.isShowingNowPlayingControls) {
			if (self.isExtended) {
				[self setBounds:CGRectMake(0, 0, screenWidth, 190)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 190)];
			} else {
				[self setBounds:CGRectMake(0, 0, screenWidth, 220)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 220)];
			}
		} else {
			if (self.isExtended) {
				[self setBounds:CGRectMake(0, 0, screenWidth, 244)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 244)];
			} else {
				[self setBounds:CGRectMake(0, 0, screenWidth, 100)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 100)];
			}
		}
	}
}

- (void)setIsShowingNowPlayingControls:(BOOL)isShowingNowPlayingControls {
	_isShowingNowPlayingControls = isShowingNowPlayingControls;
	
	if (isShowingNowPlayingControls) {
		[ringerVolumeView setHidden:YES];
		[nowPlayingControls setHidden:self.isExtended];
		
		[mediaVolumeView setFrame:CGRectMake(0, 0, screenWidth, 100)];
		[headphoneVolumeView setFrame:CGRectMake(0, 0, screenWidth, 100)];
		
		if (self.isShowingHeadphoneVolume) {
			[mediaVolumeView setHidden:YES];
			[headphoneVolumeView setHidden:NO];
		} else {
			[mediaVolumeView setHidden:NO];
			[headphoneVolumeView setHidden:YES];
		}
	} else {
		[ringerVolumeView setHidden:NO];
		[nowPlayingControls setHidden:YES];
		
		[mediaVolumeView setFrame:CGRectMake(0, 110, screenWidth, 100)];
		[headphoneVolumeView setFrame:CGRectMake(0, 110, screenWidth, 100)];
	}
	
	if (self.isVisible) {
		[UIView animateWithDuration:0.25 animations:^{
			[self setEasingFunction:easeOutExpo forKeyPath:@"frame"];
			
			if (self.isShowingNowPlayingControls) {
				if (self.isExtended) {
					[self setBounds:CGRectMake(0, 0, screenWidth, 190)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 190)];
				} else {
					[self setBounds:CGRectMake(0, 0, screenWidth, 220)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 220)];
				}
			} else {
				if (self.isExtended) {
					[self setBounds:CGRectMake(0, 0, screenWidth, 244)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 244)];
				} else {
					[self setBounds:CGRectMake(0, 0, screenWidth, 100)];
					[self.superview setFrame:CGRectMake(0, 0, screenWidth, 100)];
				}
			}
		} completion:^(BOOL finished) {
			[self removeEasingFunctionForKeyPath:@"frame"];
		}];
	} else {
		if (self.isShowingNowPlayingControls) {
			if (self.isExtended) {
				[self setBounds:CGRectMake(0, 0, screenWidth, 190)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 190)];
			} else {
				[self setBounds:CGRectMake(0, 0, screenWidth, 220)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 220)];
			}
		} else {
			if (self.isExtended) {
				[self setBounds:CGRectMake(0, 0, screenWidth, 244)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 244)];
			} else {
				[self setBounds:CGRectMake(0, 0, screenWidth, 100)];
				[self.superview setFrame:CGRectMake(0, 0, screenWidth, 100)];
			}
		}
	}
}

- (void)setIsShowingHeadphoneVolume:(BOOL)isShowingHeadphoneVolume {
	_isShowingHeadphoneVolume = isShowingHeadphoneVolume;
	
	if (isShowingHeadphoneVolume) {
		[mediaVolumeView setHidden:YES];
		[headphoneVolumeView setHidden:NO];
	} else {
		[mediaVolumeView setHidden:NO];
		[headphoneVolumeView setHidden:YES];
	}
	
	[self updateVolumeValues];
}

#pragma mark Volume Change

- (void)ringerVolumeChanged {
	[self resetAnimationTimer];
	
	float ringerVolume = [[NSString stringWithFormat:@"%.04f", [ringerSlider currentValue]] floatValue];
	ringerVolume = roundf(ringerVolume * 16) / 16;
	
	if (ringerVolume >= 1.0/16.0) {
		[ringerMuteButton setTitle:@"\uEA8F"];
		
		[[objc_getClass("SBMediaController") sharedInstance] setRingerMuted:NO];
		[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:ringerVolume forCategory:@"Ringtone"];
	} else {
		if ([self getVibrationEnabled]) {
			[ringerMuteButton setTitle:@"\uE877"];
		} else {
			[ringerMuteButton setTitle:@"\uE7ED"];
		}
		
		[[objc_getClass("SBMediaController") sharedInstance] setRingerMuted:YES];
		[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:0.0 forCategory:@"Ringtone"];
	}
	
	[ringerVolumeView setVolumeValue:ringerVolume];
	[[[RSCore sharedInstance] audioController] setRingerVolume:ringerVolume];
}

- (void)mediaVolumeChanged {
	[self resetAnimationTimer];
	
	float mediaVolume = [[NSString stringWithFormat:@"%.04f", [mediaSlider currentValue]] floatValue];
	mediaVolume = roundf(mediaVolume * 16) / 16;
	
	[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:mediaVolume forCategory:@"Audio/Video"];
	if (mediaVolume >= 1.0/16.0) {
		[mediaMuteButton setTitle:@"\uE767"];
	} else {
		[mediaMuteButton setTitle:@"\uE74F"];
	}
	
	[mediaVolumeView setVolumeValue:mediaVolume];
	[[[RSCore sharedInstance] audioController] setMediaVolume:mediaVolume];
}

- (void)headphoneVolumeChanged {
	[self resetAnimationTimer];
	
	float headphoneVolume = [[NSString stringWithFormat:@"%.04f", [headphoneSlider currentValue]] floatValue];
	headphoneVolume = roundf(headphoneVolume * 16) / 16;
	
	[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:headphoneVolume forCategory:@"Headphones"];
	
	[headphoneVolumeView setVolumeValue:headphoneVolume];
	[[[RSCore sharedInstance] audioController] setMediaVolume:headphoneVolume];
}

#pragma mark Vibration

- (BOOL)getVibrationEnabled {
	if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted]) {
		BOOL silentVibrate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"silent-vibrate"] boolValue];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:silentVibrate] forKey:@"ring-vibrate"];
		
		return silentVibrate;
	} else {
		BOOL ringerVibrate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ring-vibrate"] boolValue];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:ringerVibrate] forKey:@"silent-vibrate"];
		
		return ringerVibrate;
	}
	
	return NO;
}

- (void)toggleVibrationEnabled {
	[self resetAnimationTimer];
	
	if ([[objc_getClass("SBMediaController") sharedInstance] isRingerMuted]) {
		BOOL silentVibrate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"silent-vibrate"] boolValue];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!silentVibrate] forKey:@"silent-vibrate"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!silentVibrate] forKey:@"slient-vibrate"];
		
	} else {
		BOOL ringerVibrate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ring-vibrate"] boolValue];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!ringerVibrate] forKey:@"ring-vibrate"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!ringerVibrate] forKey:@"ring-vibrate"];
	}
	
	[self updateVibrateButtonStatus];
	[self updateVolumeValues];
}

- (void)updateVibrateButtonStatus {
	[vibrationButton setFrame:CGRectMake(10, 214, self.frame.size.width/2 - 10, 20)];
	
	[UIView performWithoutAnimation:^{
		if ([self getVibrationEnabled]) {
			NSString* baseString = [NSString stringWithFormat:@"\uE877 %@", [RSAesthetics localizedStringForKey:@"VIBRATE_ENABLED"]];
			NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
			
			[attributedString addAttributes:@{
											  NSFontAttributeName:[UIFont fontWithName:@"SegoeMDL2Assets" size:14],
											  NSForegroundColorAttributeName: [RSAesthetics accentColor],
											  NSBaselineOffsetAttributeName: @-3.0
											  } range:[baseString rangeOfString:@"\uE877"]];
			[attributedString addAttributes:@{
											  NSFontAttributeName:[UIFont fontWithName:@"SegoeUI" size:14],
											  NSForegroundColorAttributeName: [RSAesthetics accentColor]
											  } range:[baseString rangeOfString:[RSAesthetics localizedStringForKey:@"VIBRATE_ENABLED"]]];
			[vibrationButton setAttributedTitle:attributedString forState:UIControlStateNormal];
		} else {
			NSString* baseString = [NSString stringWithFormat:@"\uE877 %@", [RSAesthetics localizedStringForKey:@"VIBRATE_DISABLED"]];
			NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
			
			[attributedString addAttributes:@{
											  NSFontAttributeName:[UIFont fontWithName:@"SegoeMDL2Assets" size:14],
											  NSForegroundColorAttributeName: [UIColor whiteColor],
											  NSBaselineOffsetAttributeName: @-3.0
											  } range:[baseString rangeOfString:@"\uE877"]];
			[attributedString addAttributes:@{
											  NSFontAttributeName:[UIFont fontWithName:@"SegoeUI" size:14],
											  NSForegroundColorAttributeName: [UIColor whiteColor]
											  } range:[baseString rangeOfString:[RSAesthetics localizedStringForKey:@"VIBRATE_DISABLED"]]];
			[vibrationButton setAttributedTitle:attributedString forState:UIControlStateNormal];
		}
		
		[vibrationButton layoutIfNeeded];
	}];
	
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.apple.springboard.silent-vibrate.changed"), NULL, NULL, TRUE);
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.apple.springboard.ring-vibrate.changed"), NULL, NULL, TRUE);
	
	[vibrationButton sizeToFit];
	
	if (self.isShowingNowPlayingControls) {
		[vibrationButton setFrame:CGRectMake(10, 110, vibrationButton.frame.size.width, 18)];
	} else {
		[vibrationButton setFrame:CGRectMake(10, 216, vibrationButton.frame.size.width, 18)];
	}
}

#pragma mark Mute Buttons

- (void)toggleRingerMuted {
	[self resetAnimationTimer];
	SBMediaController* mediaController = [objc_getClass("SBMediaController") sharedInstance];
	
	if ([mediaController isRingerMuted]) {
		[mediaController setRingerMuted:NO];
		[[[RSCore sharedInstance] audioController] setRingerVolume:1.0/16.0];
		[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:1.0/16.0 forCategory:@"Ringtone"];
	} else {
		[mediaController setRingerMuted:YES];
		[[[RSCore sharedInstance] audioController] setRingerVolume:0.0];
		[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:0.0 forCategory:@"Ringtone"];
	}
	
	[self updateVolumeValues];
}

- (void)toggleMediaMuted {
	[self resetAnimationTimer];
	
	if ([[[RSCore sharedInstance] audioController] mediaVolume] >= 1.0/16.0) {
		[[[RSCore sharedInstance] audioController] setMediaVolume:0.0];
		[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:0.0 forCategory:@"Audio/Video"];
	} else {
		[[[RSCore sharedInstance] audioController] setMediaVolume:1.0/16.0];
		[[objc_getClass("AVSystemController") sharedAVSystemController] setVolumeTo:1.0/16.0 forCategory:@"Audio/Video"];
	}
	
	[self updateVolumeValues];
}

@end
