//
//  InfoManager.h
//  WisdomEnterprises
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define  Week_Self(copy_self)  __weak typeof(self) copy_self = self;
@interface InfoManager : NSObject

@property (nonatomic,strong)User * user;

+(instancetype)shareManager;

/*上传图片*/
-(void)uploadImageWithImage:(NSData *)imageData completion:(void(^)(BOOL success,NSString * url))completion;

/*保存学生信息*/
-(void)setUserInfocompletion:(void(^)(BOOL success))completion;

-(NSString *)getInfowithTitle:(NSString *)title;

-(void)setInfoWithTitle:(NSString *)title content:(NSString *)content;
@end
