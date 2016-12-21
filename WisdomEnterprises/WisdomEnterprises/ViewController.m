//
//  ViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)addChildVcWithName:(NSString *)name{
    
    UIViewController *  vc =  [[UIStoryboard storyboardWithName:name bundle:nil]instantiateInitialViewController];
    
    [self addChildViewController:vc];
    
}



@end
