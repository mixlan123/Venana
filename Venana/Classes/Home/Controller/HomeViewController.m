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
}

- (void)processWithSystemName:(SystemPickerViewSystemName)name{
    if(name == SystemPickerViewSystemNameB){
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
    
//    if(![self checkSystemNumbersWithLength:(NSUInteger)curString.length]){
//        return;
//    }
    if(curString == nil){
        curString = @"";
    }
    NSString *newString = [curString stringByAppendingString:string];
    [self.inputTextButton setTitle:newString forState:UIControlStateNormal];
}

//- (BOOL)checkSystemNumbersWithLength:(NSUInteger)length{
//    switch (self.inputSystemPickerView.selectSystemName) {
//        case SystemPickerViewSystemNameD:
//        case SystemPickerViewSystemNameH:
//        case SystemPickerViewSystemNameQ:
//            if(length >= 5){
//                return NO;
//            }
//            break;
//        case SystemPickerViewSystemNameB:
//            if(length >= 16){
//                return NO;
//            }
//            break;
//        default:
//            return YES;
//    }
//    return YES;
//}

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
    [self addTitleWithString:self.numbers[row]];
}

#pragma mark - SystemPickerView Delegate
- (void)systemPickerView:(SystemPickerView *)systemPickerView didSelectSystemFrom:(SystemPickerViewSystemName)from to:(SystemPickerViewSystemName)to{
    if(systemPickerView == self.inputSystemPickerView){
        [self.inputTextButton setTitle:@"" forState:UIControlStateNormal];
        [self processWithSystemName:to];
    }else if(systemPickerView == self.outputSystemPickerView){
        
    }
    
}

#pragma mark = ZeroOneButton Delegate
- (void)ZeroOneButton:(ZeroOneButton *)button didClickButtonWithType:(ZeroOneButtonType)type{
    NSString *appendString = (type == ZeroOneButtonTypeOne) ? @"1" : @"0";
    [self addTitleWithString:appendString];
}

@end
