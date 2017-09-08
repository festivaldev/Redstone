#import <UIKit/UIKit.h>
#import "RSPasscodeLockViewKeypadDelegate.h"

@class RSNowPlayingControls, RSLockScreenNotificationArea, SBPasscodeKeyboard;

@interface RSLockScreenView : UIView <UIScrollViewDelegate> {
	UIImageView* wallpaperView;
	UIImageView* fakeHomeScreenWallpaperView;
	UIView* wallpaperOverlay;
	
	UIScrollView* unlockScrollView;
	UIView* timeAndDateView;
	
	UILabel* timeLabel;
	UILabel* dateLabel;
	
	RSNowPlayingControls* nowPlayingControls;
	RSLockScreenNotificationArea* notificationArea;
	
	UIView<RSPasscodeLockViewKeypadDelegate>* passcodeKeyboard;
}

@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isUnlocking;
@property (nonatomic, strong) SBPasscodeKeyboard* stockPasscodeKeyboard;

- (UIScrollView*)unlockScrollView;
- (RSLockScreenNotificationArea*)notificationArea;
- (UIView<RSPasscodeLockViewKeypadDelegate>*)passcodeKeyboard;

- (void)setContentOffset:(CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (CGPoint)contentOffset;

- (void)setTime:(NSString*)time;
- (void)setDate:(NSString*)date;
- (void)reset;

- (void)notificationsUpdated;
- (void)updatePasscodeKeyboard;

- (void)handlePasscodeTextChanged;

@end
