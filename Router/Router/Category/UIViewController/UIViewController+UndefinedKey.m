//
//  UIViewController+UndefinedKey.m
//  RouterPodTest
//
//  Created by devfalme on 2019/1/7.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "UIViewController+UndefinedKey.h"

@implementation UIViewController (UndefinedKey)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"没有%@这个key", key);
}

@end
