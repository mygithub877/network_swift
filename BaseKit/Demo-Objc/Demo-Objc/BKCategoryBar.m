//
//  BKCategoryBar.m
//  Demo-Objc
//
//  Created by wenjie liu on 2020/8/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

#import "BKCategoryBar.h"
#import <Masonry/Masonry.h>
@interface BKCategoryBar ()
@property (nonatomic, copy) NSArray <BKCategroyBarButton *> *buttons;//
@property (nonatomic, strong) BKCategroyBarScrollView *scrollView;//
@end
@implementation BKCategoryBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleWidthOffset=20;
        _badgeTintColor=UIColor.redColor;
        self.scrollView=[[BKCategroyBarScrollView alloc] init];
        self.backgroundColor = UIColor.whiteColor;
        self.scrollView.showsVerticalScrollIndicator=false;
        self.scrollView.showsHorizontalScrollIndicator=false;
        self.scrollView.bounces=false;
        self.scrollView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.equalTo(@0);
        }];
    }
    return self;
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex=selectedIndex;
    [self updateSelectedIndex];
}
-(void)setBarStyle:(BKCategroyBarStyle)barStyle{
    _barStyle=barStyle;
    [self resetItems];
}
-(void)setTitleWidthOffset:(CGFloat)titleWidthOffset{
    _titleWidthOffset=titleWidthOffset;
    [self resetItems];
}
-(void)setItems:(NSArray<BKCategoryBarItem *> *)items{
    _items=items;
    [self resetItems];
    [self resetSelectMaskView];
}
-(void)setSelectedMaskStyle:(BKCategroyBarSelectionStyle)selectedMaskStyle{
    _selectedMaskStyle=selectedMaskStyle;
    [self resetSelectMaskView];
}
- (void)setFont:(UIFont *)font state:(UIControlState)state index:(NSInteger)index{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (index<0) {
        [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *tmp=item.fonts.mutableCopy;
            tmp[@(state)]=font;
            item.fonts=tmp;
            self.buttons[idx].item=item;
        }];
    }else{
        if (self.items.count<=index) {
            return;
        }
        NSMutableDictionary *tmp=self.items[index].fonts.mutableCopy;
        tmp[@(state)]=font;
        self.items[index].fonts=tmp;
        self.buttons[index].item=self.items[index];
    }
}
- (void)setTitleColor:(UIColor *)color state:(UIControlState)state index:(NSInteger)index{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (index<0) {
        [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *tmp=item.titleColors.mutableCopy;
            tmp[@(state)]=color;
            item.titleColors=tmp;
            self.buttons[idx].item=item;
        }];
    }else{
        if (self.items.count<=index) {
            return;
        }
        NSMutableDictionary *tmp=self.items[index].titleColors.mutableCopy;
        tmp[@(state)]=color;
        self.items[index].titleColors=tmp;
        self.buttons[index].item=self.items[index];
    }
}
- (void)setBackgroundColor:(UIColor *)color state:(UIControlState)state index:(NSInteger)index{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (index<0) {
        [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *tmp=item.backgroundColors.mutableCopy;
            tmp[@(state)]=color;
            item.backgroundColors=tmp;
            self.buttons[idx].item=item;
        }];
    }else{
        if (self.items.count<=index) {
            return;
        }
        NSMutableDictionary *tmp=self.items[index].backgroundColors.mutableCopy;
        tmp[@(state)]=color;
        self.items[index].backgroundColors=tmp;
        self.buttons[index].item=self.items[index];
    }
}
- (void)setBackgroundImage:(UIImage *)image state:(UIControlState)state index:(NSInteger)index{
    if (self.items==nil) {
        return;
    }
    if (state==UIControlStateHighlighted) {
        return;
    }
    if (index<0) {
        [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *tmp=item.backgroundImages.mutableCopy;
            tmp[@(state)]=image;
            item.backgroundImages=tmp;
            self.buttons[idx].item=item;
        }];
    }else{
        if (self.items.count<=index) {
            return;
        }
        NSMutableDictionary *tmp=self.items[index].backgroundImages.mutableCopy;
        tmp[@(state)]=image;
        self.items[index].backgroundImages=tmp;
        self.buttons[index].item=self.items[index];
    }
}
- (void)resetItems{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.buttons=nil;
    if (self.items==nil) {
        return;
    }
    [self resetSelectMaskView];
    __block CGFloat totalWidth= 0;
    CGFloat offset=self.titleWidthOffset;
    NSMutableArray *tmp=NSMutableArray.array;
    [self.items enumerateObjectsUsingBlock:^(BKCategoryBarItem * _Nonnull item, NSUInteger index, BOOL * _Nonnull stop) {
        BKCategroyBarButton *btn=[BKCategroyBarButton.alloc init];
        btn.tag=index;
        btn.item=item;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [tmp addObject:btn];
        [btn sizeToFit];
        totalWidth += (btn.frame.size.width+offset);
        if (index == self.selectedIndex){
            btn.selected=true;
            self.selectedMaskView.selectedButton=btn;
        }
    }];
    self.buttons=tmp;
    CGFloat offset_full = 0;
    if (totalWidth<self.frame.size.width) {
        offset_full=(self.frame.size.width-totalWidth)/self.items.count+offset;
    }else{
        CGFloat wset=(totalWidth-self.frame.size.width)/self.items.count;
        offset_full=offset-wset;
    }
    __block BKCategroyBarButton *preBtn=nil;
    [self.buttons enumerateObjectsUsingBlock:^(BKCategroyBarButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.barStyle == BKCategroyBarStyleFit) {
            btn.maiginOffset = offset;
        }else{
            btn.maiginOffset = offset_full;
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.height.equalTo(btn.superview.mas_height);
            if (preBtn == nil){
                make.left.equalTo(@0);
            }else{
                make.left.equalTo(preBtn.mas_right);
            }
        }];
        preBtn=btn;
    }];
    [preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
    }];
}
- (void)resetSelectMaskView{
    [self.selectedMaskView removeFromSuperview];
    self.scrollView.selectedView=nil;
    switch (self.selectedMaskStyle) {
        case BKCategroyBarSelectionStyleLine:{
            _selectedMaskView = BKCategroyBarLine.alloc.init;
        }
            break;
        case BKCategroyBarSelectionStyleBackgroundView:{
            _selectedMaskView = BKCategroyBarBackgroundView.alloc.init;
        }
            break;
        case BKCategroyBarSelectionStyleHumpBackground:{
            BKCategroyBarBackgroundView *v = BKCategroyBarBackgroundView.alloc.init;
            v.humpFillColor = self.humpFillColor;
            self.scrollView.selectedView=v;
            _selectedMaskView = v;
        }
            break;
        default:
            _selectedMaskView = nil;
            break;
    }
    if (self.selectedMaskView != nil) {
        [self.scrollView insertSubview:self.selectedMaskView atIndex:0];
        if (self.buttons.count > self.selectedIndex) {
            self.selectedMaskView.selectedButton=self.buttons[self.selectedIndex];
        }
    }

}
- (void)updateSelectedIndex{
    if (self.buttons.count<=self.selectedIndex) {
        return;
    }
    BKCategroyBarButton *btn = self.buttons[self.selectedIndex];
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
- (void)buttonAction:(BKCategroyBarButton *)sender{
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
- (void)updateSelectButton:(BKCategroyBarButton *)btn{
    btn.selected=true;
    self.selectedMaskView.selectedButton.selected=false;
    self.selectedMaskView.selectedButton=btn;
    [self adjustScrollContentOffset];
    [self.scrollView setNeedsDisplay];
}
@end


@implementation BKCategoryBarItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _fonts=@{@(UIControlStateNormal):[UIFont systemFontOfSize:14],@(UIControlStateSelected):[UIFont systemFontOfSize:14]};
        _titleColors=@{@(UIControlStateNormal):[UIColor blackColor],@(UIControlStateSelected):[UIColor systemBlueColor]};
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle{
    if (self=[super init]) {
        self.title=title;
        self.selectedTitle=selectedTitle;
        _fonts=@{@(UIControlStateNormal):[UIFont systemFontOfSize:14],@(UIControlStateSelected):[UIFont systemFontOfSize:14]};
        _titleColors=@{@(UIControlStateNormal):[UIColor blackColor],@(UIControlStateSelected):[UIColor systemBlueColor]};
    }
    return self;
}
-(instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    if (self=[super init]) {
        self.image=image;
        self.selectedImage=selectedImage;
        _fonts=@{@(UIControlStateNormal):[UIFont systemFontOfSize:14],@(UIControlStateSelected):[UIFont systemFontOfSize:14]};
        _titleColors=@{@(UIControlStateNormal):[UIColor blackColor],@(UIControlStateSelected):[UIColor systemBlueColor]};
    }
    return self;
}

@end
@implementation BKCategroyBarScrollView
-(void)dealloc{
    [_selectedView removeObserver:self forKeyPath:@"frame"];
    _selectedView=nil;
}
-(void)setSelectedView:(BKCategroyBarBackgroundView *)selectedView{
    if (_selectedView) {
        [_selectedView removeObserver:self forKeyPath:@"frame"];
    }
    _selectedView=selectedView;
    [_selectedView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}

@end
@implementation BKCategroyBarButton
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
    self.badgeLabel.text=item.badgeText;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setTitle:item.selectedTitle forState:UIControlStateSelected];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self updateUI];
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
-(CGSize)intrinsicContentSize{
    CGSize size=super.intrinsicContentSize;
    size.width=size.width+self.maiginOffset*2;
    return size;
}
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
    self.backgroundColor=backgroundColor;
}
@end
@implementation BKCategroyBarSelectedView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=UIColor.systemBlueColor;
        _imageView=UIImageView.alloc.init;
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        _imageView.hidden=YES;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(@0);
        }];
        _style=BKCategroyBarSelectedViewStyleInset;
        _maskInset=UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    BKCategroyBarSelectedView *newobjc=[[self.class alloc] init];
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
-(void)setStyle:(BKCategroyBarSelectedViewStyle)style{
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
-(void)setSelectedButton:(BKCategroyBarButton * _Nonnull)selectedButton{
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
    
}
-(void)dealloc{
    [_selectedButton removeObserver:self forKeyPath:@"center"];
}
@end
@implementation BKCategroyBarLine

-(void)updateFrame{
    [super updateFrame];
    CGFloat width=0;
    CGFloat btnWidth=self.selectedButton.frame.size.width;
    CGFloat x=0;
    CGFloat y=0;
    CGFloat height=2;
    switch (self.style) {
        case BKCategroyBarSelectedViewStyleInset:{
            width=btnWidth-self.maskInset.left-self.maskInset.right;
            x=CGRectGetMinX(self.selectedButton.frame)+self.maskInset.left;
            height = height - self.maskInset.bottom - self.maskInset.top;
            if (height < 0){
                height = 0;
            }
            y = self.superview.frame.size.height-height-self.maskInset.bottom;
        }
            break;
        case BKCategroyBarSelectedViewStyleSize:{
            width=self.maskSize.width;
            height=self.maskSize.height;
            x = CGRectGetMinX(self.selectedButton.frame)+btnWidth/2-width/2;
            y = self.superview.frame.size.height-self.maskSize.height;
        }
            break;
        default:
            break;
    }
    self.frame=CGRectMake(x, y, width, height);
}


@end
@implementation BKCategroyBarBackgroundView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style=BKCategroyBarSelectedViewStyleInset;
        self.maskInset=UIEdgeInsetsMake(12.5, 10, 12.5, 10);
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    BKCategroyBarBackgroundView *newobj=[super copyWithZone:zone];
    newobj.humpFillColor=self.humpFillColor;
    return newobj;
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
        case BKCategroyBarSelectedViewStyleInset:{
            width=btnWidth-self.maskInset.left-self.maskInset.right;
            height=btnHeight-self.maskInset.top-self.maskInset.bottom;
            x=CGRectGetMinX(self.selectedButton.frame)+self.maskInset.left;
            y=self.maskInset.top;
        }
            break;
        case BKCategroyBarSelectedViewStyleSize:{
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
    self.frame=CGRectMake(x, y, width, height);
}
@end
