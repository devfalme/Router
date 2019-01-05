//
//  UINavigationController+Router_t.m
//  RouterPodTest
//
//  Created by devfalme on 2019/1/5.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "UINavigationController+Router_t.h"
#import "Router_t.h"
@implementation UINavigationController (Router_t)

- (void)pushURL:(NSString *)url animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    [self pushURL:url parameters:nil animated:animated completion:completion];
}

- (void)pushURL:(NSString *)url parameters:(NSDictionary *__nullable)parameters animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    [Router pushUrl:url parameters:parameters animated:animated completion:completion];
}


@end
