//
//  Effect.h
//  Try_Cat_Shoot
//
//  Created by irons on 2014/10/9.
//  Copyright (c) 2014年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Tool.h"

@interface Effect : NSObject

-(void) newEffect;
-(void)doEffect:(int)hitPower;
-(Boolean) isHitDone;
-(Boolean) hasTool;
//@property (nonatomic) Tool * tool;
-(int)getHitCount;
-(void)newEffectWithHitCount:(int)hitCount withNoTool:(BOOL)isNoTool;
-(void)newEffectWithBelowHitCount:(int)hitCount withNoTool:(BOOL)isNoTool;
@end
