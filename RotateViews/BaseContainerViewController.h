//
//  BaseContainerViewController.h
//  RotateViews
//
//  Created by Dave Rogers on 6/29/15.
//  Copyright (c) 2015 Cemico Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseContainerViewController : UIViewController

@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

- (void)setCurrentOrientation:(UIDeviceOrientation)orientation;

@end
