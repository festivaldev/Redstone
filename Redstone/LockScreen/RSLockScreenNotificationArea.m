#import "Redstone.h"

@implementation RSLockScreenNotificationArea

// Detailed Status 100px;
// Quick Status 78px

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		/*UIView* detailedStatusTest = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
		[detailedStatusTest setBackgroundColor:[UIColor greenColor]];
		[self addSubview:detailedStatusTest];
		self.isShowingDetailedStatus = YES;*/
		
		quickStatusArea = [[UIView alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 80)];
		[self addSubview:quickStatusArea];
		
		[self prepareStatusAreas];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareStatusAreas) name:@"RedstoneSettingsChanged" object:nil];
	}
	
	return self;
}

- (void)prepareStatusAreas {
	//[[detailedStatusArea subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[[quickStatusArea subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	/// TODO: Detailed Status Area
	
	notificationApps = [NSMutableArray new];
	for (int i=0; i<5; i++) {
		NSString* bundleIdentifier = [[RSPreferences preferences] objectForKey:[NSString stringWithFormat:@"lockApp%i", i+1]];
		
		if (bundleIdentifier) {
			SBLeafIcon* icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:bundleIdentifier];
			
			if (icon) {
				RSLockScreenNotificationApp* lockApp = [[RSLockScreenNotificationApp alloc] initWithIdentifier:bundleIdentifier];
				[lockApp setFrame:CGRectMake(i*(self.frame.size.width/5), 0, self.frame.size.width/5, 80)];
				[lockApp setBadgeCount:[[icon badgeNumberOrString] intValue]];
				
				[quickStatusArea addSubview:lockApp];
				[notificationApps addObject:lockApp];
				
			}
		}
	}
}

- (void)setBadgeForApp:(NSString*)identifier value:(int)badgeValue {
	for (RSLockScreenNotificationApp* app in notificationApps) {
		if ([[app bundleIdentifier] isEqualToString:identifier]) {
			[app setBadgeCount:badgeValue];
		}
	}
}

@end
