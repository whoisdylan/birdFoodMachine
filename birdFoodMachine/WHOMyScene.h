//
//  WHOMyScene.h
//  birdFoodMachine
//

//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WHOMyScene : SKScene
-(id)initWithSize:(CGSize)size foodDodged:(NSInteger) foodDodged level:(NSInteger) level;
@property (strong, nonatomic) IBOutlet SKLabelNode* scoreLabel;

@end
