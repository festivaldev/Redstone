#import "Redstone.h"

@implementation RSLockScreenController

- (id)init {
	if (self = [super init]) {
		self.view = [[RSLockScreenView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	}
	
	return self;
}

@end
