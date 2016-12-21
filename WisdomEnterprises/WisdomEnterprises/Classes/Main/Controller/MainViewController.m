//
//  MainViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildVcWithName:@"Message"];
    [self addChildVcWithName:@"Contact"];
    [self addChildVcWithName:@"Service"];
    [self addChildVcWithName:@"Me"];
}

-(void)addChildVcWithName:(NSString *)name{
    
    UIViewController *  vc =  [[UIStoryboard storyboardWithName:name bundle:nil]instantiateInitialViewController];
    
    [self addChildViewController:vc];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
