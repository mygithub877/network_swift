//
//  ViewController.m
//  Demo-Objc
//
//  Created by wenjie liu on 2020/8/7.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import "ViewController.h"
#import "CategoryViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray <ViewItem *> *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    __weak typeof(self) weakSelf=self;
    ViewItem *item1=[ViewItem itemTitle:@"BKCategoryBar" subtitle:@"category" action:^{
        CategoryViewController *vc=CategoryViewController.alloc.init;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.dataSource=@[item1];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[UITableViewCell.alloc initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=self.dataSource[indexPath.row].title;
    cell.detailTextLabel.text=self.dataSource[indexPath.row].subtitle;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSource[indexPath.row].action) {
        self.dataSource[indexPath.row].action();
    }
}
@end
@implementation ViewItem
+(instancetype)itemTitle:(NSString *)title subtitle:(NSString *)subtitle action:(void(^)(void))action{
    ViewItem *item=ViewItem.alloc.init;
    item.title=title;
    item.subtitle=subtitle;
    item.action=action;
    return item;
}

@end
