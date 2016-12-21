//
//  SDYCommunityInfo.m
//  sdy
//
//  Created by Bode Smile on 14-9-30.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYCommunityInfo.h"
#import "SDYHTTPManager.h"
#import "SDYAccountManager.h"

#define kCommunityInfoCommCodeKey @"kCommunityInfoCommCodeKey"
#define kCommunityInfoHouseMapKey @"kCommunityInfoHouseMapKey"
#define kCommunityInfoInfoKey @"kCommunityInfoInfoKey"
#define kCommunityInfoEstateKey @"kCommunityInfoEstateKey"
#define kCommunityInfoAddressKey @"kCommunityInfoAddressKey"

@implementation SDYCommunityInfo

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.commCode forKey:kCommunityInfoCommCodeKey];
    [coder encodeObject:self.houseMap forKey:kCommunityInfoHouseMapKey];
    [coder encodeObject:self.info forKey:kCommunityInfoInfoKey];
    [coder encodeObject:self.estate forKey:kCommunityInfoEstateKey];
    [coder encodeObject:self.address forKey:kCommunityInfoAddressKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _commCode = [coder decodeObjectForKey:kCommunityInfoCommCodeKey];
        _houseMap = [coder decodeObjectForKey:kCommunityInfoHouseMapKey];
        _info = [coder decodeObjectForKey:kCommunityInfoInfoKey];
        _estate = [coder decodeObjectForKey:kCommunityInfoEstateKey];
        _address = [coder decodeObjectForKey:kCommunityInfoAddressKey];
    }
    return self;
}

-(BOOL)loadInfoWithCommunityCode:(NSString*)commCode{
    NSDictionary* infodata = [SDYHTTPManager api_queryCommunity:_TOKEN withInfo:@{@"commCode":commCode}];
    NSDictionary* comminfo;
    NSDictionary* estateinfo;
    NSDictionary* addressdata;
    if(infodata && [[infodata objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        comminfo = infodata[@"community"];
        estateinfo = infodata[@"estate"];
        addressdata = infodata[@"addressdata"];
    }
    else{
        return NO;
    }
    self.commCode = commCode;
    self.info = comminfo;
    self.estate = estateinfo;
    self.address = addressdata;
    return YES;
}

// 用于加载userinfo中的小区信息
- (BOOL)loadInfoWithCommunityCode:(NSString*)commCode inCommunities:(NSArray*)communities {
    for (NSDictionary* community in communities) {
        NSDictionary* comminfo;
        NSDictionary* estateinfo;
        NSDictionary* addressdata;
        
        comminfo = community[@"cmnCommunity"];
        estateinfo = community[@"estate"];
        addressdata = community[@"addressdata"];
        
        if ([comminfo[@"commCode"] isEqualToString:commCode]) {
            self.commCode = commCode;
            self.info = comminfo;
            self.estate = estateinfo;
            self.address = addressdata;
            
            return YES;
        }
    }
    return NO;
}

- (BOOL)loadWithCommunityCode:(NSString*)commCode {
    NSDictionary* infodata = [SDYHTTPManager api_queryCommunity:_TOKEN withInfo:@{@"commCode":commCode}];
    NSDictionary* comminfo;
    NSDictionary* estateinfo;
    NSDictionary* addressdata;
    if(infodata && [[infodata objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        comminfo = infodata[@"community"];
        estateinfo = infodata[@"estate"];
        addressdata = infodata[@"addressdata"];
    }
    else{
        return NO;
    }
    NSDictionary* data = [SDYHTTPManager api_queryHouseByComm:_TOKEN withInfo:@{@"commCode":commCode}];
    if (data && [data[@"errorCode"] isEqualToString:@"00000000"]){
        self.commCode = commCode;
        self.houseMap = data[@"houseMap"];
        self.info = comminfo;
        self.estate = estateinfo;
        self.address = addressdata;
        return YES;
    }
    else {
        return NO;
    }
}

- (NSString*)getAddressString {
    __autoreleasing NSMutableString* result;
    NSString *cityName, *district, *addressLine;
    
    result = [[NSMutableString alloc] init];
    cityName = self.address[@"cityName"];
    district = self.address[@"district"];
    addressLine = self.address[@"addressLine"];
    
    if (cityName) {
        [result appendFormat:@"%@市", cityName];
    }
    
    if (district) {
        [result appendFormat:@"%@区", district];
    }
    
    if (addressLine) {
        [result appendString:addressLine];
    }
    
    return result;
}

- (NSString*)getFullAddressString {
    __autoreleasing NSMutableString* result;
    NSString * stateName, *cityName, *district, *addressLine;
    
    result = [[NSMutableString alloc] init];
    stateName = self.address[@"stateName"];
    cityName = self.address[@"cityName"];
    district = self.address[@"district"];
    addressLine = self.address[@"addressLine"];
    
    if (stateName) {
        [result appendFormat:@"%@省", stateName];
    }
    
    if (cityName) {
        [result appendFormat:@"%@市", cityName];
    }
    
    if (district) {
        [result appendFormat:@"%@区", district];
    }
    
    if (addressLine) {
        [result appendString:addressLine];
    }
    
    return result;
}

//一级列表
//-(NSArray*)allTowerNo{
//  if(self.houseMap){
//    return self.houseMap.allKeys;
//  }
//  return nil;
//}
//
//二级列表
//-(NSArray*)allRoomNo:(NSString*)towerno{
//  if(self.houseMap){
//    NSArray* houses = self.houseMap[towerno];
//    __autoreleasing NSMutableArray* result = [[NSMutableArray alloc] init];
//    for (NSDictionary* house in houses) {
//      [result addObject:house[@"houseNo"]];
//    }
//    return result;
//  }
//  return nil;
//}

//-(NSString*)getHouseCode:(NSString*)towerno roomNo:(NSString*)roomno{
//  if(self.houseMap){
//    NSArray* houses = self.houseMap[towerno];
//    for (NSDictionary* house in houses) {
//      if([house[@"houseNo"] isEqualToString:roomno])
//        return house[@"houseCode"];
//    }
//    return nil;
//  }
//  return nil;
//}

- (NSDictionary*)getHouseInfoWithTowerNo:(NSString*)towerNo unitNo:(NSString*)unitNo roomNo:(NSString*)roomNo {
    if(self.houseMap){
        NSArray* houses = self.houseMap[towerNo];
        for (NSDictionary* house in houses) {
            if([house[@"houseNo"] isEqualToString:roomNo] && [house[@"unitNo"] isEqualToString:unitNo])
                return house;
        }
        return nil;
    }
    return nil;
}
@end
