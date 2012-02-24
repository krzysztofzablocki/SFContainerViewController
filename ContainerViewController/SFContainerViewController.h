//  Created by Krzysztof Zablocki on 8/26/11.
//  Copyright (c) 2011 private. All rights reserved.

#import <UIKit/UIKit.h>

//! Controller used to contain multiple view controllers
@interface SFContainerViewController : UIViewController {
 @private
  NSArray *viewControllers;
}
@property (nonatomic, copy) NSArray *viewControllers;
@end
