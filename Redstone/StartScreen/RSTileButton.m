#import "Redstone.h"

@implementation RSTileButton

- (id)initWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor whiteColor]];
		[self.layer setCornerRadius:frame.size.width/2];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		[titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:14]];
		[titleLabel setText:title];
		[titleLabel setTextColor:[UIColor blackColor]];
		[titleLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:titleLabel];
		
		tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
		[self addGestureRecognizer:tapGestureRecognizer];
	}
	
	return self;
}

- (void)setTitle:(NSString*)title {
	[titleLabel setText:title];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	[self setBackgroundColor:[UIColor blackColor]];
	[titleLabel setTextColor:[UIColor whiteColor]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	[self setBackgroundColor:[UIColor whiteColor]];
	[titleLabel setTextColor:[UIColor blackColor]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	[self setBackgroundColor:[UIColor whiteColor]];
	[titleLabel setTextColor:[UIColor blackColor]];
}

@end
