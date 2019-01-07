//
//  AppDelegate+RotationExtension.m
//  WebDemo
//
//  Created by MacPro on 10/13/18.
//  Copyright © 2018 MacPro. All rights reserved.
//

#import "AppDelegate+RotationExtension.h"
#import <objc/runtime.h>

@implementation AppDelegate (RotationExtension)

@dynamic isLandscape;





- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.isLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}



- (void)setIsLandscape:(BOOL)isLandscape {
    
    objc_setAssociatedObject(self, "isLandscape", @(isLandscape), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isLandscape {
    
    return [objc_getAssociatedObject(self, "isLandscape") boolValue];
}




@end
