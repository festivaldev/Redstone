#import <UIKit/UIKit.h>

@class SBLeafIcon;

@interface RSTile : UIView {
	UILabel* tileLabel;

	BOOL panEnabled;
	CGPoint centerOffset;
	
	UILongPressGestureRecognizer* longPressGestureRecognizer;
	UIPanGestureRecognizer* panGestureRecognizer;
	UITapGestureRecognizer* tapGestureRecognizer;
}

@property (nonatomic, assign) int size;
@property (nonatomic, strong) SBLeafIcon* icon;
@property (nonatomic, assign) BOOL isSelectedTile;

- (id)initWithFrame:(CGRect)frame size:(int)size bundleIdentifier:(NSString*)bundleIdentifier;
- (void)setIsSelectedTile:(BOOL)isSelectedTile;

@end
