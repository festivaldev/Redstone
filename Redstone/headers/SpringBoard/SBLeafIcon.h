#import <Foundation/Foundation.h>

@interface SBLeafIcon : NSObject

- (id)leafIdentifier;
- (id)applicationBundleID;
- (id)badgeNumberOrString;
- (BOOL)isUninstallSupported;

@end
