//
//  WHONextLevelScene.m
//  birdFoodMachine
//
//  Created by dylan on 2/11/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHONextLevelScene.h"
#import "WHOMyScene.h"

@interface WHONextLevelScene()
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger foodDodged;
@end

@implementation WHONextLevelScene

- (id) initWithSize:(CGSize)size foodDodged:(NSInteger) foodDodged level:(NSInteger) level {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:108.0/255.0 green:172.0/255.0 blue:212.0/255.0 alpha:1];
        SKLabelNode* nextLevelLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        nextLevelLabel.text = [NSString stringWithFormat:@"LEVEL %ld", (long)level];
        nextLevelLabel.fontSize = 40;
        nextLevelLabel.fontColor = [SKColor colorWithRed:240.0/255.0 green:217.0/255.0 blue:192.0/255.0 alpha:1];
        nextLevelLabel.position = CGPointMake(self.size.width/2, self.size.height-self.size.height/3);
        [self addChild:nextLevelLabel];
        self.level = level;
        self.foodDodged = foodDodged;
    }
    return self;
}

- (void) didMoveToView:(SKView *)view {
    __weak typeof(self) weakSelf = self;
    [weakSelf runAction:
     [SKAction sequence:@[
                          [SKAction waitForDuration:2.0],
                          [SKAction runBlock:^{
         SKTransition* reveal = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
         SKScene* myScene = [[WHOMyScene alloc] initWithSize:weakSelf.size foodDodged:self.foodDodged level:(self.level)];
         [weakSelf.view presentScene:myScene transition: reveal];
     }]
                          ]]
     ];
    
}

@end
