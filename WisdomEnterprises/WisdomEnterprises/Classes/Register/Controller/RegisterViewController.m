//
//  RegisterViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "SDYAccountManager.h"
#import "SDYCommunityInfo.h"

#define ACTIONSHEET_BUILDING 1
#define ACTIONSHEET_ROOM 2


@interface RegisterViewController ()
{
    NSTimer* timer;
    IBOutlet UILabel* _tipsLabel;
    IBOutlet NSLayoutConstraint* _verticalPosition;
    
    //    IBOutlet SDYTextField* _unitNumberField;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
