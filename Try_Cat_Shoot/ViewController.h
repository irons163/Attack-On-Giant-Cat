//
//  ViewController.h
//  Try_Cat_Shoot
//

//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameOverViewController.h"
#import "GameHintViewController.h"

@import iAd;
@import GoogleMobileAds;
//@class ViewController; 



@protocol pauseGameDelegate <NSObject>
- (void)pauseGame;
@end

@interface ViewController : UIViewController<BviewControllerDelegate, GameHintDelegate, GADInterstitialDelegate, pauseGameDelegate, ADBannerViewDelegate>

//@property (nonatomic, weak) id <BviewControllerDelegate> delegate;

-(void)removeAd;

@end
