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

- (BOOL)shouldAutorotate
{
    if (self.viewControllers.count == 1) {
        return NO;
    }
    
    return YES;
}

@end
