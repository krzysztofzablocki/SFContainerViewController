Purpose
--------------

SFContainerViewController is a UIViewController subclass that can have multiple UIViewController children. No memory problems, if this controller is not visible, it will unload its view and all of his children views.
From the children view you can use freely navigationController, parentViewController ( will point to container itself ), interfaceOrientation.

Supported OS & SDK Versions
-----------------------------

* iOS 4.0 (Xcode 4.3, Apple LLVM compiler 3.1)

ARC Compatibility
------------------

Actually version doesn't use ARC, but if you would like it just add an issue on GitHub and I will add it.

Installation
--------------

To use the SFContainerViewController class in an app, just drag the class files (demo files and assets are not needed) into your project.

Just subclass from SFContainerViewController, set viewControllers to your selected controllers and implement loadView so that you can have your own view to layout your controllers.

Properties
--------------

    @property (nonatomic, copy) NSArray *viewControllers;
Children view controllers of this container. 
