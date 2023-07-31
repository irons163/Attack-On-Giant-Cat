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

@implementation ViewController {
    GADInterstitial *interstitial;
    CommonUtil *commonUtil;
}

MyScene *scene;
bool isGoToFirstGameLevel = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    commonUtil = [CommonUtil sharedInstance];
    
    //this will load wether or not they bought the in-app purchase
    if (commonUtil.isPurchased) {
        // NO AD
    } else {
        // AD
    }
    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    interstitial = [self createAndLoadInterstitial];
    
    SKView * skView = (SKView *)self.view;
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
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
    
    if (commonUtil.isPurchased && commonUtil.recordGameLevel > 0) {
        [scene gameContinue:commonUtil.recordGameLevel];
    } else {
        [scene gameStart];
    }
    
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

- (void)pauseGame {
    [MyScene setAllGameRun:NO];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)gameOverWithWin:(bool)didWin {
    UIAlertView *alert = [UIAlertView new];
    alert.title = didWin ? @"You won!": @"You lost";
    alert.message = @"Game Over";
    [alert show];
}

- (void)gameOverWithLose:(int)gameLevel withGameTime:(int)gameTime withClearedHands:(int)clearedHands {
    GameOverViewController* gameOverDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverDialogViewController.delegate = self;
    gameOverDialogViewController.gameLevel = gameLevel;
    gameOverDialogViewController.gameTime = gameTime;
    gameOverDialogViewController.clearedHands = clearedHands;
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [gameOverDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self.navigationController presentViewController:gameOverDialogViewController animated:YES completion:^{
        
    }];
}

- (void)gameWin:(int)gameLevel withGameTime:(int)gameTime withClearedHands:(int)clearedHands {
    GameSuccessViewController *gameWinDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameSuccessViewController"];
    gameWinDialogViewController.gameTime = gameTime;
    gameWinDialogViewController.clearedHands = clearedHands;
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [gameWinDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self.navigationController presentViewController:gameWinDialogViewController animated:YES completion:^{
    }];
}

- (void)gameHint:(NSString*)gameHintID {
    GameHintViewController *gameHintDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:gameHintID];
    gameHintDialogViewController.delegate = self;
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [gameHintDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self.navigationController presentViewController:gameHintDialogViewController animated:YES completion:^{

    }];
}

- (void)BviewcontrollerDidTapButton {
    isGoToFirstGameLevel = true;
    
    if (commonUtil.isPurchased) {
        [scene gameContinue:commonUtil.recordGameLevel];
    } else {
        if ([self showAdmob]) {
            
        } else {
            [scene resetGameToFirstLevel];
        }
    }
}

- (void)BviewcontrollerDidTapBackToMenuButton {
    SKView *skView = (SKView *)self.view;
    [scene destroy];
    scene = nil;
    [skView presentScene:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)GameHintDismissTouch {
    [scene gameStartAfterGameHintDismiss];
}

- (void)showBuyViewController {
    BuyViewController* buyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyViewController"];
    buyViewController.viewController = self;
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [buyViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:buyViewController animated:YES completion:^{
        [MyScene setAllGameRun:NO];
    }];
}

- (void)showRankViewController {
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil showGameCenter:self];
    [gameCenterUtil submitAllSavedScores];
}

- (BOOL)showAdmob {
    if (commonUtil.isPurchased) {
        return false;
    }
    
    if ([interstitial isReady]) {
        [interstitial presentFromRootViewController:self];
        return true;
    } else {
        self->interstitial = [self createAndLoadInterstitial];
        return false;
    }
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
    
    if (isGoToFirstGameLevel) {
        [scene resetGameToFirstLevel];
    } else {
        [scene resetGameToNext];
    }
}

- (void)removeAd {
    // Remove AD
}

@end
