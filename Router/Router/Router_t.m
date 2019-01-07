//
//  Router_t.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "Router_t.h"
#import "URLParser_t.h"
#import "RouterContext_t.h"
#import <objc/runtime.h>
#import <objc/message.h>
#define ROUTE_PATH @"routePath"
#define INSTANCE_FROM_STORY @"instanceFromStory"
#define KEY_PARAMS @"params"
typedef NS_ENUM(NSUInteger, RouterType) {
    RouterTypePush,
    RouterTypePresent,
};

typedef void(^completeCallback)(RouterContext *context,
                                BOOL animated,
                                RouterType type,
                                void (^ __nullable completion)(void));

static NSArray *ClassGetSubclasses(Class parentClass) {
    int numClasses = 0, newNumClasses = objc_getClassList(NULL, 0); // 1
    Class *classes = NULL; // 2
    NSMutableArray *result = [NSMutableArray array];
    while (numClasses < newNumClasses) { // 3
        numClasses = newNumClasses; // 4
        classes = (Class *)realloc(classes, sizeof(Class) * numClasses); // 5
        newNumClasses = objc_getClassList(classes, numClasses); // 6
        for (NSInteger i = 0; i < numClasses; i++) {
            Class superClass = classes[i];
            do {
                superClass = class_getSuperclass(superClass);
            } while(superClass && superClass != parentClass);
            if (superClass == nil) {
                continue;
            }
            [result addObject:classes[i]];
        }
    }
    free(classes);
    return result;
}

static Router_t *_rutor;

@interface Router_t ()
@property (nonatomic, retain) NSMutableDictionary<NSString *, completeCallback> *handleDic;
@property (nonatomic, retain) NSMutableArray <NSString *> *urlArr;
@property (nonatomic, copy) NSString *webviewClass;
@end

@implementation Router_t

- (void)bindUrl:(NSString *)url handle:(completeCallback)handle{
    if ([self.urlArr containsObject:url]) {[self logError:[NSString stringWithFormat:@"URL:%@ 重复使用，可能会导致跳转不到预期的controller", url]];}
    [self.urlArr addObject:url];
    [self.handleDic setObject:handle forKey:url];
}

- (void)start {
    NSArray* vcArr = ClassGetSubclasses([UIViewController class]);
    for (id cls in vcArr) {
        Class currentClass = cls;
        if (!currentClass) {
            return;
        }
        unsigned int methodCount = 0;
        Method *methodList = class_copyMethodList(object_getClass(currentClass), &methodCount);
        if (methodCount > 0) {
            NSMutableArray<NSString*>* arr = [NSMutableArray arrayWithCapacity:methodCount];
            for (unsigned int i = 0; i < methodCount; i++) {
                NSString *selStr = [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding];
                [arr addObject:selStr];
            }
            NSArray<NSString*>* methods = [arr copy];
            if ([methods containsObject:ROUTE_PATH]) {
                SEL selector = NSSelectorFromString(ROUTE_PATH);
                NSString* path = ((id(*)(id,SEL))objc_msgSend)(currentClass,selector);
                [self bindUrl:path handle:^(RouterContext_t * _Nonnull context, BOOL animated, RouterType type, void (^ _Nullable completion)(void)) {
                    UIViewController* vc;
                    if ([methods containsObject:INSTANCE_FROM_STORY]) {
                        SEL selector = NSSelectorFromString(INSTANCE_FROM_STORY);
                        vc = ((id(*)(id,SEL))objc_msgSend)(currentClass,selector);
                    } else {
                        vc = [[currentClass alloc] init];
                    }
                    for (NSString *key in [context.parameters allKeys]) {
                        [vc setValue:context.parameters[key] forKey:key];
                    }
                    if (type == RouterTypePush) {
                        if (context.topNav) {
                            [context.topNav pushViewController:vc animated:animated];
                            if (completion) {
                                completion();
                            }
                        }else{
                            [self logError:@"导航控制器不存在"];
                        }
                    }else {
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        [context.topVC presentViewController:vc animated:animated completion:completion];
                    }
                }];
            }
        }
    }
}



#pragma mark push/present
- (void)presentUrl:(NSString *)url animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    [self presentUrl:url parameters:nil animated:flag completion:completion];
}

- (void)presentUrl:(NSString *)url parameters:(NSDictionary * _Nullable)parameters animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
   [self router:url type:RouterTypePresent parameters:parameters animated:flag completion:completion];
}

- (void)pushUrl:(NSString *)url animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    [self pushUrl:url parameters:nil animated:flag completion:completion];
}

- (void)pushUrl:(NSString *)url parameters:(NSDictionary * _Nullable)parameters animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    [self router:url type:RouterTypePush parameters:parameters animated:flag completion:completion];
}

- (void)router:(NSString *)url type:(RouterType)type parameters:(NSDictionary * _Nullable)parameters animated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    if ([self verify]) {
        BOOL exist = NO;
        URLParser *parser = [[URLParser alloc] initWithURL:[NSURL URLWithString:url]];
        if ([self.urlArr containsObject:parser.paten]) {
            RouterContext *context = [[RouterContext alloc] init];
            if (context.parameters) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:context.parameters];
                [dict addEntriesFromDictionary:parameters];
            }else{
                context.parameters = parameters;
            }
            completeCallback callback = self.handleDic[parser.paten];
            callback(context, flag, type, completion);
            exist = YES;
        }
        if (!exist) {[self logError:@"路径不存在, 从web打开"];}
        [self web:url type:type parameter:parameters animated:flag completion:completion];
    }
}

#pragma mark 报错处理

- (void)logError:(NSString *)error {
    NSLog(@"%@", error);
}

- (BOOL)verify {
    if (!self.urlArr.count) {
        [self logError:@"未检测到有绑定URL的控制器"];
        return NO;
    }return YES;
}

#pragma mark instancetype
+ (instancetype)defaultRouter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rutor = [[self alloc] init];
    });
    return _rutor;
}

- (instancetype)init {
    if (self = [super init]) {
        _urlArr = @[].mutableCopy;
        _handleDic = @{}.mutableCopy;
    }
    return self;
}

#pragma mark Search
- (UIViewController * _Nullable)search:(NSString *)url {
    return [self search:url parameters:nil];
}
- (UIViewController * _Nullable)search:(NSString *)url parameters:(NSDictionary * _Nullable)parameters {
    if ([self verify]) {
        NSArray* vcArr = ClassGetSubclasses([UIViewController class]);
        unsigned int methodCount = 0;
        for (Class cls in vcArr) {
            Method *methodList = class_copyMethodList(object_getClass(cls), &methodCount);
            NSMutableArray<NSString*>* arr = [NSMutableArray arrayWithCapacity:methodCount];
            for (unsigned int i = 0; i < methodCount; i++) {
                NSString *selStr = [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding];
                [arr addObject:selStr];
            }
            if ([arr containsObject:ROUTE_PATH]) {
                SEL selector = NSSelectorFromString(ROUTE_PATH);
                NSString* path = ((id(*)(id,SEL))objc_msgSend)(cls,selector);
                if ([path isEqualToString:url]) {
                    UIViewController *vc = [[cls alloc]init];
                    for (NSString *key in [parameters allKeys]) {
                        [vc setValue:parameters[key] forKey:key];
                    }
                    return vc;
                }
            }
        }
    }
    [self logError:@"路径不存在，返回空控制器"];
    return [[UIViewController alloc]init];
}

#pragma mark web
- (void)registerWebviewController:(NSString *)controller {
    self.webviewClass = controller;
}

- (void)web:(NSString *)url type:(RouterType)type parameter:(NSDictionary * _Nullable)parameters animated:(BOOL)flag completion:(void(^ _Nullable)(void))completion {
    if (self.webviewClass) {
        UIViewController *vc;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dic setObject:url forKey:@"webUrl"];
        if (self.webviewClass) {
            vc = [[NSClassFromString(self.webviewClass) alloc]init];
        }
        [vc setValuesForKeysWithDictionary:dic];
        
        RouterContext *context = [[RouterContext alloc] init];
        if (type == RouterTypePush) {
            if (context.topNav) {
                [context.topNav pushViewController:vc animated:flag];
                if (completion) {
                    completion();
                }
            }else{
                [self logError:@"导航控制器不存在"];
            }
        }else {
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [context.topVC presentViewController:vc animated:flag completion:completion];
        }     
    }
}


@end
