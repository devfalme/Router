//
//  WebRightMenuView.m
//  WebDemo
//
//  Created by MacPro on 10/12/18.
//  Copyright © 2018 MacPro. All rights reserved.
//

#import "WebRightMenuView.h"

@interface WebRightMenuView ()

//@property (nonatomic,  strong ) <# NSString #> *<# name #>;

@end

@implementation WebRightMenuView



- (void)setShowFrame:(CGRect)showFrame {
    
    _showFrame = showFrame;
    [self createMenuList];
}

- (void)createMenuList {
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    CGRect showBounds = CGRectMake(0, 0, self.showFrame.size.width, self.showFrame.size.height);
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:showBounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = showBounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)showMenuAnimation {
    CGRect finalRect = CGRectZero;
    if (CGRectEqualToRect(self.frame, self.showFrame)) {
        finalRect = self.hiddenFrame;
    } else {
        finalRect = self.showFrame;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = finalRect;
    }];
}

- (void)hiddenMenuAnimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = self.hiddenFrame;
    }];
}











@end
