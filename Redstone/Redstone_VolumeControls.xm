#import "Redstone.h"

%group volume

%end

%ctor {
	if ([[[RSPreferences preferences] objectForKey:@"volumeControlsEnabled"] boolValue]) {
		%init(volume);
	}
}
