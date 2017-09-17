#import "Redstone.h"
#import <objcipc/objcipc.h>

%group homescreen

UIView* mainDisplaySceneLayoutView;
BOOL switcherIsOpen;
static BOOL hasBeenUnlockedBefore;

void playApplicationZoomAnimation(int direction, void (^callback)()) {
	RSHomeScreenController* homeScreenController = [[RSCore sharedInstance] homeScreenController];
	RSStartScreenController* startScreenController = [homeScreenController startScreenController];
	RSAppListController* appListController = [homeScreenController appListController];
	RSLaunchScreenController* launchScreenController = [homeScreenController launchScreenController];
	
	if (direction == 0) {
		// Home Screen to App
		
		CGFloat delay = [homeScreenController launchApplication];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay+0.31 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[launchScreenController animateIn];
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[homeScreenController setContentOffset:CGPointZero];
				[startScreenController setContentOffset:CGPointMake(0, -24)];
				[appListController setContentOffset:CGPointMake(0, 0)];
			});
			
			callback();
		});
	} else if (direction == 1) {
		// App to Home Screen
		
		NSLog(@"[Redstone] launchIdentifier: %@, isUnlocking: %i", [launchScreenController launchIdentifier], [launchScreenController isUnlocking]);
		if ([launchScreenController launchIdentifier] != nil && ![launchScreenController isUnlocking]) {
			[launchScreenController animateCurrentApplicationSnapshot];
			[startScreenController setTilesHidden:YES];
			[appListController setAppsHidden:YES];
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[RSAnimation startScreenAnimateIn];
				[RSAnimation appListAnimateIn];
				
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[launchScreenController setLaunchIdentifier:nil];
				});
				
				callback();
			});
		} else {
			if (hasBeenUnlockedBefore) {
				[homeScreenController deviceHasBeenUnlocked];
			} else {
				[homeScreenController setContentOffset:CGPointZero];
				[startScreenController setContentOffset:CGPointMake(0, -24)];
				[appListController setContentOffset:CGPointMake(0, 0)];
				
				hasBeenUnlockedBefore = YES;
				
				[RSAnimation startScreenAnimateIn];
				[RSAnimation appListAnimateIn];
			}
			
			callback();
		}
		
		[launchScreenController setIsUnlocking:NO];
	}
}

%hook SBLockScreenManager

-(BOOL)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
	RSLaunchScreenController* launchScreenController = [[[RSCore sharedInstance] homeScreenController] launchScreenController];
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (frontApp) {
		[launchScreenController setIsUnlocking:NO];
		[launchScreenController setLaunchIdentifier:[frontApp bundleIdentifier]];
	} else {
		[launchScreenController setIsUnlocking:YES];
		[launchScreenController setLaunchIdentifier:nil];
	}
	
	return %orig;
}

%end	// %hook SBLockScreenManager

// iOS 10
%hook SBUIAnimationZoomApp

- (void)__startAnimation {
	playApplicationZoomAnimation([self zoomDirection], ^{
		%orig;
	});
}

%end	// %hook SBUIAnimationZoomApp

// iOS 9
%hook SBUIAnimationZoomUpApp

// Home Screen to App
- (void)_startAnimation {
	playApplicationZoomAnimation(0, ^{
		%orig;
	});
}

%end	// %hook SBUIAnimationZoomUpApp

// iOS 9
%hook SBUIAnimationZoomDownApp

// App to Home Screen
- (void)_startAnimation {
	playApplicationZoomAnimation(1, ^{
		%orig;
	});
}

%end	// %hook SBUIAnimationZoomDownApp

%hook SBApplication

- (void)setBadge:(id)arg1 {
	%orig(arg1);
	
	RSStartScreenController* startScreenController = [[[RSCore sharedInstance] homeScreenController] startScreenController];
	
	if ([startScreenController tileForBundleIdentifier:[self bundleIdentifier]]) {
		[[startScreenController tileForBundleIdentifier:[self bundleIdentifier]] setBadge:[arg1 intValue]];
	}
}

%end	// %hook SBApplication

%hook SpringBoard

- (long long) homeScreenRotationStyle {
	return 0;
}

%end	// %hook SpringBoard

%hook SBHomeScreenViewController

- (NSInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)arg1 {
	return YES;
}

%end	// %hook SBHomeScreenViewController

%hook SBMainDisplaySceneLayoutViewController

- (void)loadView {
	%orig;
	
	mainDisplaySceneLayoutView = self.view;
}

- (void)viewDidLoad {
	%orig;
	
	[self.view setUserInteractionEnabled:NO];
}

- (void)viewDidLayoutSubviews {
	%orig;
	
	if (switcherIsOpen) {
		[self.view setUserInteractionEnabled:YES];
	} else {
		[self.view setUserInteractionEnabled:NO];
	}
}

%end	// %hook SBMainDisplaySceneLayoutViewController

%hook SBDeckSwitcherViewController

- (void)viewWillAppear:(BOOL)arg1 {
	%log;
	
	switcherIsOpen = YES;
	[mainDisplaySceneLayoutView setUserInteractionEnabled:YES];
	
	%orig;
}

- (void)viewWillDisappear:(BOOL)arg1 {
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (!frontApp) {
		[[[[RSCore sharedInstance] homeScreenController] startScreenController] startLiveTiles];
	}
	
	switcherIsOpen = NO;
	[mainDisplaySceneLayoutView setUserInteractionEnabled:NO];
	
	%orig;
}

%end	// %hook SBDeckSwitcherViewController

%end // %group homescreen

%ctor {
	if ([[[RSPreferences preferences] objectForKey:@"enabled"] boolValue] && [[[RSPreferences preferences] objectForKey:@"homeScreenEnabled"] boolValue]) {
		%init(homescreen);
		
#if (!TARGET_OS_SIMULATOR)
		[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"Redstone.Application.BecameActive"  handler:^NSDictionary *(NSDictionary *message) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneApplicationDidBecomeActive" object:nil];
			
			return nil;
		}];
		
		[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"Redstone.Application.WillTerminate"  handler:^NSDictionary *(NSDictionary *message) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneApplicationWillTerminate" object:nil];
			
			return nil;
		}];
		
		[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"Redstone.Application.WillEnterForeground"  handler:^NSDictionary *(NSDictionary *message) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"RedstoneApplicationWillEnterForeground" object:nil];
			
			return nil;
		}];
#endif
	}
}
