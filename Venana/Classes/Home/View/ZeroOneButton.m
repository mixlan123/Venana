//
//  ZeroOneButton.m
//  panpo
//
//  Created by 兰轩轩 on 15/6/4.
//  Copyright (c) 2015年 Eastblue. All rights reserved.
//

#define kOneBgColor [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0]
#define kZeroBgColor [UIColor colorWithRed:46/255.0 green:221/255.0 blue:157/255.0 alpha:1.0]
#define kOneTitleColor kZeroBgColor
#define kZeroTitleColor kOneBgColor

#import "ZeroOneButton.h"
#import "UIView+Extension.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID shake_sound_male_id = 0;

@interface ZeroOneButton ()
@property (nonatomic, weak) UIButton *oneButton;
@property (nonatomic, weak) UIButton *zeroButton;
@end
@implementation ZeroOneButton

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
    UIButton *oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    oneButton.tag = ZeroOneButtonTypeOne;
    [oneButton addTarget:self action:@selector(zeroOneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [oneButton setTitle:@"1" forState:UIControlStateNormal];
    [oneButton setTitleColor:kOneTitleColor forState:UIControlStateNormal];
    [oneButton setBackgroundImage:[UIImage imageNamed:@"oneButtonBg"] forState:UIControlStateNormal];
    oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:70];
    [self addSubview:oneButton];
    self.oneButton = oneButton;
    
    UIButton *zeroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zeroButton.tag = ZeroOneButtonTypeZero;
    [zeroButton addTarget:self action:@selector(zeroOneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [zeroButton setTitle:@"0" forState:UIControlStateNormal];
    [zeroButton setTitleColor:kZeroTitleColor forState:UIControlStateNormal];
    [zeroButton setBackgroundImage:[UIImage imageNamed:@"zeroButtonBg"] forState:UIControlStateNormal];
    zeroButton.titleLabel.font = [UIFont boldSystemFontOfSize:70];
    [self addSubview:zeroButton];
    self.zeroButton = zeroButton;
}

- (void)zeroOneButtonClick:(UIButton *)button{
    //播放声音
    [self playSound];
    if([self.delegate respondsToSelector:@selector(ZeroOneButton:didClickButtonWithType:)]){
        [self.delegate ZeroOneButton:self didClickButtonWithType:(ZeroOneButtonType)button.tag];
    }
}

-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"keyPress" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
//    
//    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
//    
//    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat buttonW = self.width / 2;
    CGFloat buttonH = self.height;
    
    self.oneButton.frame = CGRectMake(0, 0, buttonW, buttonH);
    self.zeroButton.frame = CGRectMake(buttonW, 0, buttonW, buttonH);
}

@end
