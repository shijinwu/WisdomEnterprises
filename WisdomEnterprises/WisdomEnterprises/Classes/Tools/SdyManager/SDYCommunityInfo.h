//
//  SDYCommunityInfo.h
//  sdy
//
//  Created by Bode Smile on 14-9-30.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDYCommunityInfo : NSObject
<NSCoding>

@property (strong, nonatomic) NSString* commCode;
@property (strong, nonatomic) NSDictionary* houseMap;
@property (strong, nonatomic) NSDictionary* info;
@property (strong, nonatomic) NSDictionary* estate;
@property (strong, nonatomic) NSDictionary* address;

//-(BOOL)loadWithHouseCode:(NSString*)houseCode;
-(BOOL)loadInfoWithCommunityCode:(NSString*)commCode;
// 用于加载userinfo中的小区信息
- (BOOL)loadInfoWithCommunityCode:(NSString*)commCode inCommunities:(NSArray*)communities;
-(BOOL)loadWithCommunityCode:(NSString*)commCode;

-(NSString*)getAddressString;// 不包含省
- (NSString*)getFullAddressString;// 包含省

//-(NSArray*)allTowerNo;
//-(NSArray*)allRoomNo:(NSString*)towerno;
- (NSDictionary*)getHouseInfoWithTowerNo:(NSString*)towerNo unitNo:(NSString*)unitNo roomNo:(NSString*)roomNo;
@end
