//
//  GameSuccessViewController.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/6/28.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameSuccessViewController.h"
#import "CommonUtil.h"

@interface GameSuccessViewController ()

@end

@implementation GameSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameTimeLabel.text = [CommonUtil timeFormatted:self.gameTime];
    
    self.clearedHandsLabel.text = [NSString stringWithFormat:@"%d", self.clearedHands];
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

@end
