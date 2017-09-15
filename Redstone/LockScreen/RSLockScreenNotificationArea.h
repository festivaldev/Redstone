#import <UIKit/UIKit.h>

@class RSLockScreenNotificationApp, BBBulletin, _UILegibilitySettings;

@interface RSLockScreenNotificationArea : UIView {
	_UILegibilitySettings* wallpaperLegibilitySettings;
	UILabel* detailedStatusArea;
	
	NSMutableArray* notificationApps;
	UIView* quickStatusArea;
	
	BBBulletin* currentBulletin;
}

@property (nonatomic, assign) BOOL isShowingDetailedStatus;
@property (nonatomic, assign) BOOL isShowingQuickStatus;

- (void)wallpaperChanged;
- (void)prepareStatusAreas;
- (void)setBadgeForApp:(NSString*)identifier value:(int)badgeValue;
- (BBBulletin*)currentBulletin;
- (void)setCurrentBulletin:(BBBulletin*)bulletin;

@end
