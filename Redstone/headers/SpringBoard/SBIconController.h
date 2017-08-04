#import <Foundation/Foundation.h>

@class SBIconModel;

@interface SBIconController : NSObject

+ (id)sharedInstance;
- (SBIconModel*)model;
- (void)_launchIcon:(id)arg1;

@end
