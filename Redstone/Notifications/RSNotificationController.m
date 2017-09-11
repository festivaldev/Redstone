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
		[self.window setRootViewController:self];
		
		currentBulletins = [NSMutableDictionary new];
		bulletinViews = [NSMutableDictionary new];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearBulletins) name:@"RedstoneDeviceLocked" object:nil];
	}
	
	return self;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:nil completion:^(id context) {
		[UIView setAnimationsEnabled:YES];
	}];
	[UIView setAnimationsEnabled:NO];
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)addBulletin:(BBBulletin*)bulletin {
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([[[RSCore sharedInstance] audioController] isShowingVolumeHUD]) {
			[[[RSCore sharedInstance] audioController] hideVolumeHUD];
		}
		
		if ([[[RSPreferences preferences] objectForKey:@"lockScreenEnabled"] boolValue] && [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked]) {
			// Add notification to Lock Screen
			
			[self.window makeKeyAndVisible];
			[self setRotation];
			[UIView setAnimationsEnabled:YES];
			
			RSNotificationView* notification = [[RSNotificationView alloc] initWithBulletin:bulletin];
			[self.window addSubview:notification];
			[notification animateIn];
			[notification resetSlideOutTimer];
			
			[currentBulletins setObject:bulletin forKey:[bulletin bulletinID]];
			[bulletinViews setObject:notification forKey:[bulletin bulletinID]];
		} else if ([[[RSPreferences preferences] objectForKey:@"notificationsEnabled"] boolValue] && ![[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked]) {
			// Add notification globally, except Lock Screen
			
			[self.window makeKeyAndVisible];
			[self setRotation];
			[UIView setAnimationsEnabled:YES];
			
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

- (void)setRotation {
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (frontApp) {
		[[UIDevice currentDevice] setValue:[NSNumber numberWithLongLong:[frontApp statusBarOrientation]] forKey:@"orientation"];
		
		if ([frontApp statusBarOrientation] == UIDeviceOrientationPortrait || [frontApp statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown) {
			[self.window setFrame:CGRectMake(0, 0, screenWidth, 130)];
			[self.view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		} else {
			[self.window setFrame:CGRectMake(0, 0, screenHeight, 130)];
			[self.view setFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
		}
	} else {
		[[UIDevice currentDevice] setValue:[NSNumber numberWithInt:1] forKey:@"orientation"];
		[self.window setFrame:CGRectMake(0, 0, screenWidth, 130)];
		[self.view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	}
}

@end
