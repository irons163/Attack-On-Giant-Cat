//
//  Effect.m
//  Try_Cat_Shoot
//
//  Created by irons on 2014/10/9.
//  Copyright (c) 2014年 irons. All rights reserved.
//

#import "Effect.h"
//#import "Tool.h"

@interface Effect (){
    bool isNoTool;
}

@end

@implementation Effect{
    Boolean hasTool;
    int hit;
    enum A a;
    
    enum A {
        A,B,C,D
    };
}



//Tool * tool;

-(void)newEffectWithHitCount:(int)hitCount withNoTool:(BOOL)isNoTool{
    switch (hitCount) {
        case 1:
            a = A;
            break;
        case 2:
            a = B;
            break;
        case 3:
            a = C;
            break;
        case 4:
            a = D;
            break;
        default:
            break;
    }
    
    hit = hitCount;
    
    self->isNoTool = isNoTool;
    if(!isNoTool)
        [self checkAndCreateTool];
}

-(void)newEffect{
    
    int r = arc4random_uniform(4);
    
    switch (r) {
        case 0:
            a = A;
            break;
        case 1:
            a = B;
            break;
        case 2:
            a = C;
            break;
        case 3:
            a = D;
            break;
        default:
            break;
    }
    
//    a = B;
    
    switch (a) {
        case A:
            hit = 1;
            break;
        case B:
            hit = 2;
            break;
        case C:
//            _tool = [Tool new];
//            [_tool newTool];
            hit = 3;
//            hasTool = true;
            break;
        case D:
            hit = 4;
//            [newMonster];
            break;
        default:
            break;
    }
    
    isNoTool = false;
    
    [self checkAndCreateTool];

}

-(void)newEffectWithBelowHitCount:(int)hitCount withNoTool:(BOOL)isNoTool{
    
    int r = arc4random_uniform(hitCount);
    
    switch (r) {
        case 0:
            a = A;
            break;
        case 1:
            a = B;
            break;
        case 2:
            a = C;
            break;
        case 3:
            a = D;
            break;
        default:
            break;
    }
    
    switch (a) {
        case A:
            hit = 1;
            break;
        case B:
            hit = 2;
            break;
        case C:
            hit = 3;
            break;
        case D:
            hit = 4;
            break;
        default:
            break;
    }

    self->isNoTool = isNoTool;
    
    if(!isNoTool)
        [self checkAndCreateTool];
    
}

-(void)checkAndCreateTool{
    if(hit==1){
        int r = arc4random_uniform(7);
        if (r==0) {
            hasTool = true;
        }
    }
}

-(void)doEffect:(int)hitPower{
    switch (a) {
        case A:
        [self hit:hitPower];
            break;
        case B:
        [self hit:hitPower];
            break;
        case C:
//            [self.tool doToolEffect];
            [self hit:hitPower];
            break;
        case D:
            //            [self.tool doToolEffect];
            [self hit:hitPower];
            break;
        default:
            break;
    }
    
    if(!isNoTool)
        [self checkAndCreateTool];
}

int number = 0;

void(^myBlock)(void)=NULL;

void(^myBlock2)(void)=^(void){
    NSLog(@"This is Block Output, number=%i", number);
};

-(void)newHands{
    myBlock = ^(void){
        
    };
    
    myBlock2();
}

-(void)hit:(int)hitPower{
    hit-=hitPower;
    if (hit<0) {
        hit=0;
    }
}

-(Boolean)isHitDone{
    return hit==0;
}

//void tool(){
//    
//}

-(Boolean)hasTool{
    return hasTool;
}

-(int)getHitCount{
    return hit;
}

-(void) newMonster{
    
}
    @end