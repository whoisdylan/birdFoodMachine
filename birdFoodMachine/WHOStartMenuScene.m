//
//  WHOStartMenuScene.m
//  birdFoodMachine
//
//  Created by dylan on 2/11/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOStartMenuScene.h"
#import "WHOMyScene.h"

@implementation WHOStartMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:20.0/255.0 green:184.0/255.0 blue:99.0/255.0 alpha:1];
        
        //create title label
        self.titleLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.titleLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.titleLabel1.text =  @"Bird Game";
        self.titleLabel2.text = @"Machine";
        self.titleLabel1.fontSize = 44;
        self.titleLabel2.fontSize = 44;
        self.titleLabel1.fontColor = [SKColor colorWithRed:240.0/255.0 green:217.0/255.0 blue:192.0/255.0 alpha:1];
        self.titleLabel2.fontColor = [SKColor colorWithRed:240.0/255.0 green:217.0/255.0 blue:192.0/255.0 alpha:1];
        self.titleLabel1.position = CGPointMake(self.size.width/2, 2*self.size.height/3+self.titleLabel1.fontSize);
        self.titleLabel2.position = CGPointMake(self.size.width/2, 2*self.size.height/3);
        [self addChild:self.titleLabel1];
        [self addChild:self.titleLabel2];
        
        //create play button
        self.playButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.playButton.text = @"Play!";
        self.playButton.fontSize = 36;
        self.playButton.fontColor = [SKColor colorWithRed:102.0/255.0 green:90.0/255.0 blue:204.0/255.0 alpha:.95];
        self.playButton.position = CGPointMake(self.size.width/2, self.size.height/3);
        self.playButton.name = @"playButton";
        [self addChild:self.playButton];
        
    }
    return self;
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:location];

    //check if playButton node was touched
    if ([touchedNode.name isEqualToString:@"playButton"]) {
        SKTransition *reveal = [SKTransition fadeWithColor:[SKColor colorWithRed:108.0/255.0 green:172.0/255.0 blue:212.0/255.0 alpha:1] duration:1.0];
        SKScene* myScene = [[WHOMyScene alloc] initWithSize:self.size];
        [self.view presentScene:myScene transition: reveal];
    }
}
@end
