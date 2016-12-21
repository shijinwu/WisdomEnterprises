//
//  SDYEnvironment.m
//  sdy
//
//  Created by Bode Smile on 14-9-9.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYEnvironment.h"
#import <CoreLocation/CoreLocation.h>
#import "DEVICEENV.h"
#import "SDYHTTPManager.h"
#import "SDYAccountManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

SDYEnvironment* environment;

@interface SDYEnvironment()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) completion_with_array locationCompletion;
@property (strong, nonatomic) NSMutableDictionary* dictionary;
@property (strong, nonatomic) NSMutableDictionary* configStringList;
@property (strong, nonatomic) NSMutableDictionary* expressComList;
@property (strong, nonatomic) NSMutableDictionary* countDownList;
@property (strong, nonatomic) NSMutableDictionary* outExpressComs;

@end

@implementation SDYEnvironment

+(SDYEnvironment*)environment{
    if(!environment){
        environment = [[SDYEnvironment alloc] init];
    }
    return environment;
}

-(id)init{
    if (self = [super init]){
        self.countDownList = [[NSMutableDictionary alloc] init];
        self.outExpressComs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)initAll{
    [self initDictionary];
    [self initConfigString];
}

#pragma mark 文件地址

-(NSString*)userIconPath:(NSString*)userid{
    //NSString* documents = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex: 0];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString* fullpath = [cachesDir stringByAppendingPathComponent:@"UICON"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* iconPath = [fullpath stringByAppendingPathComponent:userid];
    //  if (![[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
    //    iconPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"png"];
    //  }
    return iconPath;
}

-(NSString*)downloadImagePath:(NSString*)fileName
{
    //NSString* documents = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex: 0];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString* fullpath = [cachesDir stringByAppendingPathComponent:@"IMAGE"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullpath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* iconPath = [fullpath stringByAppendingPathComponent:fileName];
    NSLog(@"%@",iconPath);
    return iconPath;
}

#pragma mark 配置字符串

-(void)initConfigString{
    if (!_UserId) {
        return;
    }
    if(!self.configStringList){
        self.configStringList = [[NSMutableDictionary alloc] init];
        NSDictionary* data;
        data = [SDYHTTPManager system_appUrl:@{@"userid":_UserId}];
        if(data && [[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
            NSArray* systemLinkList = data[@"systemLinkList"];
            if([systemLinkList count]>0){
//#ifdef DEBUG
//                NSLog(@"配置字符串 : appUrl - %@",systemLinkList[0][@"linkUrl"]);
//                NSLog(@"配置字符串 : linkDesc - %@",systemLinkList[0][@"linkDesc"]);
//#endif
                for (NSDictionary* link in systemLinkList) {
                    NSNumber* linkCode = link[@"linkCode"];
                    // linkCode 1是android，2是iOS
                    if (linkCode && linkCode.intValue == 2) {
                        [self.configStringList setObject:_CHECK_NIL(link[@"linkUrl"]) forKey:@"appUrl"];
                        [self.configStringList setObject:_CHECK_NIL(link[@"linkDesc"]) forKey:@"linkDesc"];
                    }
                }
            }
        }
    }
}

- (NSString*)getConfigString:(NSString*)key{
    if(!self.configStringList){
        [[SDYEnvironment environment] initConfigString];
    }
    return [self.configStringList objectForKey:key];
}

+ (NSString*)appURL {
    NSString* appURL = [[SDYEnvironment environment] getConfigString:@"appUrl"];
    if (!appURL) {
        appURL = [[NSBundle mainBundle] infoDictionary][@"App URL"];
    }
    if (!appURL) {
        appURL = @"http://tszhijun.com:8081/app/download/";
    }
    return appURL;
}

#pragma mark 字典信息

- (void)initDictionary {
    if (!self.dictionary) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        NSString* allKeys = @"sex,pwdType,stateName,cityName,interestGrp,employInfo,serviceType,expOutStatus,expInStatus,woType,workOrderStatus,expInConfirmType,orderType,orderStatus,receiveType,merStatus,merchantClass,goodsType";
        
        NSDictionary* data;
        data = [SDYHTTPManager api_dictItemLists:_TOKEN withInfo:@{@"dicts":allKeys}];
        if (data && [[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
            NSDictionary* dicts = [data objectForKey:@"dictMap"];
            for (NSArray* items in [dicts allValues]) {
                if (items && [items count]>0){
                    for (NSDictionary* item in items) {
                        NSArray* ditem = @[item[@"id"][@"id"],item[@"name"]];
#ifdef DEBUG
                        NSLog(@"字典项 : (%@)  %@ - %@",item[@"id"][@"dictId"],item[@"id"][@"id"],item[@"name"]);
#endif
                        if (!dict[item[@"id"][@"dictId"]]){
                            dict[item[@"id"][@"dictId"]] = [[NSMutableArray alloc] init];
                        }
                        [dict[item[@"id"][@"dictId"]] addObject:ditem];
                    }
                }
                else {
                    NSLog(@"请求字典项返回为空，请检查服务器配置：%@",allKeys);
                }
            }
        }
        else {
            NSLog(@"请求字典项错误：%@ (%@:%@)",allKeys,[data objectForKey:@"errorCode"],[data objectForKey:@"errorMsg"]);
        }
        
        self.dictionary = dict;
    }
}

- (NSArray*)allNames:(NSString*)dictId {
    if (!self.dictionary) {
        [[SDYEnvironment environment] initDictionary];
    }
    
    if (self.dictionary) {
        NSArray* items = self.dictionary[dictId];
        if (items) {
            __autoreleasing NSMutableArray* result = [[NSMutableArray alloc] init];
            for (NSArray* item in items) {
                [result addObject:item[1]];
            }
            return result;
        }
    }
    else {
        NSLog(@"请求字典项没有找到，请检查服务器配置：%@",dictId);
    }
    return nil;
}

-(NSString*)getNameFromID:(NSString*)_id dictionaryId:(NSString*)dictId{
    if(!self.dictionary){
        [[SDYEnvironment environment] initDictionary];
    }
    
    if(self.dictionary){
        NSArray* items = self.dictionary[dictId];
        if (items) {
            for (NSArray* item in items) {
                if ([item[0] isEqualToString:_id]) {
                    return item[1];
                }
            }
        }
    }
    else{
        NSLog(@"请求字典项没有找到，请检查服务器配置：%@",dictId);
    }
    return @"";
}
-(NSMutableArray *)getAllName:(NSString *)Id dictionaryId:(NSString*)dictId
{
    NSMutableArray *merchantType=[[NSMutableArray alloc]init];
    if(!self.dictionary)
    {
        [[SDYEnvironment environment] initDictionary];
    }
    
    if(self.dictionary)
    {
        NSArray* items = self.dictionary[dictId];
        
        if (items)
        {
            for (NSArray* item in items)
            {
                NSString *type=[item[0] substringWithRange:NSMakeRange(0,1)];
                if ([type isEqualToString:Id])
                {
                    [merchantType addObject:item[1]];
                }
                
            }
            
        }
    }
    else{
        NSLog(@"请求字典项没有找到，请检查服务器配置：%@",dictId);
    }
    return merchantType;
}
-(NSString*)getIDFromName:(NSString*)name dictionaryId:(NSString*)dictId{
    if(!self.dictionary){
        [[SDYEnvironment environment] initDictionary];
    }
    
    if(self.dictionary){
        NSArray* items = self.dictionary[dictId];
        if (items) {
            for (NSArray* item in items) {
                if ([item[1] isEqualToString:name]) {
                    return item[0];
                }
            }
        }
    }
    else{
        NSLog(@"请求字典项没有找到，请检查服务器配置：%@",dictId);
    }
    return nil;
}

#pragma mark 快递列表信息

-(void)initExpressComList{
    if(!self.expressComList){
        [self showProgressHUD:@"获取快递公司列表" whileExecutingBlock:^{
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            NSDictionary* data;
            data = [SDYHTTPManager api_queryAllExpCom:_TOKEN withInfo:@{@"expressCode":@""}];
            if(data && [[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
                NSArray* items = [data objectForKey:@"expComList"];
                if(items && [items count]>0){
                    for (NSDictionary* item in items) {
                        NSArray* ditem = @[item[@"expClass"],item[@"expCorpName"],item[@"expCorpCode"]];
                        [dict setObject:ditem forKey:item[@"expCorpCode"]];
                    }
                }
                else{
                    NSLog(@"请求快递列表返回为空，请检查服务器配置");
                }
            }
            else{
                NSLog(@"请求快递列表错误(%@:%@)",[data objectForKey:@"errorCode"],[data objectForKey:@"errorMsg"]);
            }
            self.expressComList = dict;
        } completionBlock:^{
        }];
    }
}

-(NSArray*)allExpressComNames{
    if(!self.expressComList){
        [[SDYEnvironment environment] initExpressComList];
    }
    
    if(self.expressComList){
        NSArray* items = self.expressComList.allValues;
        if (items) {
            __autoreleasing NSMutableArray* result = [[NSMutableArray alloc] init];
            for (NSArray* item in items) {
                [result addObject:item[1]];
            }
            return result;
        }
    }
    else{
        NSLog(@"请求快递列表没有找到，请检查服务器配置");
    }
    return nil;
}

-(NSString*)getExpressComNameFromCode:(NSString*)code{
    if(!self.expressComList){
        [[SDYEnvironment environment] initExpressComList];
    }
    
    if(self.expressComList){
        NSArray* item = self.expressComList[code];
        if(item)
            return item[1];
    }
    else{
        NSLog(@"请求快递列表没有找到，请检查服务器配置");
    }
    return nil;
}

-(NSString*)getExpressComCodeFromName:(NSString*)name{
    if(!self.expressComList){
        [[SDYEnvironment environment] initExpressComList];
    }
    
    if(self.expressComList){
        NSArray* items = self.expressComList.allValues;
        if (items) {
            for (NSArray* item in items) {
                if ([item[1] isEqualToString:name]) {
                    return item[2];
                }
            }
        }
    }
    else{
        NSLog(@"请求快递列表没有找到，请检查服务器配置");
    }
    return nil;
}

-(NSString*)getExpressComTypeFromName:(NSString*)name{
    if(!self.expressComList){
        [[SDYEnvironment environment] initExpressComList];
    }
    
    if(self.expressComList){
        NSArray* items = self.expressComList.allValues;
        if (items) {
            for (NSArray* item in items) {
                if ([item[1] isEqualToString:name]) {
                    return item[0];
                }
            }
        }
    }
    else{
        NSLog(@"请求快递列表没有找到，请检查服务器配置");
    }
    return nil;
}

-(NSArray*)getOutExpressComs:(NSString*)commCode{
    if(self.outExpressComs[commCode])
        return self.outExpressComs[commCode];
    else{
        NSDictionary* data;
        data = [SDYHTTPManager api_expOutCompanyList:_TOKEN withInfo:@{@"commonCode":commCode}];
        if(data && [[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
            self.outExpressComs[commCode] = data[@"expExpressCompanyList"];
        }
        return self.outExpressComs[commCode];
    }
}

#pragma mark 地点信息

-(void)myLocation:(completion_with_array)completion{
    self.locationCompletion = completion;
    if(!self.locationManager){
        CLLocationManager* loc = [[CLLocationManager alloc] init];
        self.locationManager = loc;
        if(IOS8){
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:500];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = locations[0];
    NSLog(@"%@",location);
    if(location && self.locationCompletion){
        self.locationCompletion(locations);
        [manager stopUpdatingLocation];
        self.locationCompletion = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    if(self.locationCompletion){
        [manager stopUpdatingLocation];
        self.locationCompletion = nil;
    }
}

#pragma mark MBProgressHUD
-(void)showProgressHUD:(NSString*)title whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:navController.visibleViewController.view];
    [navController.visibleViewController.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = title;
    [HUD showAnimated:YES whileExecutingBlock:block completionBlock:^{
        [HUD removeFromSuperview];
        completion();
    }];
}

#pragma mark 二维码

-(UIImage*)createQRCodeFromString:(NSString *)qrString withSize:(CGFloat) size{
    if(IOS7){
        CIImage* ciimage = [self createQRForString:qrString];
        return [self createNonInterpolatedUIImageFormCIImage:ciimage withSize:size];
    }
    else{
        return nil;
    }
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage* returnImage = [UIImage imageWithCGImage:scaledImage];
    
    // 释放
    CGColorSpaceRelease(cs);
    CGImageRelease(scaledImage);
    
    return returnImage;
}

#pragma mark 倒计时

-(int)countDown:(NSString*)key{
    NSNumber* t = self.countDownList[key];
    if(t){
        int cd = [t longValue]-time(0);
        if(cd>0)
            return cd;
        return 0;
    }
    return 0;
}

-(int)resetCountDown:(NSString*)key forTime:(int)second{
    [self.countDownList setObject:[NSNumber numberWithLong:time(0)+second] forKey:key];
    return second;
}

@end
