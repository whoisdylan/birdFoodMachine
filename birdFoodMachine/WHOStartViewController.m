//
//  WHOStartViewController.m
//  birdFoodMachine
//
//  Created by dylan on 2/8/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOStartViewController.h"
#import "WHOMyScene.h"
#import "WHOGameViewController.h"

@implementation WHOStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSLog(@"helloa");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

//- (void)viewDidLoad
//{
//    NSLog(@"hellob");
//    [super viewDidLoad];
//
//}

- (BOOL)shouldAutorotate
{
    return NO;
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

- (IBAction)playButton:(UIButton *)sender {
    // Configure the view.
    NSLog(@"PLAY PUSHED");
    
//    WHOGameViewController* gameViewController = [[WHOGameViewController alloc] initWithNibName:@"WHOGameViewController" bundle:nil];
    
    WHOGameViewController* gameViewController = [[WHOGameViewController alloc] initWithNibName:@"WHOGameViewController" bundle:nil];
    [self presentViewController:gameViewController animated:YES completion:nil];
//    gameViewController.view.frame = self.view.frame;

}
@end
