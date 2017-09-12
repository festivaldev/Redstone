#import "Redstone.h"

@implementation RSLockScreenNotificationApp

- (id)initWithIdentifier:(NSString*)identifier {
	if (self = [super init]) {
		bundleIdentifier = identifier;
		tileInfo = [[RSTileInfo alloc] initWithBundleIdentifier:identifier];
		[self setClipsToBounds:YES];
		
		if (tileInfo.fullSizeArtwork) {
			appIcon = [[UIImageView alloc] initWithImage:[RSAesthetics imageForTileWithBundleIdentifier:identifier size:5 colored:YES]];
		} else {
			appIcon = [[UIImageView alloc] initWithImage:[RSAesthetics imageForTileWithBundleIdentifier:identifier size:5 colored:tileInfo.hasColoredIcon]];
			[appIcon setTintColor:[UIColor whiteColor]];
		}
		[self addSubview:appIcon];
		
		appBadge = [[UILabel alloc] init];
		[appBadge setFont:[UIFont fontWithName:@"SegoeUI" size:20]];
		[appBadge setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
		[appBadge setTextAlignment:NSTextAlignmentCenter];
		[appBadge setText:@"99"];
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

@end
