#import <Foundation/Foundation.h>

@interface SBLockScreenManager : NSObject

+ (id)sharedInstance;
- (void)attemptUnlockWithPasscode:(id)arg1;
- (BOOL)_setPasscodeVisible:(BOOL)arg1 animated:(BOOL)arg2;

@end
