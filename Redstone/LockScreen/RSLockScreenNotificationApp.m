#import "Redstone.h"

@implementation RSLockScreenNotificationApp

- (id)initWithIdentifier:(NSString*)identifier {
	if (self = [super init]) {
		bundleIdentifier = identifier;
		tileInfo = [[RSTileInfo alloc] initWithBundleIdentifier:identifier];
		[self setClipsToBounds:YES];
		
		wallpaperLegibilitySettings = [[objc_getClass("SBWallpaperController") sharedInstance] legibilitySettingsForVariant:0];
		
		if (tileInfo.fullSizeArtwork) {
			appIcon = [[UIImageView alloc] initWithImage:[RSAesthetics imageForTileWithBundleIdentifier:identifier size:5 colored:YES]];
		} else {
			appIcon = [[UIImageView alloc] initWithImage:[RSAesthetics imageForTileWithBundleIdentifier:identifier size:5 colored:tileInfo.hasColoredIcon]];
			[appIcon setTintColor:[wallpaperLegibilitySettings primaryColor]];
		}
		[self addSubview:appIcon];
		
		appBadge = [[UILabel alloc] init];
		[appBadge setFont:[UIFont fontWithName:@"SegoeUI" size:20]];
		[appBadge setTextColor:[wallpaperLegibilitySettings primaryColor]];
		[appBadge setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:appBadge];
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[appIcon setFrame:CGRectInset(CGRectMake(4, (frame.size.height - (frame.size.width / 2))/2, frame.size.width/2, frame.size.width/2), 2.5, 2.5)];
	[appBadge setFrame:CGRectMake(frame.size.width/2 - 2, -2, frame.size.width/2, frame.size.height)];
}

- (void)setBadgeCount:(int)badgeCount {
	if (badgeCount > 0) {
		[self setHidden:NO];
		[appBadge setText:[NSString stringWithFormat:@"%i", badgeCount]];
	} else {
		[self setHidden:YES];
	}
}

- (id)bundleIdentifier {
	return bundleIdentifier;
}

- (void)wallpaperChanged {
	wallpaperLegibilitySettings = [[objc_getClass("SBWallpaperController") sharedInstance] legibilitySettingsForVariant:0];
	if (!tileInfo.fullSizeArtwork) {
		[appIcon setTintColor:[wallpaperLegibilitySettings primaryColor]];
	}
	[appBadge setTextColor:[wallpaperLegibilitySettings primaryColor]];
}

@end
