//
//  SDYEnvironment.h
//  sdy
//
//  Created by Bode Smile on 14-9-9.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEVICEENV.h"

#define ENVDICT_GetNameFromID(_dict,_id) ([[SDYEnvironment environment] getNameFromID:(_id) dictionaryId:(_dict)])
#define ENVDICT_GetAllName(_dict,_id) ([[SDYEnvironment environment] getAllName:(_id) dictionaryId:(_dict)])

#define SmsCodeCountDown @"SmsCode"
#define SmsCodeCountDownTime 60

#define Key_WelcomeVersion @"welcomeVersion"
#define Value_WelcomeVersion @11

#ifdef ALPHA_TEST
  #define CHECK_FIRST_LOGIN YES
#else
  #define CHECK_FIRST_LOGIN YES
#endif


typedef enum {
  SDYPasswordTypeLogin = 0,
  SDYPasswordTypeLoginSudoku,
  SDYPasswordTypePay,
  SDYPasswordPayBack
}SDYPasswordType;

@interface SDYEnvironment : NSObject

+(SDYEnvironment*)environment;

-(void)initAll;

#pragma mark 文件地址
-(NSString*)userIconPath:(NSString*)userid;
-(NSString*)downloadImagePath:(NSString*)fileName;

#pragma mark 配置字符串
-(void)initConfigString;
-(NSString*)getConfigString:(NSString*)key;
+ (NSString*)appURL;

#pragma mark 字典信息
-(void)initDictionary;
-(NSArray*)allNames:(NSString*)dictId;
-(NSString*)getNameFromID:(NSString*)_id dictionaryId:(NSString*)dictId;
-(NSString*)getIDFromName:(NSString*)name dictionaryId:(NSString*)dictId;
-(NSMutableArray *)getAllName:(NSString *)Id dictionaryId:(NSString*)dictId;

#pragma mark 快递列表信息
-(void)initExpressComList;
-(NSArray*)allExpressComNames;
-(NSString*)getExpressComNameFromCode:(NSString*)code;
-(NSString*)getExpressComCodeFromName:(NSString*)name;
-(NSString*)getExpressComTypeFromName:(NSString*)name;

-(NSArray*)getOutExpressComs:(NSString*)commCode;

#pragma mark 地点信息
-(void)myLocation:(completion_with_array)completion;

#pragma mark 二维码
-(UIImage*)createQRCodeFromString:(NSString *)qrString withSize:(CGFloat) size;

#pragma mark 倒计时
-(int)countDown:(NSString*)key;
-(int)resetCountDown:(NSString*)key forTime:(int)second;
@end
