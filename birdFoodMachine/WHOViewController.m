//
//  WHOViewController.m
//  birdFoodMachine
//
//  Created by dylan on 2/8/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOViewController.h"
#import "WHOMyScene.h"

@implementation WHOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView* skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene* scene = [WHOMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
