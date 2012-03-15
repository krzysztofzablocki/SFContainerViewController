//  Created by Krzysztof Zablocki on 8/26/11.
//  Copyright (c) 2011 private. All rights reserved.

//  ARC Helper
//
//  Version 1.2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325

//  Krzysztof Zabłocki Added AH_BRIDGE(x) to bridge cast to void*

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#define AH_BRIDGE(x) ((__bridge void*)x)
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#define AH_BRIDGE(x) (x)
#endif
#endif

//  Weak reference support

#ifndef AH_WEAK
#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_4_3
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
#if __MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_6
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#endif
#endif

//  ARC Helper ends


#import "SFContainerViewController.h"
#import <objc/runtime.h>

static NSString * const SFContainerViewControllerParentControllerKey = @"SFContainerViewControllerParentControllerKey";

@implementation SFContainerViewController
@synthesize viewControllers;

//! swap methods of UIViewController
+ (void)initialize
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{        
    {   //! navigationViewController
      Method replacingMethod = class_getInstanceMethod([self class], @selector(swappedNavigationController));
      Method replacedMethod = class_getInstanceMethod([UIViewController class], @selector(navigationController));
      class_addMethod([UIViewController class], @selector(sf_originalNavigationController), method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
      class_replaceMethod([UIViewController class], @selector(navigationController), method_getImplementation(replacingMethod), method_getTypeEncoding(replacingMethod));
    }
    
    {   //! parentViewController
      Method replacingMethod = class_getInstanceMethod([self class], @selector(swappedParentViewController));
      Method replacedMethod = class_getInstanceMethod([UIViewController class], @selector(parentViewController));
      class_addMethod([UIViewController class], @selector(sf_originalParentViewController), method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
      class_replaceMethod([UIViewController class], @selector(parentViewController), method_getImplementation(replacingMethod), method_getTypeEncoding(replacingMethod));
    }
    
    {   //! interfaceOrientation
      Method replacingMethod = class_getInstanceMethod([self class], @selector(swappedInterfaceOrientation));
      Method replacedMethod = class_getInstanceMethod([UIViewController class], @selector(interfaceOrientation));
      class_addMethod([UIViewController class], @selector(sf_originalInterfaceOrientation), method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
      class_replaceMethod([UIViewController class], @selector(interfaceOrientation), method_getImplementation(replacingMethod), method_getTypeEncoding(replacingMethod));
    }
  });
}

- (void)dealloc
{
  //! remove association just in case
  [self setViewControllers:nil];
  AH_SUPER_DEALLOC;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  for (UIViewController *viewController in viewControllers) {
    [viewController didReceiveMemoryWarning];
  }
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
  [super viewDidUnload];
  //! if parent unloaded then its time to ask children to unload their views as parent view no longer retains their views
  for (UIViewController *viewController in viewControllers) {
    //! this is the ONLY ok way to make child controllers unload their views if they are not retained in other places
    [viewController didReceiveMemoryWarning];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  for (UIViewController *viewController in viewControllers) {
    [viewController viewWillAppear:animated];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  for (UIViewController *viewController in viewControllers) {
    [viewController viewDidAppear:animated];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  for (UIViewController *viewController in viewControllers) {
    [viewController viewWillDisappear:animated];
  }
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  for (UIViewController *viewController in viewControllers) {
    [viewController viewDidDisappear:animated];
  }
}

#pragma mark - Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  for (UIViewController *viewController in viewControllers) {
    [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
  for (UIViewController *viewController in viewControllers) {
    [viewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
  }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  for (UIViewController *viewController in viewControllers) {
    [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  for (UIViewController *viewController in viewControllers) {
    if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation]) {
      return NO;
    }
  }
  return YES;
}

#pragma mark - Handling children controller
- (void)setViewControllers:(NSArray *)aViewControllers
{
  if (aViewControllers != viewControllers) {
    //! remove association from old view controllers
    for (UIViewController *viewController in viewControllers) {
      objc_setAssociatedObject(viewController, AH_BRIDGE(SFContainerViewControllerParentControllerKey), nil, OBJC_ASSOCIATION_ASSIGN);
    }      
    
    AH_RELEASE(viewControllers);
    viewControllers = [[NSArray arrayWithArray:aViewControllers] retain];
    
    //! add association in new view controllers
    for (UIViewController *viewController in viewControllers) {
      objc_setAssociatedObject(viewController, AH_BRIDGE(SFContainerViewControllerParentControllerKey), self, OBJC_ASSOCIATION_ASSIGN);
    }
  }
}

#pragma mark - UIViewController additional methods
- (UINavigationController*)swappedNavigationController
{
  UIViewController *parentController = objc_getAssociatedObject(self, AH_BRIDGE(SFContainerViewControllerParentControllerKey));
  if (parentController) {
    return parentController.navigationController;
  } else {
    return [self performSelector:@selector(sf_originalNavigationController)];
  }
}

- (UIViewController*)swappedParentViewController
{
  UIViewController *parentController = objc_getAssociatedObject(self, AH_BRIDGE(SFContainerViewControllerParentControllerKey));
  if (parentController) {
    return parentController;
  } else {
    return [self performSelector:@selector(sf_originalParentViewController)];
  }
}

- (UIInterfaceOrientation)swappedInterfaceOrientation
{
  UIViewController *parentController = objc_getAssociatedObject(self, AH_BRIDGE(SFContainerViewControllerParentControllerKey));
  if (parentController) {
    return parentController.interfaceOrientation;
  } else {
    return (UIInterfaceOrientation)[self performSelector:@selector(sf_originalInterfaceOrientation)];
  }
}

@end
