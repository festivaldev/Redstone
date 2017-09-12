#import <Cephei/HBPreferences.h>

%group callservice

%hook _UISecureHostedWindow

- (void)layoutSubviews {
	%orig;
	[self setValue:[UIColor colorWithWhite:0.12 alpha:1.0] forKey:@"backgroundColor"];
}

%end	// %hook _UISecureHostedWindow

%end	// %group callservice

%ctor {
	id preferences = [[HBPreferences alloc] initWithIdentifier:@"ml.festival.redstone"];
	
	if ([[preferences objectForKey:@"enabled"] boolValue]) {
		%init(callservice);
	}
}
