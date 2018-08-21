//
//  SelectCarViewController.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/1.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "SelectCarViewController.h"

@interface SelectCarViewController ()

@end

@implementation SelectCarViewController

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

- (IBAction)carButtonPressed:(id)sender {
    
    
//    SKTAudio.sharedInstance().playSoundEffect("button_press.wav");
    
    UIViewController * levelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectLevelViewController"];
//    levelViewController.carType = CarType(rawValue: sender.tag)!
    [self.navigationController pushViewController:levelViewController animated:true];
    
}

- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:true];
}


@end
