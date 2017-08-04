#import <UIKit/UIKit.h>

@class RSHomeScreenController;

@interface RSCore : NSObject {
	UIWindow* _window;
	
	RSHomeScreenController* homeScreenController;
}

+ (id)sharedInstance;
+ (void)hideAllExcept:(id)objectToShow;
+ (void)showAllExcept:(id)objectToHide;
- (id)initWithWindow:(UIWindow*)window;

@end
