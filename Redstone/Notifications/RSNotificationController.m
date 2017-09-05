#import "Redstone.h"

@interface UIWindow (SecureWindow)
- (void)_setSecure:(BOOL)arg1;
@end

@implementation RSNotificationController

- (id)init {
	if (self = [super init]) {
		self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 130)];
		[self.window setWindowLevel:1500];
		[self.window _setSecure:YES];
		
		currentBulletins = [NSMutableDictionary new];
		bulletinViews = [NSMutableDictionary new];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearBulletins) name:@"RedstoneDeviceLocked" object:nil];
	}
	
	return self;
}

- (void)addBulletin:(BBBulletin*)bulletin {
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([[[RSCore sharedInstance] audioController] isShowingVolumeHUD]) {
			[[[RSCore sharedInstance] audioController] hideVolumeHUD];
		}
		
		if ([[[RSPreferences preferences] objectForKey:@"lockScreenEnabled"] boolValue] && [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked]) {
			// Add notification to Lock Screen
			
			[self.window makeKeyAndVisible];
			
			RSNotificationView* notification = [[RSNotificationView alloc] initWithBulletin:bulletin];
			[self.window addSubview:notification];
			[notification animateIn];
			[notification resetSlideOutTimer];
			
			[currentBulletins setObject:bulletin forKey:[bulletin bulletinID]];
			[bulletinViews setObject:notification forKey:[bulletin bulletinID]];
		} else if ([[[RSPreferences preferences] objectForKey:@"notificationsEnabled"] boolValue] && ![[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked]) {
			// Add notification globally, except Lock Screen
			
			[self.window makeKeyAndVisible];
			
			RSNotificationView* notification = [[RSNotificationView alloc] initWithBulletin:bulletin];
			[self.window addSubview:notification];
			[notification animateIn];
			[notification resetSlideOutTimer];
			
			[currentBulletins setObject:bulletin forKey:[bulletin bulletinID]];
			[bulletinViews setObject:notification forKey:[bulletin bulletinID]];
		}
	});
}

- (void)removeBulletin:(BBBulletin*)bulletin {
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([currentBulletins objectForKey:[bulletin bulletinID]]) {
			[[bulletinViews objectForKey:[bulletin bulletinID]] removeFromSuperview];
			
			[currentBulletins removeObjectForKey:[bulletin bulletinID]];
			[bulletinViews removeObjectForKey:[bulletin bulletinID]];
		}
		
		if (currentBulletins.count < 1) {
			[self.window setHidden:YES];
		}
	});
}

- (void)clearBulletins {
	for (NSString* bulletinID in currentBulletins) {
		RSNotificationView* notification = [bulletinViews objectForKey:bulletinID];
		[notification.layer removeAllAnimations];
		[notification animateOut];
	}
}

@end
