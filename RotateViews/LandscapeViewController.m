//
//  LandscapeViewController.m
//  RotateViews
//
//  Created by Dave Rogers on 6/29/15.
//  Copyright (c) 2015 Cemico Inc. All rights reserved.
//

#import "LandscapeViewController.h"

@interface LandscapeViewController ()

@property (nonatomic, strong) IBOutlet UILabel * lblTitle;

@end

@implementation LandscapeViewController

- (void)viewDidLoad
{
    // default handling
    [super viewDidLoad];
}

- (void)updateOrientation
{
    if (self.currentOrientation == UIDeviceOrientationLandscapeLeft)
        _lblTitle.text = @"Landscape Left";
    else
        _lblTitle.text = @"Landscape Right";
}

@end
