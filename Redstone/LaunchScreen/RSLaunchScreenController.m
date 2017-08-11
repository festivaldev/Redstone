#import "Redstone.h"

@implementation RSLaunchScreenController

- (id)init {
	if (self = [super init]) {
		self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		[self.window setWindowLevel:2];
		[self.window setBackgroundColor:[RSAesthetics accentColor]];
		
		launchImageView = [UIImageView new];
		[self.window addSubview:launchImageView];
	}
	
	return self;
}

- (void)setLaunchIdentifier:(NSString *)launchIdentifier {
	_launchIdentifier = launchIdentifier;
	
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

- (void)animateIn {
	_isLaunchingApp = YES;
	
	[self.window makeKeyAndVisible];
	[self.window setAlpha:0];
	[self.window setHidden:NO];
	
	[launchImageView setHidden:NO];
	
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
	
	[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animateOut) userInfo:nil repeats:NO];
}

- (void)animateOut {
	[rootTimeout invalidate];
	rootTimeout = nil;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
																function:CubicEaseInOut
															   fromValue:1.0
																 toValue:0.0];
		[opacity setDuration:0.225];
		[opacity setRemovedOnCompletion:NO];
		[opacity setFillMode:kCAFillModeForwards];
		[self.window.layer addAnimation:opacity forKey:@"opacity"];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			_isLaunchingApp = NO;
			[self.window setHidden:YES];
		});
	});
}

@end
