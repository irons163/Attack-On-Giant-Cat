//
//  GameOverViewController.h
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/11.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameHintDelegate <NSObject>

- (void)GameHintDismissTouch;

@end

@interface GameHintViewController : UIViewController

@property int gameLevel;
@property int gameTime;

@property (strong, nonatomic) IBOutlet UIImageView *gameLevelTensDigitalLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gameLevelSingleDigital;
@property (strong, nonatomic) IBOutlet UIImageView *gameTimeMinuteTensDIgitalLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gameTimeMinuteSingleDigitalLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gameTimeSecondTensDigitalLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gameTimeSecondSingleDigitalLabel;

- (IBAction)restartGameClick:(id)sender;
- (IBAction)backToMainMenuClick:(id)sender;

@property (nonatomic, weak) id <GameHintDelegate> delegate;

@end
