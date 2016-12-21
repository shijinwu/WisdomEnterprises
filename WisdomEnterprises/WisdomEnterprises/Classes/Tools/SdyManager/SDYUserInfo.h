//
//  SDYUserInfo.h
//  sdy
//
//  Created by Bode Smile on 14-9-8.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const TSAddressInfoKeyLine1;
extern NSString* const TSAddressInfoKeyLine2;


@class SDYCommunityInfo;

@interface SDYUserInfo : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSString* refreshToken;

@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSString* payPwdSetInd;
@property (strong, nonatomic) NSDictionary* customer;
@property (strong, nonatomic) NSMutableDictionary* user;
@property (strong, nonatomic) NSDictionary* scope;
@property (strong, nonatomic) NSArray* interestInfoList;

@property (strong, nonatomic) NSDictionary* estateEmp;

@property (strong, nonatomic) NSArray* addrInfos;
@property (strong, nonatomic) NSArray* addAddressInfos;

@property (strong, nonatomic) NSMutableDictionary* commInfos;
@property (strong, nonatomic) NSMutableDictionary* commAddressInfos;


-(NSDictionary*)getDefaultAddress;
/**
 * 获取完整的地址
 */
-(NSString*)getDefaultAddressString;
/**
 * 省市区
 */
- (NSString*)getDefaultAddressLine1;
/**
 * 街道地址
 */
- (NSString*)getDefaultAddressLine2;
-(NSString*)getDefaultHouseCode;
-(NSString*)getDefaultCommCode;
- (SDYCommunityInfo*)getDefaultCommInfo;
-(NSArray*)getAddressList;
-(NSArray*)getComAddressList;
-(NSString*)getInterestInfoString;
-(NSInteger)getPayPwdInd;//(0-密码 1-免密 2-touchid)

-(void)setAddrInfos:(NSArray *)addrInfos;
// 加载userinfo中的地址和小区信息
- (void)setAddrInfos:(NSArray *)addrInfos andCommunities:(NSArray*)communities;

@property (nonatomic,assign)BOOL isImage;

//商品图片显示设置
-(void)editImageShow:(BOOL)isImage;

//获取商品图片显示的类型
-(BOOL)getImageShowStyle;

@end
