//
//  WHOMyScene.m
//  birdFoodMachine
//
//  Created by dylan on 2/8/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOMyScene.h"
#import "WHOGameOverScene.h"
#import "WHONextLevelScene.h"

@interface WHOMyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode* playerSprite;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval randomDriftTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSInteger foodDodgedTotal;
@property (nonatomic) NSInteger foodDodgedThisLevel;
@property (nonatomic) NSInteger level;
@property (nonatomic) bool fingerOnScreen;
@property (nonatomic) CGPoint baseFingerLocation;
@end


static const uint32_t playerCat =  0x1 << 0;
static const uint32_t foodCat =  0x1 << 1;

@implementation WHOMyScene

-(id)initWithSize:(CGSize)size foodDodged:(NSInteger) foodDodged level:(NSInteger) level {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:108.0/255.0 green:172.0/255.0 blue:212.0/255.0 alpha:1];
        
        self.playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"bird"];
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
        
        self.level = level;
        self.foodDodgedTotal = foodDodged;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
    
    //add score label
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Lato"];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.foodDodgedThisLevel];
    self.scoreLabel.fontSize = 16;
    self.scoreLabel.fontColor = [SKColor blackColor];
    self.scoreLabel.position = CGPointMake(self.size.width/12, self.size.height - self.size.height/12);
    [self addChild:self.scoreLabel];
}

- (int)addFoodWithoutPosition:(int) position {
    
    // Create sprite
    SKSpriteNode* foodSprite = [SKSpriteNode spriteNodeWithImageNamed:@"egg"];
    foodSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foodSprite.size];
    foodSprite.physicsBody.dynamic = YES;
    foodSprite.physicsBody.categoryBitMask = foodCat;
    foodSprite.physicsBody.contactTestBitMask = playerCat;
    foodSprite.physicsBody.collisionBitMask = 0;
    foodSprite.physicsBody.usesPreciseCollisionDetection = YES;
    
    int numFoodSpawns = self.frame.size.width/foodSprite.size.width - 1;
    NSInteger chosenSpawn = ((arc4random() % numFoodSpawns) + 1)*foodSprite.size.width;
    while (chosenSpawn == position) {
        chosenSpawn = ((arc4random() % numFoodSpawns) + 1)*foodSprite.size.width;
    }
    
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
    foodDuration -= (self.level/2);
    if (foodDuration < 1) {
        foodDuration = 1;
    }
    
    // Create the actions
    SKAction* actionMove = [SKAction moveTo:CGPointMake(chosenSpawn, self.frame.size.height-foodSprite.size.height/2) duration:foodDuration];
    SKAction* actionMoveDone = [SKAction removeFromParent];
//    __weak typeof(self) weakSelf = self;
//    SKAction * loseAction = [SKAction runBlock:^{
//        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//        SKScene * gameOverScene = [[WHOGameOverScene alloc] initWithSize:weakSelf.size won:NO];
//        [weakSelf.view presentScene:gameOverScene transition: reveal];
//    }];
    SKAction* incrementScore = [SKAction runBlock:^{
        self.foodDodgedThisLevel += 1;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.foodDodgedThisLevel];
        
        //check if it's time to go to the next level
        int foodRequired = 15;
        if (self.level >= 4) {
            foodRequired *= 2;
        }
        if (self.foodDodgedThisLevel >= foodRequired) {
            __weak typeof(self) weakSelf = self;
            self.foodDodgedTotal += self.foodDodgedThisLevel;
            self.level += 1;
            SKTransition* reveal = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            SKScene* gameOverScene = [[WHONextLevelScene alloc] initWithSize:weakSelf.size foodDodged:self.foodDodgedTotal level:self.level];
            UIPanGestureRecognizer* gestureRecognizer = self.view.gestureRecognizers.firstObject;
            [[self view] removeGestureRecognizer:gestureRecognizer];
            [weakSelf.view presentScene:gameOverScene transition: reveal];
        }
        
    }];
    [foodSprite runAction:[SKAction sequence:@[actionMove, incrementScore, actionMoveDone]]];
    return chosenSpawn;
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
    [playerSprite removeFromParent];
    [foodSprite removeFromParent];
    SKTransition* reveal = [SKTransition pushWithDirection:SKTransitionDirectionDown duration:0.5];
    self.foodDodgedTotal += self.foodDodgedThisLevel;
    SKScene* gameOverScene = [[WHOGameOverScene alloc] initWithSize:self.size won:NO finalScore:self.foodDodgedTotal];
    UIPanGestureRecognizer* gestureRecognizer = self.view.gestureRecognizers.firstObject;
    [[self view] removeGestureRecognizer:gestureRecognizer];
    [self.view presentScene:gameOverScene transition: reveal];
    
}

#pragma mark Touch Events

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
//    CGPoint prevTouchLocation = [recognizer previousLocationInView:recognizer.view];
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    CGPoint newPlayerPosition;
    
    //check recognizer state
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.fingerOnScreen = YES;
        self.baseFingerLocation = touchLocation;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.fingerOnScreen = YES;
        newPlayerPosition = CGPointMake(self.playerSprite.position.x-1.5*(self.baseFingerLocation.x-touchLocation.x),self.playerSprite.position.y-1.5*(self.baseFingerLocation.y-touchLocation.y));
        self.baseFingerLocation = touchLocation;
        
        //bounds checking on sprite position so it can't leave screen because that would be cheating!
        if (newPlayerPosition.x < self.playerSprite.size.width/2) {
            newPlayerPosition.x = self.playerSprite.size.width/2;
        }
        else if (newPlayerPosition.x > self.frame.size.width - (self.playerSprite.size.width/2)) {
            newPlayerPosition.x = self.frame.size.width - (self.playerSprite.size.width/2);
        }
        if (newPlayerPosition.y < self.playerSprite.size.height/2) {
            newPlayerPosition.y = self.playerSprite.size.height/2;
        }
        else if (newPlayerPosition.y > self.frame.size.height - (self.playerSprite.size.height/2)) {
            newPlayerPosition.y = self.frame.size.height - (self.playerSprite.size.height/2);
        }
        self.playerSprite.position = newPlayerPosition;
    }
    //if player lifts finger, randomly drift their sprite
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.fingerOnScreen = NO;
    }
    

}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    self.fingerOnScreen = YES;
//    /*
//    for (UITouch* touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        self.playerSprite.position = location;
//    }
//     */
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    self.fingerOnScreen = NO;
//}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.randomDriftTimeInterval += timeSinceLast;
    self.lastSpawnTimeInterval += timeSinceLast;
    
    if (self.randomDriftTimeInterval > .02) {
        self.randomDriftTimeInterval = 0;
        if (!self.fingerOnScreen) {
            CGFloat randomX = (CGFloat) (arc4random()%9)-4;
            CGFloat randomY = (CGFloat) (arc4random()%9)-4;
            CGFloat newX = self.playerSprite.position.x+randomX;
            CGFloat newY = self.playerSprite.position.y+randomY;
            if (newX < self.playerSprite.size.width/2) {
                newX = self.playerSprite.size.width/2;
            }
            else if (newX > self.frame.size.width - (self.playerSprite.size.width/2)) {
                newX = self.frame.size.width - (self.playerSprite.size.width/2);
            }
            if (newY < self.playerSprite.size.height/2) {
                newY = self.playerSprite.size.height/2;
            }
            else if (newY > self.frame.size.height - (self.playerSprite.size.height/2)) {
                newY = self.frame.size.height - (self.playerSprite.size.height/2);
            }
            self.playerSprite.position = CGPointMake(newX, newY);
        }
    }
    
    //go to next level

    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        int usedPosition = [self addFoodWithoutPosition:-1];
        if (self.level >= 4) {
            [self addFoodWithoutPosition:usedPosition];
        }
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
