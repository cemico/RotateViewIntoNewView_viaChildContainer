//
//  BaseContainerViewController.m
//  RotateViews
//
//  Created by Dave Rogers on 6/29/15.
//  Copyright (c) 2015 Cemico Inc. All rights reserved.
//

#import "BaseContainerViewController.h"

// private items
@interface BaseContainerViewController()

@end

@implementation BaseContainerViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // default
        _currentOrientation = UIDeviceOrientationLandscapeLeft;
    }

    return self;
}

- (void)viewDidLoad
{
    // default handling
    [super viewDidLoad];

    // initial orientation udpate
    [self updateOrientation];
}

- (void)setCurrentOrientation:(UIDeviceOrientation)orientation
{
    // save new orientation
    _currentOrientation = orientation;

    // view is live, update
    if (self.view)
        [self updateOrientation];
}

- (void)updateOrientation
{
    NSLog(@"Non-destructive, no need to not call - intended for all functionality to be in virtual override");
}

@end
