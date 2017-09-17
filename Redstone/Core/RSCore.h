#import <UIKit/UIKit.h>

@class RSHomeScreenController, RSAudioController, RSNotificationController, RSLockScreenController;

@interface RSCore : NSObject {
	UIWindow* _window;
	
	RSHomeScreenController* homeScreenController;
	RSAudioController* audioController;
	RSNotificationController* notificationController;
	RSLockScreenController* lockScreenController;
}

+ (id)sharedInstance;
+ (void)hideAllExcept:(id)objectToShow;
+ (void)showAllExcept:(id)objectToHide;
- (id)initWithWindow:(UIWindow*)window;

- (RSHomeScreenController*)homeScreenController;
- (RSAudioController*)audioController;
- (RSNotificationController*)notificationController;
- (RSLockScreenController*)lockScreenController;

- (BOOL)homeButtonPressed;

@end
