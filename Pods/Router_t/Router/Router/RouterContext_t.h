//
//  RouterContext_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ControllerLifeCircleHook_t.h"

NS_ASSUME_NONNULL_BEGIN

#ifndef RouterContext
#define RouterContext RouterContext_t
#endif

@interface RouterContext_t : NSObject
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong, readonly) NSArray *VCStack;
@property (nonatomic, strong, readonly) UIViewController *topVC;
@property (nonatomic, strong, readonly, nullable) UINavigationController* topNav;
@end

NS_ASSUME_NONNULL_END
