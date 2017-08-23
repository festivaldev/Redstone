#import <Foundation/Foundation.h>

@interface AVSystemController : NSObject
+ (id)sharedAVSystemController;
- (BOOL)getActiveCategoryVolume:(float*)arg1 andName:(id*)arg2;

@end
