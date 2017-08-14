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
	
	[rootTimeout invalidate];
	[animationTimeout invalidate];
	[hideTimeout invalidate];
	
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
	
	[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animateOut) userInfo:nil repeats:NO];
}

- (void)animateOut {
	[self animateOut:NO];
}

- (void)animateOut:(BOOL)forceClose {
	[self.window setAlpha:1];
	[self.window.layer removeAllAnimations];
	[launchImageView.layer removeAllAnimations];
	
	[rootTimeout invalidate];
	[animationTimeout invalidate];
	[hideTimeout invalidate];
	
	animationTimeout = [NSTimer scheduledTimerWithTimeInterval:(forceClose ? 0.0 : 1.0) target:[NSBlockOperation blockOperationWithBlock:^{
		
		[UIView animateWithDuration:0.225 animations:^{
			[self.window setEasingFunction:easeInOutCubic forKeyPath:@"frame"];
			[self.window setAlpha:0.0];
		} completion:^(BOOL finished) {
			_isLaunchingApp = NO;
			[self.window removeEasingFunctionForKeyPath:@"frame"];
			[self.window setHidden:YES];
		}];
	}] selector:@selector(main) userInfo:nil repeats:NO];
}

- (void)animateCurrentApplicationSnapshot {
	if (_isLaunchingApp) {
		return;
	}
	
	_isLaunchingApp = YES;
	
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
	
	hideTimeout = [NSTimer timerWithTimeInterval:0.2 target:^{
		_isLaunchingApp = NO;
		
		[self.window setHidden:YES];
		[applicationSnapshot setImage:nil];
		[applicationSnapshot setHidden:YES];
	} selector:@selector(invoke) userInfo:nil repeats:NO];
}

@end
