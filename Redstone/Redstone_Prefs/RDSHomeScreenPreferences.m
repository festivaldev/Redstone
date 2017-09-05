#import "RDSHomeScreenPreferences.h"

@implementation RDSHomeScreenPreferences

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"HomeScreen" target:self] retain];
	}
	
	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	if ([[specifier propertyForKey:@"key"] isEqualToString:@"showMoreTiles"] && [UIScreen mainScreen].bounds.size.width == 414) {
		[specifier setProperty:[NSNumber numberWithBool:NO] forKey:@"enabled"];
	}
	
	return [super readPreferenceValue:specifier];
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
