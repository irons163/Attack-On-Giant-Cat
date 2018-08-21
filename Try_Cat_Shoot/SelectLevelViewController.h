//
//  SelectLevelViewController.h
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/1.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLevelViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *continueBtn;
@property (strong, nonatomic) IBOutlet UIImageView *menuBgImage;

- (IBAction)startClick:(id)sender;
- (IBAction)systemClick:(id)sender;
- (IBAction)exitClick:(id)sender;
- (IBAction)continueClick:(id)sender;
@end
