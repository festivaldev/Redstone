#import <BulletinBoard/BBObserver.h>

@interface SBBulletinBannerController : NSObject

+ (id)sharedInstance;
- (BBObserver*)observer;

@end
