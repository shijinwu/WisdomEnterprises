//
//  EditNormalInfoController.m
//  EFamilyEducation
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "EditNormalInfoController.h"
#import "InfoManager.h"
#import "UILabel+Function.h"
#import <Masonry/Masonry.h>
#import "UIColor+WXExtension.h"
@interface EditNormalInfoController ()

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong) UITextField * infoTextField;

@property (nonatomic,copy)NSString * titleStr;


@property (nonatomic,strong)InfoManager * infoManager;


/*保存*/
-(void)save;


@end

@implementation EditNormalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.infoManager = [InfoManager shareManager];
    
    [self addSubViews];
    
    self.view.backgroundColor = [UIColor colorWithR:230 G:230 B:230 Alpha:230];
    
}
//-(void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear: animated];
//    
//    self.tabBarController.tabBar.hidden = NO;
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//     self.tabBarController.tabBar.hidden = NO;
//}

-(void)addSubViews
{
    
 
  
    
    self.navigationItem.titleView = [UILabel getTitleLabelWithTitle:self.titleStr textcolor:[UIColor whiteColor] frame:CGRectMake(0, 0, 120, 30)];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    
    
    Week_Self(copy_self)
    
    self.scrollView = ({
        
        UIScrollView * scrollView = [[UIScrollView alloc]init];
        
       // scrollView.backgroundColor = BackgroundColor;
        
        [self.view addSubview:scrollView];
        
      
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(copy_self.view);

        }];
        
        
        scrollView;
        
    });
    
    
    
    self.infoTextField = ({
        
        UITextField * textField = [[UITextField alloc]init];
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        textField.clearButtonMode = YES;
        
        textField.backgroundColor = [UIColor whiteColor];
        
        [textField becomeFirstResponder];
        
        
        textField.text = [self.infoManager getInfowithTitle:self.titleStr];
        
        [self.scrollView addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(@0);
            
            make.top.mas_equalTo(@20);
            
            make.width.equalTo(copy_self.scrollView);
            
            make.height.equalTo(@40);
            
        }];
        
        
        textField;
        
    });
    
}

-(void)save
{
   
    [self.infoManager setInfoWithTitle:self.titleStr content:self.infoTextField.text];
    

    
    if (self.saveInfo) {
        self.saveInfo();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
