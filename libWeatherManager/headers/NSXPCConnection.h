#import "NSXPCInterface.h"

typedef NS_OPTIONS(NSUInteger, NSXPCConnectionOptions) {
    NSXPCConnectionPrivileged = (1 << 12UL)
};

@interface NSXPCConnection : NSObject
@property(copy) void (^invalidationHandler)(void);
@property(copy) void (^interruptionHandler)(void);
- (id)initWithMachServiceName:(NSString *)machServiceName;
- (id)initWithMachServiceName:(NSString *)name options:(NSXPCConnectionOptions)options;
- (void)setRemoteObjectInterface:(NSXPCInterface *)interface;
- (void)setExportedInterface:(NSXPCInterface *)interface;
- (void)setExportedObject:(id)exportedObject;
- (id)remoteObjectProxyWithErrorHandler:(void (^)(NSError *error))handler;
- (id)remoteObjectProxy;
- (void)invalidate;
- (void)resume;
@end
