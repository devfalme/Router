//
//  ControllerLifeCircleHook_t.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "ControllerLifeCircleHook_t.h"
#import "UIViewController+LifeCircle_t.h"

static ControllerLifeCircleHook *UIShareStack;

ControllerLifeCircleHook *stackInstance() {
    return UIShareStack;
}

@interface ControllerLifeCircleHook_t (){
    NSPointerArray* _uiStack;
}

@end

@implementation ControllerLifeCircleHook_t

+ (void)load {
    UIShareStack = [ControllerLifeCircleHook new];
    registerGlobalAction(UIShareStack);
}
- (instancetype) init {
    self = [super init];
    if (!self) {
        return self;
    }
    _uiStack = [NSPointerArray weakObjectsPointerArray];
    return self;
}
- (void)controller:(UIViewController *)vc didAppear:(BOOL)animated {
    if (vc) {
        [_uiStack addPointer:(void*)vc];
    }
    [_uiStack compact];
}
- (void)controller:(UIViewController *)vc willDisappear:(BOOL)animated {
    [_uiStack compact];
}

- (void)controller:(UIViewController *)vc willAppear:(BOOL)animated {
    [_uiStack compact];
}

- (void)controller:(UIViewController *)vc didDisappear:(BOOL)animated {
    NSArray* allObjects = [_uiStack allObjects];
    for (int i = (int)allObjects.count-1; i >= 0; i--) {
        id object = allObjects[i];
        if (vc == object) {
            [_uiStack replacePointerAtIndex:i withPointer:NULL];
        }
    }
    [_uiStack compact];
}

- (NSArray*)VCStack {
    [_uiStack compact];
    return [_uiStack allObjects];
}
@end
