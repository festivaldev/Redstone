#import <Foundation/Foundation.h>
#import <BulletinBoard/BBBulletin.h>

@interface NCNotificationRequest : NSObject

- (BBBulletin*)bulletin;
- (NSSet*)requestDestinations;

@end
