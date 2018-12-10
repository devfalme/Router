//
//  TestViewController.m
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

ROUTER_PATH(@"testVC")

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.test);
    self.view.backgroundColor = UIColor.whiteColor;
}



@end
