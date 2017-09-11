#import <UIKit/UIKit.h>

@interface SBApplication : NSObject

- (id)bundleIdentifier;
- (id)badgeNumberOrString;
- (id)displayName;
- (long long)currentInterfaceOrientation;
- (long long)statusBarOrientation;

@end
