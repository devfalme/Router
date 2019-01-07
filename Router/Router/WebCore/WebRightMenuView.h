//
//  WebRightMenuView.h
//  WebDemo
//
//  Created by MacPro on 10/12/18.
//  Copyright © 2018 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebRightMenuView : UIView

@property (nonatomic, assign) CGRect hiddenFrame;
@property (nonatomic, assign) CGRect showFrame;

- (void)showMenuAnimation;
- (void)hiddenMenuAnimation;


@end

NS_ASSUME_NONNULL_END
