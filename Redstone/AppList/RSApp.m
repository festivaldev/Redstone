#import "Redstone.h"

@implementation RSApp

- (id)initWithFrame:(CGRect)frame bundleIdentifier:(NSString *)bundleIdentifier {
	if (self = [super initWithFrame:frame]) {
		self.icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:bundleIdentifier];
		self.tileInfo = [[RSTileInfo alloc] initWithBundleIdentifier:bundleIdentifier];
		self.originalCenter = self.center;
		
		[self setHighlightEnabled:YES];
		
		// App Icon
		
		appImageBackground = [[UIView alloc] initWithFrame:CGRectMake(5, 2, 50, 50)];
		[appImageBackground setBackgroundColor:[[RSAesthetics accentColorForTile:self.tileInfo] colorWithAlphaComponent:1.0]];
		[self addSubview:appImageBackground];
		
		if (self.tileInfo.fullSizeArtwork) {
			appImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
			[appImageView setImage:[RSAesthetics imageForTileWithBundleIdentifier:[self.icon applicationBundleID] size:5 colored:YES]];
		} else {
			appImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37.5, 37.5)];
			[appImageView setCenter:CGPointMake(25, 25)];
			[appImageView setImage:[RSAesthetics imageForTileWithBundleIdentifier:[self.icon applicationBundleID] size:5 colored:self.tileInfo.hasColoredIcon]];
			[appImageView setTintColor:[UIColor whiteColor]];
		}
		[appImageBackground addSubview:appImageView];
		
		// App Label
		
		appLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, frame.size.width-70, 54)];
		[appLabel setFont:[UIFont fontWithName:@"SegoeUI-Semilight" size:20]];
		[appLabel setTextColor:[UIColor whiteColor]];
		
		if (self.tileInfo.localizedDisplayName) {
			[appLabel setText:self.tileInfo.localizedDisplayName];
		} else if (self.tileInfo.displayName) {
			[appLabel setText:self.tileInfo.displayName];
		} else {
			[appLabel setText:[self.icon displayName]];
		}
		
		[self addSubview:appLabel];
		
		// Gesture Recognizers
		
		UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
		[longPressGestureRecognizer setMinimumPressDuration:0.5];
		[longPressGestureRecognizer setCancelsTouchesInView:NO];
		[longPressGestureRecognizer setDelaysTouchesBegan:NO];
		[longPressGestureRecognizer setDelegate:self];
		[self addGestureRecognizer:longPressGestureRecognizer];
		
		UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[tapGestureRecognizer setCancelsTouchesInView:NO];
		[tapGestureRecognizer setDelaysTouchesBegan:NO];
		[tapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
		[self addGestureRecognizer:tapGestureRecognizer];
	}
	
	return self;
}

- (NSString*)displayName {
	return appLabel.text;
}

#pragma mark Gesture Recognizers

- (void)tapped:(UITapGestureRecognizer*)gestureRecognizer {
		self.icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:[self.icon applicationBundleID]];
	
		[[[[RSCore sharedInstance] homeScreenController] launchScreenController] setLaunchIdentifier:self.icon.applicationBundleID];
		[[objc_getClass("SBIconController") sharedInstance] _launchIcon:self.icon];
}

- (void)pressed:(UILongPressGestureRecognizer*)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		[self untilt];
		[[[[RSCore sharedInstance] homeScreenController] appListController] showPinMenuForApp:self withPoint:[gestureRecognizer locationInView:self]];
	}
}

@end
