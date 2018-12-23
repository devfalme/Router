//
//  URLParser_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef URLParser
#define URLParser URLParser_t
#endif

@interface URLParser_t : NSObject

@property (nonatomic, strong, readonly) NSURL* originURL;
@property (nonatomic, strong, readonly) NSString* scheme;
@property (nonatomic, strong, readonly) NSString *paten;
@property (nonatomic, strong, readonly) NSString* host;
@property (nonatomic, strong, readonly) NSDictionary* parameters;

- (instancetype) initWithURL:(NSURL*)url;
@end

NS_ASSUME_NONNULL_END
