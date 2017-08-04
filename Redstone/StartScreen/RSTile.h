#import <UIKit/UIKit.h>

@class SBLeafIcon;

@interface RSTile : UIView

@property (nonatomic, assign) int size;
@property (nonatomic, strong) SBLeafIcon* icon;

- (id)initWithFrame:(CGRect)frame size:(int)size bundleIdentifier:(NSString*)bundleIdentifier;

@end
