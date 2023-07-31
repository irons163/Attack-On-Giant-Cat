//
//  SelectLevelViewController.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/1.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "SelectLevelViewController.h"
#import "CommonUtil.h"

@interface SelectLevelViewController ()

@end

@implementation SelectLevelViewController {
    NSUserDefaults *userDefaults;
    CommonUtil * commonUtil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuBgImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",NSLocalizedString(@"MENU_BG", "")]];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    commonUtil = [CommonUtil sharedInstance];
    commonUtil.isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPurchased"];
    
    [self checkContinueGame];
}

- (void)checkContinueGame {
    commonUtil.recordGameLevel = [userDefaults integerForKey:@"currentLevel"];
    if(commonUtil.isPurchased && commonUtil.recordGameLevel>0){
        self.continueBtn.hidden = false;
        NSLog(@"show continueBtn");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkContinueGame];
}

- (IBAction)startClick:(id)sender {
    if (!self.continueBtn.hidden) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(@"START_NEW_GAME", @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alertView show];
    } else {
        [self startGame];
    }
}

- (void)startGame {
    UIViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:gameViewController animated:true];
}

- (IBAction)systemClick:(id)sender {
    UIViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemViewController"];
    
    [self.navigationController pushViewController:gameViewController animated:true];
}

- (IBAction)exitClick:(id)sender {
    
}

- (IBAction)continueClick:(id)sender {
    UIViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:gameViewController animated:true];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel Button Pressed");
            break;
        case 1:
            NSLog(@"Ok Button Pressed");
            [CommonUtil resetGameRecoder:commonUtil];
            [self startGame];
            break;
        default:
            break;
    }
}

@end
