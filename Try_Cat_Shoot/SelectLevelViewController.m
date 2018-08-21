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

@implementation SelectLevelViewController{
    NSUserDefaults *userDefaults;
    CommonUtil * commonUtil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuBgImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",NSLocalizedString(@"MENU_BG", "")]];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    commonUtil = [CommonUtil sharedInstance];
    commonUtil.isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPurchased"];
//    commonUtil.isPurchased = true;
    
    [self checkContinueGame];
}

-(void)checkContinueGame{
    commonUtil.recordGameLevel = [userDefaults integerForKey:@"currentLevel"];
    if(commonUtil.isPurchased && commonUtil.recordGameLevel>0){
        self.continueBtn.hidden = false;
        NSLog(@"show continueBtn");
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self checkContinueGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startClick:(id)sender {
    
    if(!self.continueBtn.hidden){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:NSLocalizedString(@"START_NEW_GAME", @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alertView show];
    }else{
        [self startGame];
    }
}

-(void)startGame{
    UIViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:gameViewController animated:true];
}

- (IBAction)systemClick:(id)sender {
    UIViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemViewController"];
    
    [self.navigationController pushViewController:gameViewController animated:true];
}

- (IBAction)exitClick:(id)sender {
//    exit(0);
}

- (IBAction)continueClick:(id)sender {
    UIViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:gameViewController animated:true];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
