//
//  SFLoggingViewController.m
//  SFContainerViewController
//
//  Created by roche on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SFLoggingViewController.h"
#import "SFContainerViewController.h"

@implementation SFLoggingViewController

- (void)loadView
{
  [super loadView];
  self.view.layer.borderWidth = 1;
  self.view.layer.borderColor = [UIColor greenColor].CGColor;


  [self.view addGestureRecognizer:  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  NSLog(@"child view controller %@ just unloaded its view", self);
}

- (void)dismissModal
{
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSLog(@"child view controller %@ appeared, self.parentController is %@ %@", self, self.parentViewController, self.modalViewController);

  //! make sure nested controllers unwind
  if (!self.parentViewController || [self.parentViewController isKindOfClass:[self class]]) {
    [self performSelector:@selector(dismissModal) withObject:nil afterDelay:1];
  }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
  NSLog(@"child view controller will rotate from %d to %d", self.interfaceOrientation, toInterfaceOrientation);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  NSLog(@"child view controller did rotate from %d to %d", fromInterfaceOrientation, self.interfaceOrientation);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
  UIViewController *modalViewController = [[SFLoggingViewController alloc] init];
  [self presentModalViewController:modalViewController animated:NO];
}

@end
