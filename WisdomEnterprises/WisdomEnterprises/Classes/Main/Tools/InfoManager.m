//
//  InfoManager.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "InfoManager.h"

@implementation InfoManager

+(instancetype)shareManager
{
    static InfoManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[InfoManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [[User alloc]init];
    }
    return self;
}

-(NSString *)getInfowithTitle:(NSString *)title{
    
    NSArray * array = @[@"昵称",@"真实姓名",@"手机号",@"性别",@"爱好"];
    
    NSString * string;
    
    for (int i = 0; i < array.count; i++) {
        
        if ([title isEqualToString:array[i]])
        {
            switch (i) {
                case 0:
                    string = @"nickName";
                    break;
                case 1:
                    string = @"name";
                    break;
                case 2:
                    string = @"tel";
                    break;
                case 3:
                    string = @"gender";
                    break;
                case 4:
                    string = @"hobby";
                    break;
                    
                default:
                    break;
            }
        }
    }
    
   
    string = [NSString stringWithFormat:@"user.%@",string];
    
    string = [self valueForKeyPath:string];
    
    return string;
}


-(void)setInfoWithTitle:(NSString *)title content:(NSString *)content{
 
     NSArray * array = @[@"昵称",@"真实姓名",@"手机号",@"性别",@"爱好"];
    
    NSString * key;
    
    for (int i = 0; i < array.count; i++) {
        
        if ([title isEqualToString:array[i]]) {
            
            switch (i) {
                case 0:
                     key = @"nickName";
                    break;
                case 1:
                     key = @"name";
                    break;
                case 2:
                     key = @"tel";
                    break;
                case 3:
                     key = @"gender";
                    break;
                case 4:
                     key = @"hobby";
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    
    key = [NSString stringWithFormat:@"user.%@",key];
    
    [self setValue:content forKeyPath:key];
}

@end
