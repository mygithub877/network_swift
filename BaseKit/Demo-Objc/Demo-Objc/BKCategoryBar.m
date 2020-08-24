//
//  BKCategoryBar.m
//  Demo-Objc
//
//  Created by wenjie liu on 2020/8/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import "BKCategoryBar.h"
#import <Masonry/Masonry.h>
@interface BKCategoryBarItem()
@property (nonatomic, strong) NSDictionary<NSNumber *,UIFont *> *fonts;
@property (nonatomic, strong) NSDictionary<NSNumber *,UIColor *> *titleColors;
@property (nonatomic, strong) NSDictionary<NSNumber *,UIColor *> *backgroundColors;
@property (nonatomic, strong) NSDictionary<NSNumber *,UIImage *> *backgroundImages;
@end
@interface BKCategoryBarScrollView : UIScrollView
@property (nonatomic, strong, nullable) BKCategoryBarSelectedBackgroundView *selectedView;
@end
@interface BKCategoryBarSelectedView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) BKCategoryBarButton *selectedButton;
@property (nonatomic, strong) UIView *selectedContainerView;
@end
@interface BKCategoryBar ()
@property (nonatomic, copy) NSArray <BKCategoryBarButton *> *buttons;//
@property (nonatomic, strong) BKCategoryBarScrollView *scrollView;//
@property (nonatomic, strong) UIView *selectedContainerView;//

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIFont *> *fonts;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIColor *> *titleColors;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIColor *> *backgroundColors;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIImage *> *backgroundImages;

@end
@implementation BKCategoryBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleWidthOffset=20;
        _badgeTintColor=UIColor.redColor;
        self.scrollView=[[BKCategoryBarScrollView alloc] init];
        self.backgroundColor = UIColor.whiteColor;
        self.scrollView.showsVerticalScrollIndicator=false;
        self.scrollView.showsHorizontalScrollIndicator=false;
        self.scrollView.bounces=false;
        self.scrollView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.equalTo(@0);
        }];
        self.selectedContainerView=UIView.alloc.init;
        _fonts=@{@(UIControlStateNormal):[UIFont systemFontOfSize:14],@(UIControlStateSelected):[UIFont systemFontOfSize:14]}.mutableCopy;
        _titleColors=@{@(UIControlStateNormal):[UIColor colorWithHexString:@"999999"],@(UIControlStateSelected):[UIColor mainThemeColor]}.mutableCopy;

    }
    return self;
}
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titleWidthOffset=20;
        _badgeTintColor=UIColor.redColor;
        self.scrollView=[[BKCategoryBarScrollView alloc] init];
        self.backgroundColor = UIColor.whiteColor;
        self.scrollView.showsVerticalScrollIndicator=false;
        self.scrollView.showsHorizontalScrollIndicator=false;
        self.scrollView.bounces=false;
        self.scrollView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.equalTo(@0);
        }];
        self.selectedContainerView=UIView.alloc.init;
        _fonts=@{@(UIControlStateNormal):[UIFont systemFontOfSize:16],@(UIControlStateSelected):[UIFont systemFontOfSize:16]}.mutableCopy;
        _titleColors=@{@(UIControlStateNormal):[UIColor colorWithHexString:@"999999"],@(UIControlStateSelected):[UIColor mainThemeColor]}.mutableCopy;

        NSMutableArray *items=[NSMutableArray arrayWithCapacity:titles.count];
        [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKCategoryBarItem *item=[BKCategoryBarItem itemWithTitle:obj];
            [items addObject:item];
        }];
        self.items=items;
    }
    return self;
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex=selectedIndex;
    [self updateSelectedIndex];
}
-(void)setBarStyle:(BKCategoryBarStyle)barStyle{
    _barStyle=barStyle;
    [self resetItems];
}
-(void)setTitleWidthOffset:(CGFloat)titleWidthOffset{
    _titleWidthOffset=titleWidthOffset;
    [self resetItems];
}
-(void)setBadgeTintColor:(UIColor *)badgeTintColor{
    _badgeTintColor=badgeTintColor;
    [self.buttons enumerateObjectsUsingBlock:^(BKCategoryBarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.badgeLabel.backgroundColor=badgeTintColor;
    }];
}
-(void)setItems:(NSArray<BKCategoryBarItem *> *)items{
    if (items.count!=_items.count) {
        [items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.fonts=self.fonts.copy;
            obj.titleColors=self.titleColors.copy;
            obj.backgroundColors=self.backgroundColors.copy;
            obj.backgroundImages=self.backgroundImages.copy;
        }];
        _items=items;
        [self resetItems];
        [self setSelectedMaskStyle:self.selectedMaskStyle];
    }else{
        [items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.fonts=_items[idx].fonts.copy;
            obj.titleColors=_items[idx].titleColors.copy;
            obj.backgroundColors=_items[idx].backgroundColors.copy;
            obj.backgroundImages=_items[idx].backgroundImages.copy;
            self.buttons[idx].item=obj;
            [self.buttons[idx] sizeToFit];
        }];
        _items=items;
        [self setNeedsLayout];
    }
}
-(void)setSelectedMaskStyle:(BKCategoryBarSelectionStyle)selectedMaskStyle{
    _selectedMaskStyle=selectedMaskStyle;
    [self resetSelectMaskView];
}
- (void)setFont:(UIFont *)font state:(UIControlState)state{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (self.fonts==nil) {
        self.fonts=NSMutableDictionary.dictionary;
    }
    self.fonts[@(state)]=font;
    [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tmp=item.fonts.mutableCopy;
        if (tmp==nil) {
            tmp=self.fonts.copy;
        }else{
            tmp[@(state)]=font;
        }
        item.fonts=tmp;
        self.buttons[idx].item=item;
        [self.buttons[idx] sizeToFit];
    }];
    [self setNeedsLayout];
}
- (void)setTitleColor:(UIColor *)color state:(UIControlState)state{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (self.titleColors==nil) {
        self.titleColors=NSMutableDictionary.dictionary;
    }
    self.titleColors[@(state)]=color;
    [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tmp=item.titleColors.mutableCopy;
        if (tmp==nil) {
            tmp=self.titleColors.copy;
        }else{
            tmp[@(state)]=color;
        }
        item.titleColors=tmp;
        self.buttons[idx].item=item;
    }];
}
- (void)setBackgroundColor:(UIColor *)color state:(UIControlState)state{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (self.backgroundColors==nil) {
        self.backgroundColors=NSMutableDictionary.dictionary;
    }
    self.backgroundColors[@(state)]=color;
    [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tmp=item.backgroundColors.mutableCopy;
        if (tmp==nil) {
            tmp=self.backgroundColors.copy;
        }else{
            tmp[@(state)]=color;
        }
        item.backgroundColors=tmp.copy;
        self.buttons[idx].item=item;
    }];
    
}
- (void)setBackgroundImage:(UIImage *)image state:(UIControlState)state{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (self.backgroundImages==nil) {
        self.backgroundImages=NSMutableDictionary.dictionary;
    }
    self.backgroundImages[@(state)]=image;
    [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tmp=item.backgroundImages.mutableCopy;
        if (tmp==nil) {
            tmp=self.backgroundImages.copy;
        }else{
            tmp[@(state)]=image;
        }
        item.backgroundImages=tmp;
        self.buttons[idx].item=item;
    }];
}
- (void)setBadgeText:(NSString *)badge index:(NSInteger)index{
    self.items[index].badgeText=badge;
    self.buttons[index].item=self.items[index];
}
- (void)updateItem:(BKCategoryBarItem *)item index:(NSInteger)index{
    BKCategoryBarItem *oldItem=index>=_items.count?nil:_items[index];
    if (oldItem) {
        oldItem.title=item.title;
        oldItem.image=item.image;
        oldItem.badgeText=item.badgeText;
        oldItem.selectedTitle=item.selectedTitle;
        oldItem.selectedImage=item.selectedImage;
        self.buttons[index].item=oldItem;
        [self.buttons[index] sizeToFit];
    }
    [self setNeedsLayout];
}
- (BKCategoryBarButton *)buttonForIndex:(NSInteger)index{
    return self.buttons[index];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    __block CGFloat totalWidth= 0;
    CGFloat offset=self.titleWidthOffset;
    [self.buttons enumerateObjectsUsingBlock:^(BKCategoryBarButton * _Nonnull btn, NSUInteger index, BOOL * _Nonnull stop) {
        totalWidth += (btn.frame.size.width+offset);
    }];
    CGFloat offset_full = 0;
    if (totalWidth<self.frame.size.width) {
        offset_full=ceilf((self.frame.size.width-totalWidth)/self.items.count)+offset;
    }else{
        CGFloat wset=ceilf((totalWidth-self.frame.size.width)/self.items.count);
        offset_full=ceilf(offset-wset);
    }
    __block BKCategoryBarButton *preBtn=nil;
    [self.buttons enumerateObjectsUsingBlock:^(BKCategoryBarButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.barStyle == BKCategoryBarStyleFit) {
            btn.marginOffset = offset;
        }else{
            btn.marginOffset = offset_full;
        }
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.height.equalTo(btn.superview.mas_height);
            if (preBtn == nil){
                make.left.equalTo(@(btn.marginOffset/2));
            }else{
                make.left.equalTo(preBtn.mas_right).offset(btn.marginOffset/2+preBtn.marginOffset/2);
            }
            if (btn==self.buttons.lastObject) {
                make.right.equalTo(@(-btn.marginOffset/2));
            }
        }];
        preBtn=btn;
    }];
}
- (void)resetItems{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.buttons=nil;
    if (self.items==nil) {
        return;
    }
    __block CGFloat totalWidth= 0;
    CGFloat offset=self.titleWidthOffset;
    NSMutableArray *tmp=NSMutableArray.array;
    [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
        BKCategoryBarButton *btn=[BKCategoryBarButton.alloc init];
        btn.tag=index;
        btn.item=item;
        btn.badgeLabel.backgroundColor=self.badgeTintColor;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [tmp addObject:btn];
        if (index == self.selectedIndex){
            btn.selected=true;
            self.selectedContainerView.backgroundColor=self.backgroundColors[@(UIControlStateSelected)];
            self.selectedMaskView.selectedButton=btn;
        }
        [btn sizeToFit];
        totalWidth += (btn.frame.size.width+offset);
    }];
    self.buttons=tmp;
    CGFloat offset_full = 0;
    if (totalWidth<self.frame.size.width) {
        offset_full=ceilf((self.frame.size.width-totalWidth)/self.items.count)+offset;
    }else{
        CGFloat wset=ceilf((totalWidth-self.frame.size.width)/self.items.count);
        offset_full=ceilf(offset-wset);
    }
    __block BKCategoryBarButton *preBtn=nil;
    [self.buttons enumerateObjectsUsingBlock:^(BKCategoryBarButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.barStyle == BKCategoryBarStyleFit) {
            btn.marginOffset = offset;
        }else{
            btn.marginOffset = offset_full;
        }
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.height.equalTo(btn.superview.mas_height);
            if (preBtn == nil){
                make.left.equalTo(@(btn.marginOffset/2));
            }else{
                make.left.equalTo(preBtn.mas_right).offset(btn.marginOffset/2+preBtn.marginOffset/2);
            }
            if (btn==self.buttons.lastObject) {
                make.right.equalTo(@(-btn.marginOffset/2));
            }
        }];
        preBtn=btn;
    }];
    [self setSelectedMaskStyle:self.selectedMaskStyle];
}
- (void)resetSelectMaskView{
    [self.selectedMaskView removeFromSuperview];
    [self.selectedContainerView removeFromSuperview];
    self.scrollView.selectedView=nil;
    BOOL ishidden=_selectedMaskView.hidden;
    switch (self.selectedMaskStyle) {
        case BKCategoryBarSelectionStyleLine:{
            BKCategoryBarSelectedLineView *newView=BKCategoryBarSelectedLineView.alloc.init;
            if (_selectedMaskView) {
                newView.style=_selectedMaskView.style;
                newView.image = _selectedMaskView.image;
                newView.style = _selectedMaskView.style;
                newView.maskInset = _selectedMaskView.maskInset;
                newView.maskSize = _selectedMaskView.maskSize;
                newView.backgroundColor = _selectedMaskView.backgroundColor;
            }
            _selectedMaskView = newView;
        }
            break;
        case BKCategoryBarSelectionStyleBackgroundView:{
            BKCategoryBarSelectedBackgroundView *newView = BKCategoryBarSelectedBackgroundView.alloc.init;
            if (_selectedMaskView) {
                newView.style=_selectedMaskView.style;
                newView.image = _selectedMaskView.image;
                newView.style = _selectedMaskView.style;
                newView.maskInset = _selectedMaskView.maskInset;
                newView.maskSize = _selectedMaskView.maskSize;
                newView.backgroundColor = _selectedMaskView.backgroundColor;
            }
            _selectedMaskView = newView;
        }
            break;
        case BKCategoryBarSelectionStyleHumpBackground:{
            BKCategoryBarSelectedBackgroundView *newView = BKCategoryBarSelectedBackgroundView.alloc.init;
            if (_selectedMaskView) {
                newView.style=_selectedMaskView.style;
                newView.image = _selectedMaskView.image;
                newView.style = _selectedMaskView.style;
                newView.maskInset = _selectedMaskView.maskInset;
                newView.maskSize = _selectedMaskView.maskSize;
                if ([_selectedMaskView isKindOfClass:BKCategoryBarSelectedBackgroundView.class]) {
                    newView.humpFillColor=((BKCategoryBarSelectedBackgroundView *)_selectedMaskView).humpFillColor;
                }
                newView.backgroundColor = _selectedMaskView.backgroundColor;
            }
            self.scrollView.selectedView=newView;
            _selectedMaskView = newView;
        }
            break;
        default:
            _selectedMaskView = nil;
            break;
    }
    if (self.selectedMaskView != nil) {
        _selectedMaskView.hidden=ishidden;
        [self.scrollView insertSubview:self.selectedMaskView atIndex:0];
        [self.scrollView insertSubview:self.selectedContainerView atIndex:0];
        self.selectedMaskView.selectedContainerView=self.selectedContainerView;
        if (self.buttons.count > self.selectedIndex) {
            self.selectedMaskView.selectedButton=self.buttons[self.selectedIndex];
        }
    }

}
- (void)updateSelectedIndex{
    if (self.buttons.count<=self.selectedIndex) {
        return;
    }
    BKCategoryBarButton *btn = self.buttons[self.selectedIndex];
    if (btn.selected) {
        return;
    }
    [self updateSelectButton:btn];
}
- (void)adjustScrollContentOffset{
    CGPoint oldOffset=self.scrollView.contentOffset;
    CGFloat selectedCenter = (self.selectedMaskView.selectedButton.center.x) - oldOffset.x;
    oldOffset.x =  oldOffset.x+(selectedCenter-self.scrollView.frame.size.width/2);
    if ((oldOffset.x+self.scrollView.frame.size.width)>self.scrollView.contentSize.width){
        oldOffset.x = self.scrollView.contentSize.width-self.scrollView.frame.size.width;
    }
    if (oldOffset.x<0) {
        oldOffset.x=0;
    }
    [self.scrollView  setContentOffset:oldOffset animated:YES];
}
- (void)buttonAction:(BKCategoryBarButton *)sender{
    if (sender.selected) {
        return;
    }
    if (self.willOnClickBlock) {
        BOOL rs = self.willOnClickBlock(sender.tag);
        if (rs==YES) {
            self.selectedIndex=sender.tag;
            if (self.didOnClickBlock) {
                self.didOnClickBlock(sender.tag);
            }
        }
    }else{
        self.selectedIndex=sender.tag;
        if (self.didOnClickBlock) {
            self.didOnClickBlock(sender.tag);
        }
    }
}
- (void)updateSelectButton:(BKCategoryBarButton *)btn{
    btn.selected=true;
    self.selectedMaskView.selectedButton.selected=false;
    self.selectedMaskView.selectedButton=btn;
    [self adjustScrollContentOffset];
//    [self.scrollView setNeedsDisplay];
}
@end

@implementation BKCategoryBarItem
- (instancetype)init
{
    self = [super init];
    if (self) {
//        _fonts=@{@(UIControlStateNormal):[UIFont systemFontOfSize:14],@(UIControlStateSelected):[UIFont systemFontOfSize:14]};
//        _titleColors=@{@(UIControlStateNormal):[UIColor blackColor],@(UIControlStateSelected):[UIColor systemBlueColor]};
    }
    return self;
}
+(instancetype)itemWithTitle:(nullable NSString *)title{
    return [self itemWithTitle:title selectedTitle:nil];
}
+(instancetype)itemWithTitle:(nullable NSString *)title selectedTitle:(nullable NSString *)selectedTitle{
    BKCategoryBarItem *item=BKCategoryBarItem.alloc.init;
    item.title=title;
    item.selectedTitle=selectedTitle;
    return item;
}
+(instancetype)itemWithImage:(nullable UIImage *)image{
    return [self itemWithImage:image selectedImage:nil];
}

+(instancetype)itemWithImage:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage{
    BKCategoryBarItem *item=BKCategoryBarItem.alloc.init;
    item.image=image;
    item.selectedImage=selectedImage;
    return item;

}


@end
@implementation BKCategoryBarScrollView
-(void)dealloc{
    [_selectedView removeObserver:self forKeyPath:@"frame"];
    [_selectedView removeObserver:self forKeyPath:@"humpFillColor"];
    _selectedView=nil;
}

-(void)setSelectedView:(BKCategoryBarSelectedBackgroundView *)selectedView{
    if (_selectedView) {
        [_selectedView removeObserver:self forKeyPath:@"frame"];
        [_selectedView removeObserver:self forKeyPath:@"humpFillColor"];
    }
    _selectedView=selectedView;
    [_selectedView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_selectedView addObserver:self forKeyPath:@"humpFillColor" options:NSKeyValueObservingOptionNew context:NULL];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}

@end
@implementation BKCategoryBarButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.badgeLabel];
    }
    return self;
}
-(void)setItem:(BKCategoryBarItem *)item{
    _item=item;
    self.badgeLabel.hidden=(item.badgeText==nil);
    self.badgeLabel.text=item.badgeText;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setTitle:item.selectedTitle forState:UIControlStateSelected];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self updateUI];
}
-(void)setMarginOffset:(CGFloat)marginOffset{
    _marginOffset=marginOffset;
    [self sizeToFit];
}
-(UILabel *)badgeLabel{
    if (_badgeLabel==nil) {
        UILabel *label = UILabel.alloc.init;
        label.backgroundColor = UIColor.redColor;
        label.font=[UIFont systemFontOfSize:10];
        label.textColor = UIColor.whiteColor;
        label.clipsToBounds=true;
        label.textAlignment = NSTextAlignmentCenter;
        label.hidden = true;
        _badgeLabel=label;
    }
    return _badgeLabel;
}
//-(CGSize)intrinsicContentSize{
//    CGSize size=super.intrinsicContentSize;
//    size.width=size.width+self.marginOffset*2;
//    return size;
//}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self updateUI];
}
-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self updateUI];
}
-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self updateUI];
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self updateUI];
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect=[super imageRectForContentRect:contentRect];
    if (self.currentTitle.length>0) {
        rect.origin.x -= 2.5;
    }
    return rect;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect=[super titleRectForContentRect:contentRect];
    if (self.currentImage) {
        rect.origin.x += 2.5;
    }
    return rect;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize badgeSize=[self unReadLabelSize];
    if (self.titleLabel.text.length==0 && self.imageView.image!=nil) {
        self.badgeLabel.frame=CGRectMake(CGRectGetMaxX(self.imageView.frame), CGRectGetMinY(self.imageView.frame)-badgeSize.height/2, badgeSize.width, badgeSize.height);
    }else{
        self.badgeLabel.frame=CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame)-badgeSize.height/2, badgeSize.width, badgeSize.height);
    }
    self.badgeLabel.layer.cornerRadius = badgeSize.height/2;
}
- (CGSize)unReadLabelSize{
    [self.badgeLabel sizeToFit];
    CGSize size=self.badgeLabel.frame.size;
    CGFloat maxHeight=15.0;
    CGFloat minWidth=maxHeight;
    CGFloat width=size.width+8.0;
    if (width<minWidth) {
        width=minWidth;
    }
    return CGSizeMake(width, maxHeight);
}
- (void)updateUI{
    [self.item.titleColors enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        UIControlState state=key.intValue;
        [self setTitleColor:obj forState:state];
    }];
    [self.item.backgroundImages enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        UIControlState state=key.intValue;
        [self setBackgroundImage:obj forState:state];
    }];
    UIFont *font=self.item.fonts[@(self.state)];
    if (font==nil) {
        font=self.item.fonts[@(UIControlStateNormal)];
    }
    self.titleLabel.font=font;
    UIColor *backgroundColor=self.item.backgroundColors[@(self.state)];
    if (backgroundColor) {
        BKCategoryBar *ssp=self.superview.superview;
        ssp.selectedContainerView.backgroundColor=backgroundColor;
    }
}
@end
@implementation BKCategoryBarSelectedView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor mainThemeColor];
        _imageView=UIImageView.alloc.init;
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        _imageView.hidden=YES;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(@0);
        }];
        _style=BKCategoryBarSelectedViewStyleInset;
        _maskInset=UIEdgeInsetsMake(0, 8, 0, 8);
        _maskSize=CGSizeMake(15, 3);
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    BKCategoryBarSelectedView *newobjc=[[self.class alloc] init];
    newobjc.image = self.image;
    newobjc.style = self.style;
    newobjc.maskInset = self.maskInset;
    newobjc.maskSize = self.maskSize;
    newobjc.selectedButton = self.selectedButton;
    newobjc.backgroundColor = self.backgroundColor;
    return newobjc;
}
-(void)setImage:(UIImage *)image{
    _image=image;
    _imageView.image=image;
    _imageView.hidden=(image==nil);
}
-(void)setStyle:(BKCategoryBarSelectedViewStyle)style{
    _style=style;
    [self updateFrame];
}
-(void)setMaskInset:(UIEdgeInsets)maskInset{
    _maskInset=maskInset;
    [self updateFrame];
}
-(void)setMaskSize:(CGSize)maskSize{
    _maskSize=maskSize;
    [self updateFrame];
}
-(void)setSelectedButton:(BKCategoryBarButton * _Nonnull)selectedButton{
    if (_selectedButton) {
        [_selectedButton removeObserver:self forKeyPath:@"center"];
    }
    _selectedButton=selectedButton;
    [_selectedButton addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:NULL];
    [self updateFrame];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"cornerRadius"]) {
        _imageView.layer.cornerRadius = self.layer.cornerRadius;
    }else{
        [self updateFrame];
    }
}
- (void)updateFrame{
    self.selectedContainerView.frame=CGRectMake(self.selectedButton.frame.origin.x-self.selectedButton.marginOffset/2, self.selectedButton.frame.origin.y, self.selectedButton.frame.size.width+self.selectedButton.marginOffset, self.selectedButton.frame.size.height);
}
-(void)dealloc{
    [_selectedButton removeObserver:self forKeyPath:@"center"];
}
@end
@implementation BKCategoryBarSelectedLineView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius=1.5;
        
    }
    return self;
}
-(void)updateFrame{
    [super updateFrame];
    CGFloat width=0;
    CGFloat btnWidth=self.selectedButton.frame.size.width;
    CGFloat x=0;
    CGFloat y=0;
    CGFloat height=3;
    switch (self.style) {
        case BKCategoryBarSelectedViewStyleInset:{
            width=btnWidth-self.maskInset.left-self.maskInset.right;
            x=CGRectGetMinX(self.selectedButton.frame)+self.maskInset.left;
            height = height - self.maskInset.bottom - self.maskInset.top;
            if (height < 0){
                height = 0;
            }
            y = self.superview.frame.size.height-height-self.maskInset.bottom;
        }
            break;
        case BKCategoryBarSelectedViewStyleSize:{
            width=self.maskSize.width;
            height=self.maskSize.height;
            x = CGRectGetMinX(self.selectedButton.frame)+btnWidth/2-width/2;
            y = self.superview.frame.size.height-self.maskSize.height;
        }
            break;
        default:
            break;
    }
    x=ceilf(x);y=ceilf(y);
    if (self.frame.origin.y==y) {
        [UIView animateWithDuration:0.15 animations:^{
            self.frame=CGRectMake(x, y, width, height);
        }];
    }else{
        self.frame=CGRectMake(x, y, width, height);
    }
}


@end
@implementation BKCategoryBarSelectedBackgroundView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style=BKCategoryBarSelectedViewStyleInset;
        self.maskInset=UIEdgeInsetsMake(12.5, 10, 12.5, 10);
        _humpFillColor=UIColor.whiteColor;
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    BKCategoryBarSelectedBackgroundView *newobj=[super copyWithZone:zone];
    newobj.humpFillColor=self.humpFillColor;
    return newobj;
}
-(void)setHumpFillColor:(UIColor *)humpFillColor{
    _humpFillColor=humpFillColor;
    
}
-(void)updateFrame{
    [super updateFrame];
    CGFloat width=0;
    CGFloat btnWidth=self.selectedButton.frame.size.width;
    CGFloat btnHeight=self.selectedButton.frame.size.height;
    CGFloat x=0;
    CGFloat y=0;
    CGFloat height=0;
    switch (self.style) {
        case BKCategoryBarSelectedViewStyleInset:{
            width=btnWidth-self.maskInset.left-self.maskInset.right;
            height=btnHeight-self.maskInset.top-self.maskInset.bottom;
            x=CGRectGetMinX(self.selectedButton.frame)+self.maskInset.left;
            y=self.maskInset.top;
        }
            break;
        case BKCategoryBarSelectedViewStyleSize:{
            width=self.maskSize.width;
            height=self.maskSize.height;
            x = CGRectGetMinX(self.selectedButton.frame)+btnWidth/2-width/2;
            y = btnHeight/2-self.maskSize.height/2;
        }
            break;
        default:
            break;
    }
    self.layer.cornerRadius = height/2;
    x=ceilf(x);y=ceilf(y);
    if (self.frame.origin.y==y) {
        [UIView animateWithDuration:0.15 animations:^{
            self.frame=CGRectMake(x, y, width, height);
        }];
    }else{
        self.frame=CGRectMake(x, y, width, height);
    }
}
@end
