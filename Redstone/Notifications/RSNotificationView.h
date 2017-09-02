#import <UIKit/UIKit.h>

@class BBBulletin, SBApplication;

@interface RSNotificationView : UIView {
	BBBulletin* _bulletin;
	SBApplication* _application;
	
	UIImageView* toastIcon;
	UILabel* titleLabel;
	UILabel* subtitleLabel;
	UILabel* messageLabel;
	
	NSTimer* slideOutTimer;
	UITapGestureRecognizer* tapGestureRecognizer;
}

- (id)initWithBulletin:(BBBulletin*)bulletin;
- (void)animateIn;
- (void)animateOut;
- (void)stopSlideOutTimer;
- (void)resetSlideOutTimer;

@end
