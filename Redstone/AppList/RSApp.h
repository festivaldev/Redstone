#import <UIKit/UIKit.h>

@class RSTiltView, SBLeafIcon, RSTileInfo;

@interface RSApp : RSTiltView {
	UIView* appImageBackground;
	UIImageView* appImageView;
	UILabel* appLabel;
}

@property (nonatomic, strong) SBLeafIcon* icon;
@property (nonatomic, strong) RSTileInfo* tileInfo;
@property (nonatomic, assign) CGPoint originalCenter;

- (id)initWithFrame:(CGRect)frame bundleIdentifier:(NSString *)bundleIdentifier;
- (void)updateTextColor;
- (NSString*)displayName;

@end
