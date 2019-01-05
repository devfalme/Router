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
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSLog(@"%@", NSStringFromClass([[Router search:ROUTER_API(@"testVC") parameters:nil] class]));
}
- (IBAction)push:(id)sender {
    [self.navigationController pushURL:ROUTER_API(@"testVC") parameters:@{@"test" : @"311"} animated:YES completion:nil];
}


@end
