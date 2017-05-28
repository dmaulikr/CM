//
//  CLMNavigationController.m
//  Colour Memory
//
//  Created by Michael Zhai on 28/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMNavigationController.h"

@interface CLMNavigationController ()

@end

@implementation CLMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// these method could be overrided in sub viewControllers
-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
