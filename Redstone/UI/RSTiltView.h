#import <UIKit/UIKit.h>

@interface RSTiltView : UIView <UIGestureRecognizerDelegate> {
	CALayer* highlightLayer;
	
	BOOL isTilted;
	BOOL isHighlighted;
	
	UILongPressGestureRecognizer* tiltGestureRecognizer;
}

@property (nonatomic, assign) BOOL tiltEnabled;
@property (nonatomic, assign) BOOL highlightEnabled;
@property (nonatomic, assign) BOOL coloredHighlight;
@property (nonatomic, strong) UILabel* titleLabel;

- (void)untilt;
- (void)addTarget:(id)target action:(SEL)action;
- (void)setTitle:(NSString*)title;
- (void)setAttributedTitle:(NSAttributedString*)attributedTitle;

@end
