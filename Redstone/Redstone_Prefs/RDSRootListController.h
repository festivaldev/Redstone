#import <CepheiPrefs/HBRootListController.h>
#import <Cephei/HBPreferences.h>

@interface RDSRootListController : HBRootListController {
	UIWindow* settingsView;
	NSBundle* prefBundle;
}

- (void)resetHomeScreenLayout;
- (void)killSpringBoard;

@end
