//
//  HomeViewController.m
//  panpo
//
//  Created by 兰轩轩 on 15/6/4.
//  Copyright (c) 2015年 Eastblue. All rights reserved.
//

#import "HomeViewController.h"
#import "SystemPickerView.h"
#import "ZeroOneButton.h"
#import "UIView+Extension.h"
#import "SystemConvert.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate, SystemPickerViewDelegate, ZeroOneButtonDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *numberPicker;
@property (weak, nonatomic) IBOutlet SystemPickerView *inputSystemPickerView;
@property (weak, nonatomic) IBOutlet SystemPickerView *outputSystemPickerView;
@property (weak, nonatomic) IBOutlet ZeroOneButton *zeroOneButton;
@property (weak, nonatomic) IBOutlet UIButton *inputTextButton;
@property (weak, nonatomic) IBOutlet UIButton *outputTextButton;

@property (nonatomic, strong) NSArray *numbers;

@end

@implementation HomeViewController
- (NSArray *)numbers{
    if(_numbers == nil){
        _numbers = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F"];
    }
    return _numbers;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.outputSystemPickerView.defaultSystemName = SystemPickerViewSystemNameD;
    [self setupUserInterface];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.inputSystemPickerView.delegate = self;
    self.outputSystemPickerView.delegate = self;
    self.zeroOneButton.delegate = self;
}

#pragma mark - 私有方法
- (void)setupUserInterface{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(deleteChar)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
}

- (void)deleteChar{
    NSString *curStr = [self.inputTextButton currentTitle];
    if(curStr.length >= 1){
        NSString *newStr = [curStr substringWithRange:(NSRange){0, curStr.length - 1}];
        [self.inputTextButton setTitle:newStr forState:UIControlStateNormal];
        [self calculateResult];
    }
}

- (void)processWithSystemName:(SystemPickerViewSystemName)name{
    if(name == SystemPickerViewSystemNameB){
        //隐藏表盘
        //调出10界面
        self.numberPicker.hidden = YES;
        self.zeroOneButton.hidden = NO;
        
    }else{
        [self.numberPicker reloadComponent:0];
        [self.numberPicker selectRow:[self.numberPicker numberOfRowsInComponent:0]/2 inComponent:0 animated:NO];
        self.numberPicker.hidden = NO;
        self.zeroOneButton.hidden = YES;
    }
}

- (void)addTitleWithString:(NSString *)string{
    NSString *curString = [self.inputTextButton currentTitle];

    if(curString == nil){
        curString = @"";
    }
    NSString *newString = [curString stringByAppendingString:string];
    [self.inputTextButton setTitle:newString forState:UIControlStateNormal];
}

/**
 *  计算结果
 */
- (void)calculateResult{
    switch (self.inputSystemPickerView.selectSystemName) {
        case SystemPickerViewSystemNameB:
            [self calculateResultOnBinary];
            break;
        case SystemPickerViewSystemNameD:
            [self calculateResultOnDecimal];
            break;
        case SystemPickerViewSystemNameQ:
            [self calculateResultOnQ];
            break;
        case SystemPickerViewSystemNameH:
            [self calculateResultOnHex];
            break;
            
        default:
            break;
    }
    [self outputCheckout];
}
- (void)calculateResultOnBinary{
    NSString *result = nil;
    switch (self.outputSystemPickerView.selectSystemName) {
        case SystemPickerViewSystemNameB:
            result = [self.inputTextButton currentTitle];
            break;
        case SystemPickerViewSystemNameD:
            result = [SystemConvert binaryToDecimal:[self.inputTextButton currentTitle]];
            break;
        case SystemPickerViewSystemNameH:
            result = [SystemConvert binaryToHex:[self.inputTextButton currentTitle]];
            break;
        case SystemPickerViewSystemNameQ:
            result = [SystemConvert binaryToQ:[self.inputTextButton currentTitle]];
            break;
        default:
            result = [self.inputTextButton currentTitle];
            break;
    }
    [self.outputTextButton setTitle:result forState:UIControlStateNormal];
}
- (void)calculateResultOnDecimal{
    NSString *result = nil;
    switch (self.outputSystemPickerView.selectSystemName) {
        case SystemPickerViewSystemNameB:
            result = [SystemConvert decimalToBinary:[[self.inputTextButton currentTitle] integerValue]];
            break;
        case SystemPickerViewSystemNameD:
            result = [self.inputTextButton currentTitle];
            break;
        case SystemPickerViewSystemNameH:
            result = [SystemConvert decimalToHex:[[self.inputTextButton currentTitle] integerValue]];
            break;
        case SystemPickerViewSystemNameQ:
            result = [SystemConvert decimalToQ:[[self.inputTextButton currentTitle] integerValue]];
            break;
        default:
            result = [self.inputTextButton currentTitle];
            break;
    }
    [self.outputTextButton setTitle:result forState:UIControlStateNormal];
}
- (void)calculateResultOnQ{
    NSString *result = nil;
    switch (self.outputSystemPickerView.selectSystemName) {
        case SystemPickerViewSystemNameB:
            result = [SystemConvert qToBinary:[self.inputTextButton currentTitle]];
            break;
        case SystemPickerViewSystemNameD:
            result = [SystemConvert qToDecimal:[self.inputTextButton currentTitle]];
            break;
        case SystemPickerViewSystemNameH:
            result = [SystemConvert qToHex:[self.inputTextButton currentTitle]];
            break;
        case SystemPickerViewSystemNameQ:
            result = [self.inputTextButton currentTitle];
            break;
        default:
            result = [self.inputTextButton currentTitle];
            break;
    }
    [self.outputTextButton setTitle:result forState:UIControlStateNormal];
}
- (void)calculateResultOnHex{
    NSString *result = nil;
    switch (self.outputSystemPickerView.selectSystemName) {
        case SystemPickerViewSystemNameB:
            result = [SystemConvert hexToBinary:[self.inputTextButton currentTitle]];
            break;
        case SystemPickerViewSystemNameD:
            result = [SystemConvert hexToDecimal:[self.inputTextButton currentTitle]];
            break;
        case SystemPickerViewSystemNameH:
            result = [self.inputTextButton currentTitle];
            break;
        case SystemPickerViewSystemNameQ:
            result = [SystemConvert hexToQ:[self.inputTextButton currentTitle]];
            break;
        default:
            result = [self.inputTextButton currentTitle];
            break;
    }
    [self.outputTextButton setTitle:result forState:UIControlStateNormal];
}

- (BOOL)inputCheckout{
    CGFloat width = [[self.inputTextButton currentTitle] boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.inputTextButton.titleLabel.font} context:nil].size.width;
    if(width >= (self.view.width - 100)){
        //显示警告
        [self inputWarning];
        return NO;
    }
    return YES;
}
- (void)outputCheckout{
    CGFloat width = [[self.outputTextButton currentTitle] boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.inputTextButton.titleLabel.font} context:nil].size.width;
    if(width >= (self.view.width - 100)){
        [self.outputTextButton setTitle:@"Beyond" forState:UIControlStateNormal];
    }
}
- (void)inputWarning{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    CAKeyframeAnimation *animate = [[CAKeyframeAnimation alloc]init];
    animate.keyPath = @"transform.translation.x";
    animate.values = @[@(0), @(-10), @(0), @(10)];
    animate.repeatCount = 2;
    animate.duration = 0.2;
    [self.inputTextButton.layer addAnimation:animate forKey:nil];
}


#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.inputSystemPickerView.selectSystemName) {
        case SystemPickerViewSystemNameD:
            return 10;
            break;
        case SystemPickerViewSystemNameH:
            return self.numbers.count;
            break;
        case SystemPickerViewSystemNameQ:
            return 8;
            break;
        default:
            return self.numbers.count;
    }
}

#pragma mark - UIPickerView Delegate
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = self.numbers[row];
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    return attrStr;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if([self inputCheckout] == NO)return;
    [self addTitleWithString:self.numbers[row]];
    
    [self calculateResult];
}

#pragma mark - SystemPickerView Delegate
- (void)systemPickerView:(SystemPickerView *)systemPickerView didSelectSystemFrom:(SystemPickerViewSystemName)from to:(SystemPickerViewSystemName)to{
    
    if(systemPickerView == self.inputSystemPickerView){
        [self.inputTextButton setTitle:@"" forState:UIControlStateNormal];
        [self.outputTextButton setTitle:@"" forState:UIControlStateNormal];
        [self processWithSystemName:to];
    }else if(systemPickerView == self.outputSystemPickerView){
        [self calculateResult];
    }
    
}

#pragma mark = ZeroOneButton Delegate
- (void)ZeroOneButton:(ZeroOneButton *)button didClickButtonWithType:(ZeroOneButtonType)type{
    if([self inputCheckout] == NO)return;
    //改变输入显示
    NSString *appendString = (type == ZeroOneButtonTypeOne) ? @"1" : @"0";
    [self addTitleWithString:appendString];
    
    //计算结果并且显示
    [self calculateResult];
}

@end
