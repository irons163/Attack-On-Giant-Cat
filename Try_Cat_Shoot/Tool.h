//
//  Tool.h
//  Try_Cat_Shoot
//
//  Created by irons on 2014/10/9.
//  Copyright (c) 2014年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum ToolType{
    A,B,C,D,E
} ToolType;

@interface Tool : SKSpriteNode{
    //ToolType tool;
    ToolType tool;
}




-(void)doToolEffect;
-(void) newTool;
-(void) newToolWithFaster;
-(void) newToolWithF_Double;
-(void) newToolWithF_D_Triple;
-(void) newToolWithPower;
-(void) newToolWithP_Heal;
-(ToolType)getToolType;
@end
