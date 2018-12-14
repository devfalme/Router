//
//  RouterContext_t.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "RouterContext_t.h"


@implementation RouterContext_t
- (NSArray *)VCStack {
    return [stackInstance() VCStack];
}

- (UIViewController *)topVC {
    return stackInstance().VCStack.lastObject;
}

- (UINavigationController *)topNav {
    NSArray* vcs = [self VCStack];
    for (int i = (int)vcs.count -1; i >=0 ; i--) {
        UIViewController* vc = vcs[i];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)vc;
        }
        if (vc.navigationController) {
            return vc.navigationController;
        }
    }
    return nil;
}
@end
