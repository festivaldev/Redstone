#import "Redstone.h"

@implementation RSCore

static RSCore* sharedInstance;
static id currentApplication;

+ (id)sharedInstance {
	return sharedInstance;
}

+ (void)hideAllExcept:(id)objectToShow {
	for (UIView* view in [[[objc_getClass("SBUIController") sharedInstance] window] subviews]) {
		if ([view isKindOfClass:NSClassFromString(@"SBHostWrapperView")]) {
			[view setHidden:NO];
		} else if (view != objectToShow) {
			[view setHidden:YES];
		}
	}
	
	if (objectToShow) {
		[objectToShow setHidden:NO];
	}
}

+ (void)showAllExcept:(id)objectToHide {
	for (UIView* view in [[[objc_getClass("SBUIController") sharedInstance] window] subviews]) {
		[view setHidden:(view == objectToHide)];
	}
	
	if (objectToHide) {
		[objectToHide setHidden:YES];
	}
}

- (id)initWithWindow:(UIWindow*)window {
	if (self = [super init]) {
		sharedInstance = self;
		
		_window = window;
		
		[UIFont registerFontFromURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fonts/segoeui.ttf", RESOURCES_PATH]]];
		[UIFont registerFontFromURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fonts/segoeuisl.ttf", RESOURCES_PATH]]];
		[UIFont registerFontFromURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fonts/segoeuil.ttf", RESOURCES_PATH]]];
		[UIFont registerFontFromURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fonts/segmdl2.ttf", RESOURCES_PATH]]];
		[UIFont registerFontFromURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fonts/seguisb.ttf", RESOURCES_PATH]]];
		
		if ([[[RSPreferences preferences] objectForKey:@"homeScreenEnabled"] boolValue]) {
			homeScreenController = [RSHomeScreenController new];
			[_window addSubview:homeScreenController.view];
		
			[[self class] hideAllExcept:homeScreenController.view];
		}
		
		if ([[[RSPreferences preferences] objectForKey:@"volumeControlsEnabled"] boolValue] || [[[RSPreferences preferences] objectForKey:@"lockScreenEnabled"] boolValue]) {
			audioController = [RSAudioController new];
		}
		
		notificationController = [RSNotificationController new];
		
		if ([[[RSPreferences preferences] objectForKey:@"lockScreenEnabled"] boolValue]) {
			lockScreenController = [RSLockScreenController new];
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:@"RedstoneApplicationDidBecomeActive" object:nil];
	}
	
	return self;
}

- (RSHomeScreenController*)homeScreenController {
	return homeScreenController;
}

- (RSAudioController*)audioController {
	return audioController;
}

- (RSNotificationController*)notificationController {
	return notificationController;
}

- (RSLockScreenController*)lockScreenController {
	return lockScreenController;
}

- (void)applicationDidBecomeActive {
	if (homeScreenController == nil) {
		return;
	}
	
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (frontApp) {
		[[homeScreenController launchScreenController] setIsUnlocking:NO];
		[[homeScreenController launchScreenController] setLaunchIdentifier:[frontApp bundleIdentifier]];
		
		[[homeScreenController startScreenController] setIsEditing:NO];
		[[homeScreenController startScreenController] stopLiveTiles];
		[[homeScreenController startScreenController] setTilesHidden:NO];
		[[homeScreenController appListController] setAppsHidden:NO];
		
		for (RSAlertController* alertController in [homeScreenController alertControllers]) {
			[alertController dismiss];
		}
		
		[[[homeScreenController appListController] jumpList] animateOut];
		[[homeScreenController appListController] hidePinMenu];
		
		[[[homeScreenController appListController] searchBar] resignFirstResponder];
		[[[homeScreenController appListController] searchBar] setText:@""];
		[[homeScreenController appListController] showAppsFittingQuery];
		[[[homeScreenController appListController] searchBar] resignFirstResponder];
	}
}

- (BOOL)homeButtonPressed {
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (audioController != nil) {
		if ([audioController isShowingVolumeHUD]) {
			[audioController hideVolumeHUD];
			return NO;
		}
	}
	
	if (homeScreenController != nil) {
		if ([currentApplication isKindOfClass:NSClassFromString(@"SBDashBoardViewController")] || frontApp != nil) {
			return YES;
		}
		
		if ([homeScreenController alertControllers].count > 0) {
			[(RSAlertController*)[[homeScreenController alertControllers] lastObject] dismiss];
		}
		
		if ([[[homeScreenController appListController] jumpList] isOpen]) {
			[[[homeScreenController appListController] jumpList] animateOut];
			return NO;
		}
		
		if ([[[homeScreenController appListController] pinMenu] isOpen]) {
			[[homeScreenController appListController] hidePinMenu];
			return NO;
		}
		
		if ([[[homeScreenController appListController] searchBar] text].length > 0) {
			[[[homeScreenController appListController] searchBar] resignFirstResponder];
			[[[homeScreenController appListController] searchBar] setText:@""];
			[[homeScreenController appListController] showAppsFittingQuery];
		}
		
		if ([[[homeScreenController appListController] searchBar] isFirstResponder]) {
			[[[homeScreenController appListController] searchBar] resignFirstResponder];
			return NO;
		}
		
		if ([[homeScreenController startScreenController] isEditing]) {
			[[homeScreenController startScreenController] setIsEditing:NO];
			return NO;
		}
		
		if ([homeScreenController contentOffset].x != 0 || [[homeScreenController startScreenController] contentOffset].y != -24 || [[homeScreenController appListController] contentOffset].y != 0) {
			[homeScreenController setContentOffset:CGPointZero animated:YES];
			[[homeScreenController startScreenController] setContentOffset:CGPointMake(0, -24) animated:YES];
			[[homeScreenController appListController] setContentOffset:CGPointZero animated:YES];
			
			return NO;
		}

	}
	
	return YES;
}

@end
