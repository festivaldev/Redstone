#import <Foundation/Foundation.h>

@interface SBLeafIcon : NSObject

- (id)leafIdentifier;
- (id)application;
- (id)applicationBundleID;
- (id)badgeNumberOrString;
- (BOOL)isUninstallSupported;
- (void)completeUninstall;
- (void)setUninstalled;
- (id)displayName;
- (id)getUnmaskedIconImage:(int)arg1;

- (id)uninstallAlertTitle;
- (id)uninstallAlertBody;
- (id)uninstallAlertConfirmTitle;
- (id)uninstallAlertCancelTitle;

@end
