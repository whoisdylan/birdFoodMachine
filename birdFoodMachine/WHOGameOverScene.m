//
//  WHOGameOverScene.m
//  birdFoodMachine
//
//  Created by dylan on 2/9/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOGameOverScene.h"
#import "WHOMyScene.h"
#import "WHOStartMenuScene.h"

@implementation WHOGameOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won finalScore:(int)score {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:227.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        
        NSString * message;
        if (won) {
            message = @"You Win!";
        } else {
            message = @"You Goofed!";
        }
        
        SKLabelNode *endLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        endLabel.text = message;
        endLabel.fontSize = 40;
        endLabel.fontColor = [SKColor colorWithRed:240.0/255.0 green:217.0/255.0 blue:192.0/255.0 alpha:1.0];
        endLabel.position = CGPointMake(self.size.width/2, self.size.height-self.size.height/3);
        [self addChild:endLabel];
        
        SKLabelNode *finalScoreLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        SKLabelNode *finalScoreLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        SKLabelNode *finalScoreLabel3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        finalScoreLabel1.text = @"You dodged";
        finalScoreLabel2.text = [NSString stringWithFormat:@"%d", score];
        if (score == 1) {
            finalScoreLabel3.text = @"thing";
        }
        else {
            finalScoreLabel3.text = @"things";
//            finalScoreLabel.text = [NSString stringWithFormat:@"You dodged \n %d \n gross things", score];
        }
        finalScoreLabel1.fontSize = 30;
        finalScoreLabel2.fontSize = 30;
        finalScoreLabel3.fontSize = 30;
        finalScoreLabel1.fontColor = [SKColor colorWithRed:240.0/255.0 green:217.0/255.0 blue:192.0/255.0 alpha:1];
        finalScoreLabel2.fontColor = [SKColor colorWithRed:240.0/255.0 green:217.0/255.0 blue:192.0/255.0 alpha:1];
        finalScoreLabel3.fontColor = [SKColor colorWithRed:240.0/255.0 green:217.0/255.0 blue:192.0/255.0 alpha:1];
        finalScoreLabel1.position = CGPointMake(self.size.width/2, self.size.height/3+2*finalScoreLabel1.fontSize);
        finalScoreLabel2.position = CGPointMake(self.size.width/2, self.size.height/3+finalScoreLabel1.fontSize);
        finalScoreLabel3.position = CGPointMake(self.size.width/2, self.size.height/3);
        [self addChild:finalScoreLabel1];
        [self addChild:finalScoreLabel2];
        [self addChild:finalScoreLabel3];
        
//        [self runAction:
//         [SKAction sequence:@[
//                              [SKAction waitForDuration:3.0],
//                              [SKAction runBlock:^{
//             SKTransition *reveal = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:0.5];
//             SKScene* myScene = [[WHOStartMenuScene alloc] initWithSize:self.size];
//             [self.view presentScene:myScene transition: reveal];
//         }]
//                              ]]
//         ];
        
    }
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch* touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
    
    //if screen touched, go to start screen
    SKTransition *reveal = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:0.5];
    SKScene* startScene = [[WHOStartMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:startScene transition: reveal];
}

@end
