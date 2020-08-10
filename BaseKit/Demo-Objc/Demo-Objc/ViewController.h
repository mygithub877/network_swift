//
//  ViewController.h
//  Demo-Objc
//
//  Created by wenjie liu on 2020/8/7.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, assign) NSInteger index;
@end

@interface ViewItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, copy) void (^action)(void);
+(instancetype)itemTitle:(NSString *)title subtitle:(NSString *)subtitle action:(void(^)(void))action;
@end
