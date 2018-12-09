//
//  Router_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterContext_t.h"
#import "RouterDefine_t.h"
#import "RouterError_t.h"

NS_ASSUME_NONNULL_BEGIN

#ifndef Router
#define Router [Router_t defaultRouter]
#endif

#ifndef RouterStart
#define RouterStart [Router_t start]
#endif

typedef void(^completeCallback)(RouterContext *context);

@interface Router_t : NSObject

+ (instancetype)defaultRouter;
+ (void)start;

- (UIViewController * _Nullable)search:(NSString *)url;

- (void)post:(NSString *)url parameters:(NSDictionary *)parameters fail:(void(^ _Nullable)(RouterError *error))fail;
- (void)get:(NSString *)url fail:(void(^ _Nullable)(RouterError *error))fail;


@end

NS_ASSUME_NONNULL_END
