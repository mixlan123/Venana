//
//  ZeroOneButton.h
//  panpo
//
//  Created by 兰轩轩 on 15/6/4.
//  Copyright (c) 2015年 Eastblue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZeroOneButton;

typedef enum {
    ZeroOneButtonTypeZero,
    ZeroOneButtonTypeOne
}ZeroOneButtonType;

@protocol ZeroOneButtonDelegate <NSObject>

@optional
- (void)ZeroOneButton:(ZeroOneButton *)button didClickButtonWithType:(ZeroOneButtonType)type;
@end

@interface ZeroOneButton : UIView
@property (nonatomic, weak) id<ZeroOneButtonDelegate> delegate;
@end
