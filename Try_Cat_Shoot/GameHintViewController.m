//
//  GameOverViewController.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/11.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameHintViewController.h"
#import "ViewController.h"
#import "TextureHelper.h"

@interface GameHintViewController ()<GameHintDelegate>

@end

@implementation GameHintViewController

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
    //    self.gameLevelTensDigitalLabel.image = [TextureHelper timeTextures][0];
    
    self.gameLevelTensDigitalLabel.image = [self getNumberImage:(self.gameLevel+1)/10];
    
    self.gameLevelSingleDigital.image = [self getNumberImage:(self.gameLevel+1)%10];
    
    self.gameTimeMinuteTensDIgitalLabel.image = [self getNumberImage:self.gameTime/60/10];
    self.gameTimeMinuteSingleDigitalLabel.image = [self getNumberImage:self.gameTime/60%10];
    self.gameTimeSecondTensDigitalLabel.image = [self getNumberImage:self.gameTime%60/10];
    self.gameTimeSecondSingleDigitalLabel.image = [self getNumberImage:self.gameTime%60%10];
}

- (UIImage *)getNumberImage:(int)number {
    UIImage* image;
    switch (number) {
        case 0:
            image = [TextureHelper timeImages][0];
            break;
        case 1:
            image = [TextureHelper timeImages][1];
            break;
        case 2:
            image = [TextureHelper timeImages][2];
            break;
        case 3:
            image = [TextureHelper timeImages][3];
            break;
        case 4:
            image = [TextureHelper timeImages][4];
            break;
        case 5:
            image = [TextureHelper timeImages][5];
            break;
        case 6:
            image = [TextureHelper timeImages][6];
            break;
        case 7:
            image = [TextureHelper timeImages][7];
            break;
        case 8:
            image = [TextureHelper timeImages][8];
            break;
        case 9:
            image = [TextureHelper timeImages][9];
            break;
    }
    return image;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:true completion:^{
        [self.delegate GameHintDismissTouch];
    }];
}


@end
