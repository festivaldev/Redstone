#import <UIKit/UIKit.h>

@class RSLockScreenNotificationApp;

@interface RSLockScreenNotificationArea : UIView {
	NSMutableArray* notificationApps;
	
	UIView* detailedStatusArea;
	UIView* quickStatusArea;
}

@property (nonatomic, assign) BOOL isShowingDetailedStatus;
@property (nonatomic, assign) BOOL isShowingQuickStatus;

- (void)setBadgeForApp:(NSString*)identifier value:(int)badgeValue;

@end
