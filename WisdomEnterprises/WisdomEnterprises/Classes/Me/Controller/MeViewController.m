//
//  MeViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "EditNormalInfoController.h"



#import "EditGenderController.h"

#import "MeViewController.h"

#import "UIView+Function.h"

#import "InfoManager.h"
#import <Masonry/Masonry.h>
#import "UIImageView+EMWebCache.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * showDataSource;

@property (nonatomic,strong)InfoManager * infoManager;


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)addShowDataSource
{
    NSArray * section0 = @[@"头像",@"昵称",@"真实姓名",@"手机号码",@"性别",@"爱好"];
    NSArray * section1 = @[@"设置密码"];
    NSArray * section2 = @[@"退出帐号"];
    
    self.showDataSource = @[section0,section1,section2];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showDataSource.count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.showDataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.textLabel.text = self.showDataSource[indexPath.section][indexPath.row];
    
    [self setCellInfoWithIndexPath:indexPath cell:cell];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section== 0 && indexPath.row == 0) {
        
        return 260;
    }
   
    return 80;
}


-(void)setCellInfoWithIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell{
   
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.center = CGPointMake(self.view.width/2,130);
            imageView.size = CGSizeMake(120, 120);
            
            imageView.backgroundColor = [UIColor orangeColor];
            [cell.contentView addSubview:imageView];
            
            imageView.tag = 10001;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.infoManager.user.imageUrl]];
            
        }else
        {
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.right-200,7, 150, 30)];
            
            label.textColor = [UIColor blackColor];
            
            label.textAlignment = NSTextAlignmentRight;
            
            [cell.contentView addSubview:label];
            
            switch (indexPath.row) {
                case 1:
                    label.text = self.infoManager.user.nickName;
                    break;
                case 2:
                    label.text = self.infoManager.user.name;
                    break;
                case 3:
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    label.text = self.infoManager.user.tel;
                    break;
                case 4:
                    label.text = self.infoManager.user.gender;
                    break;
                case 5:
                    label.text = self.infoManager.user.hobby;
                    break;
                    
                default:
                    break;
            }
    }
    
    }
    
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
