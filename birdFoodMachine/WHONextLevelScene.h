//
//  WHONextLevelScene.h
//  birdFoodMachine
//
//  Created by dylan on 2/11/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WHONextLevelScene : SKScene
-(id)initWithSize:(CGSize)size foodDodged:(NSInteger) foodDodged level:(NSInteger) level;
@property (strong, nonatomic) IBOutlet SKLabelNode* nextLevelLabel;
@end
