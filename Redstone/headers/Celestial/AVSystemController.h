#import <Foundation/Foundation.h>

@interface AVSystemController : NSObject
+ (id)sharedAVSystemController;
- (BOOL)getActiveCategoryVolume:(float*)arg1 andName:(id*)arg2;
- (BOOL)getVolume:(float*)arg1 forCategory:(id)arg2;
- (void)setVolumeTo:(float)arg1 forCategory:(id)arg2;
- (id)attributeForKey:(id)arg1;

@end
