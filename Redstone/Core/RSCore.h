#import <UIKit/UIKit.h>

@class RSHomeScreenController;

@interface RSCore : NSObject {
	UIWindow* _window;
	
	RSHomeScreenController* homeScreenController;
}

- (id)initWithWindow:(UIWindow*)window;

@end
