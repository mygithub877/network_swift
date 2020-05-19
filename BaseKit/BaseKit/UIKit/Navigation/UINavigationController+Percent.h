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
//系统内部私有方法，不可改名
- (void)_updateInteractiveTransition:(CGFloat)percent;
@end
@interface UIBarButtonItem (Tint)
@end
NS_ASSUME_NONNULL_END
