//
//  ViewController.m
//  Try_Cat_Shoot
//
//  Created by irons on 2014/9/29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "CommonUtil.h"
#import "BuyViewController.h"
#import "GameCenterUtil.h"
#import "GameSuccessViewController.h"

@implementation ViewController{
    ADBannerView * adBannerView;
    GADInterstitial *interstitial;
    CommonUtil * commonUtil;
}

MyScene * scene;
bool isGoToFirstGameLevel = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    commonUtil = [CommonUtil sharedInstance];
    
    bool areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //this will load wether or not they bought the in-app purchase
    
    if(commonUtil.isPurchased){
//        [self.view setBackgroundColor:[UIColor blueColor]];
        //if they did buy it, set the background to blue, if your using the code above to set the background to blue, if your removing ads, your going to have to make your own code here
    }else{
        adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 200, 30)];
        adBannerView.delegate = self;
        adBannerView.alpha = 1.0f;
        [self.view addSubview:adBannerView];
    }
    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    interstitial = [self createAndLoadInterstitial];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    //scene->game(YES);
//    scene.game(YES);
    
    scene.delegate = self;
    
    scene.onGameEnd2 = ^(bool didWin){
        [self gameOverWithWin:didWin];
    };
    
    scene.onGameOver = ^(int gameLevel, int gameTime, int clearedHands){
        [self gameOverWithLose:gameLevel withGameTime:gameTime withClearedHands:clearedHands];
    };
    
    scene.showAdmob = ^(){
        isGoToFirstGameLevel = false;
        if([self showAdmob]){
            
        }else{
            [scene resetGameToNext];
        }
    };
    
    scene.showBuyViewController = ^(){
        [self showBuyViewController];
    };
    
    scene.showRankViewController = ^(){
        [self showRankViewController];
    };
    
    scene.showGameHint = ^(NSString * gameHintID){
        [self gameHint:gameHintID];
    };
    
    scene.onGameWin = ^(int gameLevel, int gameTime, int clearedHands){
        [self gameWin:gameLevel withGameTime:gameTime withClearedHands:clearedHands];
    };
    
    if(commonUtil.isPurchased && commonUtil.recordGameLevel>0){
        [scene gameContinue:commonUtil.recordGameLevel];
    }else{
        [scene gameStart];
    }
    
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
    
//    scene.game;
//    [scene game];
    
}

-(void)pauseGame{
    [MyScene setAllGameRun:NO];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)goBackalertss: UIAlertControlleraler {

    [self dismissViewControllerAnimated:true completion:^{
        
    }];
    [self.navigationController popToRootViewControllerAnimated:false];
}

-(void) gameOverWithWin:(bool ) didWin{
    UIAlertView *alert = [UIAlertView new];
    alert.title = didWin ? @"You won!": @"You lost";
    alert.message = @"Game Over";
    [alert show];
    
//    [self presentViewController:alert animated:true completion:^{
//        
//    }];
    
//    (title: didWin ? "You won!": "You lost", message: "Game Over", preferredStyle: .Alert)
//    presentViewController(alert, animated: true, completion: nil);
}

-(void) gameOverWithLose:(int)gameLevel withGameTime:(int)gameTime withClearedHands:(int)clearedHands{
    GameOverViewController* gameOverDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverDialogViewController.delegate = self;
    
//    gameOverDialogViewController.gameLevelTensDigitalLabel = time;
    
    gameOverDialogViewController.gameLevel = gameLevel;
    
    gameOverDialogViewController.gameTime = gameTime;
    
    gameOverDialogViewController.clearedHands = clearedHands;
    
//    [self.navigationController popToViewController:gameOverDialogViewController animated:YES];
    
//    [self.delegate BviewcontrollerDidTapButton:self];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [gameOverDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    */
    
    [self.navigationController presentViewController:gameOverDialogViewController animated:YES completion:^{
//        [reset];
    }];
}

-(void) gameWin:(int)gameLevel withGameTime:(int)gameTime withClearedHands:(int)clearedHands{
    GameSuccessViewController* gameWinDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameSuccessViewController"];
    gameWinDialogViewController.gameTime = gameTime;
    gameWinDialogViewController.clearedHands = clearedHands;
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [gameWinDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
    [self.navigationController presentViewController:gameWinDialogViewController animated:YES completion:^{
    }];
}

-(void) gameHint:(NSString*)gameHintID{
    GameHintViewController* gameHintDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:gameHintID];
    gameHintDialogViewController.delegate = self;
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [gameHintDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
    [self.navigationController presentViewController:gameHintDialogViewController animated:YES completion:^{
        //        [reset];
    }];
}

-(void)BviewcontrollerDidTapButton{
//    [scene resetGame];
    isGoToFirstGameLevel = true;
    if(commonUtil.isPurchased){
        [scene gameContinue:commonUtil.recordGameLevel];
    }else{
        if([self showAdmob]){
           
        }else{
            [scene resetGameToFirstLevel];
        }
    }
}

-(void)BviewcontrollerDidTapBackToMenuButton{
    SKView * skView = (SKView *)self.view;
    [scene destroy];
    scene = nil;
    [skView presentScene:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)GameHintDismissTouch{
    [scene gameStartAfterGameHintDismiss];
}

-(void) showBuyViewController{
    BuyViewController* buyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyViewController"];
    buyViewController.viewController = self;
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [buyViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:buyViewController animated:YES completion:^{
        [MyScene setAllGameRun:NO];
    }];
}

-(void) showRankViewController{
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
//    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil showGameCenter:self];
    [gameCenterUtil submitAllSavedScores];
}

-(BOOL)showAdmob{
    if(commonUtil.isPurchased){
        return false;
    }
    
    if ([interstitial isReady]) {
        [interstitial presentFromRootViewController:self];
        return true;
    }else{
        self->interstitial = [self createAndLoadInterstitial];
        return false;
    }
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self layoutAnimated:true];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //    [adBannerView removeFromSuperview];
    //    adBannerView.delegate = nil;
    //    adBannerView = nil;
    [self layoutAnimated:true];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    [MyScene setAllGameRun:NO];
    return true;
}

- (void)layoutAnimated:(BOOL)animated
{
//    CGRect contentFrame = self.view.bounds;
    
    CGRect contentFrame = self.view.bounds;
//    contentFrame.origin.y = -50;
    CGRect bannerFrame = adBannerView.frame;
    if (adBannerView.bannerLoaded)
    {
        //        contentFrame.size.height -= adBannerView.frame.size.height;
        contentFrame.size.height = 0;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
//        bannerFrame.origin.y = contentFrame.size.height;
        bannerFrame.origin.y = -50;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        adBannerView.frame = contentFrame;
        [adBannerView layoutIfNeeded];
        adBannerView.frame = bannerFrame;
    }];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
    interstitial.adUnitID = @"ca-app-pub-3940256099942544/4411468910";
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self->interstitial = [self createAndLoadInterstitial];
    
    if(isGoToFirstGameLevel){
        [scene resetGameToFirstLevel];
    }else{
        [scene resetGameToNext];
    }
    
}

-(void)removeAd{
    [adBannerView setAlpha:0];
}

@end
