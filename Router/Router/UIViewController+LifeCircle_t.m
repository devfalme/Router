//
//  UIViewController+LifeCircle_t.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "UIViewController+LifeCircle_t.h"
#import <objc/runtime.h>

static void __viewControllerLifeCircleSwizzInstance(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static void* viewAppearKey = &viewAppearKey;

typedef void(^viewAppearBlock)(BOOL animated);

typedef void(^itorActionBlock)(ControllerLifeCircleHook* action );

void itorAction(NSArray* actions, itorActionBlock block) {
    for (ControllerLifeCircleHook* action in actions) {
        if (block) {
            block(action);
        }
    }
}

NSMutableArray* viewControllerGlobalActions() {
    static NSMutableArray* globalActions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalActions = [NSMutableArray array];
    });
    return globalActions;
}

void registerGlobalAction(ControllerLifeCircleHook* action) {
    void(^Register)(void) = ^(void) {
        NSMutableArray* actions = viewControllerGlobalActions();
        if (![actions containsObject:action]) {
            [actions addObject:action];
        }
    };
    
    if ([NSThread mainThread]) {
        Register();
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            Register();
        });
    }
}

void removeGlobalAction(ControllerLifeCircleHook* action) {
    void(^Remove)(void) = ^(void) {
        NSMutableArray* actions = viewControllerGlobalActions();
        if ([actions containsObject:action]) {
            [actions removeObject:action];
        }
    };
    if ([NSThread mainThread]) {
        Remove();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            Remove();
        });
    }
}

@implementation UIViewController (LifeCircle_t)

- (NSArray*)lifeCircleActions {
    NSArray* lcs = objc_getAssociatedObject(self, viewAppearKey);
    if ([lcs isKindOfClass:[NSArray class]]) {
        return lcs;
    }
    return [NSArray array];
}

- (void)setLifeCircleActions:(NSArray*)array {
    objc_setAssociatedObject(self, viewAppearKey, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ControllerLifeCircleHook* )registerLifeCircleAction:(ControllerLifeCircleHook *)action {
    NSMutableArray* array = [NSMutableArray arrayWithArray:[self lifeCircleActions]];
    [array addObject:action];
    [self setLifeCircleActions:array];
    return action;
}

- (void)removeLifeCircleAction:(ControllerLifeCircleHook *)action {
    NSArray* array = [self lifeCircleActions];
    NSInteger index = [array indexOfObject:action];
    if (index == NSNotFound) {
        return;
    }
    NSMutableArray* mArray = [NSMutableArray arrayWithArray:array];
    [mArray removeObjectAtIndex:index];
    [self setLifeCircleActions:array];
}



- (void)action_performAction:(itorActionBlock)block {
    itorAction([viewControllerGlobalActions() copy], block);
    itorAction([[self lifeCircleActions] copy], block);
}

- (void)action_swizzViewDidDisappear:(BOOL)animated {
    [self action_swizzViewDidDisappear:animated];
    [self action_performAction:^(ControllerLifeCircleHook *action) {
        if ([action respondsToSelector:@selector(controller:didDisappear:)]) {
            [action controller:self didDisappear:animated];
        }
    }];
}

- (void)action_swizzViewWillDisappear:(BOOL)animated {
    [self action_swizzViewWillDisappear:animated];
    [self action_performAction:^(ControllerLifeCircleHook *action) {
        if ([action respondsToSelector:@selector(controller:willDisappear:)]) {
            [action controller:self willDisappear:animated];
        }
    }];
}
- (void)action_swizzviewWillAppear:(BOOL)animated {
    [self action_swizzviewWillAppear:animated];
    [self action_performAction:^(ControllerLifeCircleHook *action) {
        if ([action respondsToSelector:@selector(controller:willAppear:)]) {
            [action controller:self willAppear:animated];
        }
    }];
}

-(void)action_swizzviewDidAppear:(BOOL)animated {
    [self action_swizzviewDidAppear:animated];
    [self action_performAction:^(ControllerLifeCircleHook *action) {
        if ([action respondsToSelector:@selector(controller:didAppear:)]) {
            [action controller:self didAppear:animated];
        }
    }];
}

@end

@interface UIViewControllerActionSetup : NSObject

@end

@implementation UIViewControllerActionSetup

+ (void) load {
    Class viewControllerClass = [UIViewController class];
    __viewControllerLifeCircleSwizzInstance(viewControllerClass,@selector(viewDidAppear:),@selector(action_swizzviewDidAppear:));
    __viewControllerLifeCircleSwizzInstance(viewControllerClass, @selector(viewDidDisappear:), @selector(action_swizzViewDidDisappear:));
    __viewControllerLifeCircleSwizzInstance(viewControllerClass, @selector(viewWillAppear:), @selector(action_swizzviewWillAppear:));
    __viewControllerLifeCircleSwizzInstance(viewControllerClass, @selector(viewWillDisappear:), @selector(action_swizzViewWillDisappear:));
}



@end
