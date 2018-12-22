//
//  UIViewController+LifeCircle_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllerLifeCircleHook_t.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LifeCircle_t)

- (ControllerLifeCircleHook* )registerLifeCircleAction:(ControllerLifeCircleHook *)action;

- (void)removeLifeCircleAction:(ControllerLifeCircleHook *)action;

FOUNDATION_EXTERN void removeGlobalAction(ControllerLifeCircleHook* action);
FOUNDATION_EXTERN void registerGlobalAction(ControllerLifeCircleHook* action);

@end

NS_ASSUME_NONNULL_END
