//
//  ViewController.m
//  RotateViews
//
//  Created by Dave Rogers on 6/26/15.
//  Copyright (c) 2015 Cemico Inc. All rights reserved.
//

#import "ViewController.h"
#import "PortraitViewController.h"
#import "LandscapeViewController.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIView *         viewContainer;
@property (nonatomic, assign) UIDeviceOrientation       orientation;
@property (nonatomic, strong) PortraitViewController *  vcPortrait;
@property (nonatomic, strong) LandscapeViewController * vcLandscape;

@end

@implementation ViewController

- (void)viewDidLoad
{
    // default handling
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // default handling
    [super viewWillAppear:animated];

    // be sure to generate orientation changes
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    // listen in on changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification"  object:nil];

    // default non-typical states
    _orientation = (UIDeviceOrientation)[[UIDevice currentDevice] orientation];
    if (_orientation == UIDeviceOrientationUnknown ||
        _orientation == UIDeviceOrientationFaceUp  ||
        _orientation == UIDeviceOrientationFaceDown )
    {
        _orientation = UIDeviceOrientationPortrait;
    }

    // save "new" orientation
    UIDeviceOrientation newOrientation = _orientation;

    // set "old" / "current" orientation state to the opposite orientation
    if (UIDeviceOrientationIsLandscape(newOrientation))
        _orientation = UIDeviceOrientationPortrait;
    else /* if (UIDeviceOrientationIsPortrait(newOrientation)) */
        _orientation = UIDeviceOrientationLandscapeLeft;

    // set first orientation
    [self syncOrientation:newOrientation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // default handling
    [super viewDidDisappear:animated];

    // stop generating the orientation changes
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    // stop listening
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // reset
    _orientation = UIDeviceOrientationUnknown;
}

- (void)didReceiveMemoryWarning
{
    // free our unused controller
    if (self.childViewControllers.count > 0)
    {
        if (self.childViewControllers[0] == _vcPortrait)
            _vcLandscape = nil;
        else if (self.childViewControllers[0] == _vcLandscape)
            _vcPortrait = nil;
    }
}

-(void)didRotate:(NSNotification *)notification
{
    // notification center callback - get new orientation
    UIDeviceOrientation newOrientation = [[UIDevice currentDevice] orientation];

    // process
    [self syncOrientation:newOrientation];
}

- (void)syncOrientation:(UIDeviceOrientation)newOrientation
{
    // replaced with the prefersStatusBarHidden below
//    [UIApplication sharedApplication].statusBarHidden = YES;

    // skip non-typical states
    if (newOrientation != UIDeviceOrientationUnknown &&
        newOrientation != UIDeviceOrientationFaceUp  &&
        newOrientation != UIDeviceOrientationFaceDown )
    {
        // optimization if not forced
        if (_orientation != newOrientation)
        {
            NSLog(@"Orientation changed");
            BaseContainerViewController * vcNew = nil;

            // track change
            if (UIDeviceOrientationIsLandscape(newOrientation) && UIDeviceOrientationIsPortrait(_orientation))
            {
                NSLog(@"to Landscape");

                // lazy create
                if (!_vcLandscape)
                    _vcLandscape = [self.storyboard instantiateViewControllerWithIdentifier:@"Landscape"];

                // new container
                vcNew = _vcLandscape;
            }
            else if (UIDeviceOrientationIsPortrait(newOrientation) && UIDeviceOrientationIsLandscape(_orientation))
            {
                NSLog(@"to Portrait");

                // lazy create
                if (!_vcPortrait)
                    _vcPortrait  = [self.storyboard instantiateViewControllerWithIdentifier:@"Portrait"];

                // new container
                vcNew = _vcPortrait;
            }

            // init to current orientation
            [vcNew setCurrentOrientation:newOrientation];

            // set new view
            [self setCurrenetView:vcNew];

            // sync background to new view's background for easier transition
            _viewContainer.backgroundColor = vcNew.view.backgroundColor;

            // save new orientation
            _orientation = newOrientation;
        }
    }
}

- (void)setCurrenetView:(BaseContainerViewController *)vcBase
{
    // remove old view and controller
    [self clearCurrentView];

    // order specific
    {
        // (1) - add the new vc as child controller
        [self addChildViewController:vcBase];

        // (2) - adjust to new view to container size
        vcBase.view.frame = _viewContainer.frame;

        // (3) add it to container view, calls willMoveToParentViewController for us
        [_viewContainer addSubview:vcBase.view];

        // (4) notify it that move is done
        [vcBase didMoveToParentViewController:self];

        NSLog(@"New View: %@", NSStringFromCGRect(vcBase.view.frame));
    }
}

- (void)clearCurrentView
{
    // first one is default view
    while (self.childViewControllers.count > 0)
    {
        // should only ever be one
        UIViewController * vc = [self.childViewControllers lastObject];

        // order specific
        {
            // (1) - notify
            [vc willMoveToParentViewController:nil];

            // (2) - remove the view
            [vc.view removeFromSuperview];

            // (3) - remove the controller
            [vc removeFromParentViewController];
        }
    }

    NSAssert(_viewContainer.subviews.count == 0, @"Container still has children");
}

// replaced with the supportedInterfaceOrientations below
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

- (NSUInteger)supportedInterfaceOrientations
{
    // default excludes Portrait Upside Down
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
