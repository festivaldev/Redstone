#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	RSPasscodeLockViewTypeNone,
	RSPasscodeLockViewTypeFixedDigit,
	RSPasscodeLockViewTypeLongNumeric,
	RSPasscodeLockViewTypeAlphanumeric
} RSPasscodeLockViewType;

@protocol RSPasscodeLockViewKeypadDelegate

@required
- (void)setPasscodeText:(NSString*)passcodeText;
- (RSPasscodeLockViewType)passcodeLockViewType;
- (void)handleFailedAuthentication;

@end
