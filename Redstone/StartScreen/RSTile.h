#import <UIKit/UIKit.h>
#import "UI/RSTiltView.h"

@protocol RSLiveTileInterface;
@class SBLeafIcon, RSTileInfo, RSTileButton;

@interface RSTile : RSTiltView <UIGestureRecognizerDelegate> {
	UIView* tileWrapper;
	UIView* tileContainer;
	
	UIImageView* tileImageView;
	UILabel* tileLabel;
	
	int badgeValue;
	UILabel* badgeLabel;

	BOOL panEnabled;
	CGPoint centerOffset;
	
	UILongPressGestureRecognizer* longPressGestureRecognizer;
	UIPanGestureRecognizer* panGestureRecognizer;
	UITapGestureRecognizer* tapGestureRecognizer;
	
	RSTileButton* unpinButton;
	RSTileButton* resizeButton;
	
	NSBundle* liveTileBundle;
	UIView<RSLiveTileInterface>* liveTile;
	NSTimer* liveTileUpdateTimer;
	NSTimer* liveTileAnimationTimer;
	NSInteger liveTilePageIndex;
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
- (void)unpin;
- (void)setNextSize;
- (CGFloat)scaleButtonRotationForCurrentSize;
- (void)setBadge:(int)badgeCount;

- (void)startLiveTile;
- (void)stopLiveTile;
- (void)setLiveTileHidden:(BOOL)hidden;
- (void)setLiveTileHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)displayNextLiveTilePage;

@end
