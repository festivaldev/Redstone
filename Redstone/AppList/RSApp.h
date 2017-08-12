#import <UIKit/UIKit.h>

@class SBLeafIcon, RSTileInfo;

@interface RSApp : UIView {
	UIView* appImageBackground;
	UIImageView* appImageView;
	UILabel* appLabel;
}

@property (nonatomic, strong) SBLeafIcon* icon;
@property (nonatomic, strong) RSTileInfo* tileInfo;
@property (nonatomic, assign) CGPoint originalCenter;

- (id)initWithFrame:(CGRect)frame bundleIdentifier:(NSString *)bundleIdentifier;

@end
