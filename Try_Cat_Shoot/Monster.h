//
//  Monster.h
//  Try_Cat_Shoot
//
//  Created by irons on 2014/10/9.
//  Copyright (c) 2014年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Effect.h"
#import "TextureHelper.h"

@interface Monster : SKSpriteNode {

}

-(void) setEffect;
-(void) doEffect:(int)hitPower;
-(int) getDir;
-(void) setDir:(int)dir;
-(int) getCount;
-(void) setCount:(int)count;
@property (nonatomic) Effect * effect;
@property (nonatomic) BOOL * isNoTool;

-(id) initWithSpriteSheetNamed: (NSString *) spriteSheet withinNode: (SKSpriteNode *) scene sourceRect: (CGRect) source andRowNumberOfSprites: (int) rowNumberOfSprites andColNumberOfSprites: (int) colNumberOfSprites;

-(NSArray*) getTextures;

-(Monster*) newMonster;

-(void) setEffectWithHitCount:(int)hitCount withNoTool:(BOOL)isNoTool;
-(void) setEffectWithBelowHitCount:(int)hitCount withNoTool:(BOOL)isNoTool;

-(void) changeType;

-(void) setMoveToY:(int)y;
-(int) getMoveToY;

//@property int direction;
@end

//int direction = 0;