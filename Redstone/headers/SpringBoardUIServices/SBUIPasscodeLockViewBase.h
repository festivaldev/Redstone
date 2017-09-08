#import <UIKit/UIKit.h>

@interface SBUIPasscodeLockViewBase : UIView

- (NSString*)passcode;

-(id)_longNumericEntryField;

// new
+ (id)currentPasscodeView;

@end
