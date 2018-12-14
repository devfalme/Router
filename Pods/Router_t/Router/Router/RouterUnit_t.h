//
//  RouterUnit_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SDURLEncode)
- (NSString *)URLEncode;
- (NSString *)URLDecode;
@end
//  用来处理参数携带 拼接参数 返回编码、拼接后的URL
FOUNDATION_EXTERN NSURL *URLRouteQueryLink(NSString *baseUrl, NSDictionary *query);
//  添加参数
FOUNDATION_EXTERN NSString *URLRouteJoinParamterString(NSString *urlStr, NSString *query);
//  将拼接好的参数encode
FOUNDATION_EXTERN NSString *URLRouteEncodeURLQueryParamters(NSDictionary *paramter);
//  将参数decode
FOUNDATION_EXTERN NSDictionary *URLRouteDecodeURLQueryParamters(NSString *urlStr);

NS_ASSUME_NONNULL_END
