@interface NSXPCInterface : NSObject
+ (NSXPCInterface *)interfaceWithProtocol:(Protocol *)protocol;
- (void)setClass:(Class)argumentClass forSelector:(SEL)selector argumentIndex:(int)argumentIndex ofReply:(BOOL)ofReply;
- (void)setClasses:(NSSet *)classes forSelector:(SEL)selector argumentIndex:(int)argumentIndex ofReply:(BOOL)ofReply;
@end
