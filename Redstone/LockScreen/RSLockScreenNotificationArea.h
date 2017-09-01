#import <UIKit/UIKit.h>

@class RSLockScreenNotificationApp, BBBulletin;

@interface RSLockScreenNotificationArea : UIView {
	NSMutableArray* notificationApps;
	
	UIView* detailedStatusArea;
	UIView* quickStatusArea;
	
	BBBulletin* currentBulletin;
}

@property (nonatomic, assign) BOOL isShowingDetailedStatus;
@property (nonatomic, assign) BOOL isShowingQuickStatus;

- (void)setBadgeForApp:(NSString*)identifier value:(int)badgeValue;
- (BBBulletin*)currentBulletin;
- (void)setCurrentBulletin:(BBBulletin*)bulletin;

@end
