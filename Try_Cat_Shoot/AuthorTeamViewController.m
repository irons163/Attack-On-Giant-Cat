//
//  AuthorTeamViewController.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/14.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "AuthorTeamViewController.h"

@interface AuthorTeamViewController ()

@end

@implementation AuthorTeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
