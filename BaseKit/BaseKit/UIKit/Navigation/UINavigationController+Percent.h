//
//  UINavigationController+Percent.h
//  BaseKit
//
//  Created by wenjie liu on 2020/5/9.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Percent)
- (void)_updateInteractiveTransition:(CGFloat)percent;
@end

NS_ASSUME_NONNULL_END
