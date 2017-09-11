#import <UIKit/UIKit.h>
#import <BulletinBoard/BBBulletin.h>

@interface RSNotificationController : UIViewController {
	NSMutableDictionary* currentBulletins;
	NSMutableDictionary* bulletinViews;
}

@property (nonatomic, strong) UIWindow* window;

- (void)addBulletin:(BBBulletin*)bulletin;
- (void)removeBulletin:(BBBulletin*)bulletin;
- (void)clearBulletins;

@end
