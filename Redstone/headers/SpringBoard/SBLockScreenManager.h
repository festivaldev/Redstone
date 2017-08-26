#import <Foundation/Foundation.h>

@interface SBLockScreenManager : NSObject

+ (id)sharedInstance;
- (void)attemptUnlockWithPasscode:(id)arg1;

@end
