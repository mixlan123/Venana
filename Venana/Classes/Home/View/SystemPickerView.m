//
//  SystemPickerView.m
//  panpo
//
//  Created by 兰轩轩 on 15/6/4.
//  Copyright (c) 2015年 Eastblue. All rights reserved.
//

#define kMainColor [UIColor colorWithRed:73/255.0 green:184/255.0 blue:224/255.0 alpha:1.0]

#import "SystemPickerView.h"
#import "UIView+Extension.h"

@interface SystemPickerView ()

/**
 *  二、八、十、十六进制按钮
 */
@property (nonatomic, weak) UIButton *bSystemButton;
@property (nonatomic, weak) UIButton *qSystemButton;
@property (nonatomic, weak) UIButton *dSystemButton;
@property (nonatomic, weak) UIButton *hSystemButton;

/**
 *  选中背景
 */
@property (nonatomic, weak) UIView *selectedBgView;

@property (nonatomic, strong) UIButton *lastSelectedButton;

@end

@implementation SystemPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupControls];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupControls];
    }
    return self;
}

- (void)setupControls{
    //生成背景
    [self insertSelectedBgView];
    //生成进制按钮
    self.bSystemButton = [self insertButtonWithTitle:@"B"];
    self.bSystemButton.tag = SystemPickerViewSystemNameB;
    self.qSystemButton = [self insertButtonWithTitle:@"Q"];
    self.qSystemButton.tag = SystemPickerViewSystemNameQ;
    self.dSystemButton = [self insertButtonWithTitle:@"D"];
    self.dSystemButton.tag = SystemPickerViewSystemNameD;
    self.hSystemButton = [self insertButtonWithTitle:@"H"];
    self.hSystemButton.tag = SystemPickerViewSystemNameH;
}
- (UIButton *)insertButtonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(systemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}
- (void)insertSelectedBgView{
    CGFloat wah = 40;
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.size = CGSizeMake(wah, wah);
    bgView.layer.cornerRadius = wah / 2;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    self.selectedBgView = bgView;
}

- (void)systemButtonClick:(UIButton *)button{
    self.selectSystemName = (SystemPickerViewSystemName)button.tag;
    [self.lastSelectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:kMainColor forState:UIControlStateNormal];
    
    //通知代理
    if([self.delegate respondsToSelector:@selector(systemPickerView:didSelectSystemFrom:to:)]){
        [self.delegate systemPickerView:self didSelectSystemFrom:(SystemPickerViewSystemName)self.lastSelectedButton.tag to:(SystemPickerViewSystemName)button.tag];
    }

    self.lastSelectedButton = button;
    [UIView animateWithDuration:0.25 animations:^{
       self.selectedBgView.center = button.center;
    }];
}

- (void)setDelegate:(id<SystemPickerViewDelegate>)delegate{
    _delegate = delegate;
    [self systemButtonClick:self.bSystemButton];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat paddingLaR = 50;
    CGFloat buttonH = 30;
    CGFloat buttonW = 50;
    CGFloat buttonY = (self.height - buttonH) / 2;
    
    CGFloat perSpace = ((self.width - 2 * paddingLaR) - 4 * buttonW) / 3;
    
    //1
    CGFloat bX = paddingLaR;
    self.bSystemButton.frame = CGRectMake(bX, buttonY, buttonW, buttonH);
    
    //2
    CGFloat qX = CGRectGetMaxX(self.bSystemButton.frame) + perSpace;
    self.qSystemButton.frame = CGRectMake(qX, buttonY, buttonW, buttonH);
    
    //3
    CGFloat dX = CGRectGetMaxX(self.qSystemButton.frame) + perSpace;
    self.dSystemButton.frame = CGRectMake(dX, buttonY, buttonW, buttonH);
    
    //4
    CGFloat hX = CGRectGetMaxX(self.dSystemButton.frame) + perSpace;
    self.hSystemButton.frame = CGRectMake(hX, buttonY, buttonW, buttonH);
    
    self.selectedBgView.center = self.bSystemButton.center;
    [self.bSystemButton setTitleColor:kMainColor forState:UIControlStateNormal];
    self.lastSelectedButton = self.bSystemButton;
    self.selectSystemName = SystemPickerViewSystemNameB;
}
@end
