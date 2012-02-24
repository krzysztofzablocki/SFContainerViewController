//
//  RandomContainerViewController.m
//  SFContainerViewController
//
//  Created by roche on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SFRandomContainerViewController.h"
#import "SFRandomContainerView.h"
#import "SFLoggingViewController.h"

@implementation SFRandomContainerViewController
- (id)init
{
  self = [super init];
  if (self) {
    static int count = 0;
    self.tabBarItem.title = [NSString stringWithFormat:@"Controller%d", ++count];
  }
  return self;
}

- (void)loadView
{
  int columns = arc4random() % 4 + 2;
  int rows = arc4random() % 3 + 3;

  //! just some random child controllers generation
  SFRandomContainerView *containerView = [[[SFRandomContainerView alloc] init] autorelease];
  self.view = containerView;
  containerView.rows = rows;
  containerView.columns = columns;
  
  NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:columns * rows];
  for (int i = 0; i < columns * rows; ++i) {
    SFLoggingViewController *randomController = [[SFLoggingViewController alloc] init];
    randomController.view.backgroundColor = [UIColor colorWithRed:((arc4random() % 255) / 255.0f) green:((arc4random() % 255) / 255.0f) blue:((arc4random() % 255) / 255.0f) alpha:1];
    [containerView addSubview:randomController.view];
    [viewControllers addObject:randomController];
    [randomController release];
  }  
  
  [self setViewControllers:viewControllers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

@end
