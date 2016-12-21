//
//  SDYHTTPManager.m
//  sdy
//
//  Created by BodeMeng on 14-9-15.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYHTTPManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "BODEJSON.h"
#import "SDYSecurityManager.h"
#import "SDYAccountManager.h"
#import "DEVICEENV.h"

#ifdef ALPHA_TEST
//    #define SERVER_URL @"http://123.56.196.118:8081/estate-web" // hp test
    #define SERVER_URL @"http://www.tszhijun.com:8081/estate-web"
#else
    #define SERVER_URL @"http://www.tszhijun.com:8081/estate-web"
#endif

#define REQUEST_TIMEOUT_SECONDS 20
#define HTTPDETAILLOG YES

SDYHTTPManager* HTTPManager;
BOOL debug_mode = NO;

@implementation SDYHTTPManager

+ (SDYHTTPManager*)defaultManager
{
    if(!HTTPManager)
    {
        HTTPManager = [[SDYHTTPManager alloc] init];
    }
    return HTTPManager;
}

+ (void)setDebugMode:(BOOL)debug{
    debug_mode = debug;
}

- (id)init {
    if (self = [super init]){
        if (!networkQueue) {
            networkQueue = [[ASINetworkQueue alloc] init];
        }
        [networkQueue reset];
        //[networkQueue setDownloadProgressDelegate:progressIndicator];
        [networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
        [networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
        //    [networkQueue setShowAccurateProgress:[accurateProgress isOn]];
        [networkQueue setDelegate:self];
        [networkQueue go];
    }
    return self;
}

- (void)httpDownload:(NSString*)api withFilePath:(NSString*)path {
    ASIHTTPRequest *request;
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,api]]];
    [request setDownloadDestinationPath:path];
    [request setRequestMethod:@"POST"];
    if(HTTPDETAILLOG){
        NSLog(@"----HttpDownloadRequest(%@) : %@",request.requestMethod,request.url);
        if(path)
            NSLog(@"--------SavePath : %@",path);
    }
    //[request setUserInfo:[NSDictionary dictionaryWithObject:@"request1" forKey:@"name"]];
    [networkQueue addOperation:request];
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
    NSLog(@"%@ 下载完成",[request downloadDestinationPath]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FileDownloadCompletedNotification object:[[request downloadDestinationPath] lastPathComponent]];
    //  UIImage *img = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
    //  if (img) {
    //    if ([imageView1 image]) {
    //      if ([imageView2 image]) {
    //        [imageView3 setImage:img];
    //      } else {
    //        [imageView2 setImage:img];
    //      }
    //    } else {
    //      [imageView1 setImage:img];
    //    }
    //  }
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@ 下载失败",[request downloadDestinationPath]);
    //  if (!failed) {
    //    if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
    //      UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Download failed" message:@"Failed to download images" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    //      [alertView show];
    //    }
    //    failed = YES;
    //  }
}


+(NSDictionary*)httpRequest:(NSString*)api withInfo:(NSDictionary*)info
{
    return [self httpRequest:api withInfo:info sign:NO];
}

+(NSDictionary*)httpRequest:(NSString*)api withInfo:(NSDictionary*)info sign:(BOOL)sign
{
    return [self httpRequest:api withInfo:info sign:sign redoCount:0];
}

+(NSDictionary*)httpRequest:(NSString*)api withInfo:(NSDictionary*)info sign:(BOOL)sign redoCount:(int)redoCount
{
    ASIFormDataRequest* request=[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,api]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request setRequestMethod:info?@"POST":@"GET"];
    NSString *infoJson;
    // NSLog(@"我的测试info%@",info);
    if(info)//info
    {
        infoJson = [info toJSONString];
        [request setPostBody:[[infoJson dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
    }
    if(sign)//sign
    {
        //  NSLog(@"%@",api);
        //    NSArray* apiSlice =[api componentsSeparatedByString:@"?"];
        //     // NSLog(@"shuzu%@",apiSlice);
        //    NSMutableArray* paramSlice;
        //      //1 apiurl
        //        if([apiSlice count]>=2)
        //        {
        //          paramSlice = [[[apiSlice objectAtIndex:1] componentsSeparatedByString:@"&"] mutableCopy];
        //              for (NSUInteger i=0; i<[paramSlice count]; i++)
        //              {
        //                NSString* param = [paramSlice objectAtIndex:i];
        //                NSArray* paramPart = [param componentsSeparatedByString:@"="];
        //                if([paramPart count]!=2)
        //                  NSLog(@"API URL ERROR 1");
        //                [paramSlice setObject:[NSString stringWithFormat:@"%@=%@",[[paramPart objectAtIndex:0] lowercaseString],[paramPart objectAtIndex:1]] atIndexedSubscript:i];
        //               }
        //            NSLog(@"paramSlice%@",paramSlice);
        //        }
        //      //2
        //        if(!paramSlice)
        //          paramSlice = [[NSMutableArray alloc] init];
        //        if(infoJson)
        //        {
        //          [paramSlice addObject:[NSString stringWithFormat:@"content=%@",infoJson]];
        //        }
        //       paramSlice =[[paramSlice sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        //        {
        //           return [obj1 compare:obj2];
        //        }] mutableCopy];
        //        NSMutableString* wholeParam = [[NSMutableString alloc] init];
        //        for (NSString* param in paramSlice)
        //        {
        //          if([wholeParam length]>0)
        //            [wholeParam appendFormat:@"&%@",param];
        //          else
        //            [wholeParam appendString:param];
        //        }
        //        if(wholeParam)//
        //        {
        //          NSString* hashString = [[SDYSecurityManager defaultManager] hashString:wholeParam];
        //          [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&sign=%@",SERVER_URL,api,hashString]]];
        //        }
        //        else
        //        {
        //          NSLog(@"API URL ERROR 2");
        //        }
        // 后台不做校验
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&sign=%@",SERVER_URL,api,@"xxx"]]];
    }//sign
    
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:REQUEST_TIMEOUT_SECONDS];
    [request setResponseEncoding:NSUTF8StringEncoding];
    if(HTTPDETAILLOG)
    {
        NSLog(@"----HttpRequest(%@) : %@",request.requestMethod,request.url);
        if(infoJson)
            NSLog(@"--------HttpRequestPostInfo : %@",infoJson);
    }
    [request startSynchronous];
    __autoreleasing NSDictionary* json;
    
    NSError* error = [request error];
    if(error)
    {
        json = [[NSDictionary alloc] initWithObjectsAndKeys:error.localizedDescription,@"errorMsg",[NSString stringWithFormat:@"IOS%ld",(long)error.code],@"errorCode", nil];
    }
    else
    {
        NSString* responseData = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        json = [responseData toJSONObject];
        if(!json)
        {
            json = [[NSDictionary alloc] initWithObjectsAndKeys:@"Parse Json Error",@"errorMsg",[NSString stringWithFormat:@"IOS%d",-1000],@"errorCode", nil];
            if(HTTPDETAILLOG) {
                NSLog(@"responseStatusCode: %d", request.responseStatusCode);
                NSLog(@"HttpResponseString : %@",responseData);
            }
        }
    }
    if(HTTPDETAILLOG)
        NSLog(@"...HttpResponse : %@",json);
    if(redoCount==0 && [[json objectForKey:@"errorCode"] isEqualToString:@"BASE0003"] && [SDYAccountManager refreshToken])
    {
        return [self httpRequest:api withInfo:info sign:sign redoCount:redoCount+1];
    }
    return json;
}

#pragma mark - test
+(NSDictionary*)httpsRequest:(NSString*)api withInfo:(NSDictionary*)info
{
    ASIFormDataRequest* request=[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://huangweiqi.iego.cn:8443/estate-web",api]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request setRequestMethod:info?@"POST":@"GET"];
    NSString *infoJson;
    // NSLog(@"我的测试info%@",info);
    if(info)//info
    {
        infoJson = [info toJSONString];
        [request setPostBody:[[infoJson dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
    }
    
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:REQUEST_TIMEOUT_SECONDS];
    [request setResponseEncoding:NSUTF8StringEncoding];
    if(HTTPDETAILLOG)
    {
        NSLog(@"----HttpRequest(%@) : %@",request.requestMethod,request.url);
        if(infoJson)
            NSLog(@"--------HttpRequestPostInfo : %@",infoJson);
    }
    [request startSynchronous];
    __autoreleasing NSDictionary* json;
    
    NSError* error = [request error ];
    if(error)
    {
        json = [[NSDictionary alloc] initWithObjectsAndKeys:error.localizedDescription,@"errorMsg",[NSString stringWithFormat:@"IOS%ld",(long)error.code],@"errorCode", nil];
    }
    else
    {
        NSString* responseData = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        json=[responseData toJSONObject];
        if(!json)
        {
            json = [[NSDictionary alloc] initWithObjectsAndKeys:@"Parse Json Error",@"errorMsg",[NSString stringWithFormat:@"IOS%d",-1000],@"errorCode", nil];
            if(HTTPDETAILLOG)
                NSLog(@"HttpResponseString : %@",responseData);
        }
    }
    if(HTTPDETAILLOG)
        NSLog(@"...HttpResponse : %@",json);
    if(/*redoCount==0 && */[[json objectForKey:@"errorCode"] isEqualToString:@"BASE0003"] && [SDYAccountManager refreshToken])
    {
        //        return [self httpRequest:api withInfo:info sign:sign redoCount:redoCount+1];
        return [self httpsRequest:api withInfo:info];
    }
    return json;
}

#pragma mark -

+ (NSDictionary*)httpRequest:(NSString*)api withData:(NSData*)data redoCount:(int)redoCount{
    return [self httpRequest:api withData:data redoCount:redoCount imageExtension:@"png"];
}

+ (NSDictionary*)httpRequest:(NSString*)api withData:(NSData*)data redoCount:(int)redoCount imageExtension:(NSString*)extension {
    
    NSString* fileName = [@"file1" stringByAppendingPathExtension:extension];
    NSString* contentType = [@"image" stringByAppendingPathComponent:extension];
    ASIFormDataRequest* request=[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,api]]];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data; charset=utf-8"];
    [request setRequestMethod:@"POST"];
    [request setData:data withFileName:fileName andContentType:contentType forKey:@"file1"];
    [request setValidatesSecureCertificate:NO];
    //[request setDelegate:self];
    [request setTimeOutSeconds:REQUEST_TIMEOUT_SECONDS*4];
    [request setResponseEncoding:NSUTF8StringEncoding];
    if(HTTPDETAILLOG){
        NSLog(@"----HttpRequest(%@) : %@",request.requestMethod,request.url);
        if(data)
            NSLog(@"--------HttpRequestDataLength : %lu",(unsigned long)[data length]);
    }
    [request startSynchronous ];
    __autoreleasing NSDictionary* json;
    
    NSError* error = [request error ];
    if(error){
        json = [[NSDictionary alloc] initWithObjectsAndKeys:error.localizedDescription,@"errorMsg",[NSString stringWithFormat:@"IOS%ld",(long)error.code],@"errorCode", nil];
    }
    else{
        NSString* responseData = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        json=[responseData toJSONObject];
        if(!json){
            json = [[NSDictionary alloc] initWithObjectsAndKeys:@"Parse Json Error",@"errorMsg",[NSString stringWithFormat:@"IOS%d",-1000],@"errorCode", nil];
            if(HTTPDETAILLOG)
                NSLog(@"HttpResponseString : %@",responseData);
        }
    }
    if(HTTPDETAILLOG)
        NSLog(@"...HttpResponse : %@",json);
    if(redoCount==0 && [[json objectForKey:@"errorCode"] isEqualToString:@"BASE0003"] && [SDYAccountManager refreshToken]){
        return [self httpRequest:api withData:data redoCount:redoCount+1];
    }
    return json;
}

//2.2.1	获取密码传输
+(NSDictionary*)oauth_pwdKey{
    //  return [self httpRequest:@"/oauth/pwdKey" withInfo:nil];
    return @{@"errorCode": @"00000000", @"pwdKey": @"SuNlJnE+9sUnITs+9DesaEys"};
}

//2.2.2	获取授权码
+(NSDictionary*)oauth_authorize:(NSDictionary*)info{
    return [self httpRequest:@"/oauth/authorize" withInfo:info];
}

//2.2.3	获取AccessToken
//+(NSDictionary*)oauth_accessToken:(NSString*)code exUserId:(NSString*)exUserId{
//  return [self httpRequest:[NSString stringWithFormat:@"/oauth/accessToken?code=%@&exUserId=%@&device=2&vsn=%@",code,exUserId,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] withInfo:nil];
//}

// 新的登录接口。合并authorize与accessToken
+ (NSDictionary*)oauth_login:(NSDictionary*)info {
    return [self httpRequest:@"/oauth/login" withInfo:info];
}

//2.2.4	刷新AccessToken
+(NSDictionary*)oauth_refreshToken:(NSString*)token exUserId:(NSString*)exUserId{
    return [self httpRequest:[NSString stringWithFormat:@"/oauth/refreshToken?refreshToken=%@&exUserId=%@&device=2&vsn=%@",token,exUserId,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] withInfo:nil];
}

//3.1	用户注册
+(NSDictionary*)noauth_register:(NSDictionary*)info{
    return [self httpRequest:@"/noauth/register" withInfo:info];
}

//3.2	获取短信验证码
+(NSDictionary*)noauth_getSmsCode:(NSDictionary*)info{
    return [self httpRequest:@"/noauth/getSmsCode" withInfo:info];
}

//3.3	用户信息查询
+(NSDictionary*)api_queryUserInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryUserInfo",token] withInfo:info sign:YES];
}

//3.4	用户是否注册查询
+(NSDictionary*)noauth_checkReg:(NSDictionary*)info{
    return [self httpRequest:@"/noauth/checkReg" withInfo:info];
}

//3.5	用户信息修改
+(NSDictionary*)api_updateUserInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=updateUserInfo",token] withInfo:info sign:YES];
}

//3.6	收件人地址查询
+(NSDictionary*)api_queryAddrInfos:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryAddrInfos",token] withInfo:info sign:YES];
}

//3.7	收件人地址维护
+(NSDictionary*)api_saveAddrInfos:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=saveAddrInfos",token] withInfo:info sign:YES];
}

//3.8	用户余额查询
+(NSDictionary*)api_queryAcctBal:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryAcctBal",token] withInfo:info sign:YES];
}

//3.9	密码设置
+(NSDictionary*)api_userPwdSet:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=userPwdSet",token] withInfo:info sign:YES];
}

//3.10	密码重置
+(NSDictionary*)api_userPwdReset:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=userPwdReset",token] withInfo:info sign:YES];
}

//3.11	用户金融交易查询
+(NSDictionary*)api_queryFinanceTrxn:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryFinanceTrxn",token] withInfo:info sign:YES];
}

//3.12	用户店铺列表
+(NSDictionary*)api_queryUserMerchants:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryUserMerchants",token] withInfo:info sign:YES];
}

//3.13	店铺信息查询
+(NSDictionary*)api_queryMerchantInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryMerchantInfo",token] withInfo:info sign:YES];
}

//3.14	店铺商品列表
+(NSDictionary*)api_queryMerchantGoods:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryMerchantGoods",token] withInfo:info sign:YES];
}

//3.15	商品信息查询
+(NSDictionary*)api_queryGoodsInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryGoodsInfo",token] withInfo:info sign:YES];
}

//3.16	申请开店
+(NSDictionary*)api_applyShop:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=applyShop",token] withInfo:info sign:YES];
}

//3.17	用户订单查询
+(NSDictionary*)api_queryUserOrders:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryUserOrders",token] withInfo:info sign:YES];
}

//3.18	订单信息查询
+(NSDictionary*)api_queryOrderInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryOrderInfo",token] withInfo:info sign:YES];
}

//3.19	订单生成
+(NSDictionary*)api_genOrderInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=genOrderInfo",token] withInfo:info sign:YES];
}

//3.20	订单状态维护
+(NSDictionary*)api_updateOrderStatus:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=updateOrderStatus",token] withInfo:info sign:YES];
}

//3.21	订单信息维护
//+(NSDictionary*)api_updateOrderStatus:(NSString*)token withInfo:(NSDictionary*)info{
//  return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=updateOrderStatus",token] withInfo:info sign:YES];
//}

//3.22	工单生成
+(NSDictionary*)api_genWorkOrder:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=genWorkOrder",token] withInfo:info sign:YES];
}
//3.23	工单信息查询
+(NSDictionary*)api_queryWorkOrderInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryWorkOrderInfo",token] withInfo:info sign:YES];
}

//3.24	用户工单列表
+(NSDictionary*)api_queryWorkOrders:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryWorkOrders",token] withInfo:info sign:YES];
}

//3.25	工单状态维护
+(NSDictionary*)api_updateWorkOrderStatus:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=updateWorkOrderStatus",token] withInfo:info sign:YES];
}

//3.26	调查问卷填写
+(NSDictionary*)api_queryQuestionnaires:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryQuestionnaires",token] withInfo:info sign:YES];
}

//3.27	商户商品评价
+(NSDictionary*)api_evaluateMerchantGoods:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=evaluateMerchantGoods",token] withInfo:info sign:YES];
}

//3.28	附近小区查询
+(NSDictionary*)api_queryNearCommunity:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryNearCommunity",token] withInfo:info sign:YES];
}

//3.29	小区模糊查询
+(NSDictionary*)api_queryLikeCommunity:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryLikeCommunity",token] withInfo:info sign:YES];
}

//3.30	小区信息查询
+(NSDictionary*)api_queryCommunity:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryCommunity",token] withInfo:info sign:YES];
}

//3.31	字典项查询
+(NSDictionary*)api_dictItems:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=dictItems",token] withInfo:info sign:YES];
}

//3.32	多字典项查询
+(NSDictionary*)api_dictItemLists:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=dictItemLists",token] withInfo:info sign:YES];
}

//3.32	获取开换锁商家列表
//+(NSDictionary*)api_queryLikeCommunityTran:(NSString*)token withInfo:(NSDictionary*)info{
//  return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryLikeCommunityTran",token] withInfo:info sign:YES];
//}

//3.34	短信验证码校验
+(NSDictionary*)api_checkSmsIdCode:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=checkSmsIdCode",token] withInfo:info sign:YES];
}

//3.35	员工-代收快递录入（接收快递）
+(NSDictionary*)api_empExpIn:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=empExpIn",token] withInfo:info sign:YES];
}

//3.36	获取代收快递列表
+(NSDictionary*)api_queryExpInList:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryExpInList",token] withInfo:info sign:YES];
}

//3.37	代收快递派送请求
+(NSDictionary*)api_sendExpIn:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=sendExpIn",token] withInfo:info sign:YES];
}

//3.38	代收快递派送确认收到
+(NSDictionary*)api_makeSureSendExpIn:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=makeSureSendExpIn",token] withInfo:info sign:YES];
}

//3.39	代发快递请求
+(NSDictionary*)api_outExp:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=outExp",token] withInfo:info sign:YES];
}

//3.40	员工-代发快递列表
+(NSDictionary*)api_empOutExpList:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=empOutExpList",token] withInfo:info sign:YES];
}

//3.41	员工-代发快递揽件
+(NSDictionary*)api_empOutExp:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=empOutExp",token] withInfo:info sign:YES];
}

//3.42	查询房屋户成员
+(NSDictionary*)api_queryHouseMember:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryHouseMember",token] withInfo:info sign:YES];
}

//3.43	快递查询
+(NSDictionary*)api_queryExp:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryExp",token] withInfo:info sign:YES];
}

//3.44	查询快递公司列表
+(NSDictionary*)api_queryAllExpCom:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryAllExpCom",token] withInfo:info sign:YES];
}

//3.45	查询房屋信息
+(NSDictionary*)api_queryHouseByComm:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryHouseByComm",token] withInfo:info sign:YES];
}

//3.46	获取支付数据
+(NSDictionary*)api_bill99Pay:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=bill99Pay",token] withInfo:info sign:YES];
}

// 上传货到付款白条
+(NSDictionary*)api_uploadOrderLous:(NSString*)token withInfo:(NSDictionary*)info {
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=uploadOrderLous",token] withInfo:info sign:YES];
}

//3.47	代收快递派送取消
+(NSDictionary*)api_sendExpInCancel:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=sendExpInCancel",token] withInfo:info sign:YES];
}

//3.48	代收快递删除
+(NSDictionary*)api_sendExpInDelete:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=sendExpInDelete",token] withInfo:info sign:YES];
}

//3.49	文件上传
+(NSDictionary*)file_upload:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key withData:(NSData*)data{
    return [self httpRequest:[NSString stringWithFormat:@"/file/upload?attachType=%@&idKey=%@",type,key] withData:data redoCount:0];
}

// 上传图片
+ (NSDictionary*)file_upload:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key withData:(NSData*)data extension:(NSString*)extension {
    return [self httpRequest:[NSString stringWithFormat:@"/file/upload?attachType=%@&idKey=%@",type,key] withData:data redoCount:0 imageExtension:extension];
}

//3.50	文件下载
+(void)file_download:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key filePath:(NSString*)path{
    return [[self defaultManager] httpDownload:[NSString stringWithFormat:@"/file/download?attachType=%@&idKey=%@",type,key] withFilePath:path];
}

//3.50	获得文件下载的URL
+(NSURL*)file_downloadURL:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key{
    __autoreleasing NSURL* url = [NSURL URLWithString:[self file_downloadURLString:token attachType:type idKey:key]];
    return url;
}

+(NSString*)file_downloadURLString:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key{
    __autoreleasing NSString* url = [NSString stringWithFormat:@"%@/file/download?attachType=%@&idKey=%@",SERVER_URL,type,key];
    return url;
}

// 新的下载api
+(NSURL*)file_download_newURL:(NSString*)token attachType:(NSString*)type imageName:(NSString*)imageName {
    __autoreleasing NSURL* url = [NSURL URLWithString:[self file_download_newURLString:token attachType:type imageName:imageName]];
    return url;
}

+(NSString*)file_download_newURLString:(NSString*)token attachType:(NSString*)type imageName:(NSString*)imageName {
    __autoreleasing NSString* url = [NSString stringWithFormat:@"%@/file/download/new?attachType=%@&imageName=%@",SERVER_URL,type,imageName];
    return url;
}

//3.51	代发快递取消
+(NSDictionary*)api_sendExpOutCancel:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=sendExpOutCancel",token] withInfo:info sign:YES];
}

//3.52	代发快递删除
+(NSDictionary*)api_sendExpOutDelete:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=sendExpOutDelete",token] withInfo:info sign:YES];
}

//3.53	小区公告列表查询
+(NSDictionary*)api_queryNoticeList:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryNoticeList",token] withInfo:info sign:YES];
}

//3.54	小区公告信息查询
+(NSDictionary*)api_queryNoticeInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryNoticeInfo",token] withInfo:info sign:YES];
}

//3.55	通过houseCode查询房屋户成员
+(NSDictionary*)api_queryHouseMemberByHouseCode:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryHouseMemberByHouseCode",token] withInfo:info sign:YES];
}

//3.56	物业员工信息查询
+(NSDictionary*)api_queryqueryEstateEmp:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryEstateEmp",token] withInfo:info sign:YES];
}

//3.57	支付密码设置
+(NSDictionary*)api_payPwdSet:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=payPwdSet",token] withInfo:info sign:YES];
}

#pragma mark - System

//3.59	App下载链接
+(NSDictionary*)system_appUrl:(NSDictionary*)info{
    return [self httpRequest:@"/system/appUrl" withInfo:info];
}

//首页面图片接口
+(NSDictionary*)system_covers:(NSDictionary*)info{
    return [self httpRequest:@"/system/covers" withInfo:info];
}

/// 智郡热点列表接口
+ (NSDictionary*)system_info_list {
    return [self httpRequest:@"/system/info/list" withInfo:@{}];
}

#pragma mark -

//3.60	物业费账单列表
+(NSDictionary*)api_queryEstateAcctBill:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryEstateAcctBill",token] withInfo:info sign:YES];
}

//3.61	查询物业信息
+(NSDictionary*)api_queryEstateInfo:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryEstateInfo",token] withInfo:info sign:YES];
}

//3.63	查询充值商品列表
+(NSDictionary*)api_queryRechargeGoods:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryRechargeGoods",token] withInfo:info sign:YES];
}

//3.64	快递查询(爱查快递)
+(NSDictionary*)api_queryAiExp:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryAiExp",token] withInfo:info sign:YES];
}

//3.65	员工-代发快递揽件取消
+(NSDictionary*)api_empSendExpOutCancel:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=empSendExpOutCancel",token] withInfo:info sign:YES];
}

// 发送快递
+ (NSDictionary*)api_expExpoutexpressSendExpressWithInfo:(NSDictionary*)info {
    return [self httpRequest:[NSString stringWithFormat:@"/exp/expoutexpress/sendExpress"] withInfo:info];
}

//3.66	代发快递列表
+(NSDictionary*)api_expOutList:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=expOutList",token] withInfo:info sign:YES];
}

//3.67	代发快递公司列表
+(NSDictionary*)api_expOutCompanyList:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=expOutCompanyList",token] withInfo:info sign:YES];
}

//3.68	公告列表查询
+(NSDictionary*)api_queryPushMsgList:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryPushMsgList",token] withInfo:info sign:YES];
}

//3.69	判断订单是否评价
+(NSDictionary*)api_queryEvaluateInd:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryEvaluateInd",token] withInfo:info sign:YES];
}

//3.70	商户订单查询
+(NSDictionary*)api_queryMerchantOrders:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryMerchantOrders",token] withInfo:info sign:YES];
}

//3.71	支付密码验证
+(NSDictionary*)api_validatePayPwd:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=validatePayPwd",token] withInfo:info sign:YES];
}

//3.72	商户列表查询
+(NSDictionary*)api_queryMerchantList:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryMerchantList",token] withInfo:info sign:YES];
}

//3.73	员工工单列表
+(NSDictionary*)api_queryEmpWorkOrders:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryEmpWorkOrders",token] withInfo:info sign:YES];
}


//3.76  收货地址列表查询
+(NSDictionary *)api_queryReceiveAddrs:(NSString*)token withinfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=queryReceiveAddrs",token] withInfo:info sign:YES];
}
//3.77  收货地址维护
+(NSDictionary *)api_receiveAddrMag:(NSString *)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=receiveAddrMag",token] withInfo:info sign:YES];
}
//3.78	便民采购特销商品列表
+(NSDictionary*)api_querySpecialGoods:(NSString*)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=querySpecialGoods",token] withInfo:info sign:YES redoCount:0];
}

//3.79	员工-水电维修商品
+(NSDictionary*)api_baoxiuOrderCreate:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=baoxiuOrderCreate",token] withInfo:info sign:YES];
}

//3.80	获取支付宝支付数据
+(NSDictionary*)api_alipay:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=alipay",token] withInfo:info sign:YES];
}

//3.80.1	获取微信支付数据
+(NSDictionary*)api_wxpay:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=weixinpay",token] withInfo:info sign:YES];
}


//3.81	衣服类型列表查询
+(NSDictionary*)api_xyCategoryList:(NSString*)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xyCategoryList",token] withInfo:info sign:YES];
}
//3.82	洗衣件数折扣查询
+(NSDictionary*)api_xyDiscontList:(NSString*)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xyDiscontList",token] withInfo:info sign:YES];
}
//3.83	洗衣订单生成
+(NSDictionary*)api_genXiyiOrderInfo:(NSString*)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=genXiyiOrderInfo",token] withInfo:info sign:YES];
}
//3.84	洗衣派送请求
+(NSDictionary *)api_xySend:(NSString*)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xySend",token] withInfo:info sign:YES];
}
//3.85	洗衣派送请求更改
+(NSDictionary *)api_xySendUpdate:(NSString*)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xySendUpdate",token] withInfo:info sign:YES];
}
//3.86	员工-洗衣派送送达确认
+(NSDictionary*)api_xySendConfirm:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xySendConfirm",token] withInfo:info sign:YES];
}

//3.87	员工-洗衣揽件确认
+(NSDictionary*)api_xyGetConfirm:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xyGetConfirm",token] withInfo:info sign:YES];
}

//3.88	合并支付
+(NSDictionary*)api_mergeOrder:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=mergeOrder",token] withInfo:info sign:YES];
}
//3.89	员工-洗衣订单查询
+(NSDictionary*)api_xyEmpQueryOrders:(NSString*)token withInfo:(NSDictionary*)info{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xyEmpQueryOrders",token] withInfo:info sign:YES];
}

//3.1	员工信息查询
+(NSDictionary*)api_xyEmpInfo:(NSString*)token withInfo:(NSDictionary*)info
{
    return [self httpRequest:[NSString stringWithFormat:@"/api/platform.proc?accessToken=%@&trxnCode=xyEmpInfo",token] withInfo:info sign:YES];
}

#pragma mark - 物业

// 随手拍
+ (NSDictionary*)api_takereadilyListWithInfo:(NSDictionary*)info {
    return [self httpRequest:@"/cmn/takereadily/list" withInfo:info];
}

// 新增随手拍
+ (NSDictionary*)api_takereadilyAddWithInfo:(NSDictionary*)info {
    return [self httpRequest:@"/cmn/takereadily/add" withInfo:info];
}

// 修改随手拍状态
+ (NSDictionary*)api_takereadilyUpdateStatusWithInfo:(NSDictionary*)info {
    return [self httpRequest:@"/cmn/takereadily/updateStatus" withInfo:info];
}

// 删除随手拍
+ (NSDictionary*)api_takereadilyDeleteWithInfo:(NSDictionary*)info {
    return [self httpRequest:@"/cmn/takereadily/delete" withInfo:info];
}

// 管理人员查询随手拍
+ (NSDictionary*)api_takereadilyGetAssignListWithInfo:(NSDictionary*)info {
    return [self httpRequest:@"/cmn/takereadily/getAssignList" withInfo:info];
}

// 管理人员更新随手拍处理状态
+ (NSDictionary*)api_takereadilyUpdateProcessWithInfo:(NSDictionary*)info {
    return [self httpRequest:@"/cmn/takereadily/updateProcess" withInfo:info];
}

#pragma mark - 汽车服务

// 汽车列表
+ (NSDictionary*)api_autoListWithInfo:(NSDictionary*)info {
    return [self httpRequest:[NSString stringWithFormat:@"/auto/list"] withInfo:info];
}

// 汽车添加
+ (NSDictionary*)api_autoAddWithInfo:(NSDictionary*)info {
    return [self httpRequest:[NSString stringWithFormat:@"/auto/add"] withInfo:info];
}

// 汽车更新
+ (NSDictionary*)api_autoUpdateWithInfo:(NSDictionary*)info {
    return [self httpRequest:[NSString stringWithFormat:@"/auto/update"] withInfo:info];
}

@end
