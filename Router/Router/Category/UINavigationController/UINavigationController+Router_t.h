//
//  UINavigationController+Router_t.h
//  RouterPodTest
//
//  Created by devfalme on 2019/1/5.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Router_t)

- (void)pushURL:(NSString *)url animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

- (void)pushURL:(NSString *)url parameters:(NSDictionary *__nullable)parameters animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
