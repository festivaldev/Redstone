#import <UIKit/UIKit.h>

@interface RSAppListSection : UIView {
	NSString* displayName;
	UILabel* sectionLabel;
}

@property (nonatomic, assign) int yPosition;
@property (nonatomic, assign) CGPoint originalCenter;

- (id)initWithFrame:(CGRect)frame letter:(NSString*)letter;
- (NSString*)displayName;

@end
