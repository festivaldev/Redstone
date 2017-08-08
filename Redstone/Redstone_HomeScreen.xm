#import "Redstone.h"

%group homescreen

%hook SpringBoard

- (long long) homeScreenRotationStyle {
	return 0;
}

- (void)frontDisplayDidChange:(id)arg1 {
	%orig(arg1);
	
	//[[RSCore sharedInstance] frontDisplayDidChange:arg1];
}

%end // %hook SpringBoard

%hook SBHomeScreenViewController

- (NSInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)arg1 {
	return YES;
}

%end // %hook SBHomeScreenViewController

%hook SBMainDisplaySceneLayoutViewController

- (void)viewDidLoad {
	%orig;
	
	[self.view setUserInteractionEnabled:NO];
}

- (void)viewDidLayoutSubviews {
	%orig;
	
	[self.view setUserInteractionEnabled:NO];
}

%end // %hook SBMainDisplaySceneLayoutViewController

%end // %group homescreen

%ctor {
	if ([[[RSPreferences preferences] objectForKey:@"homeScreenEnabled"] boolValue]) {
		%init(homescreen);
	}
}
