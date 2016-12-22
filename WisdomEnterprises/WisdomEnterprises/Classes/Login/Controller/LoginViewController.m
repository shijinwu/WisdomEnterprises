//
//  LoginViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+HUD.h"
#import <MJRefresh/MJRefresh.h>
#import "EaseUI.h"
#import "EaseManager.h"
#import "MBProgressHUD.h"
#import "ConversationListViewController.h"
#import "MessageViewController.h"
#import "UIColor+WXExtension.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (nonatomic,strong)  IBOutlet UITextField *password;
@property (nonatomic,strong)  IBOutlet UIButton *loginButton;

@property (nonatomic,strong)EaseManager * easeManager;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.easeManager = [EaseManager shareManager];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

-(void)changeFrame:(NSNotification *)notification{
    
    NSDictionary * dic = notification.userInfo;
    
    NSLog(@"dic = %@",dic);
    
    //键盘弹起后的frame
    NSValue * endV = dic[UIKeyboardFrameEndUserInfoKey];
    
    CGRect endFrame = [endV CGRectValue];
    
    CGFloat x = (_loginButton.mj_y + _loginButton.mj_h + 10) -  endFrame.origin.y;
    
   
    [UIView animateWithDuration:0.7 animations:^{
        
        if (x > 0) {
            
            self.view.mj_y = -x;
            
        }
        else{
            
            self.view.mj_y = 0;
        }
        
    }];
    
//    NSNumber * d = dic[UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber * c = dic[UIKeyboardAnimationCurveUserInfoKey];
    
}

-(void)setupUI{
    

    _backgroundView.layer.cornerRadius = 8;
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"86"]];
    accountImageView.frame = CGRectMake(0, 0, 80, 40);
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(90, 2, 1, 32)];
    line.backgroundColor = [UIColor colorWithR:234 G:234 B:234 Alpha:1];
    
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [aView addSubview:accountImageView];
    
    [aView addSubview:line];
    
    _account.leftView = aView;
    
    _account.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * passwordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mima"]];
    passwordImageView.frame = CGRectMake(0, 0, 80, 40);

     UIView * pView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    
    [pView addSubview:passwordImageView];
    
    _password.leftView = pView;
    
    _password.leftViewMode = UITextFieldViewModeAlways;
    
    _password.secureTextEntry = YES;
  
  
    _loginButton.layer.cornerRadius = 5;
    [_loginButton addTarget:self action:@selector(longin:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)longin:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    
    __weak typeof(self) weakself = self;
    [self showHudInView:self.view hint:@"正在登录..."];
    
    [self.easeManager loginWithUsername:@"wxb2017" password:@"1111" completionHandler:^(EMError *error) {
        
        if (!error){
            [self hideHud];
            
            //获取数据库中数据
            [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
            
            [self.easeManager getDBDatacompletionHandler:^{
                
                [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                //发送自动登陆状态通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                
                
//                MessageViewController * vc = [[MessageViewController alloc]initWithConversationChatter:@"wxb2017" conversationType:EMConversationTypeChat];
//
                ConversationListViewController * vc =[[ConversationListViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
            
            
        }
        else{
            
            switch (error.code)
            {
                    
               [self showHint:@"聊天连接失败,请退出重新连接"];
            
        }
            
        }
        
        
    }];
    
//    if([self test]){
//        
//        NSLog(@"发送登录请求");
//        
//        
//    }
}


-(BOOL)test{
    
    if (_account.text.length == 0 || _password.text.length == 0){
        
        [self showHint:@"请输入用户名或密码"];
        
        return NO;
    
    }
    if (_account.text.length != 11){
        
        [self showHint:@"请输入正确的用户名"];
        
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
