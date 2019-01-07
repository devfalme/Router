//
//  Router_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIViewController+UndefinedKey.h"
#import "UIViewController+Router_t.h"
#import "UINavigationController+Router_t.h"

#import "RouterDefine_t.h"

@class RouterContext_t;

//注：所有由路由生成的控制器都是调用init方法生产的

NS_ASSUME_NONNULL_BEGIN

#ifndef Router
#define Router [Router_t defaultRouter]
#endif

#ifndef RouterStart
#define RouterStart [[Router_t defaultRouter] start]
#endif

@protocol RouterProtocol <NSObject>

@optional
+ (NSString *)routePath;
+ (UIViewController *)instanceFromStory;

@end

@interface Router_t : NSObject

+ (instancetype)defaultRouter;
- (void)start;

- (UIViewController * _Nullable)search:(NSString *)url;
- (UIViewController * _Nullable)search:(NSString *)url parameters:(NSDictionary * _Nullable)parameters;


- (void)presentUrl:(NSString *)url animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;
- (void)presentUrl:(NSString *)url parameters:(NSDictionary * _Nullable)parameters animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;

- (void)pushUrl:(NSString *)url animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;
- (void)pushUrl:(NSString *)url parameters:(NSDictionary * _Nullable)parameters animated:(BOOL)flag completion:(void (^ __nullable)(void))completion;



//当URL没有对应的绑定控制器将使用webview打开，不绑定将不打开
//填入webviewController的类名即可 注：webview的URL和parameter是分开的，不再解析URL中的parameter,url 作为链接赋值给webUrl属性
- (void)registerWebviewController:(NSString *)controllerClass;
@end

NS_ASSUME_NONNULL_END

