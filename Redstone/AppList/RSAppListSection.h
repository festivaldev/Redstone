#import <UIKit/UIKit.h>
#import "UI/RSTiltView.h"

@interface RSAppListSection : RSTiltView {
	NSString* displayName;
	UILabel* sectionLabel;
}

@property (nonatomic, assign) int yPosition;
@property (nonatomic, assign) CGPoint originalCenter;

- (id)initWithFrame:(CGRect)frame letter:(NSString*)letter;
- (void)updateTextColor;
- (NSString*)displayName;

@end
