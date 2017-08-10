#import <UIKit/UIKit.h>

@class SBLeafIcon, RSTileInfo, RSTileButton;

@interface RSTile : UIView <UIGestureRecognizerDelegate> {
	UILabel* tileLabel;

	BOOL panEnabled;
	CGPoint centerOffset;
	
	UILongPressGestureRecognizer* longPressGestureRecognizer;
	UIPanGestureRecognizer* panGestureRecognizer;
	UITapGestureRecognizer* tapGestureRecognizer;
	
	RSTileButton* unpinButton;
	RSTileButton* resizeButton;
}

@property (nonatomic, assign) int size;
@property (nonatomic, strong) SBLeafIcon* icon;
@property (nonatomic, strong) RSTileInfo* tileInfo;
@property (nonatomic, assign) BOOL isSelectedTile;

@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGPoint nextCenterUpdate;
@property (nonatomic, assign) CGRect nextFrameUpdate;

- (id)initWithFrame:(CGRect)frame size:(int)size bundleIdentifier:(NSString*)bundleIdentifier;
- (CGRect)basePosition;
- (void)setIsSelectedTile:(BOOL)isSelectedTile;

@end
