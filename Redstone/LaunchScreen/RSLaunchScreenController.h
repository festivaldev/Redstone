#import <UIKit/UIKit.h>

@interface RSLaunchScreenController : NSObject {
	UIImageView* launchImageView;
	
	NSTimer* rootTimeout;
}

@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) NSString* launchIdentifier;
@property (nonatomic, assign, readonly) BOOL isLaunchingApp;

- (void)animateIn;
- (void)animateOut;

@end
