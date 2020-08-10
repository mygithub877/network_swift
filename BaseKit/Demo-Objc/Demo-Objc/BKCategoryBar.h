//
//  BKCategoryBar.h
//  Demo-Objc
//
//  Created by wenjie liu on 2020/8/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,BKCategroyBarStyle) {
    BKCategroyBarStyleFit,
    BKCategroyBarStyleFull
};
typedef NS_ENUM(NSUInteger,BKCategroyBarSelectionStyle) {
    BKCategroyBarSelectionStyleLine,
    BKCategroyBarSelectionStyleBackgroundView,
    BKCategroyBarSelectionStyleHumpBackground,
    BKCategroyBarSelectionStyleWithout
};
@class BKCategoryBarItem,BKCategroyBarSelectedView;
@interface BKCategoryBar : UIView
@property (nonatomic, assign) BKCategroyBarStyle barStyle;//布局样式
@property (nonatomic, assign) BKCategroyBarSelectionStyle selectedMaskStyle;//布局样式
@property (nonatomic, assign) NSInteger selectedIndex;//选中索引
@property (nonatomic, assign) CGFloat titleWidthOffset;//default 20
@property (nonatomic, copy) NSArray <BKCategoryBarItem *> *items;//
@property (nonatomic, strong) UIColor *badgeTintColor;//角标背景色
@property (nonatomic, strong) UIColor *humpFillColor;//
@property (nonatomic, strong, readonly) BKCategroyBarSelectedView *selectedMaskView;//

@property (nonatomic, copy) void (^didOnClickBlock)(NSInteger index);
@property (nonatomic, copy) BOOL (^willOnClickBlock)(NSInteger index);

- (void)setFont:(UIFont *)font state:(UIControlState)state index:(NSInteger)index;
- (void)setTitleColor:(UIColor *)color state:(UIControlState)state index:(NSInteger)index;
- (void)setBackgroundColor:(UIColor *)color state:(UIControlState)state index:(NSInteger)index;
- (void)setBackgroundImage:(UIImage *)image state:(UIControlState)state index:(NSInteger)index;

@end



@interface BKCategoryBarItem : NSObject
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *selectedTitle;
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong, nullable) UIImage *selectedImage;
@property (nonatomic, strong, nullable) NSString *badgeText;
@property (nonatomic, strong) NSDictionary<NSNumber *,UIFont *> *fonts;
@property (nonatomic, strong) NSDictionary<NSNumber *,UIColor *> *titleColors;
@property (nonatomic, strong) NSDictionary<NSNumber *,UIColor *> *backgroundColors;
@property (nonatomic, strong) NSDictionary<NSNumber *,UIImage *> *backgroundImages;
-(instancetype)initWithTitle:(nullable NSString *)title selectedTitle:(nullable NSString *)selectedTitle;
-(instancetype)initWithImage:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage;
@end
@class BKCategroyBarBackgroundView;
@interface BKCategroyBarScrollView : UIScrollView
@property (nonatomic, strong, nullable) BKCategroyBarBackgroundView *selectedView;
@end
@interface BKCategroyBarButton : UIButton
@property (nonatomic, strong) BKCategoryBarItem *item;
@property (nonatomic, assign) CGFloat maiginOffset;
@property (nonatomic, strong) UILabel *badgeLabel;
@end
typedef NS_ENUM(NSUInteger, BKCategroyBarSelectedViewStyle) {
    BKCategroyBarSelectedViewStyleInset,
    BKCategroyBarSelectedViewStyleSize,
};
@interface BKCategroyBarSelectedView : UIView <NSCopying>
@property (nonatomic, assign) BKCategroyBarSelectedViewStyle style;
@property (nonatomic, assign) UIEdgeInsets maskInset;
@property (nonatomic, assign) CGSize maskSize;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) BKCategroyBarButton *selectedButton;
// Override
- (void)updateFrame;
@end
@interface BKCategroyBarLine : BKCategroyBarSelectedView

@end
@interface BKCategroyBarBackgroundView : BKCategroyBarSelectedView
@property (nonatomic, strong) UIColor *humpFillColor;
@end
NS_ASSUME_NONNULL_END
