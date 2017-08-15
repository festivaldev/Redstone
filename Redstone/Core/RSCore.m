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
		
		if ([[[RSPreferences preferences] objectForKey:@"homeScreenEnabled"] boolValue]) {
			homeScreenController = [RSHomeScreenController new];
			[_window addSubview:homeScreenController.view];
		
			[[self class] hideAllExcept:homeScreenController.view];
		}
	}
	
	return self;
}

- (RSHomeScreenController*)homeScreenController {
	return homeScreenController;
}

- (void)frontDisplayDidChange:(id)application {
	if (homeScreenController == nil) {
		return;
	}
	
	currentApplication = application;
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (frontApp) {
		//[[homeScreenController startScreenController] setTilesVisible:NO];
		[[homeScreenController startScreenController] setIsEditing:NO];
		[[homeScreenController launchScreenController] setLaunchIdentifier:[frontApp bundleIdentifier]];
	} else {
		//[[homeScreenController startScreenController] setTilesVisible:YES];
	}
}

- (BOOL)homeButtonPressed {
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (homeScreenController != nil) {
		if ([currentApplication isKindOfClass:NSClassFromString(@"SBDashBoardViewController")] || frontApp != nil) {
			
			[[homeScreenController launchScreenController] setLaunchIdentifier:[frontApp bundleIdentifier]];
			return YES;
		}
		
		if ([[[homeScreenController appListController] jumpList] isOpen]) {
			[[[homeScreenController appListController] jumpList] animateOut];
			return NO;
		}
		
		if ([[[homeScreenController appListController] pinMenu] isOpen]) {
			[[homeScreenController appListController] hidePinMenu];
			return NO;
		}
		
		/// TODO: Search Bar
		
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
