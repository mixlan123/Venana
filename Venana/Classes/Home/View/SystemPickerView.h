//
//  SystemPickerView.h
//  panpo
//
//  Created by 兰轩轩 on 15/6/4.
//  Copyright (c) 2015年 Eastblue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemPickerView;

typedef enum {
    SystemPickerViewSystemNameB,        //二进制
    SystemPickerViewSystemNameQ,        //八进制
    SystemPickerViewSystemNameD,        //十进制
    SystemPickerViewSystemNameH         //十六进制
}SystemPickerViewSystemName;

@protocol SystemPickerViewDelegate <NSObject>

@optional
/**
 *  从 from进制 跳转到 to进制
 */
- (void)systemPickerView:(SystemPickerView *)systemPickerView didSelectSystemFrom:(SystemPickerViewSystemName)from to:(SystemPickerViewSystemName)to;

@end

@interface SystemPickerView : UIView
@property (nonatomic, weak) id<SystemPickerViewDelegate> delegate;
@property (nonatomic, assign) SystemPickerViewSystemName selectSystemName;
@property (nonatomic, assign) SystemPickerViewSystemName defaultSystemName;
@end
