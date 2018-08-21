//
//  MyScene.h
//  Try_Cat_Shoot
//

//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameOverViewController.h"

@interface MyScene : SKScene{
    @public
    void(^game)(bool);
    
}

typedef void(^gametype)(bool);
typedef void(^gameOverDialog)(int, int, int);
typedef void(^gameWinDialog)(int, int, int);

enum ShootType{
    None, Faster, Double, Triple,  Power
};

@property (nonatomic, weak) id <BviewControllerDelegate> delegate;

@property (atomic, copy) void (^onGameEnd)(bool);
@property (atomic, copy) gametype onGameEnd2;
@property (atomic, copy) gameOverDialog onGameOver;
@property (atomic, copy) gameWinDialog onGameWin;
typedef void(^admob)();
@property (atomic, copy) admob showAdmob;
typedef void(^buyView)();
@property (atomic, copy) buyView showBuyViewController;
typedef void(^rankView)();
@property (atomic, copy) rankView showRankViewController;
typedef void(^gameHint)(NSString*);
@property (atomic, copy) gameHint showGameHint;

@property int num;
-(void)getClock:(int)a, ...;
+(enum ShootType)getShootType;
+(void)setShootType:(enum ShootType)shootTypee;
+(void)heal;
//-(void)resetGame;
-(void)resetGameToNext;
-(void)resetGameToFirstLevel;

+(void)setAllGameRun:(bool)isrun;
/// private
-(void)setGameRun:(bool)isrun;
-(void)gameStartAfterGameHintDismiss;
-(void)gameStart;
-(void)gameContinue:(int)recordGameLevel;
-(void)destroy;
@end

static int bulletCount = 1;

