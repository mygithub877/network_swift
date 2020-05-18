//
//  UINavigationController+Percent.m
//  BaseKit
//
//  Created by wenjie liu on 2020/5/11.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import "UINavigationController+Percent.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem (Tint)
+(void)load{
    Method originalMethod = class_getInstanceMethod(self, @selector(setTintColor:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(mof_setTintColor:));
    method_exchangeImplementations(originalMethod,swizzledMethod);
}
- (void)mof_setTintColor:(UIColor *)tintColor{
    [self mof_setTintColor:tintColor];
    if ([self.customView isKindOfClass:UIButton.class]) {
        [(UIButton *)self.customView setTitleColor:tintColor forState:UIControlStateNormal];
    }
    
}
@end
