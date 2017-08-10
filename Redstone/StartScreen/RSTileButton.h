#import <UIKit/UIKit.h>

@interface RSTileButton : UIView {
	UILabel* titleLabel;
	UITapGestureRecognizer* tapGestureRecognizer;
}

- (id)initWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;
- (void)setTitle:(NSString*)title;

@end
