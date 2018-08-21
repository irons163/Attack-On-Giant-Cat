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
    // Do any additional setup after loading the view.
    self.gameTimeLabel.text = [CommonUtil timeFormatted:self.gameTime];
    
    self.clearedHandsLabel.text = [NSString stringWithFormat:@"%d", self.clearedHands];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
//        [self.delegate BviewcontrollerDidTapBackToMenuButton];
    }];
}

@end
