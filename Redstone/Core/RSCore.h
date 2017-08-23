#import <UIKit/UIKit.h>

@class RSHomeScreenController, RSAudioController;

@interface RSCore : NSObject {
	UIWindow* _window;
	
	RSHomeScreenController* homeScreenController;
	RSAudioController* audioController;
}

+ (id)sharedInstance;
+ (void)hideAllExcept:(id)objectToShow;
+ (void)showAllExcept:(id)objectToHide;
- (id)initWithWindow:(UIWindow*)window;

- (RSHomeScreenController*)homeScreenController;
- (RSAudioController*)audioController;

- (void)frontDisplayDidChange:(id)application;
- (BOOL)homeButtonPressed;

@end
