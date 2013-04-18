Purpose
--------------

SFContainerViewController is a UIViewController subclass that can have multiple UIViewController children. No memory problems, if this controller is not visible, it will unload its view and all of his children views.
From the children view you can use freely navigationController, parentViewController ( will point to container itself ), interfaceOrientation.

[Follow me on twitter][1]

Supported OS & SDK Versions
-----------------------------

* iOS 4.0 (Xcode 4.3, Apple LLVM compiler 3.1)

ARC Compatibility
------------------

SFContainerViewController automatically works with both ARC and non-ARC projects through conditional compilation. There is no need to exclude SFContainerViewController files from the ARC validation process, or to convert CCNode+SFGestureRecognizers using the ARC conversion tool.

Installation
--------------

To use the SFContainerViewController class in an app, just drag the class files (demo files and assets are not needed) into your project.

Just subclass from SFContainerViewController, set viewControllers to your selected controllers and implement loadView so that you can have your own view to layout your controllers.

Properties
--------------

    @property (nonatomic, copy) NSArray *viewControllers;
Children view controllers of this container. 

  [1]: http://twitter.com/merowing_
