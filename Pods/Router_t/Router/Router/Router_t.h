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

//注：所有由路由生成的控制器都是调用init方法生产的

NS_ASSUME_NONNULL_BEGIN

#ifndef Router
#define Router [Router_t defaultRouter]
#endif

#ifndef RouterStart
#define RouterStart [[Router_t defaultRouter] start]
#endif

typedef NS_ENUM(NSUInteger, RouterType) {
    RouterTypePush,
    RouterTypePresent,
};

@protocol RouterProtocol <NSObject>

@optional
+ (NSString *)routePath;
+ (UIViewController*) instanceFromStory;

@end


typedef void(^completeCallback)(RouterContext *context, RouterType type);

@interface Router_t : NSObject

+ (instancetype)defaultRouter;
- (void)start;

- (UIViewController * _Nullable)search:(NSString *)url parameters:(NSDictionary *)parameters;

- (void)post:(NSString *)url parameters:(NSDictionary *)parameters type:(RouterType)type;
- (void)get:(NSString *)url type:(RouterType)type;

//当URL没有对应的绑定控制器将使用webview打开，不绑定将不打开
//填入webviewController的类名即可
- (void)registerWebviewController:(NSString *)controllerClass;
@end

NS_ASSUME_NONNULL_END
