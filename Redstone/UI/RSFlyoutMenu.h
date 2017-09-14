#import <UIKit/UIKit.h>

@interface RSFlyoutMenu : UIView {
	NSMutableArray* actions;
}

@property (nonatomic, assign) BOOL isOpen;

- (void)accentColorChanged;
- (void)updateFlyoutSize;
- (void)addActionWithTitle:(NSString*)title target:(id)target action:(SEL)action;
- (void)setActionHidden:(BOOL)hidden atIndex:(NSInteger)index;
- (void)setActionDisabled:(BOOL)disabled atIndex:(NSInteger)index;
- (void)appearAtPosition:(CGPoint)position;
- (void)disappear;

@end
