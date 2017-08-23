#import <UIKit/UIKit.h>

@class RSVolumeView;

@interface RSVolumeHUD : UIView {
	NSTimer* animationTimer;
	
	RSVolumeView* ringerVolumeView;
	RSVolumeView* mediaVolumeView;
	RSVolumeView* headphoneVolumeView;
}

@property (nonatomic, assign) BOOL isVisible;

- (void)appear;
- (void)disappear;
- (void)resetAnimationTimer;

@end
