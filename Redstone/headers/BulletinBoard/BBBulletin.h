#import <Foundation/Foundation.h>

@interface BBBulletin : NSObject

- (id)bulletinID;
- (id)title;
- (id)subtitle;
- (id)message;
- (id)content;
- (id)section;
- (NSDate*)date;
- (id)responseForDefaultAction;

@end
