//
//  BKCategoryBar.h
//  Demo-Objc
//
//  Created by wenjie liu on 2020/8/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,BKCategoryBarStyle) {
    BKCategoryBarStyleFull,
    BKCategoryBarStyleFit
    
};
typedef NS_ENUM(NSUInteger,BKCategoryBarSelectionStyle) {
    BKCategoryBarSelectionStyleLine,
    BKCategoryBarSelectionStyleBackgroundView,
    BKCategoryBarSelectionStyleHumpBackground,
    BKCategoryBarSelectionStyleNone
};
@class BKCategoryBarItem,BKCategoryBarSelectedView;
@class BKCategoryBarButton;
@interface BKCategoryBar : UIView
@property (nonatomic, assign) BKCategoryBarStyle barStyle;//布局样式
@property (nonatomic, assign) BKCategoryBarSelectionStyle selectedMaskStyle;//布局样式
@property (nonatomic, assign) NSInteger selectedIndex;//选中索引
@property (nonatomic, assign) CGFloat titleWidthOffset;//default 20
@property (nonatomic, copy) NSArray <BKCategoryBarItem *> *items;//
@property (nonatomic, strong) UIColor *badgeTintColor;//角标背景色
@property (nonatomic, strong, readonly) __kindof BKCategoryBarSelectedView *selectedMaskView;//

@property (nonatomic, copy) void (^didOnClickBlock)(NSInteger index);
@property (nonatomic, copy) BOOL (^willOnClickBlock)(NSInteger index);
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;

- (void)setFont:(UIFont *)font state:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color state:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)color state:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image state:(UIControlState)state;
- (void)setBadgeText:(nullable NSString *)badge index:(NSInteger)index;//更新角标
- (void)updateItem:(BKCategoryBarItem *)item index:(NSInteger)index;
- (BKCategoryBarButton *)buttonForIndex:(NSInteger)index;
@end



@interface BKCategoryBarItem : NSObject
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *selectedTitle;
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong, nullable) UIImage *selectedImage;
@property (nonatomic, strong, nullable) NSString *badgeText;

+(instancetype)itemWithTitle:(nullable NSString *)title;

+(instancetype)itemWithTitle:(nullable NSString *)title selectedTitle:(nullable NSString *)selectedTitle;
+(instancetype)itemWithImage:(nullable UIImage *)image;

+(instancetype)itemWithImage:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage;
@end


@interface BKCategoryBarButton : UIButton
@property (nonatomic, strong) BKCategoryBarItem *item;
@property (nonatomic, assign) CGFloat marginOffset;
@property (nonatomic, strong) UILabel *badgeLabel;
@end

typedef NS_ENUM(NSUInteger, BKCategoryBarSelectedViewStyle) {
    BKCategoryBarSelectedViewStyleInset,
    BKCategoryBarSelectedViewStyleSize,
};

@interface BKCategoryBarSelectedView : UIView <NSCopying>
@property (nonatomic, assign) BKCategoryBarSelectedViewStyle style;
@property (nonatomic, assign) UIEdgeInsets maskInset;
@property (nonatomic, assign) CGSize maskSize;
@property (nonatomic, strong) UIImage *image;
// Override
- (void)updateFrame;
@end
@interface BKCategoryBarSelectedLineView : BKCategoryBarSelectedView

@end
@interface BKCategoryBarSelectedBackgroundView : BKCategoryBarSelectedView
@property (nonatomic, strong) UIColor *humpFillColor;

@end
NS_ASSUME_NONNULL_END
