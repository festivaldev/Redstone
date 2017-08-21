@class RSAlertAction;

#import <UIKit/UIKit.h>

@interface RSAlertController : UIViewController {
	UIView* contentView;
	NSMutableArray* actions;
	
	UILabel* titleLabel;
	UILabel* messageLabel;
}

@property (nonatomic, strong) NSString* message;

+ (id)alertControllerWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(RSAlertAction*)action;
- (void)show;
- (void)dismiss;

@end
