//
//  CommondUtil.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/15.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "CommonUtil.h"
#import "Reachability.h"

static CommonUtil* instance;

@implementation CommonUtil

- (id)init {
    if (self=[super init]) {
        self.isPurchased = false;
        self.isBillDebug = true;
    }
    return self;
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (bool)isConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        return false;
    } else {
        return true;
    }
    
}

+ (void)resetGameRecoder:(CommonUtil *)commonUtil {
    commonUtil.recordGameLevel = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:commonUtil.recordGameLevel forKey:@"currentLevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentGameTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentClearBall"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end
