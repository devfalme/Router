//
//  UIViewController+Router_t.h
//  RouterPodTest
//
//  Created by devfalme on 2019/1/5.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Router_t)

- (void)presentURL:(NSString *)url animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;

- (void)presentURL:(NSString *)url parameters:(NSDictionary *__nullable)parameters animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
