#import "Redstone.h"

@implementation RSNowPlayingControls

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		mediaTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, 30)];
		[mediaTitleLabel setFont:[UIFont fontWithName:@"SegoeUI" size:24]];
		[mediaTitleLabel setTextColor:[UIColor whiteColor]];
		[mediaTitleLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:mediaTitleLabel];
		
		mediaSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, frame.size.width-20, 18)];
		[mediaSubtitleLabel setFont:[UIFont fontWithName:@"SegoeUI-Semibold" size:15]];
		[mediaSubtitleLabel setTextColor:[UIColor whiteColor]];
		[mediaSubtitleLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:mediaSubtitleLabel];
		
		prevTitleButton = [[RSTiltView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 106, 60, 44, 44)];
		[prevTitleButton setHighlightEnabled:YES];
		[prevTitleButton.titleLabel setTextColor:[UIColor whiteColor]];
		[prevTitleButton.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:24]];
		[prevTitleButton setTitle:@"\uE892"];
		[prevTitleButton addTarget:self action:@selector(previousTrack)];
		[self addSubview:prevTitleButton];
		
		playPauseButton = [[RSTiltView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 44/2, 60, 44, 44)];
		[playPauseButton setHighlightEnabled:YES];
		[playPauseButton.titleLabel setTextColor:[UIColor whiteColor]];
		[playPauseButton.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:24]];
		[playPauseButton setTitle:@"\uE768"];
		[playPauseButton addTarget:self action:@selector(togglePlayPause)];
		[self addSubview:playPauseButton];
		
		nextTitleButton = [[RSTiltView alloc] initWithFrame:CGRectMake(frame.size.width/2 + 106 - 44, 60, 44, 44)];
		[nextTitleButton setHighlightEnabled:YES];
		[nextTitleButton.titleLabel setTextColor:[UIColor whiteColor]];
		[nextTitleButton.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:24]];
		[nextTitleButton setTitle:@"\uE893"];
		[nextTitleButton addTarget:self action:@selector(nextTrack)];
		[self addSubview:nextTitleButton];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNowPlayingInfo) name:@"RedstoneNowPlayingUpdateFinished" object:nil];
		[self updateNowPlayingInfo];
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[mediaTitleLabel setFrame:CGRectMake(10, 0, frame.size.width-20, 30)];
	[mediaSubtitleLabel setFrame:CGRectMake(10, 30, frame.size.width-20, 18)];
	[prevTitleButton setFrame:CGRectMake(frame.size.width/2 - 106, 60, 44, 44)];
	[playPauseButton setFrame:CGRectMake(frame.size.width/2 - 44/2, 60, 44, 44)];
	[nextTitleButton setFrame:CGRectMake(frame.size.width/2 + 106 - 44, 60, 44, 44)];
}

- (void)updateNowPlayingInfo {
	BOOL isPlaying = [[[RSCore sharedInstance] audioController] isPlaying];
	UIImage* artwork = [[[RSCore sharedInstance] audioController] artwork];
	NSString* artist = [[[RSCore sharedInstance] audioController] artist];
	NSString* title = [[[RSCore sharedInstance] audioController] title];
	
	if (title != nil && ![title isEqualToString:@""]) {
		[mediaTitleLabel setText:title];
	} else {
		[mediaTitleLabel setText:[RSAesthetics localizedStringForKey:@"MEDIA_UNKNOWN_TITLE"]];
	}
	
	if (artist != nil && ![artist isEqualToString:@""]) {
		[mediaSubtitleLabel setText:artist];
	} else {
		[mediaSubtitleLabel setText:[RSAesthetics localizedStringForKey:@"MEDIA_UNKNOWN_ARTIST"]];
	}
	
	[UIView performWithoutAnimation:^{
		if (isPlaying) {
			[playPauseButton setTitle:@"\uE769"];
		} else {
			[playPauseButton setTitle:@"\uE768"];
		}
		
		[playPauseButton layoutIfNeeded];
	}];
	
	if (!isPlaying && !artwork) {
		[self setHidden:YES];
	} else {
		[self setHidden:NO];
	}
}

- (void)previousTrack {
	[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] changeTrack:-1];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneNowPlayingUpdate" object:nil];
}

- (void)togglePlayPause {
	[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] togglePlayPause];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneNowPlayingUpdate" object:nil];
}

- (void)nextTrack {
	[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] changeTrack:1];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneNowPlayingUpdate" object:nil];
}

@end
