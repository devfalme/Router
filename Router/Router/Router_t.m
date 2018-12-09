//
//  Router_t.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "Router_t.h"
#import "URLParser_t.h"
#import <objc/runtime.h>
#import <objc/message.h>
#define ROUTE_PATH @"routePath"
#define INSTANCE_FROM_STORY @"instanceFromStory"
#define KEY_PARAMS @"params"

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
@property (nonatomic, retain) NSMutableArray<NSDictionary *> *results;
@end

@implementation Router_t

+ (void)start {
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
                [Router addPaten:path callback:^(RouterContext *context) {
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
                    [context.topNav pushViewController:vc animated:YES];
                }];
            }
        }
    }
}

- (UIViewController * _Nullable)search:(NSString *)url {
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
                return [[cls alloc]init];
            }
        }
    }
    
    return nil;
}

+ (instancetype)defaultRouter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rutor = [[self alloc] init];
    });
    return _rutor;
}

- (instancetype)init {
    if (self = [super init]) {
        _results = @[].mutableCopy;
    }
    return self;
}

- (void)post:(NSString *)url parameters:(NSDictionary *)parameters fail:(void(^ _Nullable)(RouterError *error))fail {
    URLParser *parser = [[URLParser alloc] initWithURL:[NSURL URLWithString:url]];
    [_results enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj allKeys] containsObject:parser.paten]) {
            RouterContext *context = [[RouterContext alloc] init];
            if (context.parameters) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:context.parameters];
                [dict setDictionary:parameters];
            }else{
                context.parameters = parameters;                
            }
            completeCallback callback = obj[parser.paten];
            if (callback) {
                if (context.topNav) {
                    callback(context);
                }else{
                    RouterError *error = [RouterError code:1 description:@"导航控制器不存在"];
                    if (fail) {
                        fail(error);
                    }
                }
            }
            *stop = YES;
        }else{
            RouterError *error = [RouterError code:0 description:@"路径不存在"];
            if (fail) {
                fail(error);
            }
        }
    }];
}
- (void)get:(NSString *)url fail:(void (^)(RouterError_t * _Nonnull))fail {
    URLParser *parser = [[URLParser alloc] initWithURL:[NSURL URLWithString:url]];
    [_results enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj allKeys] containsObject:parser.paten]) {
            RouterContext *context = [[RouterContext alloc] init];
            context.parameters = parser.parameters;
            completeCallback callback = obj[parser.paten];
            if (callback) {
                if (context.topNav) {
                    callback(context);
                }else{
                    RouterError *error = [RouterError code:1 description:@"导航控制器不存在"];
                    if (fail) {
                        fail(error);
                    }
                }
            }
            *stop = YES;
        }else{
            RouterError *error = [RouterError code:0 description:@"路径不存在"];
            if (fail) {
                fail(error);
            }
        }
    }];
}

- (void)addPaten:(NSString *)paten callback:(completeCallback)callback{
    NSDictionary *dict = @{paten:callback};
    if (![_results containsObject:dict]) {
        [_results addObject:dict];
    }
}
@end
