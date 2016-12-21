//
//  ChangePasswordViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "UIViewController+HUD.h"
@interface ChangePasswordViewController ()
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _backgroundView.layer.cornerRadius = 8;
    
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)changeFrame:(NSNotification *)notification{
    
    NSDictionary * dic = notification.userInfo;
    
    NSLog(@"dic = %@",dic);
    
    //键盘弹起后的frame
    NSValue * endV = dic[UIKeyboardFrameEndUserInfoKey];
    
    CGRect endFrame = [endV CGRectValue];
    
    CGFloat x = (_confirmPassword.mj_y + _confirmPassword.mj_h + 10) -  endFrame.origin.y;
    
    
    [UIView animateWithDuration:0.7 animations:^{
        
        if (x > 0) {
            
            self.view.mj_y = -x;
            
        }
        else{
            
            self.view.mj_y = 0;
        }
        
    }];
    
}

-(BOOL)test{
    if (_account.text.length == 0 || _password.text.length == 0||_confirmPassword.text.length == 0){
        
        [self showHint:@"请填写完整后提交"];
        
        return NO;
        
    }
    if (![_password.text isEqualToString:_confirmPassword.text]){
        
        [self showHint:@"密码和确认密码不相符"];
        
        return NO;
    }
    if (_password.text.length <= 6){
        
        [self showHint:@"密码必须大于6位"];
        
        return NO;
    }

    
    
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
