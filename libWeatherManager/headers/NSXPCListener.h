#import "NSXPCListenerDelegate.h"

@interface NSXPCListener : NSObject
@property (nonatomic, assign) id <NSXPCListenerDelegate> delegate;
- (id)initWithMachServiceName:(NSString *)machServiceName;
- (void)invalidate;
- (void)resume;
@end

