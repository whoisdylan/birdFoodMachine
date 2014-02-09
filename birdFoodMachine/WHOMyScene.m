//
//  WHOMyScene.m
//  birdFoodMachine
//
//  Created by dylan on 2/8/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOMyScene.h"
#import "WHOGameOverScene.h"

@interface WHOMyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode* playerSprite;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int foodDodged;
@end


static const uint32_t playerCat =  0x1 << 0;
static const uint32_t foodCat =  0x1 << 1;

@implementation WHOMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        self.playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.playerSprite.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.playerSprite.size.height-20);
        self.playerSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.playerSprite.size.width/2];
        self.playerSprite.physicsBody.dynamic = YES;
        self.playerSprite.physicsBody.categoryBitMask = playerCat;
        self.playerSprite.physicsBody.contactTestBitMask = foodCat;
        self.playerSprite.physicsBody.collisionBitMask = 0;
        self.playerSprite.physicsBody.usesPreciseCollisionDetection = YES;
        
        [self addChild:self.playerSprite];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
}

- (void)addFood {
    
    // Create sprite
    SKSpriteNode* foodSprite = [SKSpriteNode spriteNodeWithImageNamed:@"monster"];
    foodSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foodSprite.size];
    foodSprite.physicsBody.dynamic = YES;
    foodSprite.physicsBody.categoryBitMask = foodCat;
    foodSprite.physicsBody.contactTestBitMask = playerCat;
    foodSprite.physicsBody.collisionBitMask = 0;
    foodSprite.physicsBody.usesPreciseCollisionDetection = YES;
    
    int numFoodSpawns = self.frame.size.width/foodSprite.size.width - 1;
    int chosenSpawn = ((arc4random() % numFoodSpawns) + 1)*foodSprite.size.width;
    
    // Create the food slightly off-screen along the bottom edge,
    // and along a random position along the x axis as calculated above
    foodSprite.position = CGPointMake(chosenSpawn, foodSprite.size.height/2);
    [self addChild:foodSprite];
    
    // Determine speed of the monster
//    int minDuration = 1.0;
//    int maxDuration = 4.0;
//    int rangeDuration = maxDuration - minDuration;
//    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    int foodDuration = 3.0;
    
    // Create the actions
    SKAction* actionMove = [SKAction moveTo:CGPointMake(chosenSpawn, self.frame.size.height-foodSprite.size.height/2) duration:foodDuration];
    SKAction* actionMoveDone = [SKAction removeFromParent];
//    __weak typeof(self) weakSelf = self;
//    SKAction * loseAction = [SKAction runBlock:^{
//        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//        SKScene * gameOverScene = [[WHOGameOverScene alloc] initWithSize:weakSelf.size won:NO];
//        [weakSelf.view presentScene:gameOverScene transition: reveal];
//    }];
    [foodSprite runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
}

#pragma mark Physics

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    //figure out which body is which category
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if (firstBody.categoryBitMask == playerCat && secondBody.categoryBitMask ==foodCat) {
        [self player:(SKSpriteNode *) firstBody.node didCollideWithFood:(SKSpriteNode *) secondBody.node];
    }
}

- (void)player:(SKSpriteNode *)playerSprite didCollideWithFood:(SKSpriteNode *)foodSprite {
    NSLog(@"Hit");
    [playerSprite removeFromParent];
    [foodSprite removeFromParent];
    SKTransition* reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene* gameOverScene = [[WHOGameOverScene alloc] initWithSize:self.size won:NO];
    UIPanGestureRecognizer* gestureRecognizer = self.view.gestureRecognizers.firstObject;
    [[self view] removeGestureRecognizer:gestureRecognizer];
    [self.view presentScene:gameOverScene transition: reveal];
    
}

#pragma mark Touch Events

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    
    self.playerSprite.position = touchLocation;

//	if (recognizer.state == UIGestureRecognizerStateBegan) {
//        
//    } else if (recognizer.state == UIGestureRecognizerStateChanged) {

//    } else if (recognizer.state == UIGestureRecognizerStateEnded) {

//        }
//        
//    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        self.playerSprite.position = location;
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addFood];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

@end
