//
//  RouterError_t.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "RouterError_t.h"

@implementation RouterError_t
+ (instancetype)code:(NSInteger)code description:(NSString *)description {
    RouterError_t *error = [[self alloc]init];
    [error setValue:[NSString stringWithFormat:@"Code:%ld, Description:%@", (long)code, description] forKey:@"errorDescription"];
    return error;
}
@end
