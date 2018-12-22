//
//  URLParser_t.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "URLParser_t.h"
#import "RouterUnit_t.h"

@implementation URLParser_t
- (instancetype) initWithURL:(NSURL*)url {
    self = [super init];
    if (!self) {
        return self;
    }
    _originURL = url;
    [self decodeURL];
    return self;
}

- (void)decodeURL {
    _scheme = _originURL.scheme;
    _host = _originURL.host;
    NSString* query = _originURL.query;
    _parameters = URLRouteDecodeURLQueryParamters(query);
    if (_parameters) {
        _paten = [_originURL.absoluteString substringWithRange:NSMakeRange(0, [_originURL.absoluteString rangeOfString:query].location - 1)];
    }else{
        _paten = _originURL.absoluteString;
    }
}
@end
