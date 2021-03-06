#import "RDSLockScreenPreferences.h"

@implementation RDSLockScreenPreferences

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"LockScreen" target:self] retain];
	}
	
	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	settingsView = [[UIApplication sharedApplication] keyWindow];
	
	settingsView.tintColor = [UIColor redColor];
	self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	settingsView.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
}

@end
