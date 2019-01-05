//
//  UIViewController+Router_t.m
//  RouterPodTest
//
//  Created by devfalme on 2019/1/5.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "UIViewController+Router_t.h"
#import "Router_t.h"
@implementation UIViewController (Router_t)

- (void)presentURL:(NSString *)url animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    [self presentURL:url parameters:nil animated:flag completion:completion];
}
- (void)presentURL:(NSString *)url parameters:(NSDictionary *__nullable)parameters animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    [Router presentUrl:url parameters:parameters animated:flag completion:completion];
}

@end
