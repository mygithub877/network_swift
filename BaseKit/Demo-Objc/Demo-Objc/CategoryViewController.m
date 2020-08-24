//
//  CategoryViewController.m
//  Demo-Objc
//
//  Created by wenjie liu on 2020/8/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import "CategoryViewController.h"
#import "BKCategoryBar.h"
#import <Masonry/Masonry.h>

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColor.whiteColor;
    self.edgesForExtendedLayout=UIRectEdgeNone;

    // Do any additional setup after loading the view.
    BKCategoryBarItem *item1=[BKCategoryBarItem.alloc initWithTitle:@"标题1" selectedTitle:nil];
    BKCategoryBarItem *item2=[BKCategoryBarItem.alloc initWithTitle:@"普通状态" selectedTitle:@"选中状态"];
    BKCategoryBarItem *item3=[BKCategoryBarItem.alloc initWithTitle:@"这是长标题" selectedTitle:nil];
    BKCategoryBarItem *item4=[BKCategoryBarItem.alloc initWithTitle:@"短" selectedTitle:nil];
    BKCategoryBarItem *item5=[BKCategoryBarItem.alloc initWithTitle:@"喝喝" selectedTitle:nil];
    BKCategoryBar *bar=BKCategoryBar.alloc.init;
    bar.titleWidthOffset=15;
    bar.items=@[item1,item2,item3,item4,item5];
    bar.selectedMaskView.maskInset=UIEdgeInsetsMake(-3, 20, 0, 20);
    bar.backgroundColor=UIColor.systemPinkColor;
    [self.view addSubview:bar];
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@20);
        make.height.equalTo(@40);
        make.right.equalTo(@-10);
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
