//
//  WHOGameViewController.m
//  birdFoodMachine
//
//  Created by dylan on 2/10/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOGameViewController.h"
#import "WHOMyScene.h"

@interface WHOGameViewController ()

@end

@implementation WHOGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    SKView* skView = [[SKView alloc] initWithFrame: gameViewController.view.frame];
//    SKView* skView = [(SKView *) [WHOGameViewController alloc] init];
    SKView* skView = (SKView* ) self.view;
    //    skView.showsFPS = YES;
    //    skView.showsNodeCount = YES;
    
    
    // Create and configure the scene.
    SKScene* scene = [WHOMyScene sceneWithSize:skView.bounds.size];
    //    SKScene* scene = [[WHOMyScene alloc] initWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    
    
    //    SKTransition* reveal = [SKTransition pushWithDirection:SKTransitionDirectionDown duration:0.5];
    //    [skView presentScene:scene transition: reveal];
    
    [skView presentScene:scene];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
