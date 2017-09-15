#import "Redstone.h"

@implementation RSLaunchScreenController

UIImage* _UICreateScreenUIImage();

- (id)init {
	if (self = [super init]) {
		self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[self.window setWindowLevel:2];
		[self.window setBackgroundColor:[RSAesthetics accentColor]];
		
		launchImageView = [UIImageView new];
		[self.window addSubview:launchImageView];
		
		applicationSnapshot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[applicationSnapshot setHidden:YES];
		[self.window setUserInteractionEnabled:NO];
		[self.window addSubview:applicationSnapshot];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateOut) name:@"RedstoneApplicationDidBecomeActive" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:@"RedstoneApplicationWillEnterForeground" object:nil];
	}
	
	return self;
}

- (void)applicationWillEnterForeground {
	SBApplication* frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (frontApp) {
		[self setIsUnlocking:NO];
		[self setLaunchIdentifier:[frontApp bundleIdentifier]];
	}
}

- (void)setLaunchIdentifier:(NSString *)launchIdentifier {
	_launchIdentifier = launchIdentifier;
	NSLog(@"[Redstone] LaunchScreenController setLaunchIdentifier: %@", launchIdentifier);
	
	RSTileInfo* tileInfo = [[RSTileInfo alloc] initWithBundleIdentifier:launchIdentifier];
	
	if (tileInfo) {
		[self.window setBackgroundColor:[[RSAesthetics accentColorForTile:tileInfo] colorWithAlphaComponent:1.0]];
		if (tileInfo.fullSizeArtwork) {
			[launchImageView setFrame:CGRectMake(0, 0, 269, 132)];
			[launchImageView setImage:[RSAesthetics imageForTileWithBundleIdentifier:launchIdentifier size:3 colored:YES]];
		} else {
			[launchImageView setFrame:CGRectMake(0, 0, 76, 76)];
			[launchImageView setImage:[RSAesthetics imageForTileWithBundleIdentifier:launchIdentifier size:3 colored:tileInfo.hasColoredIcon]];
			[launchImageView setTintColor:[UIColor whiteColor]];
		}
		
		[launchImageView setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
	} else {
		[self.window setBackgroundColor:[RSAesthetics accentColor]];
	}
}

- (void)setIsUnlocking:(BOOL)isUnlocking {
	_isUnlocking = isUnlocking;
	NSLog(@"[Redstone] LaunchScreenController setIsUnlocking: %d", isUnlocking);
}

- (void)setIsLaunchingApp:(BOOL)isLaunchingApp {
	_isLaunchingApp = isLaunchingApp;
	NSLog(@"[Redstone] LaunchScreenController setIsLaunchingApp: %d", isLaunchingApp);
}

- (void)animateIn {
	NSLog(@"[Redstone] LaunchScreenController animateIn");
	[self setIsLaunchingApp:YES];
	
	[rootTimeout invalidate];
	
	[self.window makeKeyAndVisible];
	[self.window setAlpha:0];
	[self.window setHidden:NO];
	
	[launchImageView setHidden:NO];
	[applicationSnapshot setImage:nil];
	[applicationSnapshot setHidden:YES];
	
	[self.window.layer removeAllAnimations];
	[launchImageView.layer removeAllAnimations];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseIn
														   fromValue:0.0
															 toValue:1.0];
	[opacity setDuration:0.3];
	[opacity setRemovedOnCompletion:NO];
	[opacity setFillMode:kCAFillModeForwards];
	[self.window.layer addAnimation:opacity forKey:@"opacity"];
	
	CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:CubicEaseOut
														 fromValue:0.8
														   toValue:1.0];
	[scale setDuration:0.5];
	[scale setRemovedOnCompletion:NO];
	[scale setFillMode:kCAFillModeForwards];
	[launchImageView.layer addAnimation:scale forKey:@"scale"];
	
	rootTimeout = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animateOut) userInfo:nil repeats:NO];
}

- (void)animateOut {
	NSLog(@"[Redstone] LaunchScreenController animateOut");
	[self.window setAlpha:1];
	[self.window.layer removeAllAnimations];
	[launchImageView.layer removeAllAnimations];
	
	[rootTimeout invalidate];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.225 animations:^{
			[self.window setEasingFunction:easeInOutCubic forKeyPath:@"frame"];
			[self.window setAlpha:0.0];
		} completion:^(BOOL finished) {
			[self setIsLaunchingApp:NO];
			[self.window removeEasingFunctionForKeyPath:@"frame"];
			[self.window setHidden:YES];
		}];
	});
}

- (void)animateCurrentApplicationSnapshot {
	NSLog(@"[Redstone] LaunchScreenController animateCurrentApplicationSnapshot");
	if (self.isLaunchingApp) {
		NSLog(@"[Redstone] LaunchScreenController animateCurrentApplicationSnapshot isLaunchingApp");
		return;
	}
	
	
	[self setIsLaunchingApp:YES];
	
	[applicationSnapshot.layer removeAllAnimations];
	[applicationSnapshot setImage:_UICreateScreenUIImage()];
	[applicationSnapshot setHidden:NO];
	
	[self.window.layer removeAllAnimations];
	[self.window setBackgroundColor:[UIColor clearColor]];
	[launchImageView setHidden:YES];
	
	[self.window makeKeyAndVisible];
	[self.window setAlpha:0];
	[self.window setHidden:NO];
	
	CAAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseInOut
														   fromValue:1.0
															 toValue:0.0];
	opacity.duration = 0.2;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	
	CAAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:CubicEaseInOut
														 fromValue:1.0
														   toValue:1.5];
	scale.duration = 0.15;
	scale.removedOnCompletion = NO;
	scale.fillMode = kCAFillModeForwards;
	
	[self.window.layer addAnimation:opacity forKey:@"opacity"];
	[self.window.layer addAnimation:scale forKey:@"scale"];
	
	//hideTimeout = [NSTimer timerWithTimeInterval:0.2 target:^{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self setIsLaunchingApp:NO];
		
		[self.window setHidden:YES];
		[applicationSnapshot setImage:nil];
		[applicationSnapshot setHidden:YES];
	});
}

@end
