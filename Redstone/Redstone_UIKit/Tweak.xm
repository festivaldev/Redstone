#import <objcipc/objcipc.h>

%ctor {
	// Application became active
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		if(![[notification.object class] isSubclassOfClass:[%c(SpringBoard) class]]) {
			NSLog(@"[Redstone] application became active");
			[OBJCIPC sendMessageToSpringBoardWithMessageName:@"Redstone.Application.BecameActive" dictionary:nil];
		}
	}];
	
	// Application will terminate
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		if(![[notification.object class] isSubclassOfClass:[%c(SpringBoard) class]]) {
			NSLog(@"[Redstone] application will terminate");
			[OBJCIPC sendMessageToSpringBoardWithMessageName:@"Redstone.Application.WillTerminate" dictionary:nil];
		}
	}];
	
	// Application did enter background
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		if(![[notification.object class] isSubclassOfClass:[%c(SpringBoard) class]]) {
			NSLog(@"[Redstone] application did enter background");
		}
	}];
	
	// Application will enter foreground
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		if(![[notification.object class] isSubclassOfClass:[%c(SpringBoard) class]]) {
			NSLog(@"[Redstone] application will enter foreground");
			[OBJCIPC sendMessageToSpringBoardWithMessageName:@"Redstone.Application.WillEnterForeground" dictionary:nil];
		}
	}];
}
