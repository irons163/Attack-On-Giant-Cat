//
//  Monster.m
//  Try_Cat_Shoot
//
//  Created by irons on 2014/10/9.
//  Copyright (c) 2014年 irons. All rights reserved.
//

#import "Monster.h"
#import "Effect.h"


@interface Monster (){
    int bb;
    int direction;
    int count;
    int moveToY;
}
@property NSString * ss;

- (void)other;

@end

@implementation Monster

static NSString* ss;

int aa;
Effect * e;
NSMutableArray *animatingFrames;
SKTexture *temp;
NSMutableArray *mAnimatingFrames;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ss = @"123";
    });

}

-(void) setEffectWithNoTool{
    
}

-(void) setEffectWithBelowHitCount:(int)hitCount withNoTool:(BOOL)isNoTool{
    self.effect = [Effect new];
    
    [self.effect newEffectWithBelowHitCount:hitCount withNoTool:isNoTool];
    
    self.isNoTool = isNoTool;
    
    NSArray *hand;
    
    switch (self.effect.getHitCount) {
        case 1:
            hand = TextureHelper.hand1Textures;
            break;
        case 2:
            hand = TextureHelper.hand2Textures;
            break;
        case 3:
            hand = TextureHelper.hand3Textures;
            break;
        case 4:
            hand = TextureHelper.hand4Textures;
            break;
        default:
            break;
    }
    
    SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:hand timePerFrame:0.08]];
    
    [self runAction:[SKAction repeatActionForever: monsterAnimation ] withKey:@"monster"];
}

-(void) setEffect{

    
    self.effect = [Effect new];
    
    [self.effect newEffect];
    
    
    NSArray *hand;

    switch (self.effect.getHitCount) {
        case 1:
            hand = TextureHelper.hand1Textures;
            break;
        case 2:
            hand = TextureHelper.hand2Textures;
            break;
        case 3:
            hand = TextureHelper.hand3Textures;
            break;
        case 4:
            hand = TextureHelper.hand4Textures;
            break;
        default:
            break;
    }
    
    SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:hand timePerFrame:0.08]];
    
    [self runAction:[SKAction repeatActionForever: monsterAnimation ]];
    
//    [TextureHelper hand1Textures];
//    
//    TextureHelper *helper = [TextureHelper new];
//    
//    helper.hand2Textures = nil;
//    
//    TextureHelper.hand1;
//    
//    TextureHelper* helper = [TextureHelper new];
//
//    NSArray *hand2 = TextureHelper.hand2Textures;
}

-(void) setEffectWithHitCount:(int)hitCount withNoTool:(BOOL)isNoTool{
    self.effect = [Effect new];
    
    [self.effect newEffectWithHitCount:hitCount withNoTool:isNoTool];
    
    self.isNoTool = isNoTool;
    
    NSArray *hand;
    
    switch (self.effect.getHitCount) {
        case 1:
            hand = TextureHelper.hand1Textures;
            break;
        case 2:
            hand = TextureHelper.hand2Textures;
            break;
        case 3:
            hand = TextureHelper.hand3Textures;
            break;
        case 4:
            hand = TextureHelper.hand4Textures;
            break;
        default:
            break;
    }
    
    SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:hand timePerFrame:0.08]];
    
    [self runAction:[SKAction repeatActionForever: monsterAnimation ] withKey:@"monster"];

}

-(void) doEffect:(int)hitPower{
    [self.effect doEffect:hitPower];
}

-(int) getDir{
    return direction;
}

-(void) setDir:(int)dir{
    direction = dir;
}

-(int) getCount{
    return count;
}

-(void) setCount:(int)c{
    count = c;
}

-(int)getMoveToY{
    return moveToY;
}

-(void)setMoveToY:(int)y{
    moveToY = y;
}

-(id) initWithSpriteSheetNamed: (NSString *) spriteSheet withinNode: (SKSpriteNode *) scene sourceRect: (CGRect) source andRowNumberOfSprites: (int) rowNumberOfSprites andColNumberOfSprites: (int) colNumberOfSprites{
    
    // @param numberOfSprites - the number of sprite images to the left
    // @param scene - I add my sprite to a map node. Change it to a SKScene
    // if [self addChild:] is used.
    
    mAnimatingFrames = [NSMutableArray array];
    
//    SKTexture  *ssTexture = [SKTexture textureWithImageNamed:spriteSheet];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hand1"
                                                     ofType:@"png"];
    UIImage *myImage = [UIImage imageWithContentsOfFile:path];

    SKTexture  *ssTexture = [SKTexture textureWithImage:myImage];
    
    // Makes the sprite (ssTexture) stay pixelated:
    ssTexture.filteringMode = SKTextureFilteringNearest;
    
    float sx = source.origin.x;
    float sy = source.origin.y;
    float sWidth = source.size.width;
    float sHeight = source.size.height;
    
    // IMPORTANT: textureWithRect: uses 1 as 100% of the sprite.
    // This is why division from the original sprite is necessary.
    // Also why sx is incremented by a fraction.
    
    for (int i = 0; i < rowNumberOfSprites*colNumberOfSprites; i++) {
        CGRect cutter = CGRectMake(sx, sy, sWidth/ssTexture.size.width, sHeight/ssTexture.size.height);
        temp = [SKTexture textureWithRect:cutter inTexture:ssTexture];
        [mAnimatingFrames addObject:temp];
        
//        if(i < colNumberOfSprites){
            sx+=sWidth/ssTexture.size.width;
//        }else
        if((i+1)%colNumberOfSprites==0){
            sx=source.origin.x;
            sy+=sHeight/ssTexture.size.height;
        }
        
    }
    
    self = [Monster spriteNodeWithTexture:mAnimatingFrames[0]];
    
    animatingFrames = mAnimatingFrames;
    
    [scene addChild:self];
    
    return self;
}

-(NSArray*) getTextures{
    return mAnimatingFrames;
}

-(Monster *)newMonster{
    Monster * m = [SKSpriteNode spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
    
    m.position = self.position;
    [m runAction:[self actionForKey:@"aa"]];
    
    
    return m;
}

-(void) changeType{
    NSArray *hand;
    
    switch (self.effect.getHitCount) {
        case 1:
            hand = TextureHelper.hand1Textures;
            break;
        case 2:
            hand = TextureHelper.hand2Textures;
            break;
        case 3:
            hand = TextureHelper.hand3Textures;
            break;
        case 4:
            hand = TextureHelper.hand4Textures;
            break;
        default:
            return;
            break;
    }
    
    SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:hand timePerFrame:0.08]];
    
    [self removeActionForKey:@"monster"];
    
    [self runAction:[SKAction repeatActionForever: monsterAnimation ] withKey:@"monster"];
}

//- (NSString *)description
//{
//    return [NSStringstringWithFormat:@"<%@>",@{@"name":count,@"work":direction}];
//}
//
//- (NSString *)debugDescription
//{
//    return [NSStringstringWithFormat:@"<%@ : %p, %@>",[selfclass],self,@{@"name":_name,@"work":_work}];
//}

//- (void)addMonster {
//    // 创建怪物Sprite
//    Monster * monster = [Monster spriteNodeWithImageNamed:@"monster"];
//    
//    [monster setEffect];
//    
//    // 决定怪物在竖直方向上的出现位置
//    int minY = monster.size.height / 2;
//    int maxY = self.frame.size.height - monster.size.height / 2;
//    int rangeY = maxY - minY;
//    int actualY = (arc4random() % rangeY) + minY;
//    
//    int minX = monster.size.width / 2;
//    int maxX = self.frame.size.width - monster.size.width / 2;
//    int rangeX = maxX - minX;
//    int actualX = (arc4random() % rangeX) + minX;
//    
//    // Create the monster slightly off-screen along the right edge,
//    // and along a random position along the Y axis as calculated above
//    monster.position = CGPointMake(self.position.x, self.frame.size.height - monster.size.height);
//    [self addChild:monster];
//    
//    // 设置怪物的速度
//    int minDuration = 1.0;
//    int maxDuration = 2.0;
//    int rangeDuration = maxDuration - minDuration;
//    int actualDuration = (arc4random() % rangeDuration) + minDuration;
//    
//    actualX = (arc4random() % rangeX) + minX;
//    
//    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, 0) duration:actualDuration];
//    
//    //    actionMove:acti;
//    
//    
//    SKAction * action = [SKAction sequence:@[actionMove]];
//    
//    SKAction *s = [SKAction sequence:@[actionMove , [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration]]];
//    
//    [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
//    
//    [spriteNodes addObject:monster];
//    
//    ////    SKAction * loseAction = [SKAction runBlock:^{
//    ////        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//    ////        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
//    ////        [self.view presentScene:gameOverScene transition: reveal];
//    ////    }];
//    //    [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
//    
//    monster.physicsBody = [SKPhysicsBody bodyWit hRectangleOfSize:monster.size]; // 1
//    monster.physicsBody.dynamic = YES; // 2
//    monster.physicsBody.categoryBitMask = monsterCategory; // 3
//    monster.physicsBody.contactTestBitMask = projectileCategory; // 4
//    monster.physicsBody.collisionBitMask = 0; // 5
//    
//    
//}

@end
