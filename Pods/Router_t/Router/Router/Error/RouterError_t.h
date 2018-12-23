//
//  RouterError_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef RouterError
#define RouterError RouterError_t
#endif

@interface RouterError_t : NSObject

@property (nonatomic, retain, readonly) NSString *errorDescription;

+ (instancetype)code:(NSInteger)code description:(NSString *)description;

@end

NS_ASSUME_NONNULL_END
