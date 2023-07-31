//
//  GameSuccessViewController.h
//  Try_Cat_Shoot
//
//  Created by irons on 2015/6/28.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSuccessViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *gameTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *clearedHandsLabel;

- (IBAction)backBtnClick:(id)sender;

@property int gameTime;
@property int clearedHands;

@end
