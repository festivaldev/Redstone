#import <UIKit/UIKit.h>

@interface RSLaunchScreenController : NSObject {
	UIImageView* launchImageView;
	UIImageView* applicationSnapshot;
	
	NSTimer* rootTimeout;
	NSTimer* animationTimeout;
	NSTimer* hideTimeout;
}

@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) NSString* launchIdentifier;
@property (nonatomic, assign, readonly) BOOL isLaunchingApp;
@property (nonatomic, assign) BOOL isUnlocking;

- (void)animateIn;
- (void)animateOut:(BOOL)forceClose;
- (void)animateCurrentApplicationSnapshot;

@end
