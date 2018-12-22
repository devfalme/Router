//
//  ControllerLifeCircleHook_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef ControllerLifeCircleHook
#define ControllerLifeCircleHook ControllerLifeCircleHook_t
#endif

@interface ControllerLifeCircleHook_t : NSObject

@property (nonatomic, strong, readonly) NSArray* VCStack;

FOUNDATION_EXTERN ControllerLifeCircleHook* stackInstance(void);

- (void)controller:(UIViewController*)vc willAppear:(BOOL)animated;
- (void)controller:(UIViewController*)vc didAppear:(BOOL)animated;
- (void)controller:(UIViewController*)vc willDisappear:(BOOL)animated;
- (void)controller:(UIViewController*)vc didDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
