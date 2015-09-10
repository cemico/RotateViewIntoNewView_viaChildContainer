//
//  PortraitViewController.m
//  RotateViews
//
//  Created by Dave Rogers on 6/29/15.
//  Copyright (c) 2015 Cemico Inc. All rights reserved.
//

#import "PortraitViewController.h"

@interface PortraitViewController()

@property (nonatomic, strong) IBOutlet UILabel * lblTitle;

@end

@implementation PortraitViewController

- (void)viewDidLoad
{
    // default handling
    [super viewDidLoad];
}

- (void)updateOrientation
{
    if (self.currentOrientation == UIDeviceOrientationPortrait)
        _lblTitle.text = @"Portrait Up";
    else
        _lblTitle.text = @"Portrait Down";
}

@end
