//
//  EditGenderController.m
//  EFamilyEducation
//
//  Created by mac on 16/3/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "EditGenderController.h"
#import "InfoManager.h"
#import "UILabel+Function.h"
#import "UIColor+WXExtension.h"
@interface EditGenderController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)NSString * titleStr;

@property (nonatomic,strong)InfoManager * infoManager;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataSource;



@end

@implementation EditGenderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.infoManager = [InfoManager shareManager];
    
    self.view.backgroundColor = [UIColor colorWithR:230 G:230 B:230 Alpha:230];
    [self addSubViews];
    
    [self addDataSource];
    
}

-(void)addSubViews
{
    
   // self.view.backgroundColor = BackgroundColor;
    
    self.navigationItem.titleView = [UILabel getTitleLabelWithTitle:self.titleStr textcolor:[UIColor whiteColor] frame:CGRectMake(0, 0, 120, 30)];

    
    self.tableView = ({
        
        UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        tableView.delegate = self;
        
        tableView.dataSource = self;
        
        [self.view addSubview:tableView];
        
        self.tableView.tableFooterView = [[UIView alloc]init];
        
        tableView;
        
        
    });
  
}

-(void)addDataSource
{
    // @"0" 为未选中状态
    
    NSString * gender = self.infoManager.user.gender;
    
    if (!gender) {
      
        self.dataSource = [NSMutableArray arrayWithArray:@[@"0",@"0"]];
    }
    else if ([gender isEqualToString:@"男"])
    {
        self.dataSource = [NSMutableArray arrayWithArray:@[@"1",@"0"]];
    }
    else
    {
         self.dataSource = [NSMutableArray arrayWithArray:@[@"0",@"1"]];
    }
    
   
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSString * string = @"男";
  
    if (indexPath.row == 1)
    {
        string = @"女";
    }
    
    NSString * status = self.dataSource[indexPath.row];
    
    if ([status isEqualToString:@"1"]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    cell.textLabel.text = string;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString * gender = @"男";
    
    for (int i = 0 ; i < self.dataSource.count; i++)
    {
        if (indexPath.row == i) {
            
            self.dataSource[i] = @"1";
            
            if (i == 1) {
                
               gender = @"女";
            }
        }
        else
        {
              self.dataSource[i] = @"0";
 
          
        }
        NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
        [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    

    
    
    self.infoManager.user.gender = gender;
    

    
    if (self.saveInfo) {
        self.saveInfo();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
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
