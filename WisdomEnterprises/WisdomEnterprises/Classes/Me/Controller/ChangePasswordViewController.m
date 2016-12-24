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
#import "UIColor+WXExtension.h"
@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation ChangePasswordViewController
- (IBAction)tapConfirmButton:(UIButton *)sender {
    
    // 确认
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self setupUI];
    
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)setupUI{
    
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"86"]];
    accountImageView.frame = CGRectMake(0, 0, 80, 40);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(90, 2, 1, 32)];
    line.backgroundColor = [UIColor colorWithR:234 G:234 B:234 Alpha:1];
    
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [aView addSubview:accountImageView];
    
    [aView addSubview:line];
    
    _account.leftView = aView;
    
    _account.leftViewMode = UITextFieldViewModeAlways;
    
    _account.delegate = self;
    
    UIImageView * passwordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mima"]];
    passwordImageView.frame = CGRectMake(0, 0, 80, 40);
    
    UIView * pView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    
    [pView addSubview:passwordImageView];
    
    _password.leftView = pView;
    
    _password.leftViewMode = UITextFieldViewModeAlways;
    
    
    _password.delegate = self;
    
     UIView * cView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
  
    _confirmPassword.leftView = cView;
    
    _confirmPassword.leftViewMode = UITextFieldViewModeAlways;
    
    
    _confirmPassword.delegate = self;
    
    self.confirmButton.layer.cornerRadius = 5;
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _account) {
        [_account resignFirstResponder];
        [_password becomeFirstResponder];
    } else if (textField == _password) {
        [_password resignFirstResponder];
        [_confirmPassword becomeFirstResponder];
    }
    else if(textField == _confirmPassword){
        [_confirmPassword resignFirstResponder];
        [self tapConfirmButton:nil];
    }
    return YES;
}


@end
