//
//  SDYUserInfo.m
//  sdy
//
//  Created by Bode Smile on 14-9-8.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYUserInfo.h"
#import "SDYEnvironment.h"
#import "SDYCommunityInfo.h"
#import "JNKeychain.h"
NSString* const TSAddressInfoKeyLine1 = @"line1";
NSString* const TSAddressInfoKeyLine2 = @"line2";

#define Key_imageShowStyle @"imageShowStyle"

@implementation SDYUserInfo

-(NSDictionary*)getDefaultAddress
{
    for (NSDictionary* info in self.addrInfos) {
        if([info[@"defaultInd"] isEqualToString:@"Y"])
            return info;
    }
    return (self.addrInfos&&[self.addrInfos count]>0)?[self.addrInfos objectAtIndex:0]:nil;
}

-(NSString*)getDefaultHouseCode{
    NSDictionary* address = [self getDefaultAddress];
    if(address){
        return address[@"houseCode"];
    }
    return @"";
}

-(NSString*)getDefaultCommCode{
    NSDictionary* address = [self getDefaultAddress];
    if(address){
        return address[@"commCode"];
    }
    return @"";
}

- (SDYCommunityInfo*)getDefaultCommInfo {
    NSString* commCode = [self getDefaultCommCode];
    return self.commInfos[commCode];
}

- (NSArray*)getAddressList
{
    __autoreleasing NSMutableArray* result = [[NSMutableArray alloc] init];
    
    for (NSDictionary* info in self.addrInfos)
    {
        SDYCommunityInfo* commInfo = self.commInfos[info[@"commCode"]];
        NSString* line1 = [commInfo getFullAddressString];
        NSString* line2 = [self houseInfoWithDictionary:info];
        
        NSString *commcode = info[@"commCode"];
        NSString *houseInfo = [NSString stringWithFormat:@"%@ %@栋%@单元%@室", info[@"commName"], info[@"towerNo"], info[@"unitNo"], info[@"houseNo"]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *str = houseInfo;
        if (commInfo) {
            str = [NSString stringWithFormat:@"%@%@",[commInfo getAddressString], houseInfo];
        }
        
        [dic setValue:commcode forKey:@"key"];
        [dic setValue:str forKey:@"value"];
        if (line1) {
            dic[TSAddressInfoKeyLine1] = line1;
        }
        
        if (line2) {
            dic[TSAddressInfoKeyLine2] = line2;
        }
        
        [result addObject:dic];
    }
    
    return result;
}

- (NSArray*)getComAddressList
{
    __autoreleasing NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSDictionary* info in self.addAddressInfos)
    {
        // NSString *commcode=info[@"addrCode"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        NSString *str=[NSString stringWithFormat:@"%@%@ %@%@",info[@"stateName"],info[@"cityName"],info[@"district"],info[@"addressLine"]];
        // [dic setValue:commcode forKey:@"key"];
        [dic setValue:str forKey:@"value"];
        [result addObject:dic];
    }
    return result;
}

/**
 * 获取完整的地址
 */
- (NSString*)getDefaultAddressString {
    NSDictionary* info = [self getDefaultAddress];
    if (info) {
        NSString* houseInfo = [NSString stringWithFormat:@"%@ %@栋%@单元%@室", info[@"commName"], info[@"towerNo"], info[@"unitNo"], info[@"houseNo"]];
        SDYCommunityInfo* commInfo = self.commInfos[info[@"commCode"]];
        if(commInfo){
            return [NSString stringWithFormat:@"%@%@",[commInfo getAddressString], houseInfo];
        }
        else
            return houseInfo;
    }
    return nil;
}

/**
 * 省市区
 */
- (NSString*)getDefaultAddressLine1 {
    NSDictionary* info = [self getDefaultAddress];
    if (info) {
        SDYCommunityInfo* commInfo = self.commInfos[info[@"commCode"]];
        if (commInfo) {
            return [commInfo getFullAddressString];
        }
    }
    
    return nil;
}

- (NSString*)houseInfoWithDictionary:(NSDictionary*)dict {
    if (dict) {
        NSMutableString* houseInfo = [NSMutableString new];
        NSString *commName, *towerNo, *unitNo, *houseNo;
        
        commName = dict[@"commName"];
        towerNo = dict[@"towerNo"];
        unitNo = dict[@"unitNo"];
        houseNo = dict[@"houseNo"];
        
        if (commName) {
            [houseInfo appendString:commName];
        }
        
        if (towerNo) {
            [houseInfo appendFormat:@"%@栋", towerNo];
        }
        
        if (unitNo) {
            [houseInfo appendFormat:@"%@单元", unitNo];
        }
        
        if (houseNo) {
            [houseInfo appendFormat:@"%@室", houseNo];
        }
        
        return houseInfo;
    }
    
    return nil;
}

/**
 * 街道地址
 */
- (NSString*)getDefaultAddressLine2 {
    NSDictionary* info = [self getDefaultAddress];
    return [self houseInfoWithDictionary:info];
}

-(NSString*)getInterestInfoString{
    __autoreleasing NSMutableString* result = [[NSMutableString alloc] init];
    for (NSDictionary *iInfo in self.interestInfoList) {
        [result appendFormat:@"%@ ",ENVDICT_GetNameFromID(@"interestGrp",[iInfo objectForKey:@"interestgrpId"])];
    }
    return result;
}

-(NSInteger)getPayPwdInd{
    if([self.user[@"payPwdInd"] isEqualToString:@"Y"])
        return 1;
    return 0;
}

-(void)setAddrInfos:(NSArray *)addrInfos{
    _addrInfos = addrInfos;
    if(!self.commInfos)
        self.commInfos = [[NSMutableDictionary alloc] init];
    for (NSDictionary* info in self.addrInfos) {
        NSString *commCode = info[@"commCode"];
        if(![self.commInfos objectForKey:commCode]){
            SDYCommunityInfo* commInfo = [[SDYCommunityInfo alloc] init];
            if([commInfo loadInfoWithCommunityCode:commCode]){
                [self.commInfos setObject:commInfo forKey:commCode];
            }
        }
    }
}

// 加载userinfo中的地址和小区信息
- (void)setAddrInfos:(NSArray *)addrInfos andCommunities:(NSArray*)communities {
    _addrInfos = addrInfos;
    if(!self.commInfos)
        self.commInfos = [[NSMutableDictionary alloc] init];
    for (NSDictionary* info in self.addrInfos) {
        NSString *commCode = info[@"commCode"];
        if(![self.commInfos objectForKey:commCode]){
            SDYCommunityInfo* commInfo = [[SDYCommunityInfo alloc] init];
            if([commInfo loadInfoWithCommunityCode:commCode inCommunities:communities]){
                [self.commInfos setObject:commInfo forKey:commCode];
            }
        }
    }
}


// 关于图片显示类型的设置
-(void)editImageShow:(BOOL)isImage
{
    
    self.isImage = isImage;
    [JNKeychain saveValue:@(isImage) forKey:Key_imageShowStyle];
}
-(BOOL)getImageShowStyle
{
    
    NSNumber * number = [JNKeychain loadValueForKey:Key_imageShowStyle];
    
    if (number == nil)
    {
        self.isImage = NO;
        return NO;
    }
    
    self.isImage = number.boolValue;
    return  number.boolValue;
}

@end
