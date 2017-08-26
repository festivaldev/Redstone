#import <UIKit/UIKit.h>

@class RSHomeScreenController, RSAudioController, RSLockScreenController;

@interface RSCore : NSObject {
	UIWindow* _window;
	
	RSHomeScreenController* homeScreenController;
	RSAudioController* audioController;
	RSLockScreenController* lockScreenController;
}

+ (id)sharedInstance;
+ (void)hideAllExcept:(id)objectToShow;
+ (void)showAllExcept:(id)objectToHide;
- (id)initWithWindow:(UIWindow*)window;

- (RSHomeScreenController*)homeScreenController;
- (RSAudioController*)audioController;
- (RSLockScreenController*)lockScreenController;

- (void)frontDisplayDidChange:(id)application;
- (BOOL)homeButtonPressed;

@end
