#import <UIKit/UIKit.h>

@class RSTileInfo, _UILegibilitySettings;

@interface RSLockScreenNotificationApp : UIView {
	NSString* bundleIdentifier;
	_UILegibilitySettings* wallpaperLegibilitySettings;
	
	UIImageView* appIcon;
	UILabel* appBadge;
	
	RSTileInfo* tileInfo;
}

- (id)initWithIdentifier:(NSString*)identifier;
- (void)setBadgeCount:(int)badgeCount;
- (id)bundleIdentifier;
- (void)wallpaperChanged;

@end
