//
//  Tool.m
//  Try_Cat_Shoot
//
//  Created by irons on 2014/10/9.
//  Copyright (c) 2014年 irons. All rights reserved.
//

#import "Tool.h"
#import "MyScene.h"



@interface Tool (){

}
@property SKSpriteNode * cat;

@end

@implementation Tool







-(void) newTool{
    int r = arc4random_uniform(5);
//    r = 2;
    switch (r) {
        case 0:
            tool = A;
            
            
            break;
        case 1:
             tool = B;
            
            break;
        case 2:
             tool = C;
            
            break;
        case 3:
            tool = D;
            
            break;
        case 4:
            tool = E;
            
            break;
        default:
            break;
    }
    
//    tool = A;
//    self.cat = cat;
}

-(void) newToolWithFaster{
    tool = A;
}

-(void) newToolWithF_Double{
    int r = arc4random_uniform(2);
    switch (r) {
        case 0:
            tool = A;
            break;
        case 1:
            tool = B;
            
            break;
        case 2:
            tool = C;
            
            break;
        case 3:
            tool = D;
            
            break;
        case 4:
            tool = E;
            
            break;
        default:
            break;
    }
}

-(void) newToolWithF_D_Triple{
    int r = arc4random_uniform(3);
    switch (r) {
        case 0:
            tool = A;
            break;
        case 1:
            tool = B;
            
            break;
        case 2:
            tool = C;
            
            break;
        case 3:
            tool = D;
            
            break;
        case 4:
            tool = E;
            
            break;
        default:
            break;
    }
}

-(void) newToolWithPower{
    tool = D;
}

-(void) newToolWithP_Heal{
    int r = arc4random_uniform(2);
    switch (r) {
        case 0:
            tool = D;
            break;
        case 1:
            tool = E;
            break;
        default:
            break;
    }
}

-(void)doToolEffect{
    switch (tool) {
        case A:
        [self faster];
            break;
        case B:
            [self double2];
            break;
        case C:
            [self triple3];
            break;
        case D:
            [self power];
            break;
        case E:
            [self heal];
            break;
        default:
            break;
    }
}

-(void) faster{
    [MyScene setShootType:Faster];
    MyScene:bulletCount = 1;
}

-(void)double2{
   
    [MyScene setShootType:Double];
    MyScene:bulletCount = 1;
//    static.MyScene:bulletCount = 2;
    
}

-(void)triple3{
[MyScene setShootType:Triple];
MyScene:bulletCount = 1;
}

-(void)power{
    [MyScene setShootType:Power];
     MyScene:bulletCount = 2;
}

-(void)heal{
//    [MyScene setShootType:Heal];
    [MyScene heal];
//    MyScene:bulletCount = 2;
}

-(ToolType)getToolType{
    return tool;
}

@end
