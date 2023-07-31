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

@import GoogleMobileAds;

@protocol pauseGameDelegate <NSObject>

- (void)pauseGame;

@end

@interface ViewController : UIViewController<BviewControllerDelegate, GameHintDelegate, GADInterstitialDelegate, pauseGameDelegate>

- (void)removeAd;

@end
