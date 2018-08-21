//
//  MyScene.m
//  Try_Cat_Shoot
//
//  Created by irons on 2014/9/29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "Monster.h"
#import "TextureHelper.h"
#import "Tool.h"
#import "Cat.h"
#import "Bullet.h"
#import "MyUtils.h"
#import "CommonUtil.h"
#import "GameCenterUtil.h"

#define DEFAULT_HP  20

/////////////////////////////////////////////////////////////////////////////TEST
#define TEST_MODE  false
//////////////////////////////////////////////////////////////////////////

@interface MyScene () <SKPhysicsContactDelegate>{
    NSMutableArray * spriteNodes;
    NSMutableArray * spriteNodesExplode;
    NSMutableArray * spriteNodesTool;
    NSMutableArray * spriteNodesProjectile;
    NSMutableArray * spriteNodesFireball;
    NSMutableArray * contactQueue;
    NSMutableArray * timers;
    NSArray * hamsterDefaultArray;
    NSArray * rightNsArray;
    NSArray * leftNsArray;
    CommonUtil * commonUtil;
    SKSpriteNode * storeBtn;
    SKSpriteNode * rankBtn;
    SKSpriteNode * musicBtn;
    NSArray * storeBtnClickTextureArray;
    NSMutableArray * musicBtnTextures;
}
@property (nonatomic) SKSpriteNode * player, *fire;
@property (nonatomic) Cat * cat;
@property (nonatomic) SKSpriteNode * controlPoint;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) SKSpriteNode * controlBar;
@property (nonatomic) SKSpriteNode * infoBar;
@property (nonatomic) SKSpriteNode * hp1, *hp2, *hp3;
@property (nonatomic) SKSpriteNode * hpBar;
@property (nonatomic) SKCropNode * node;
@property (nonatomic) SKSpriteNode * timeMinuteHunsDigital, * timeMinuteTensDigital, *timeMinuteSingalDigital, *timeQmark, *timeScecondTensDigital, *timeSecondSingalDigital, *gameLevelSingleNode, *gameLevelTenNode;
@property (nonatomic) SKSpriteNode * backgroundNode;
@property (nonatomic) SKSpriteNode * pauseBtnNode;
@property (nonatomic) SKSpriteNode * testBtnNode;
@property (nonatomic) SKSpriteNode * sendScoreBtnNode;
@property (nonatomic) SKSpriteNode * clearedNode;
@end

///////////////////////////////////////////////////////////////
/// Object init function
@interface MyScene(init)

@end
///////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////
/// Object destroy function
@interface MyScene(destroy)

@end
///////////////////////////////////////////////////////////////

//@interface What : NSObject {
//@public
//    
//@private
//}
//
///// public
//@property
//
//@end
//
//@implementation What {
//    int num;
//}
//
//@end


@implementation MyScene

//@synthesize game = _game;

static NSMutableArray * scenes;

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;
static const uint32_t toolCategory        =  0x1 << 2;
static const uint32_t catCategory        =  0x1 << 3;
static const uint32_t hamsterCategory        =  0x1 << 5;
static const uint32_t fireballCategory        =  0x1 << 6;

int clearedMonster = 0;
SKLabelNode * clearedMonsterLabel;

//SKLabelNode * toolTimeLabel;
NSTimer * theTimer;

SKLabelNode * theGameTimerLabel;
NSTimer * theGameTimer;

Boolean isGameRun = true;

bool isShootEnable = false;

bool isMoveBar = false;

bool isMoveAble = true;

bool isInjure = false;

bool isInvinceble = false;

bool isGameEndSuccess = false;

CGPoint p;

int hp = 3;

NSArray * currentCatTextures;

//int catMaxHp = 10;
//int catCurrentHp = catMaxHp;
int catMaxHp = DEFAULT_HP;
int catCurrentHp = DEFAULT_HP;
float catHpIncreasePerLevel = 0.5;

static int playerInitX, playerInitY;
static int catInitX, catInitY;
static int barInitX, barInitY;

int gameLevel;

int gameTime = 0;

int shootCount = 0;

int backgroundLayerZPosition = -3;

int projectileLayerZPosition = -2;

int fireballLayerZPosition = -1;

const int GAME_SUCCESS_LEVEL = 29; //GAME_SUCCESS_LEVEL + 1 = real level

//int monsterLayerZPosition = 3;

//int accumulatedTime = 0;

NSDate *pauseStart, *previousFireDate;

const int ONLY_LEVEL1_HAND_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL12_HAND_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL123_HAND_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL123_2HAND_HOW_MANY_LEVELS = 1;

const int ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL123_HAND_WITH_TOOL_POWER_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_HOW_MANY_LEVELS = 1;

const int ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS = 3;

const int ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS = 1;

const int ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS = 1;
const int ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS = 2;
const int ONLY_LEVEL1234_RANDOM_HAND_2FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS = 1;

/*
const int ONLY_LEVEL1_HAND_LEVEL = ONLY_LEVEL1_HAND_HOW_MANY_LEVELS;
const int ONLY_LEVEL12_HAND_LEVEL = ONLY_LEVEL1_HAND_LEVEL + ONLY_LEVEL12_HAND_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_LEVEL = ONLY_LEVEL12_HAND_LEVEL + ONLY_LEVEL123_HAND_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_2HAND_LEVEL = ONLY_LEVEL123_HAND_LEVEL + ONLY_LEVEL123_2HAND_HOW_MANY_LEVELS;

const int ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_LEVEL = ONLY_LEVEL123_2HAND_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_POWER_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_POWER_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_POWER_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_HOW_MANY_LEVELS;

const int ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_LEVEL + ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;

const int ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;

const int ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_RANDOM_HAND_2FIREBALL_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_RANDOM_HAND_2FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS;
*/

const int ONLY_LEVEL1_HAND_LEVEL = 0;
const int ONLY_LEVEL12_HAND_LEVEL = ONLY_LEVEL1_HAND_LEVEL + ONLY_LEVEL1_HAND_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_LEVEL = ONLY_LEVEL12_HAND_LEVEL + ONLY_LEVEL12_HAND_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_2HAND_LEVEL = ONLY_LEVEL123_HAND_LEVEL + ONLY_LEVEL123_HAND_HOW_MANY_LEVELS;

const int ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_LEVEL = ONLY_LEVEL123_2HAND_LEVEL + ONLY_LEVEL123_2HAND_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_POWER_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_POWER_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_POWER_HOW_MANY_LEVELS;

const int ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_LEVEL + ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_HOW_MANY_LEVELS;

const int ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;

const int ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS;
const int ONLY_LEVEL1234_RANDOM_HAND_2FIREBALL_WITH_ALL_TOOL_LEVEL = ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL + ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_HOW_MANY_LEVELS;

const int NORMAL_RANDOM_TOOL = 0;
const int ONLY_FASTER_TOOL = 1;
const int ONLY_F_DOUBLE_TOOL = 2;
const int ONLY_F_D_TRIPLE_TOOL = 3;
const int ONLY_POWER_TOOL = 4;
const int ONLY_P_HEAL_TOOL = 5;
int toolLevel = NORMAL_RANDOM_TOOL;

const int FIRE_BALL_NONE = 0;
const int FIRE_BALL_ONE = 1;
const int FIRE_BALL_TWO = 2;
int fireballLevel = FIRE_BALL_NONE;

const int NORMAL_TEXTURE_INDEX = 0;
const int PRESSED_TEXTURE_INDEX = 1;

static enum ShootType shootType = None;

+(enum ShootType)getShootType{
    return shootType;
}

+(void)setShootType:(enum ShootType)shootTypee{
    MyScene:shootType = shootTypee;
}

- (void)setGame:(void (^)(bool))game {
    
}

- (void)dealloc {
    [scenes removeObject:self];
}

//- (void)handleContact:(SKPhysicsContact*)contact {
//    SKPhysicsBody* bodyA = contact.bodyA;
//    SKPhysicsBody* bodyB = contact.bodyB;
//    [(SKSpriteNode*)bodyA.node  = nil;
//    bodyB = nil;
//}

-(void)resetCount{
    ccount = DEFAULT_COUNT;
}

-(id)initWithSize:(CGSize)size {
    /// first time only
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scenes = [NSMutableArray new];
    });
    
    if (self = [super initWithSize:size]) {
        /// add to pool
        [scenes addObject:self];
        
        /* Setup your scene here */
        
        commonUtil = [CommonUtil sharedInstance];
        
        isGameRun = false;
        
        isMoveAble = false;
        
        isShootEnable = false;
        
        isMoveBar = false;
        
        isInjure = false;
        
        isInvinceble = false;
        
        isGameEndSuccess = false;
        
        hp = 3;
        
        catMaxHp = DEFAULT_HP;
        catCurrentHp = DEFAULT_HP;
        
        gameLevel = 0;
        gameTime = 0;
        clearedMonster = 0;
        
        shootType = None;
        bulletCount = 1;
        fireballLevel = FIRE_BALL_NONE;
        
        shootCount = 0;
        
//        _game = nil;
        [TextureHelper initTextures];
        
        [self initTextures];
        
        [MyUtils playBackgroundMusic:@""];
        
        [MyUtils backgroundMusicPlayerStop];
        
                NSLog(@"Size: %@", NSStringFromCGSize(size));
//        self.backgroundColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        
        self.controlBar = [SKSpriteNode spriteNodeWithImageNamed:@"control_bar"];
        //        self.controlBar.size = CGSizeMake(50, 50);
        self.controlBar.position = CGPointMake(0, self.controlBar.size.height/2);
        
        self.clearedNode = [SKSpriteNode spriteNodeWithImageNamed:@"icon"];
        self.clearedNode.anchorPoint = CGPointMake(0, 0);
        self.clearedNode.size = CGSizeMake(self.controlBar.size.height/5*3, self.controlBar.size.height/2);
        self.clearedNode.position = CGPointMake(0, self.controlBar.size.height/2);
        
        clearedMonsterLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
//        clearedMonsterLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                                   CGRectGetMidY(self.frame));
        clearedMonsterLabel.text = @"0";
        clearedMonsterLabel.fontSize = 20;
        clearedMonsterLabel.color = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        clearedMonsterLabel.position = CGPointMake(self.clearedNode.position.x + self.clearedNode.size.width + clearedMonsterLabel.frame.size.width/2, self.clearedNode.position.y +3 );
        
        self.infoBar = [SKSpriteNode spriteNodeWithImageNamed:@"info_bar"];
        self.infoBar.size = CGSizeMake(self.frame.size.width, 30);
        self.infoBar.position = CGPointMake(self.frame.size.width/2, self.infoBar.size.height/2);
        
        self.backgroundNode = [SKSpriteNode spriteNodeWithTexture:[TextureHelper bgTextures][0]];
        
        CGSize backgroundSize = CGSizeMake(self.frame.size.width, self.frame.size.height - self.controlBar.size.height                                                                                                                                                                                                                                                                                                                                                       );
        
        self.backgroundNode.size = backgroundSize;
        
        self.backgroundNode.anchorPoint = CGPointMake(0, 0);
        
        self.backgroundNode.position = CGPointMake(0, 70);
        
        self.backgroundNode.zPosition = backgroundLayerZPosition;
        
        [self addChild:self.backgroundNode];
        
        [self addChild:self.controlBar];
        
        [self addChild:self.clearedNode];
        
        [self addChild:clearedMonsterLabel];
        
        [self addChild:self.infoBar];
        
        // 4
        //self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        //        self.player.position = CGPointMake(100, 100);
        
        hamsterDefaultArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                                                  sequence:@[@7]];
        
//        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.player = [SKSpriteNode spriteNodeWithTexture:hamsterDefaultArray[0]];
        
//        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7];
        
        SKSpriteNode * hpFrame = [SKSpriteNode spriteNodeWithImageNamed:@"hp_frame"];
        
        self.hpBar = [SKSpriteNode spriteNodeWithImageNamed:@"hp_bar"];
        
        self.hpBar.zPosition = backgroundLayerZPosition;
        
        hpFrame.size = CGSizeMake(self.frame.size.width, 42);
        
        hpFrame.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMaxY(self.frame) - hpFrame.size.height/2 - 45);
        
        hpFrame.zPosition = backgroundLayerZPosition;
        
        [self changeCatHpBar];
        
        [self addChild:hpFrame];
        
        [self addChild:self.hpBar];
        
        [TextureHelper initCatTextures];
        
        [self randomCurrentCatTextures];

        [TextureHelper initHandTexturesSourceRect:CGRectMake(0, 0, 117, 105) andRowNumberOfSprites:2 andColNumberOfSprites:7];
        
        self.player.size = CGSizeMake(60, 60);
        
        playerInitX = self.frame.size.width/2;
        playerInitY = self.player.size.height + 40;
        self.player.position = CGPointMake(playerInitX, playerInitY);
        
        self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.width/2];
        self.player.physicsBody.dynamic = YES;
        self.player.physicsBody.categoryBitMask = hamsterCategory;
        self.player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
        self.player.physicsBody.collisionBitMask = 0;
        self.player.physicsBody.usesPreciseCollisionDetection = YES;
        
//        SKNode * sknode = [SKNode node];

//        sknode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.width/2];
//        sknode.physicsBody.dynamic = YES;
//        sknode.physicsBody.categoryBitMask = hamsterCategory;
//        sknode.physicsBody.contactTestBitMask = monsterCategory;
//        sknode.physicsBody.collisionBitMask = 0;
//        sknode.physicsBody.usesPreciseCollisionDetection = YES;
        
//        [sknode addChild:self.player];
//        [self addChild:sknode];
        [self addChild:self.player];
        
        self.cat = [Cat spriteNodeWithTexture:currentCatTextures[0]];
        int catOriginHeight = self.cat.size.height;
        self.cat.size = CGSizeMake(100, 100);
        [self randomCatInitX];
        catInitY = self.frame.size.height - catOriginHeight/2;
        self.cat.position = CGPointMake(catInitX, catInitY);
        
        self.cat.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.cat.size.width/2];
        self.cat.physicsBody.dynamic = YES;
        self.cat.physicsBody.categoryBitMask = catCategory;
        self.cat.physicsBody.contactTestBitMask = projectileCategory;
        self.cat.physicsBody.collisionBitMask = 0;
        self.cat.physicsBody.usesPreciseCollisionDetection = YES;
        self.cat.zPosition = fireballLayerZPosition;
//        [self addChild:self.cat];
        
        self.node = [SKCropNode node];
//        self.node.zPosition = 0;
//        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
        
        [self.node addChild:self.cat];
        
//        [node addChild:mask];
        
        [self addChild:self.node];
        
//        [self catDieAndDisapearDown];
        
//        node.position = self.cat.position;
        
        self.pauseBtnNode = [SKSpriteNode spriteNodeWithImageNamed:@"game_resume_btn"];
        self.pauseBtnNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 100);
        self.pauseBtnNode.size = CGSizeMake(50, 50);
        self.pauseBtnNode.hidden = true;
        [self addChild:self.pauseBtnNode];
        
        int gameLevelNodeWH = 30;
        
        self.gameLevelSingleNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameLevel+1)%10]];
        self.gameLevelSingleNode.size = CGSizeMake(gameLevelNodeWH, gameLevelNodeWH);
        self.gameLevelSingleNode.position = CGPointMake(self.frame.size.width/4, catInitY);
        self.gameLevelSingleNode.zPosition = backgroundLayerZPosition;
        
        self.gameLevelTenNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameLevel+1)/10]];
        self.gameLevelTenNode.size = CGSizeMake(gameLevelNodeWH, gameLevelNodeWH);
        self.gameLevelTenNode.position = CGPointMake(self.frame.size.width/4 - gameLevelNodeWH, catInitY);
        self.gameLevelTenNode.zPosition = backgroundLayerZPosition;
        
        
        [self addChild:self.gameLevelSingleNode];
        [self addChild:self.gameLevelTenNode];
        
        storeBtn = [SKSpriteNode spriteNodeWithImageNamed:@"store1"];
        storeBtn.size = CGSizeMake(42,42);
        storeBtn.position = CGPointMake(self.frame.size.width - storeBtn.size.width/2 -3, self.gameLevelSingleNode.position.y);
        storeBtn.zPosition = backgroundLayerZPosition;
        [self addChild:storeBtn];
        
        rankBtn = [SKSpriteNode spriteNodeWithImageNamed:@"leader_board_btn"];
        rankBtn.size = CGSizeMake(42,42);
        rankBtn.position = CGPointMake(self.frame.size.width - rankBtn.size.width*1.5 -3, self.gameLevelSingleNode.position.y);
        rankBtn.zPosition = backgroundLayerZPosition;
        [self addChild:rankBtn];
        
        self.hp1 = [SKSpriteNode spriteNodeWithImageNamed:@"hp"];
        self.hp1.size = CGSizeMake(30, 30);
        self.hp1.position = CGPointMake(self.hp1.size.width/2, self.hp1.size.height/2);
        [self addChild:self.hp1];

        self.hp2 = [SKSpriteNode spriteNodeWithImageNamed:@"hp"];
        self.hp2.size = CGSizeMake(30, 30);
        self.hp2.position = CGPointMake(self.hp1.size.width + self.hp2.size.width/2, self.hp2.size.height/2);
        [self addChild:self.hp2];
        
        self.hp3 = [SKSpriteNode spriteNodeWithImageNamed:@"hp"];
        self.hp3.size = CGSizeMake(30, 30);
        self.hp3.position = CGPointMake(self.hp3.size.width/2*5, self.hp3.size.height/2);
        [self addChild:self.hp3];
        
        
        
        self.controlPoint = [SKSpriteNode spriteNodeWithImageNamed:@"control_point"];
        self.controlPoint.size = CGSizeMake(50, 50);
//        barInitX = self.controlPoint.size.width/2;
        barInitX = playerInitX;
        barInitY = self.controlPoint.size.height;
        self.controlPoint.position = CGPointMake(barInitX, barInitY);
        [self addChild:self.controlPoint];
        

        self.fire = [SKSpriteNode spriteNodeWithTexture:nil size:CGSizeMake(70, 70)];
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"invinceble" withinNode:nil sourceRect:CGRectMake(0, 0, 300, 288) andRowNumberOfSprites:1 andColNumberOfSprites:4];
        
        SKAction *monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.5];
        
        SKAction *actionMoveDone = [SKAction removeFromParent];
        
        //        [self.player runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
        
        [self.fire runAction:[SKAction repeatActionForever:monsterAnimation]];
        
        self.fire.position = self.player.position;
        
        self.fire.hidden = true;
        
        [self addChild:self.fire];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        
        /*
         toolTimeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        toolTimeLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame)-200);
       
        toolTimeLabel.text = @"Hello, wWorld!";
        toolTimeLabel.fontSize = 30;
        [self addChild:toolTimeLabel];
        */
        
        /*
        theGameTimerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        theGameTimerLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                             CGRectGetMidY(self.frame)+100);
        
        theGameTimerLabel.text = [NSString stringWithFormat:@"%d", gameTime];
        theGameTimerLabel.fontSize = 30;
        [self addChild:theGameTimerLabel];
        */
        int timeNodeWidthHeight = 30;
        
        self.timeMinuteHunsDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
        self.timeMinuteHunsDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
        
        self.timeMinuteHunsDigital.position = CGPointMake(self.frame.size.width/2 - self.timeMinuteHunsDigital.size.width, self.timeMinuteHunsDigital.size.height/2);
        
        self.timeMinuteTensDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
        
        self.timeMinuteTensDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
        
        self.timeMinuteTensDigital.position = CGPointMake(self.frame.size.width/2, self.timeMinuteTensDigital.size.height/2);
        
        self.timeMinuteSingalDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
        
        self.timeMinuteSingalDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
        
        self.timeMinuteSingalDigital.position = CGPointMake(self.frame.size.width/2+timeNodeWidthHeight, self.timeMinuteSingalDigital.size.height/2);
        
        self.timeQmark = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][10]];
        
        self.timeQmark.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
        
        self.timeQmark.position = CGPointMake(self.frame.size.width/2+timeNodeWidthHeight*2, self.timeQmark.size.height/2);
        
        self.timeScecondTensDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
        
        self.timeScecondTensDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
        
        self.timeScecondTensDigital.position = CGPointMake(self.frame.size.width/2+timeNodeWidthHeight*3, self.timeScecondTensDigital.size.height/2);
        
        self.timeSecondSingalDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
        
        self.timeSecondSingalDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
        
        self.timeSecondSingalDigital.position = CGPointMake(self.frame.size.width/2+timeNodeWidthHeight*4, self.timeSecondSingalDigital.size.height/2);
        
        [self addChild:self.timeMinuteHunsDigital];
        [self addChild:self.timeMinuteTensDigital];
        [self addChild:self.timeMinuteSingalDigital];
        [self addChild:self.timeQmark];
        [self addChild:self.timeScecondTensDigital];
        [self addChild:self.timeSecondSingalDigital];
        
        if(TEST_MODE==true){
            self.testBtnNode = [SKSpriteNode spriteNodeWithTexture:currentCatTextures[0]];
            self.testBtnNode.size = CGSizeMake(50, 50);
            self.testBtnNode.position = CGPointMake(50, 150);
            [self addChild:self.testBtnNode];
            
            self.sendScoreBtnNode = [SKSpriteNode spriteNodeWithTexture:currentCatTextures[0]];
            self.sendScoreBtnNode.size = CGSizeMake(50, 50);
            self.sendScoreBtnNode.position = CGPointMake(150, 150);
            [self addChild:self.sendScoreBtnNode];
        }
        
        [self initClickTextureArrays];
        
//        self.backgroundColor = [SKColor colorWithRed:0.65 green:0.65 blue:0.3 alpha:1.0];
        
//        spriteNodes = [NSMutableArray arrayWithCapacity:20];
//        spriteNodesTool = [NSMutableArray arrayWithCapacity:20];
//        contactQueue = [NSMutableArray arrayWithCapacity:20];

        spriteNodes = [[NSMutableArray alloc] init];
        spriteNodesExplode = [[NSMutableArray alloc] init];
        spriteNodesTool = [[NSMutableArray alloc] init];
        spriteNodesProjectile = [[NSMutableArray alloc] init];
        spriteNodesFireball = [[NSMutableArray alloc] init];
        contactQueue = [[NSMutableArray alloc] init];
        timers = [[NSMutableArray alloc] init];
        
//        [self initGameTimer];
        musicBtnTextures = [NSMutableArray array];
        [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music-hd"]];
        [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music_Select-hd"]];
        
        musicBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Music-hd"];
        musicBtn.size = CGSizeMake(42,42);
//        musicBtn.anchorPoint = CGPointMake(0, 0);
        musicBtn.position = CGPointMake(self.frame.size.width - musicBtn.size.width*2.5-3, self.gameLevelSingleNode.position.y);
        musicBtn.zPosition = backgroundLayerZPosition;
        //        rankBtn.zPosition = backgroundLayerZPosition;
        [self addChild:musicBtn];
        
        NSArray* musics = [NSArray arrayWithObjects:@"am_white.mp3", @"biai.mp3", @"cafe.mp3", @"deformation.mp3", nil];
        
        int index = arc4random_uniform(4);
        [MyUtils preparePlayBackgroundMusic:musics[index]];
        
        id isPlayMusicObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"isPlayMusic"];
        BOOL isPlayMusic = true;
        if(isPlayMusicObject==nil){
            isPlayMusicObject = false;
        }else{
            isPlayMusic = [isPlayMusicObject boolValue];
        }
        if(isPlayMusic){
            [MyUtils backgroundMusicPlayerPlay];
            musicBtn.texture = musicBtnTextures[0];
        }else{
            [MyUtils backgroundMusicPlayerPause];
            musicBtn.texture = musicBtnTextures[1];
        }
    }
    return self;
}

-(void)initTextures{
    rightNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                         //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                              sequence:@[@3,@4,@5,@4,@3,@2]];
    
    leftNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                         //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                              sequence:@[@3,@4,@5,@4,@3,@2]];
}

-(void)initClickTextureArrays{
    SKTexture * normalTexture, * pressedTexture;
    normalTexture = [SKTexture textureWithImageNamed:@"store1"];
    pressedTexture = [SKTexture textureWithImageNamed:@"store2"];
    storeBtnClickTextureArray = @[normalTexture, pressedTexture];
}

-(void) randomCurrentCatTextures{
    int r = arc4random_uniform(5);
    
    switch (r) {
        case 0:
            currentCatTextures = [TextureHelper cat1Textures];
            break;
        case 1:
            currentCatTextures = [TextureHelper cat2Textures];
            break;
        case 2:
            currentCatTextures = [TextureHelper cat3Textures];
            break;
        case 3:
            currentCatTextures = [TextureHelper cat4Textures];
            break;
        case 4:
            currentCatTextures = [TextureHelper cat5Textures];
            break;
        default:
            break;
    }
}

-(void) catDieAndDisapearDown{
    __block int count = 1;
    
    float h = self.cat.size.height/15.0f;
    float catW = self.cat.size.width;
    float catH = self.cat.size.height;
    
    CGSize displaySise = CGSizeMake(catW, catH - h);
    
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:displaySise];
    
    //        mask.size = CGSizeMake(20, 20);
    
//    self.cat.position = CGPointMake(200, 200);
    
//    mask.position = CGPointMake(200, 200);
    
    mask.position = self.cat.position;
    
    self.node.maskNode = mask;
    
    [self.cat removeAllActions];
    
    SKAction * actionMoveY = [SKAction moveTo:CGPointMake(self.cat.position.x
                                                          , _cat.position.y - h*count) duration:0];
    SKAction * actionBlock = [SKAction runBlock:^{
        CGPoint point = self.cat.position;
        point.y = self.cat.position.y - h;
        self.cat.position = point;
//        SKSpriteNode * s = self.node.maskNode;
//        s.size = CGSizeMake(self.cat.size.width, catH - h*count);
        count++;
    }];
    
    SKAction * actionReset = [SKAction runBlock:^{
        
        if(gameLevel>=GAME_SUCCESS_LEVEL){
            GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
            [gameCenterUtil reportScore:gameTime forCategory:@"com.irons.AttackOnGiantCat"];
            
            SKSpriteNode * meiow = [SKSpriteNode spriteNodeWithImageNamed:@"meiow"];
            
            meiow.size = CGSizeMake(50, 50);
            
            meiow.zRotation = -M_PI/6.0;
            
            meiow.position = CGPointMake(self.frame.size.width, self.frame.size.height);
            
            SKAction * scale = [SKAction scaleTo:10 duration:5];
            
            SKAction * move = [SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) duration:5];
            
            SKAction * end = [SKAction runBlock:^{
                
                self.onGameWin(gameLevel, gameTime, clearedMonster);
                isGameEndSuccess = true;
            }];
            
            [meiow runAction:[SKAction group:@[scale, [SKAction sequence:@[move, end]]]]];
            
            [self addChild:meiow];
            
            isGameRun = false;
            
            isMoveAble = false;
            
            return;
        }

        
            self.showAdmob();
        
        }];
    
    SKAction * actionMoveDoneD = [SKAction removeFromParent];
    
    SKAction * delay = [SKAction runBlock:^{
        [NSThread sleepForTimeInterval:2];
    }];
    
    SKAction * catDown = [SKAction repeatAction: [SKAction sequence:@[actionBlock, [SKAction waitForDuration:0.1]]] count:15];
    
    [self.cat runAction:[SKAction sequence:@[catDown, actionReset]]];
}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
////    for (UITouch *touch in touches) {
////        CGPoint location = [touch locationInNode:self];
////        
////        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
////        
////        sprite.position = location;
////        
////        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
////        
////        [sprite runAction:[SKAction repeatActionForever:action]];
////        
////        [self addChild:sprite];
////    }
//}

-(void)update:(CFTimeInterval)currentTime {
    if(!isGameRun)
        return;
    
    if (self.pauseBtnNode.hidden==false) {
        [self setViewRun:false];
        return;
    }
    
    /* Called before each frame is rendered */
    // 获取时间增量
    // 如果我们运行的每秒帧数低于60，我们依然希望一切和每秒60帧移动的位移相同
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // 如果上次更新后得时间增量大于1秒
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
//    if (timeInSeconds < 0 || numberOfLaps == 0) {
//        isGameRun = true;
//        uibloblock = gameOverBlock { block(didWin: numberOfLaps == 0)
//        
//        }
//    }
    
//    _game = ^(bool didWin){
//        
//    };
    
    self.onGameEnd = ^(bool is){
        
    };
    
    UIView * (^makeView)(void) = ^{
        UIView *view = [UIView new];
        view.frame = CGRectZero;
        view.backgroundColor = [UIColor redColor];
        return view;
    };

    UIView* view = makeView();
    UIView* view1 = makeView();
    UIView* view2 = makeView();
    
}

//-(void)gameOver:(bool)didWin{
//    UIAlertView alert = UIAlertController(title: didWin ? "You won!": "You lost", message: "Game Over", preferredStyle: .Alert)
//    presentViewController(alert, animated: true, completion: nil);
//    
//}

const int DEFAULT_COUNT = 11;
int ccountLimit = DEFAULT_COUNT;
int ccount = DEFAULT_COUNT/2;
int combo;
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    
    [self processContactsForUpdate];
    
//    if (shootType==Faster && self.lastSpawnTimeInterval > 0.5) {
//        [self shoot];
//    }else if(self.lastSpawnTimeInterval > 1){
//        [self shoot];
//    }
    
    if (self.lastSpawnTimeInterval > 0.5) {
        self.lastSpawnTimeInterval = 0;
        
        ccount++;
        shootCount++;
        
        if(isShootEnable && shootType==Faster)
            [self shoot];
        else if(isShootEnable && shootCount%2==1)
            [self shoot];
            
        if(ccount>=ccountLimit)    {
            
            /*
            //speshious sesion by gameLevel
            if(gameLevel==0){
                
            }else if(gameLevel==1){
                
            }else if(gameLevel==2){
                
            }else{
                
            }
            */
            
            
            /*
            if(gameLevel < ONLY_LEVEL1_HAND_LEVEL){
                [self addMonsterWithBelowHitCount:1 isNoTool:true];
            }else if(gameLevel < ONLY_LEVEL12_HAND_LEVEL){
                [self addMonsterWithBelowHitCount:2 isNoTool:true];
            }else if(gameLevel < ONLY_LEVEL123_HAND_LEVEL){
                [self addMonsterWithBelowHitCount:3 isNoTool:true];
            }else if(gameLevel < ONLY_LEVEL123_2HAND_LEVEL){
                [self addMonsterWithBelowHitCount:3 isNoTool:true];
                [self addMonsterWithBelowHitCount:3 isNoTool:true];
//            }else if(gameLevel < ONLY_LEVEL123_3HAND_LEVEL){
//                [self addMonsterWithBelowHitCount:3 isNoTool:true];
//                [self addMonsterWithBelowHitCount:3 isNoTool:true];
//                [self addMonsterWithBelowHitCount:3 isNoTool:true];
            }else if(gameLevel < ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_LEVEL){
                toolLevel = ONLY_FASTER_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_LEVEL){
                toolLevel = ONLY_F_DOUBLE_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_LEVEL){
                toolLevel = ONLY_F_D_TRIPLE_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL123_HAND_WITH_TOOL_POWER_LEVEL){
                toolLevel = ONLY_POWER_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_LEVEL){
                toolLevel = ONLY_P_HEAL_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                
                int continueAttackCounter = 0;
                
                int r = arc4random_uniform(40);
                
                if(r<90){
                    
                    //                do{
                    //                    continueAttackCounter = combo;
                    
                    if(r < 20){
                        combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else if(r<40){
                        combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else {
                        combo++;
                        //                continueAttackCounter++;
                        //                continue;
                    }
                    //                    continueAttackCounter--;
                    //                }while (continueAttackCounter>0 );
                    
                }else{
                    combo=0;
                    [self addMonsterWithBelowHitCount:3 isNoTool:false];
                }
                //            else if(r<100){
                //                [self addMonsterDouble];
                //            }
                
                continueAttackCounter = combo;
                while (continueAttackCounter>0) {
                    //                continueAttackCounter = combo;
                    
                    if(r < 20){
                        //                    combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else if(r<40){
                        //                    combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else {
                        //                    continueAttackCounter++;
                        continue;
                    }
                    
                    continueAttackCounter--;
                }
            }else if(gameLevel < ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self randomAddHand];
            }else if(gameLevel < ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                fireballLevel = FIRE_BALL_ONE;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                fireballLevel = FIRE_BALL_ONE;
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
            }else if(gameLevel < ONLY_LEVEL1234_RANDOM_HAND_2FIREBALL_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                fireballLevel = FIRE_BALL_TWO;
                [self randomAddHand];
            }*/
            
            
            if(gameLevel >= ONLY_LEVEL1234_RANDOM_HAND_2FIREBALL_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                fireballLevel = FIRE_BALL_TWO;
                [self randomAddHand];
            }else if(gameLevel >= ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                fireballLevel = FIRE_BALL_ONE;
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                fireballLevel = FIRE_BALL_ONE;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self randomAddHand];
            }else if(gameLevel >= ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self addMonsterWithBelowHitCount:4 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_LEVEL){
                toolLevel = NORMAL_RANDOM_TOOL;
                
                int continueAttackCounter = 0;
                
                int r = arc4random_uniform(40);
                
                if(r<90){
                    
                    //                do{
                    //                    continueAttackCounter = combo;
                    
                    if(r < 20){
                        combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else if(r<40){
                        combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else if(r<60){
                        combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else {
                        combo++;
                        //                continueAttackCounter++;
                        //                continue;
                    }
                    //                    continueAttackCounter--;
                    //                }while (continueAttackCounter>0 );
                    
                }else{
                    combo=0;
                    [self addMonsterWithBelowHitCount:3 isNoTool:false];
                }
                //            else if(r<100){
                //                [self addMonsterDouble];
                //            }
                
                continueAttackCounter = combo;
                while (continueAttackCounter>0) {
                    //                continueAttackCounter = combo;
                    
                    if(r < 20){
                        //                    combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else if(r<40){
                        //                    combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else if(r<60){
                        //                    combo=0;
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                        [self addMonsterWithBelowHitCount:3 isNoTool:false];
                    }else {
                        //                    continueAttackCounter++;
                        continue;
                    }
                    
                    continueAttackCounter--;
                }
            }else if(gameLevel >= ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_LEVEL){
                toolLevel = ONLY_P_HEAL_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_HAND_WITH_TOOL_POWER_LEVEL){
                toolLevel = ONLY_POWER_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_LEVEL){
                toolLevel = ONLY_F_D_TRIPLE_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_LEVEL){
                toolLevel = ONLY_F_DOUBLE_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_LEVEL){
                toolLevel = ONLY_FASTER_TOOL;
                [self addMonsterWithBelowHitCount:3 isNoTool:false];
            }else if(gameLevel >= ONLY_LEVEL123_2HAND_LEVEL){
//                [self addMonsterWithBelowHitCount:3 isNoTool:true];
//                [self addMonsterWithBelowHitCount:3 isNoTool:true];
                [self randomAddHandWithBelowHitCount:3 isNoTool:true withBelowHandNumber:2];
            }else if(gameLevel >= ONLY_LEVEL123_HAND_LEVEL){
                [self addMonsterWithBelowHitCount:3 isNoTool:true];
            }else if(gameLevel >= ONLY_LEVEL12_HAND_LEVEL){
                [self addMonsterWithBelowHitCount:2 isNoTool:true];
            }else if(gameLevel >= ONLY_LEVEL1_HAND_LEVEL){
                [self addMonsterWithBelowHitCount:1 isNoTool:true];
            }
            
            ccount = 0;
        }
        
        [self checkHamsterHp];
        
        [self setClearedMonsterNodeText];
        
        // 设置怪物的速度
        int minDuration = 2.0;
        int maxDuration = 4.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        int actualX = (arc4random() % (int)self.frame.size.width);
        
        // Create the actions
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, _cat.position.y) duration:actualDuration];
        
        if (isGameRun && ccount%2==1) {
        SKAction * actionMoveDone = [SKAction removeFromParent];
//        [self.cat runAction:[SKAction sequence:@[actionMove]]];
            SKAction * moveAnimation = [SKAction animateWithTextures:@[currentCatTextures[0],currentCatTextures[1]] timePerFrame:0.3];
            if(!isInjure){
                [self.cat runAction:moveAnimation withKey:@"catMove"];
            }
            [self.cat runAction:actionMove];
//        [self.cat runAction:[SKAction group:@[actionMove, moveAnimation]] withKey:@"catMove"];
        }
    }else if(self.lastSpawnTimeInterval > 0.3){

    }
    

}

-(void)randomAddHandWithBelowHitCount:(int)hitCount isNoTool:(bool)isNoTool withBelowHandNumber:(int)number{
    const int ONE_HNAD_RATE = 50;
    const int TWO_HNAD_RATE = 30;
    const int THREE_HNAD_RATE = 20;
    
    int r;
    if(number==1){
        r = arc4random_uniform(ONE_HNAD_RATE);
    }else if(number==2){
        r = arc4random_uniform(ONE_HNAD_RATE+TWO_HNAD_RATE);
    }else if(number==3){
        r = arc4random_uniform(ONE_HNAD_RATE+TWO_HNAD_RATE+THREE_HNAD_RATE);
    }
    
    if(r < ONE_HNAD_RATE){
        combo=0;
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
    }else if(r<ONE_HNAD_RATE+TWO_HNAD_RATE){
        combo=0;
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
    }else if(r<ONE_HNAD_RATE+TWO_HNAD_RATE+THREE_HNAD_RATE){
        combo=0;
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
    }else {
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
    }
    
    /*
    int continueAttackCounter = 0;
    
    int r = arc4random_uniform(100);
    
    if(r<90){
        if(r < 20){
            combo=0;
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        }else if(r<40){
            combo=0;
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        }else if(r<60){
            combo=0;
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        }else {
            combo++;
        }
    }else{
        combo=0;
        [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
    }
    
    
    continueAttackCounter = combo;
    while (continueAttackCounter>0) {
        r = arc4random_uniform(100);
        if(r < 20){
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        }else if(r<40){
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
            [self addMonsterWithBelowHitCount:hitCount isNoTool:isNoTool];
        }else {
            continue;
        }
        continueAttackCounter--;
    }*/
}

-(void)randomAddHand{
    int continueAttackCounter = 0;
    
    int r = arc4random_uniform(40);
    
    if(r<90){
        
        //                do{
        //                    continueAttackCounter = combo;
        
        if(r < 20){
            combo=0;
            [self addMonster];
        }else if(r<40){
            combo=0;
            [self addMonster];
            [self addMonster];
        }else if(r<60){
            combo=0;
            [self addMonster];
            [self addMonster];
            [self addMonster];
        }else {
            combo++;
            //                continueAttackCounter++;
            //                continue;
        }
        //                    continueAttackCounter--;
        //                }while (continueAttackCounter>0 );
        
    }else{
        combo=0;
        [self addMonster];
    }
    //            else if(r<100){
    //                [self addMonsterDouble];
    //            }
    
    continueAttackCounter = combo;
    while (continueAttackCounter>0) {
        //                continueAttackCounter = combo;
        
        if(r < 20){
            //                    combo=0;
            [self addMonster];
        }else if(r<40){
            //                    combo=0;
            [self addMonster];
            [self addMonster];
        }else if(r<60){
            [self addMonster];
            [self addMonster];
            [self addMonster];
        }else {
            //                    continueAttackCounter++;
            continue;
        }
        
        continueAttackCounter--;
    }
}

-(void)checkHamsterHp{
    if (hp<=0) {
        [self.hp1 setHidden:true];
        [self.hp2 setHidden:true];
        [self.hp3 setHidden:true];
    }else if(hp==1){
        [self.hp1 setHidden:false];
        [self.hp2 setHidden:true];
        [self.hp3 setHidden:true];
    }else if(hp==2){
        [self.hp1 setHidden:false];
        [self.hp2 setHidden:false];
        [self.hp3 setHidden:true];
    }else if(hp==3){
        [self.hp1 setHidden:false];
        [self.hp2 setHidden:false];
        [self.hp3 setHidden:false];
    }
}

-(void)shoot{
    [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
    
    // 1 - 选择其中的一个touch对象
    //    UITouch * touch = [touches anyObject];
    //    CGPoint location = [touch locationInNode:self];
    
    if(shootType==None){
        // 2 - 初始化子弹的位置
        
        //        TextureHelper *textureHelper = [[TextureHelper alloc] init];
        //        [TextureHelper new];
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
        
        //    SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        
        Bullet * projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        
        projectile.position = self.player.position;
        
        SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        // 3- 计算子弹移动的偏移量
        //    CGPoint offset = rwSub(location, projectile.position);
        
        // 4 - 如果子弹是向后射的那就不做任何操作直接返回
        //    if (offset.x <= 0) return;
        
        // 5 - 好了，把子弹添加上吧，我们已经检查了两次位置了
        projectile.zPosition = projectileLayerZPosition;
        [self insertChild:projectile atIndex:1];
//        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        // 6 - 获取子弹射出的方向
        //    CGPoint direction = rwNormalize(offset);R
        
        //    CGPoint p = new CGPointMake(p, );
        // 7 - 让子弹射得足够远来确保它到达屏幕边缘
        //    CGPoint shootAmount = rwMult(projectile.position, 1000);
        
        //    CGPoint p = CGPointMake(0, 1000);
        //
        //    // 8 - 把子弹的位移加到它现在的位置上
        //    CGPoint realDest = rwAdd(p, projectile.position);
        //
        //        // 9 - 创建子弹发射的动作
        //        float velocity = 480.0/1.0;
        //        float realMoveDuration = self.size.width / velocity;
        //        SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        //        SKAction * actionMoveDone = [SKAction removeFromParent];
        //        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        
        CGPoint p = CGPointMake(0, 1000);
        
        // 8 - 把子弹的位移加到它现在的位置上
        CGPoint realDest = rwAdd(p, projectile.position);
        
        // 9 - 创建子弹发射的动作
        float velocity = 480.0/5.0;
        float realMoveDuration = self.size.width / velocity;
        SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
    }else if(shootType==Faster){
        
        Bullet * projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        projectile.position = self.player.position;
        projectile.zPosition = projectileLayerZPosition;
        
        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        CGPoint p = CGPointMake(0, 1000);
        
        // 8 - 把子弹的位移加到它现在的位置上
        CGPoint realDest = rwAdd(p, projectile.position);
        
        // 9 - 创建子弹发射的动作
        float velocity = 480.0/5.0;
        float realMoveDuration = self.size.width / velocity;
        SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
        
        projectile.position = self.player.position;
        
        SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        
    }else if(shootType==Double){
        
        //        SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        Bullet * projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        projectile.position = self.player.position;
        projectile.zPosition = projectileLayerZPosition;
        
        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        CGPoint p = CGPointMake(300, 1000);
        CGPoint realDest = rwAdd(p, projectile.position);
        
        float velocity = 480.0/5.0;
        float realMoveDuration = self.size.width / velocity;
        SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
        
        projectile.position = self.player.position;
        
        SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        //        SKAction * a = [SKAction rotateToAngle:3.14/2.0 duration:1.0];
        //
        //        [projectile runAction:a];
        
        projectile.zRotation = -3.14/6.0;
        
        
        //        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        projectile.position = self.player.position;
        projectile.zPosition = projectileLayerZPosition;
        
        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        float x = projectile.position.x-300;
        float y = projectile.position.y + 1000;
        
        velocity = 480.0/5.0;
        realMoveDuration = self.size.width / velocity;
        
        actionMove = [SKAction moveTo:CGPointMake(x, y) duration:realMoveDuration];
        
        actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
        
        projectile.position = self.player.position;
        
        monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        projectile.zRotation = 3.14/6.0;
        
    }else if(shootType==Triple){
        //        SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        Bullet * projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        projectile.position = self.player.position;
        projectile.zPosition = projectileLayerZPosition;
        
        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        CGPoint p = CGPointMake(0, 1000);
        
        // 8 - 把子弹的位移加到它现在的位置上
        CGPoint realDest = rwAdd(p, projectile.position);
        
        // 9 - 创建子弹发射的动作
        float velocity = 480.0/5.0;
        float realMoveDuration = self.size.width / velocity;
        SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];

        projectile.position = self.player.position;
        
        SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        
        
        //        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        projectile.position = self.player.position;
        projectile.zPosition = projectileLayerZPosition;
        
        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        p = CGPointMake(300, 1000);
        realDest = rwAdd(p, projectile.position);
        
        velocity = 480.0/5.0;
        realMoveDuration = self.size.width / velocity;
        //            SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        
        
        actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        
        actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
        
        projectile.position = self.player.position;
        
        monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        projectile.zRotation = -3.14/6.0;
        
        //        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        projectile.position = self.player.position;
        projectile.zPosition = projectileLayerZPosition;
        
        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        float x = projectile.position.x-300;
        float y = projectile.position.y + 1000;
        
        velocity = 480.0/5.0;
        realMoveDuration = self.size.width / velocity;
        //            SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        
        
        actionMove = [SKAction moveTo:CGPointMake(x, y) duration:realMoveDuration];
        
        actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
        
        projectile.position = self.player.position;
        
        monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
        projectile.zRotation = 3.14/6.0;
    }else if(shootType==Power){
        
        Bullet * projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
        
        projectile.hitPower = 2;
        
        projectile.position = self.player.position;
        projectile.zPosition = projectileLayerZPosition;
        
        [self addChild:projectile];
        [spriteNodesProjectile addObject:projectile];
        
        CGPoint p = CGPointMake(0, 1000);
        
        // 8 - 把子弹的位移加到它现在的位置上
        CGPoint realDest = rwAdd(p, projectile.position);
        
        // 9 - 创建子弹发射的动作
        float velocity = 480.0/5.0;
        float realMoveDuration = self.size.width / velocity;
        SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        
        projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
        projectile.physicsBody.dynamic = YES;
        projectile.physicsBody.categoryBitMask = projectileCategory;
        projectile.physicsBody.contactTestBitMask = monsterCategory;
        projectile.physicsBody.collisionBitMask = 0;
        projectile.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"peanut" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 200) andRowNumberOfSprites:1 andColNumberOfSprites:8];
        
        projectile.position = self.player.position;
        
        SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
        
        [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
        
    }
    
//    isMoveBar = false;
    
    
    TextureHelper *textureHelper = [TextureHelper alloc];
    
    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                         //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                              sequence:@[@7,@8,@0,@1,@2]];
    
    SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.1];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    //        [self.player runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
    
    [self.player runAction:monsterAnimation];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
//    if(self.lastSpawnTimeInterval < 0.5){
//        return;
//    }
    
    storeBtn.texture = storeBtnClickTextureArray[NORMAL_TEXTURE_INDEX];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
 
    isMoveBar = false;
    isShootEnable = false;
    
    if(isGameEndSuccess){
        [self backToMenu];
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    CGPoint amount = CGPointMake(0.1 * 20,0.1 * 20);
//    SKAction* action = [SKAction sha];screenShakeWithNode(worldNode,
//                                              amount: amount, oscillations: 10, duration: 3.0) worldNode.runAction(action)
    
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
        CGRect rect = [self.controlPoint calculateAccumulatedFrame];
    bool isCollision = CGRectContainsPoint(rect, location);
    if(isCollision){
        p = location;
        isMoveBar = true;
        isShootEnable = true;
    }
    
    if(self.pauseBtnNode.hidden==false){
        rect = [self.pauseBtnNode calculateAccumulatedFrame];
        isCollision = CGRectContainsPoint(rect, location);
        if(isCollision){
            [self setGameRun:YES];
            [self setViewRun:YES];
        }
    }
    
    if(TEST_MODE==true){
        if(CGRectContainsPoint([self.testBtnNode calculateAccumulatedFrame], location)){
            catCurrentHp = 0;
//            [self changeCatHpBar];
            if (catCurrentHp<=0) {
                catCurrentHp = 0;
                isGameRun = false;
                isMoveAble = false;
                
                for (int i = 0; i < [self children].count; i++) {
                    SKNode * n = [self children][i];
                    [n removeAllActions];
                }
                
                [self.cat setTexture:currentCatTextures[3]];
                
                //        SKAction * actionMove = [SKAction moveTo:CGPointMake(self.cat.position.x, self.cat.position.y - self.cat.size.height) duration:3];
                //        SKAction * actionMoveDone = [SKAction removeFromParent];
                //        SKAction * actionReset = [SKAction runBlock:^{
                //            [self resetGame];
                //            isGameRun = true;
                //        }];
                //        [self.cat runAction:[SKAction sequence:@[actionMove, actionReset]]];
                
                [self catDieAndDisapearDown];
            }
            
            [self changeCatHpBar];
            
        }else if(CGRectContainsPoint([self.sendScoreBtnNode calculateAccumulatedFrame], location)){
            GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
            [gameCenterUtil reportScore:gameTime forCategory:@"com.irons.AttackOnGiantCat"];
        }
    }
    
    if(CGRectContainsPoint(storeBtn.calculateAccumulatedFrame, location)){
        storeBtn.texture = storeBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        [self displayBuyView];
    }else if(CGRectContainsPoint(rankBtn.calculateAccumulatedFrame, location)){
//        rankBtn.texture = storeBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        [self displayRankView];
    }else if(CGRectContainsPoint(musicBtn.calculateAccumulatedFrame, location)){
        if([MyUtils isBackgroundMusicPlayerPlaying]){
            [MyUtils backgroundMusicPlayerPause];
            musicBtn.texture = musicBtnTextures[1];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isPlayMusic"];
        }else{
            [MyUtils backgroundMusicPlayerPlay];
            musicBtn.texture = musicBtnTextures[0];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isPlayMusic"];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isMoveBar && isMoveAble){
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        /*
        if(location.x - self.player.size.width/2 <0){
            location.x = self.player.size.width/2;
        }else if(location.x + self.player.size.width/2 > self.frame.size.width){
            location.x = self.frame.size.width - self.player.size.width/2;
        }*/
        
        CGFloat offx = location.x - p.x;;
//        if(location.x - self.player.size.width/2 <0){
//            offx = location.x - p.x;
//        }else if(location.x + self.player.size.width/2 > self.frame.size.width){
//            
//        }else{
//            offx = location.x - p.x;
//        }
        
        if(self.player.position.x + offx < self.player.size.width/2){
            offx = self.player.size.width/2 - self.player.position.x;
        }else if(self.player.position.x + offx > self.frame.size.width - self.player.size.width/2){
            offx = self.frame.size.width - self.player.size.width/2 - self.player.position.x;
        }
        
        CGPoint position = self.controlPoint.position;
        position.x = position.x + offx;
        self.controlPoint.position = position;
        
        position = self.player.position;
        position.x = position.x + offx;
        self.player.position = position;
        
        p = location;
        
//        if (self.fire.hidden) {
//            
//        }else{
            self.fire.position = self.player.position;
//        }
        
        
        
        if(offx > 8){
            self.player.xScale = -1;
            
//            self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.width/2];
//            self.player.physicsBody.dynamic = YES;
//            self.player.physicsBody.categoryBitMask = hamsterCategory;
//            self.player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
//            self.player.physicsBody.collisionBitMask = 0;
//            self.player.physicsBody.usesPreciseCollisionDetection = YES;
            
            SKAction * monsterAnimation = [SKAction animateWithTextures:rightNsArray timePerFrame:0.1];
            
            SKAction * actionMoveDone = [SKAction removeFromParent];
            
            //        [self.player runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
            
            [self.player runAction:monsterAnimation];
            
        }else if(offx <-8){
            self.player.xScale = 1;
            
//            self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.width/2];
//            self.player.physicsBody.dynamic = YES;
//            self.player.physicsBody.categoryBitMask = hamsterCategory;
//            self.player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
//            self.player.physicsBody.collisionBitMask = 0;
//            self.player.physicsBody.usesPreciseCollisionDetection = YES;
            
            SKAction * monsterAnimation = [SKAction animateWithTextures:leftNsArray timePerFrame:0.1];
            
            SKAction * actionMoveDone = [SKAction removeFromParent];
            
            //        [self.player runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
            
            [self.player runAction:monsterAnimation];
            
        }
    }
}

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}
static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}
static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}
static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}
// 让向量的长度（模）等于1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

- (void)addMonster{
    CGPoint p = CGPointMake(self.cat.position.x, self.cat.position.y-self.cat.size.height/2);
    [self addMonsterWithHitCount:-1 position:p dir:-1 monster:nil isBelowHitCount:false isNoTool:false];
}

- (void)addMonsterWithBelowHitCount:(int)hitCount isNoTool:(bool)isNoTool{
    CGPoint p = CGPointMake(self.cat.position.x, self.cat.position.y-self.cat.size.height/2);
    [self addMonsterWithHitCount:hitCount position:p dir:-1 monster:nil isBelowHitCount:true isNoTool:isNoTool];
}

- (void)addMonsterWithHitCount:(int)hitCount position:(CGPoint) position dir:(int) dir monster:(Monster*) originalMonster isBelowHitCount:(bool)isBelowHitCount isNoTool:(bool)isNoTool{

    Monster * monster = [Monster spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
    
    monster.size = CGSizeMake(50, 50);
    
    NSLog(@"monster hitCount:%d", hitCount);
    
    if(isBelowHitCount){
        [monster setEffectWithBelowHitCount:hitCount withNoTool:isNoTool];
    }else{
        if(hitCount==-1)
            [monster setEffect];
        else
            [monster setEffectWithHitCount:hitCount withNoTool:isNoTool];
    }
    
    // 决定怪物在竖直方向上的出现位置
    int minY = monster.size.height / 2;
    int maxY = self.frame.size.height - monster.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    int minX = monster.size.width / 2;
    int maxX = self.frame.size.width - monster.size.width / 2;
    
//    if(position.y > self.frame.size.height/2){
//        minX = monster.size.width*3;
//        maxX = self.frame.size.width - monster.size.width*3;
//    }
    
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = CGPointMake(position.x, position.y);
    monster.zPosition = projectileLayerZPosition;
    [self addChild:monster];
    
    // 设置怪物的速度
    int minDuration = 3.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    actualX = (arc4random() % rangeX) + minX;
    
    SKAction * actionMove;

    if (dir==0 || dir==-1) {
//    if (dir==-1) {
        if (originalMonster==nil) {
            actionMove = [SKAction moveTo:CGPointMake(actualX, self.player.position.y) duration:actualDuration];
        }else{
            int duration = [[originalMonster actionForKey:@"aa"] duration];
            int moveToY = 0;
            duration = (monster.position.y - moveToY)/originalMonster.getMoveToY * duration;
            actionMove = [SKAction moveTo:CGPointMake(actualX, self.player.position.y) duration:duration];
        }
        
        [monster setMoveToY:monster.position.y];
        
    }else{
        [monster setCount:originalMonster.getCount+1];
        float duration = [[originalMonster actionForKey:@"aa"] duration];
//        int moveToY = self.frame.size.height*(powf(2/3.0f, originalMonster.getCount+1));
        float moveToY = self.frame.size.height*(powf(3/4.0f, 1));
//        duration = (moveToY - monster.position.y)/moveToY * duration;
        
        float len = sqrtf((actualX-monster.position.x) * (actualX-monster.position.x) + (moveToY-monster.position.y) * (moveToY-monster.position.y));
        
        duration = len/moveToY * 4;
        
//        duration = 2;
        actionMove = [SKAction moveTo:CGPointMake(actualX, moveToY) duration:duration];
        [monster setMoveToY:monster.position.y];
        
//        dir = -1;
//        [monster setDir:dir];
//        dir = 1;
    }
    
//    actionMove:acti;
    
    
    SKAction * action = [SKAction sequence:@[actionMove]];
    
     SKAction *s = [SKAction sequence:@[actionMove , [self newListener2:monster wihtX:minX withY:rangeX withD:actualDuration dir:dir]]];
    
    [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
    
    [spriteNodes addObject:monster];
    
    if(spriteNodes.count>10){
        int monsterNum = spriteNodes.count;
        for (int i = 0; i < monsterNum-10; i++) {
            SKSpriteNode* s = spriteNodes[i];
            [spriteNodes removeObjectAtIndex:i];
            
            [s removeFromParent];
        }
        
    }
    
////    SKAction * loseAction = [SKAction runBlock:^{
////        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
////        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
////        [self.view presentScene:gameOverScene transition: reveal];
////    }];
//    [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    monster.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:monster.size.width/2]; // 1
    monster.physicsBody.dynamic = YES; // 2
    monster.physicsBody.categoryBitMask = monsterCategory; // 3
    monster.physicsBody.contactTestBitMask = projectileCategory; // 4
    monster.physicsBody.collisionBitMask = 0; // 5
    
    
//        Monster * monster = [Monster spriteNodeWithImageNamed:@"monster"];
//    
//     [monster setEffect];
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
//    monster.position = CGPointMake(self.cat.position.x, self.frame.size.height - monster.size.height);
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
//    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size]; // 1
//    monster.physicsBody.dynamic = YES; // 2
//    monster.physicsBody.categoryBitMask = monsterCategory; // 3
//    monster.physicsBody.contactTestBitMask = projectileCategory; // 4
//    monster.physicsBody.collisionBitMask = 0; // 5
}

-(SKAction*)newMoveAction:(float)x withY:(float)y withD:(float)d{
    SKAction *m = [SKAction moveTo:CGPointMake(x, y) duration:d];
    return m;
}

//-(SKAction*)newListener:(Monster*)monster wihtX:(int)minX withY:(int)rangeX withD:(float)actualDuration{
//    SKAction *listener = [SKAction runBlock:^{
//        
//        if(![self checkTheLimitSide:monster withDir:[monster getDir]]){
//            int actualX = (arc4random() % rangeX) + minX;
//            
//            if([monster getDir]==0){
//                int moveToY;
//                if(monster.position.y - monster.size.height*2 < 0)
//                    moveToY = 0;
//                else
//                    moveToY = monster.position.y - monster.size.height*2;
//                SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, moveToY) duration:actualDuration];
//                SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration]]];
//                [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
//                //            [SKAction removeFromParent];
//            }else{
//                SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, monster.position.y + monster.size.height*2) duration:actualDuration];
//                SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration]]];
//                [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
//                //            [SKAction removeFromParent];
//            }
//        }else{
//            
//            if([monster getCount]<2){
//                int actualX = (arc4random() % rangeX) + minX;
//                
//                [monster setCount:[monster getCount]+1];
//                
//                if([monster getDir]==0){
//                [monster setDir:1];
////                    [monster setCou                                                                                                                                                                                                                                                                                                                                                                                                                                     nt:0];
//                SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, monster.position.y + monster.size.height*2) duration:actualDuration];
//                SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration]]];
//                     [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
//                    }else{
//                        [monster setDir:0];
////                        [monster setCount:0];
//                        SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, monster.position.y - monster.size.height*2) duration:actualDuration];
//                        SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration]]];
//                        [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
//                    }
//
//            }
//            else{
//                [monster removeFromParent];
//                
//                [self resetGame];
//            }
//        }
//    }];
//    
//    return listener;
//}

-(void)changeDir:(Monster*)monster{
    
    // 决定怪物在竖直方向上的出现位置
    int minY = monster.size.height / 2;
    int maxY = self.frame.size.height - monster.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    int minX = monster.size.width / 2;
    int maxX = self.frame.size.width - monster.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // 设置怪物的速度
    int minDuration = 3.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    float moveToY = self.frame.size.height*(powf(3/4.0f, 1));
    
    float len = sqrtf((actualX-monster.position.x) * (actualX-monster.position.x) + (moveToY-monster.position.y) * (moveToY-monster.position.y));
    
    float duration = len/moveToY * 4;
    
//    int duration = (moveToY - monster.position.y)/moveToY * 8;
//    duration = 2;
    SKAction * actionMove;
    actionMove = [SKAction moveTo:CGPointMake(actualX, moveToY) duration:duration];
    [monster setMoveToY:monster.position.y];
    
//    actionMove:acti;


    SKAction * action = [SKAction sequence:@[actionMove]];

    SKAction *s = [SKAction sequence:@[actionMove , [self newListener2:monster wihtX:minX withY:rangeX withD:actualDuration dir:2]]];

    [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
}

-(SKAction*)newListener2:(Monster*)monster wihtX:(int)minX withY:(int)rangeX withD:(float)actualDuration dir:(int)dir{
    
    if (dir>=0) {
        [monster setDir:dir];
    }
    
    SKAction *listener = [SKAction runBlock:^{
        
        NSLog(@"monster listener runAction block");
        
        if([monster getCount]<10){
            int actualX = (arc4random() % rangeX) + minX;
            
            if([monster getCount] < 2)
                [monster setCount:[monster getCount]+1];
            
            if([monster getDir]==0||[monster getDir]==-1){
                NSLog(@"monster getDir:%d, setDir:1", [monster getDir]);
                [monster setDir:1];
                //                    [monster setCount:0];
                int moveToY = self.frame.size.height*(powf(2/3.0f, 1));
                SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, moveToY) duration:actualDuration];
                SKAction *s = [SKAction sequence:@[aa, [self newListener2:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
                [monster setMoveToY:monster.position.y];
            }else{
                NSLog(@"monster getDir:%d, setDir:0", [monster getDir]);
                [monster setDir:0];
                //                        [monster setCount:0];
                SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, self.player.position.y) duration:actualDuration];
                SKAction *s = [SKAction sequence:@[aa, [self newListener2:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
                [monster setMoveToY:monster.position.y];
            }
            
        }
    }];
    
    return listener;
}

-(SKAction*)newListener:(Monster*)monster wihtX:(int)minX withY:(int)rangeX withD:(float)actualDuration dir:(int)dir{
    
    if (dir>=0) {
        [monster setDir:dir];
    }
    
    SKAction *listener = [SKAction runBlock:^{
        
        NSLog(@"monster listener runAction block");
        
        if(![self checkTheLimitSide:monster withDir:[monster getDir]]){
            int actualX = (arc4random() % rangeX) + minX;
            
            NSLog(@"fail linster");
            
            if([monster getDir]==0){
                int moveToY;
//                if(monster.position.y - monster.size.height*2 < 0)
//                    moveToY = 0;
//                else
                    moveToY = self.frame.size.height*(powf(2/3.0f, [monster getCount]));
                SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, moveToY) duration:actualDuration];
//                SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                
                [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
                [monster setMoveToY:monster.position.y];
                //            [SKAction removeFromParent];
            }else{
                SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, monster.position.y + monster.size.height*2) duration:actualDuration];
//                SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                
                [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
                [monster setMoveToY:monster.position.y];
                //            [SKAction removeFromParent];
            }
        }else{
            
            if([monster getCount]<10){
                int actualX = (arc4random() % rangeX) + minX;
                
                if([monster getCount] < 2)
                [monster setCount:[monster getCount]+1];
                
                if([monster getDir]==0){
                    NSLog(@"monster getDir:%d, setDir:1", [monster getDir]);
                    [monster setDir:1];
                    //                    [monster setCount:0];
                    int moveToY = self.frame.size.height*(powf(2/3.0f, [monster getCount]));
                    SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, moveToY) duration:actualDuration];
                    SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                    [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
                    [monster setMoveToY:monster.position.y];
                }else{
                    NSLog(@"monster getDir:%d, setDir:0", [monster getDir]);
                    [monster setDir:0];
                    //                        [monster setCount:0];
                    SKAction  *aa = [SKAction moveTo:CGPointMake(actualX, 0) duration:actualDuration];
                    SKAction *s = [SKAction sequence:@[aa, [self newListener:monster wihtX:minX withY:rangeX withD:actualDuration dir:-1]]];
                    [monster runAction:[SKAction repeatAction:s count:1] withKey:@"aa"];
                    [monster setMoveToY:monster.position.y];
                }
                
            }
            else{
//                [monster removeFromParent];
                
//                [self resetGame];
            }
        }
    }];
    
    return listener;
}


-(Boolean)checkTheLimitSide:(Monster*)monster withDir:(int)dir{
    int c = [monster getCount];
    if(dir==0 || dir==-1){
        NSLog(@"dir=0|-1, monster.position.y < monster.size.height");
        return (monster.position.y < monster.size.height);
    }
    else if(dir==1){
        NSLog(@"dir=1, monster.position.y+1 >= self.frame.size.height*(powf(2/3.0f, [monster getCount]))");
        return (monster.position.y+1 >= self.frame.size.height*(powf(2/3.0f, [monster getCount])));
        
    }else{
        NSLog(@"dir=2, monster.position.y+1 >= self.frame.size.height*(powf(4/5.0f, 1))");
        return (monster.position.y+1 >= self.frame.size.height*(powf(2/3.0f, 1)));
    }
}

- (void)projectile:(Bullet *)projectile didCollideWithMonster:(Monster *)monster {
    
    if (projectile.hidden||monster.hidden||projectile==nil||monster==nil) {
        return;
    }
    
    NSLog(@"Hit");
    
    projectile.hidden = true;
    
//    projectile.physicsBody = nil;
    
    [projectile removeFromParent];
    
//    projectile = nil;
    
    [monster doEffect:projectile.hitPower];
    
    if(![monster.effect isHitDone]){
        [monster changeType];
        [self changeDir:monster];
    }
    
    NSLog(@"after doEffect and changeType");
    
    if([monster.effect isHitDone]){
        clearedMonster++;
       [monster removeFromParent];
        monster.hidden = true;
//        monster = nil;
        NSLog(@"monster hit down");
        
        SKSpriteNode *explode = [SKSpriteNode spriteNodeWithTexture:nil size:CGSizeMake(100, 100)];
        
        
        
        NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"explode" withinNode:nil sourceRect:CGRectMake(0, 0, 500, 500) andRowNumberOfSprites:1 andColNumberOfSprites:5];
        
        explode.position = monster.position;
        
        SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.2];
        
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        [explode runAction:[SKAction sequence: @[monsterAnimation, actionMoveDone]]];
        
        [self addChild:explode];
        [spriteNodesExplode addObject:explode];
        
        NSLog(@"explode");
        
        if([monster.effect hasTool]){
        Tool * tool = [Tool spriteNodeWithTexture:nil size:CGSizeMake(40, 40)];

        if(toolLevel==NORMAL_RANDOM_TOOL){
            [tool newTool];
        }else if(toolLevel==ONLY_FASTER_TOOL){
            [tool newToolWithFaster];
        }else if(toolLevel==ONLY_F_DOUBLE_TOOL){
            [tool newToolWithF_Double];
        }else if(toolLevel==ONLY_F_D_TRIPLE_TOOL){
            [tool newToolWithF_D_Triple];
        }else if(toolLevel==ONLY_POWER_TOOL){
            [tool newToolWithPower];
        }else if(toolLevel==ONLY_P_HEAL_TOOL){
            [tool newToolWithP_Heal];
        }
        
            
        ToolType tooltype = [tool getToolType];
        
            switch (tooltype) {
                case A:
//                    nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];

                    nsArray = @[[SKTexture textureWithImageNamed:@"tool1_1"], [SKTexture textureWithImageNamed:@"tool1_2"]];
                    
//                    projectile.position = self.player.position;
                    
                   monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.3]];
                    
                    [tool runAction:[SKAction repeatActionForever: monsterAnimation ]];
                    break;
                    
                case B:
                    nsArray = @[[SKTexture textureWithImageNamed:@"tool2_1"], [SKTexture textureWithImageNamed:@"tool2_2"]];
                    
//                    projectile.position = self.player.position;
                    
                    monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
                    
                    [tool runAction:[SKAction repeatActionForever: monsterAnimation ]];
                    break;
                    
                case C:
                    nsArray = @[[SKTexture textureWithImageNamed:@"tool3_1"], [SKTexture textureWithImageNamed:@"tool3_2"]];
                    monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
                    
                    [tool runAction:[SKAction repeatActionForever: monsterAnimation ]];
                    
                    break;
                case D:
                    nsArray = @[[SKTexture textureWithImageNamed:@"tool4_1"], [SKTexture textureWithImageNamed:@"tool4_2"]];
                    monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
                    
                    [tool runAction:[SKAction repeatActionForever: monsterAnimation ]];
                    
                    break;
                case E:
                    nsArray = @[[SKTexture textureWithImageNamed:@"tool6_1"], [SKTexture textureWithImageNamed:@"tool6_2"]];
                    monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
                    
                    [tool runAction:[SKAction repeatActionForever: monsterAnimation ]];
                    
                    break;
                default:
                    
                    break;
            }
            
        int minX = monster.size.width / 2;
        int maxX = self.frame.size.width - monster.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        // Create the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        tool.position = CGPointMake(monster.position.x, monster.position.y);
        [self addChild:tool];
        
        // 设置怪物的速度
        int minDuration = 4.0;
        int maxDuration = 5.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        actualX = (arc4random() % rangeX) + minX;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(tool.position.x, 100) duration:actualDuration];
        
        //    actionMove:acti;
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * action = [SKAction sequence:@[actionMove, [SKAction runBlock:^{
            NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                                   target:self
                                                             selector:@selector(toolDisapear:)
                                                                 userInfo:tool
                                                                  repeats:NO];
            [timers addObject:timer];
        }]]];
        
        
        tool.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tool.size]; // 1
        tool.physicsBody.dynamic = YES; // 2
        tool.physicsBody.categoryBitMask = toolCategory; // 3
        tool.physicsBody.contactTestBitMask = projectileCategory|hamsterCategory; // 4
        tool.physicsBody.collisionBitMask = 0; // 5
        
        [tool runAction:action];
            
            [spriteNodesTool addObject:tool];
        }
        \
    }else{
        
        //split
        
        [self addMonsterWithHitCount:monster.effect.getHitCount position:monster.position dir:2 monster:monster isBelowHitCount:false isNoTool:monster.isNoTool];
        
        NSLog(@"monster split");
        
    }
    
    NSLog(@"did didCollideWithMonster");
    
//    self.monstersDestroyed++;
//    if (self.monstersDestroyed > 30) {
//        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
//        [self.view presentScene:gameOverScene transition: reveal];
//    }
}

-(void)toolDisapear:(NSTimer*)timer{
    Tool * tool = [timer userInfo];
    [tool removeFromParent];
    [timers removeObject:timer];
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithTool:(Tool *)tool {
    
    if (projectile.hidden||projectile==nil) {
        return;
    }
    
    projectile.hidden = true;
    
    [tool doToolEffect];
    [projectile removeFromParent];
    [tool removeFromParent];
    
//    [self initializeTimer];
    
}

- (void)projectile:(Bullet *)projectile didCollideWithCat:(SKSpriteNode *)cat {
    
    if (projectile.hidden||projectile==nil) {
        return;
    }
    
    projectile.hidden = true;
    
//    [tool doToolEffect];
    
//    [tool removeFromParent];
    
//    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
    
//    projectile.position = self.player.position;

    NSArray *nsArray = @[currentCatTextures[2], currentCatTextures[0]];
    
    SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.5];
    
    [self.cat removeActionForKey:@"injure"];
    [self.cat removeActionForKey:@"catMove"];
    isInjure = true;
    [self.cat runAction:[SKAction sequence:@[monsterAnimation, [SKAction runBlock:^{
        isInjure = false;
    }]]] withKey:@"injure"];
    
    catCurrentHp -= [projectile hitPower];
    
    if (catCurrentHp<=0) {
        catCurrentHp = 0;
        isGameRun = false;
        isMoveAble = false;
        
        for (int i = 0; i < [self children].count; i++) {
            SKNode * n = [self children][i];
            [n removeAllActions];
        }
        
        [self.cat setTexture:currentCatTextures[3]];
        
//        SKAction * actionMove = [SKAction moveTo:CGPointMake(self.cat.position.x, self.cat.position.y - self.cat.size.height) duration:3];
//        SKAction * actionMoveDone = [SKAction removeFromParent];
//        SKAction * actionReset = [SKAction runBlock:^{
//            [self resetGame];
//            isGameRun = true;
//        }];
//        [self.cat runAction:[SKAction sequence:@[actionMove, actionReset]]];
                    
        [self catDieAndDisapearDown];
    }else{
        
        for(int i = 0; i < fireballLevel; i ++){
            SKSpriteNode * fireballNode = [SKSpriteNode spriteNodeWithImageNamed:@"fireball"];
            fireballNode.size = CGSizeMake(50, 70);
            int fireballX = arc4random_uniform(self.frame.size.width - fireballNode.size.width)+fireballNode.size.width/2;
            fireballNode.position = CGPointMake(fireballX, self.frame.size.height-fireballNode.size.height/2);
            fireballNode.zPosition = fireballLayerZPosition;
            
            fireballNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:fireballNode.size.width/2]; // 1
            fireballNode.physicsBody.dynamic = YES; // 2
            fireballNode.physicsBody.categoryBitMask = fireballCategory; // 3
            fireballNode.physicsBody.contactTestBitMask = hamsterCategory; // 4
            fireballNode.physicsBody.collisionBitMask = 0; // 5
            
            SKAction * move = [SKAction moveToY:0 duration:4];
            SKAction * end = [SKAction runBlock:^{
                [fireballNode removeFromParent];
            }];
            [fireballNode runAction:[SKAction sequence:@[move, end]]];
            
            [self addChild:fireballNode];
            [spriteNodesFireball addObject:fireballNode];
        }
        
    }
    
    [self changeCatHpBar];
    
    [projectile removeFromParent];
    
//    [self initializeTimer];
    
}

-(void)monster:(SKSpriteNode *) monster didCollideWithHamster:(SKSpriteNode *) hamster{
    
    if(monster.hidden||monster==nil){
        return;
    }
    
    monster.hidden = true;
    
    if(self.fire.hidden && !isInvinceble){
        hp--;
//    [self shake:10];
    
    [hamster removeAllActions];
    [hamster setTexture:[TextureHelper hamsterInjureTexture]];
    
        if(hp<=0){
        isGameRun = NO;
//            self.onGameEnd2(YES);
            for (int i =0; i < [spriteNodes count]; i++) {
                SKSpriteNode * m = [spriteNodes objectAtIndex:i];
                [m removeAllActions];
//                [m removeFromParent];
                //        [spriteNodes removeObjectAtIndex:i];
            }
            
            for (int i =0; i < [spriteNodesExplode count]; i++) {
                SKSpriteNode * m = [spriteNodesExplode objectAtIndex:i];
                [m removeAllActions];
            }
            
            for (int i =0; i < [spriteNodesFireball count]; i++) {
                SKSpriteNode * m = [spriteNodesFireball objectAtIndex:i];
                [m removeAllActions];
            }
            
            self.onGameOver(gameLevel, gameTime, clearedMonster);
            return;
            
        }
    isInvinceble = true;
    isMoveAble = false;
    isShootEnable = false;
    
    NSTimer * timer =  [NSTimer scheduledTimerWithTimeInterval:2.0
                                                        target:self
                                                      selector:@selector(hamsterInjureTime:)
                                                      userInfo:nil
                                                       repeats:NO];
        [timers addObject:timer];
    }
    
    
    [monster removeFromParent];
    monster = nil;
}

- (void)humster:(SKSpriteNode *)projectile didhumsterCollideWithTool:(Tool *)tool {
    
    if (tool.hidden||tool==nil) {
        return;
    }
    
    tool.hidden = true;
    
    [tool doToolEffect];
//    [projectile removeFromParent];
    [tool removeFromParent];
    
//    [self initializeTimer];
    
}

- (void)humster:(SKSpriteNode *)hamster didhumsterCollideWithFireball:(SKSpriteNode *)fireball {
    [self monster:fireball didCollideWithHamster:hamster];
}

-(void)hamsterInjureTime:(NSTimer*)timer{
    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                                              sequence:@[@7]];
    
    [self.player setTexture:nsArray[0]];
    
    isMoveAble = true;
    if (isMoveBar) {
        isShootEnable = true;
    }
    
    self.fire.hidden = false;
    
    [timers removeObject:timer];
    
    NSTimer * invincebleTimer =  [NSTimer scheduledTimerWithTimeInterval:5.0
                                                        target:self
                                                                selector:@selector(hamsterInvincebleEnd:)
                                                      userInfo:nil
                                                       repeats:NO];
    [timers addObject:invincebleTimer];
}

-(void)hamsterInvincebleEnd:(NSTimer*)timer{
    self.fire.hidden = true;
    isInvinceble = false;
    [timers removeObject:timer];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [contactQueue addObject:contact];
    
}

-(void)processContactsForUpdate
{
    for (SKPhysicsContact * contact in [contactQueue copy]) {
        [self handleContact:contact];
        [contactQueue removeObject:contact];
    }
}

-(void) handleContact:(SKPhysicsContact *)contact
{
    NSLog(@"contact");
    // What you are doing in your current didBeginContact method
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask == projectileCategory)  &&
        (secondBody.categoryBitMask == monsterCategory))
    {
        NSLog(@"will do didCollideWithMonster");
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
        
    }
    
    else if ((firstBody.categoryBitMask == projectileCategory) &&
             (secondBody.categoryBitMask == toolCategory))
    {
        /* 子彈吃道具
        NSLog(@"will do didCollideWithTool");
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithTool:(SKSpriteNode *) secondBody.node];
         */
    }
    
    else if ((firstBody.categoryBitMask == projectileCategory) &&
             (secondBody.categoryBitMask == catCategory))
    {
        NSLog(@"will do didCollideWithCat");
        [self projectile:(Bullet *) firstBody.node didCollideWithCat:(SKSpriteNode *) secondBody.node];
    }
    
    else if ((firstBody.categoryBitMask == monsterCategory) &&
             (secondBody.categoryBitMask == hamsterCategory))
    {
        NSLog(@"will do didCollideWithHamster");
        [self monster:(SKSpriteNode *) firstBody.node didCollideWithHamster:(SKSpriteNode *) secondBody.node];
    }
    
    else if ((firstBody.categoryBitMask == toolCategory) &&
             (secondBody.categoryBitMask == hamsterCategory))
    {
        NSLog(@"will do didhumsterCollideWithTool");
        [self humster:(SKSpriteNode *) secondBody.node didhumsterCollideWithTool:(Tool *) firstBody.node];
    }
    
    else if ((firstBody.categoryBitMask == hamsterCategory) &&
             (secondBody.categoryBitMask == fireballCategory))
    {
        NSLog(@"will do didhumsterCollideWithFireball");
        [self humster:(SKSpriteNode *) firstBody.node didhumsterCollideWithFireball:(SKSpriteNode *) secondBody.node];
    }
    
//    // 2
//    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
//        (secondBody.categoryBitMask & monsterCategory) != 0)
//    {
//        NSLog(@"will do didCollideWithMonster");
//        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
//        
//    }
//    
//    else if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
//        (secondBody.categoryBitMask & toolCategory) != 0)
//    {
//        NSLog(@"will do didCollideWithTool");
//        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithTool:(SKSpriteNode *) secondBody.node];
//    }
//    
//    else if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
//        (secondBody.categoryBitMask & catCategory) != 0)
//    {
//        NSLog(@"will do didCollideWithCat");
//        [self projectile:(Bullet *) firstBody.node didCollideWithCat:(SKSpriteNode *) secondBody.node];
//    }
//    
//    else if ((firstBody.categoryBitMask & monsterCategory) != 0 &&
//        (secondBody.categoryBitMask & hamsterCategory) != 0)
//    {
//        NSLog(@"will do didCollideWithHamster");
//        [self monster:(SKSpriteNode *) firstBody.node didCollideWithHamster:(SKSpriteNode *) secondBody.node];
//    }
//    
//    else if ((firstBody.categoryBitMask & toolCategory) != 0 &&
//              (secondBody.categoryBitMask & hamsterCategory) != 0)
//    {
//        NSLog(@"will do didhumsterCollideWithTool");
//        [self humster:(SKSpriteNode *) secondBody.node didhumsterCollideWithTool:(Tool *) firstBody.node];
//    }

//    firstBody.node.hidden = true;
//    [firstBody.node removeFromParent];
//    [secondBody.node removeFromParent];
}

/*
//自行定義的函式，用來設定使用Timer/計時器的相關參數
-(void)initializeTimer {
    toolTime = 10;
    toolTimeLabel.text = [NSString stringWithFormat:@"%d", toolTime];
    //設定Timer觸發的頻率，每秒30次
    float theInterval = 1.0/1.0;
    [theTimer invalidate];
    //正式啟用Timer，selector是設定Timer觸發時所要呼叫的函式
    //theTimer是NSTimer型態的指標，用來存放當前的計時器狀態
    theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval
                                                target:self
                                              selector:@selector(countToolTime)
                                              userInfo:nil
                                               repeats:YES];
}

int toolTime=10;

-(void)countToolTime{
    if(toolTime<=0){
        toolTimeLabel.text = @"";
        [theTimer invalidate];
        return;
    }
    toolTime--;
    toolTimeLabel.text = [NSString stringWithFormat:@"%d", toolTime];
}
*/

-(void)initGameTimer{
    
    theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                              selector:@selector(countGameTime)
                                              userInfo:nil
                                               repeats:YES];
    [timers addObject:theGameTimer];
}

-(void)countGameTime{
//    if(gameTime>3600){
////        theGameTimerLabel.text = @"";
//        [theGameTimer invalidate];
//        return;
//    }
    
    if(!isGameRun){
        return;
    }
    
    gameTime++;

    [self setTimeTextures];
}

-(void)setTimeTextures{
    theGameTimerLabel.text = [NSString stringWithFormat:@"%d", gameTime];
    
    SKTexture* timeMinuteHunDigitalTexture = [self getTimeTexture:gameTime/60/10/10];
    SKTexture* timeMinuteTenDigitalTexture = [self getTimeTexture:gameTime/60/10%10];
    SKTexture* timeMinuteSingleDigitalTexture = [self getTimeTexture:gameTime/60%10];
    SKTexture* timeSecondTenDigitalTexture = [self getTimeTexture:gameTime%60/10];
    SKTexture* timeSecondSingleDigitalTexture = [self getTimeTexture:gameTime%60%10];
    
    [self.timeMinuteHunsDigital setTexture:timeMinuteHunDigitalTexture];
    [self.timeMinuteTensDigital setTexture:timeMinuteTenDigitalTexture];
    [self.timeMinuteSingalDigital setTexture:timeMinuteSingleDigitalTexture];
    [self.timeScecondTensDigital setTexture:timeSecondTenDigitalTexture];
    [self.timeSecondSingalDigital setTexture:timeSecondSingleDigitalTexture];
}

-(void)setClearedMonsterNodeText{
    NSString * s = [NSString stringWithFormat:@"%d", clearedMonster];
    
    clearedMonsterLabel.text = s;
    clearedMonsterLabel.position = CGPointMake(self.clearedNode.position.x + self.clearedNode.size.width + clearedMonsterLabel.frame.size.width/2, clearedMonsterLabel.position.y);
}

-(SKTexture*)getTimeTexture:(int)time{
    SKTexture* texture;
    switch (time) {
        case 0:
            texture = [TextureHelper timeTextures][0];
            break;
        case 1:
            texture = [TextureHelper timeTextures][1];
            break;
        case 2:
            texture = [TextureHelper timeTextures][2];
            break;
        case 3:
            texture = [TextureHelper timeTextures][3];
            break;
        case 4:
            texture = [TextureHelper timeTextures][4];
            break;
        case 5:
            texture = [TextureHelper timeTextures][5];
            break;
        case 6:
            texture = [TextureHelper timeTextures][6];
            break;
        case 7:
            texture = [TextureHelper timeTextures][7];
            break;
        case 8:
            texture = [TextureHelper timeTextures][8];
            break;
        case 9:
            texture = [TextureHelper timeTextures][9];
            break;
    }
    return texture;
}

-(void)gameContinue:(int)recordGameLevel{
    gameLevel = recordGameLevel-1;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    gameTime = [userDefaults integerForKey:@"currentGameTime"];
    clearedMonster = [userDefaults integerForKey:@"currentClearBall"];
    [self resetGameToNext];
    [self checkShowGameHintAndStartGame];
}

-(void)gameStart{
//    gameTime=5940;
    [self checkShowGameHintAndStartGame];
}

-(void)resetGameToFirstLevel{
    gameLevel = -1;
    [self resetGameAndGoTOFirstLevel:true];
}

-(void)resetGameToNext{
    [self resetGameAndGoTOFirstLevel:false];
//    isGameRun = true;
//    isMoveAble = true;
}

-(void)resetGameAndGoTOFirstLevel:(bool)goToFirstLevel{
//    gameTime = 60;
    
    [self changeGameLevel];
    [self setBgByGameLevel];
    
//    if (commonUtil.isPurchased) {
        [self saveLevelInfo];
//    }
    
    hp = 3;
    
    [self checkHamsterHp];
    
    for (int i =0; i < [spriteNodes count]; i++) {
        SKSpriteNode * m = [spriteNodes objectAtIndex:i];
        [m removeAllActions];
        [m removeFromParent];
        //        [spriteNodes removeObjectAtIndex:i];
    }
    
    [self removeChildrenInArray:spriteNodes];
    [spriteNodes removeAllObjects];
    
    for (int i =0; i < [spriteNodesExplode count]; i++) {
        SKSpriteNode * m = [spriteNodesExplode objectAtIndex:i];
        [m removeAllActions];
        [m removeFromParent];
        //        [spriteNodes removeObjectAtIndex:i];
    }
    [self removeChildrenInArray:spriteNodesExplode];
    [spriteNodesExplode removeAllObjects];
    
    for (int i =0; i < [spriteNodesTool count]; i++) {
        SKSpriteNode * m = [spriteNodesTool objectAtIndex:i];
        [m removeAllActions];
        [m removeFromParent];
//        [spriteNodesTool removeObjectAtIndex:i];
    }
    [spriteNodesTool removeAllObjects];
    
    for (int i =0; i < [spriteNodesProjectile count]; i++) {
        SKSpriteNode * m = [spriteNodesProjectile objectAtIndex:i];
        [m removeAllActions];
        [m removeFromParent];
        //        [spriteNodesTool removeObjectAtIndex:i];
    }
    [spriteNodesProjectile removeAllObjects];
    
    for (int i =0; i < [spriteNodesFireball count]; i++) {
        SKSpriteNode * m = [spriteNodesFireball objectAtIndex:i];
        [m removeAllActions];
        [m removeFromParent];
        //        [spriteNodesTool removeObjectAtIndex:i];
    }
    [spriteNodesFireball removeAllObjects];
    
    for (int i =0; i < [contactQueue count]; i++) {
        [contactQueue removeAllObjects];
    }
    
//    toolTime = 0;
    
    self.player.position = CGPointMake(playerInitX, playerInitY);
    self.player.texture = hamsterDefaultArray[0];
    [self.cat removeAllActions];
    [self randomCatInitX];
    self.cat.position = CGPointMake(catInitX, catInitY);
    self.controlPoint.position = CGPointMake(barInitX, barInitY);
    
    [self randomCurrentCatTextures];
    
    self.cat.texture = currentCatTextures[0];
    
    shootType = None;
    bulletCount = 1;
    
    self.node.maskNode = nil;
    
    [self resetCount];
    
    for(int i = 0 ; i < timers.count; i++){
        NSTimer * t = timers[i];
        [t invalidate];
    }
    
    if(goToFirstLevel){
        gameTime=0;
        clearedMonster = 0;
        [self setTimeTextures];
        [self setClearedMonsterNodeText];
    }
    
    self.fire.position = self.player.position;
    self.fire.hidden = true;
    isInvinceble = false;
    isInjure = false;
    
    [self checkShowGameHintAndStartGame];
}

-(void)checkShowGameHintAndStartGame{
    bool isShowGameHint = true;
    NSString *hintID = nil;
    
    switch (gameLevel) {
        case ONLY_LEVEL1_HAND_LEVEL:
            hintID = @"GameHint1ViewController";
            
        break;
        case ONLY_LEVEL12_HAND_LEVEL:
            hintID = @"GameHint2ViewController";
            ccountLimit = DEFAULT_COUNT-1;
        break;
        case ONLY_LEVEL123_HAND_LEVEL:
            hintID = @"GameHint3ViewController";
        break;
        case ONLY_LEVEL123_2HAND_LEVEL:
            hintID = @"GameHint4ViewController";
        break;
        case ONLY_LEVEL123_HAND_WITH_TOOL_FASTER_LEVEL:
            hintID = @"GameHint5ViewController";
            ccountLimit = DEFAULT_COUNT-2;
        break;
        case ONLY_LEVEL123_HAND_WITH_TOOL_F_DOUBLE_LEVEL:
            hintID = @"GameHint6ViewController";
        break;
        case ONLY_LEVEL123_HAND_WITH_TOOL_F_D_TRIPLE_LEVEL:
            hintID = @"GameHint7ViewController";
            ccountLimit = DEFAULT_COUNT-3;
        break;
        case ONLY_LEVEL123_HAND_WITH_TOOL_POWER_LEVEL:
            hintID = @"GameHint8ViewController";
            break;
        case ONLY_LEVEL123_HAND_WITH_TOOL_P_HEAL_LEVEL:
            hintID = @"GameHint9ViewController";
            break;
        case ONLY_LEVEL123_RANDOM_HAND_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint10ViewController";
            break;
        case ONLY_LEVEL123_3HAND_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint11ViewController";
            break;
        case ONLY_LEVEL1234_HAND_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint12ViewController";
            ccountLimit = DEFAULT_COUNT-4;
            break;
        case ONLY_LEVEL1234_2HAND_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint13ViewController";
            break;
        case ONLY_LEVEL1234_RANDOM_HAND_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint14ViewController";
            ccountLimit = DEFAULT_COUNT-5;
            break;
        case ONLY_LEVEL123_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint15ViewController";
            break;
        case ONLY_LEVEL1234_HAND_FIREBALL_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint16ViewController";
            break;
        case ONLY_LEVEL1234_RANDOM_HAND_2FIREBALL_WITH_ALL_TOOL_LEVEL:
            hintID = @"GameHint17ViewController";
            ccountLimit = DEFAULT_COUNT-6;
            break;
        default:
            isShowGameHint = false;
        break;
    }
    
    if(isShowGameHint){
        self.showGameHint(hintID);
    }else{
        [self gameStartAfterRestGame];
    }
}

-(void)gameStartAfterGameHintDismiss{
    [self gameStartAfterRestGame];
}

-(void)gameStartAfterRestGame{
    //    gameTime=0;
    [self initGameTimer];
    
    isGameRun = true;
    isMoveAble = true;
}

-(void)changeGameLevel{
    gameLevel++;
    self.gameLevelSingleNode.texture = [self getTimeTexture:(gameLevel+1)%10];
    self.gameLevelTenNode.texture = [self getTimeTexture:(gameLevel+1)/10];
    
    catMaxHp = DEFAULT_HP + gameLevel*catHpIncreasePerLevel;
    catCurrentHp = catMaxHp;
    
    [self changeCatHpBar];
}

-(void)setBgByGameLevel{
    self.backgroundNode.texture = [TextureHelper bgTextures][gameLevel/2];
}

+(void)heal{
    hp++;
}

-(void)changeCatHpBar {
    float hpBarWidth = self.frame.size.width/((float)catMaxHp/catCurrentHp);
    
    self.hpBar.size = CGSizeMake(hpBarWidth, 42);
    
    self.hpBar.anchorPoint = CGPointMake(0.5, 0.5);
    
    float hpBarOffsetX = self.frame.size.width/10 - hpBarWidth/10;
    
    self.hpBar.position = CGPointMake(CGRectGetMinX(self.frame) + hpBarWidth/2 + hpBarOffsetX,
                                 CGRectGetMaxY(self.frame) - self.hpBar.size.height/2 - 45);
}

//- (NSString *)description
//{
//    return [CFStringCreateWithFormat:@"<%@>",@{@"name":@"",@"work":@""}];
//}
//
//- (NSString *)debugDescription
//{
//    return [NSStringstringWithFormat:@"<%@ : %p, %@>",[selfclass],self,@{@"name":_name,@"work":_work}];
//}

//-(void)shake:(NSInteger)times {
//    
//    CGPoint initialPoint = self.position;
//    NSInteger amplitudeX = 32;
//    NSInteger amplitudeY = 2;
//    NSMutableArray * randomActions = [NSMutableArray array];
//    for (int i=0; i<times; i++) {
//        NSInteger randX = self.position.x+arc4random() % amplitudeX - amplitudeX/2;
//        NSInteger randY = self.position.y+arc4random() % amplitudeY - amplitudeY/2;
//        SKAction *action = [SKAction moveTo:CGPointMake(randX, randY) duration:0.01];
//        [randomActions addObject:action];
//    }
//    
//    SKAction *rep = [SKAction sequence:randomActions];
//    
//    for (int i=0; i<self.children.count; i++) {
//        [self.children[i] runAction:rep completion:^{
//            self.position = initialPoint;
//        }];
//    }
//    
//}


//-(void)shake:(NSInteger)times {
//    
//    CGPoint initialPoint = self.position;
//    NSInteger amplitudeX = 32;
//    NSInteger amplitudeY = 2;
//        for (int i=0; i<self.children.count; i++) {
//        
//            NSMutableArray * randomActions = [NSMutableArray array];
//
//        for (int k=0; k<times; k++) {
//        
//        NSInteger randX = [self.children[i] position].x + (k%2?-10:10);
//        NSInteger randY = [self.children[i] position].y;
//        SKAction *action = [SKAction moveTo:CGPointMake(randX, randY) duration:0.2];
//        [randomActions addObject:action];
//        }
//        
//        SKAction *rep = [SKAction sequence:randomActions];
//        [self.children[i] runAction:rep];
//        
//    }
//    
////    SKAction *rep = [SKAction sequence:randomActions];
////    
////    for (int i=0; i<self.children.count; i++) {
////        [self.children[i] runAction:rep completion:^{
//////            self.position = initialPoint;
////        }];
////    }
//    
//}

-(void)randomCatInitX{
    catInitX = arc4random_uniform(self.frame.size.width - self.cat.size.width)+self.cat.size.width/2;
}

-(void)shakeEffect{
    
}

-(void)backToMenu{
//    [self removeFromParent];
    [self.delegate BviewcontrollerDidTapBackToMenuButton];
}

+(void)setAllGameRun:(bool)isrun {
    for (MyScene * scene  in scenes) {
        
        [scene setViewRun:isrun];
        [scene setGameRun:isrun];
    }
}

-(void)setGameRun:(bool)isrun {
//    isGameRun = isrun;
    
    self.pauseBtnNode.hidden = isrun;
}

-(void)setViewRun:(bool)isrun{
    
    
    SKView *v = (SKView *)self.view;
//    if(v.paused == !isrun){
//        return;
//    }
//    
//    v.paused = !isrun;
    
    for (int i = 0; i < [self children].count; i++) {
        SKNode * n = [self children][i];
        n.paused = !isrun;
    }
    
    if (self.pauseBtnNode.hidden == false && !isrun) {
        return;
    }
    
    if(!isrun){
        pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
        for (int i = 0; i < timers.count; i++) {
//            [timers[i] invalidate];
            NSTimer * t = timers[i];
            previousFireDate = [t fireDate];
            [t setFireDate:[NSDate distantFuture]];
        }
    }else{
        float pauseTime = -1*[pauseStart timeIntervalSinceNow];
        for (int i = 0; i < timers.count; i++) {
            NSTimer * t = timers[i];
            [t setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDate]];
        }
    }
}

-(void)displayBuyView{
    self.showBuyViewController();
}

-(void)displayRankView{
    self.showRankViewController();
}

-(void)saveLevelInfo{
    [[NSUserDefaults standardUserDefaults] setInteger:gameLevel forKey:@"currentLevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:gameTime forKey:@"currentGameTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:clearedMonster forKey:@"currentClearBall"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    commonUtil.recordGameLevel = gameLevel;
}

-(void)destroy{
    for(int i = 0 ; i < timers.count; i++){
        NSTimer * t = timers[i];
        [t invalidate];
    }
    
    timers = nil;
}

/*
-(void)saveLevelPartInfo{
    [[NSUserDefaults standardUserDefaults] setInteger:gameTime forKey:@"currentGameTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:gameTime forKey:@"currentClearBall"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
*/
 
@end
