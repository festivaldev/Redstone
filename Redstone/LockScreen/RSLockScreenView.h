#import <UIKit/UIKit.h>

@interface RSLockScreenView : UIView <UIScrollViewDelegate> {
	UIImageView* wallpaperView;
	UIImageView* fakeHomeScreenWallpaperView;
	
	UIScrollView* unlockScrollView;
	UIView* timeAndDateView;
	
	UILabel* timeLabel;
	UILabel* dateLabel;
}

@property (nonatomic, assign) BOOL isScrolling;

- (void)setContentOffset:(CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (CGPoint)contentOffset;

- (void)setTime:(NSString*)time;
- (void)setDate:(NSString*)date;
- (void)reset;

@end
