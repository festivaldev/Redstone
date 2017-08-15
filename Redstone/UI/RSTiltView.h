#import <UIKit/UIKit.h>

@interface RSTiltView : UIView <UIGestureRecognizerDelegate> {
	CALayer* highlightLayer;
	
	BOOL isTilted;
	BOOL isHighlighted;
	
	UILongPressGestureRecognizer* gestureRecognizer;
}

@property (nonatomic, assign) BOOL tiltEnabled;
@property (nonatomic, assign) BOOL highlightEnabled;
@property (nonatomic, assign) BOOL coloredHighlight;
@property (nonatomic, strong) UILabel* titleLabel;

- (void)untilt;
- (void)setTitle:(NSString*)title;

@end
