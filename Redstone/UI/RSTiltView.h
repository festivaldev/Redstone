#import <UIKit/UIKit.h>

@interface RSTiltView : UIView {
	CALayer* highlightLayer;
	
	BOOL isTilted;
	BOOL isHighlighted;
}

@property (nonatomic, assign) BOOL tiltEnabled;
@property (nonatomic, assign) BOOL highlightEnabled;
@property (nonatomic, assign) BOOL coloredHighlight;

@end
