#include "RDSRootListController.h"

@implementation RDSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	
	prefBundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/Redstone.bundle"];

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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (void)resetHomeScreenLayout {
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@""
																			 message:[prefBundle localizedStringForKey:@"RESET_START_SCREEN_LAYOUT_MESSAGE" value:@"" table:@"Root"]
																	  preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[prefBundle localizedStringForKey:@"RESET_START_SCREEN_LAYOUT_CANCEL" value:@"" table:@"Root"]
														   style:UIAlertActionStyleCancel
														 handler:nil];
	
	UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:[prefBundle localizedStringForKey:@"RESET_START_SCREEN_LAYOUT_CONFIRM" value:@"" table:@"Root"]
															style:UIAlertActionStyleDestructive
														  handler:^(UIAlertAction *action) {
															  HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier:@"ml.festival.redstone"];
															  [preferences setObject:[NSArray arrayWithContentsOfFile:@"/var/mobile/Library/FESTIVAL/Redstone/2ColumnDefaultLayout.plist"] forKey:@"2ColumnLayout"];
															  [preferences setObject:[NSArray arrayWithContentsOfFile:@"/var/mobile/Library/FESTIVAL/Redstone/3ColumnDefaultLayout.plist"] forKey:@"3ColumnLayout"];
															  [preferences synchronize];
															  
															  system("killall SpringBoard");
														  }];
	[alertController addAction:cancelAction];
	[alertController addAction:confirmAction];
	[self presentViewController:alertController animated:YES completion:nil];
	
}

- (void)killSpringBoard {
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@""
																			 message:[prefBundle localizedStringForKey:@"RESTART_SPRINGBOARD_MESSAGE" value:@"" table:@"Root"]
																	  preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[prefBundle localizedStringForKey:@"RESTART_SPRINGBOARD_CANCEL" value:@"" table:@"Root"]
														   style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:[prefBundle localizedStringForKey:@"RESTART_SPRINGBOARD_CONFIRM" value:@"" table:@"Root"]
															style:UIAlertActionStyleDestructive
														  handler:^(UIAlertAction* action) {
															  system("killall SpringBoard");
														  }];
	
	[alertController addAction:cancelAction];
	[alertController addAction:confirmAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

#pragma GCC diagnostic pop

@end
