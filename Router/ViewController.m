//
//  ViewController.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", NSStringFromClass([[Router search:ROUTER_API(@"testVC")] class]));
}
- (IBAction)push:(id)sender {
    [Router post:ROUTER_API(@"testVC") parameters:@{@"test" : @"311"} fail:^(RouterError_t * _Nonnull error) {

    }];
}


@end
