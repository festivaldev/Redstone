#import "Redstone.h"

@implementation RSLockScreenNotificationArea

// Detailed Status 100px;
// Quick Status 78px

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		detailedStatusArea = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
		[detailedStatusArea setNumberOfLines:3];
		[detailedStatusArea setFont:[UIFont fontWithName:@"SegoeUI" size:24]];
		[detailedStatusArea setTextColor:[UIColor whiteColor]];
		[self addSubview:detailedStatusArea];
		
		if (screenWidth < 375) {
			[detailedStatusArea setFont:[UIFont fontWithName:@"SegoeUI" size:20]];
		}
		
		quickStatusArea = [[UIView alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 80)];
		[self addSubview:quickStatusArea];
		
		[self prepareStatusAreas];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareStatusAreas) name:@"RedstoneSettingsChanged" object:nil];
	}
	
	return self;
}

- (void)prepareStatusAreas {
	[[quickStatusArea subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	if (currentBulletin && [[currentBulletin section] isEqualToString:[[RSPreferences preferences] objectForKey:@"lockDetailApp"]]) {
		NSString* bulletinText = @"";
		
		if ([currentBulletin title]) {
			bulletinText = [bulletinText stringByAppendingString:[currentBulletin title]];
		}
		
		if ([currentBulletin title] && [currentBulletin subtitle]) {
			bulletinText = [bulletinText stringByAppendingString:@"\n"];
		}
		
		if ([currentBulletin subtitle]) {
			bulletinText = [bulletinText stringByAppendingString:[currentBulletin subtitle]];
		}
		
		if (([currentBulletin title] && [currentBulletin message]) || ([currentBulletin subtitle] && [currentBulletin message])) {
			bulletinText = [bulletinText stringByAppendingString:@"\n"];
		}
		
		if ([currentBulletin message]) {
			bulletinText = [bulletinText stringByAppendingString:[currentBulletin message]];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			self.isShowingDetailedStatus = YES;
			[detailedStatusArea setHidden:NO];
			[detailedStatusArea setText:bulletinText];
			
			[[[[RSCore sharedInstance] lockScreenController] view] notificationsUpdated];
		});
	} else {
		currentBulletin = nil;
		dispatch_async(dispatch_get_main_queue(), ^{
			self.isShowingDetailedStatus = NO;
			[detailedStatusArea setHidden:NO];
			[detailedStatusArea setText:@""];
			
			[[[[RSCore sharedInstance] lockScreenController] view] notificationsUpdated];
		});
	}
	
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

- (BBBulletin*)currentBulletin {
	return currentBulletin;
}

- (void)setCurrentBulletin:(BBBulletin *)bulletin {
	if (bulletin && ![[bulletin section] isEqualToString:[[RSPreferences preferences] objectForKey:@"lockDetailApp"]]) {
		return;
	}
	
	currentBulletin = bulletin;
	[self prepareStatusAreas];
}

@end
