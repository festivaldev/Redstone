#import <UIKit/UIKit.h>

@class RSTileInfo;

@interface RSLockScreenNotificationApp : UIView {
	NSString* bundleIdentifier;
	
	UIImageView* appIcon;
	UILabel* appBadge;
	
	RSTileInfo* tileInfo;
}

- (id)initWithIdentifier:(NSString*)identifier;
- (void)setBadgeCount:(int)badgeCount;
- (id)bundleIdentifier;

@end
