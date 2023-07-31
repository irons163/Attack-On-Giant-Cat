//
//  AppDelegate.m
//  Try_Cat_Shoot
//
//  Created by irons on 2014/9/29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"
#import "GameCenterUtil.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    /*
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    */
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%@", NSStringFromClass([self.window.rootViewController class]));
    
    [MyScene setAllGameRun:NO];
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@end
