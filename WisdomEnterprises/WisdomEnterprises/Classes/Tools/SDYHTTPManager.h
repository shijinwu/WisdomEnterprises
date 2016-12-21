//
//  SDYHTTPManager.h
//  sdy
//
//  Created by BodeMeng on 14-9-15.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FileDownloadCompletedNotification @"FileDownloadCompletedNotification"

@class ASINetworkQueue;

@interface SDYHTTPManager : NSObject{
  ASINetworkQueue *networkQueue;
}

+(SDYHTTPManager*)defaultManager;

+(void)setDebugMode:(BOOL)debug;

//2.2.1	获取密码传输
+(NSDictionary*)oauth_pwdKey;
//2.2.2	获取授权码
+(NSDictionary*)oauth_authorize:(NSDictionary*)info;
//2.2.3	获取AccessToken
//+(NSDictionary*)oauth_accessToken:(NSString*)code exUserId:(NSString*)exUserId;
// 新的登录接口。合并authorize与accessToken
+ (NSDictionary*)oauth_login:(NSDictionary*)info;
//2.2.4	刷新AccessToken
+(NSDictionary*)oauth_refreshToken:(NSString*)token exUserId:(NSString*)exUserId;

//3.1	用户注册
+(NSDictionary*)noauth_register:(NSDictionary*)info;
//3.2	获取短信验证码
+(NSDictionary*)noauth_getSmsCode:(NSDictionary*)info;
//3.3	用户信息查询
+(NSDictionary*)api_queryUserInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.4	用户是否注册查询
+(NSDictionary*)noauth_checkReg:(NSDictionary*)info;
//3.5	用户信息修改
+(NSDictionary*)api_updateUserInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.6	收件人地址查询
+(NSDictionary*)api_queryAddrInfos:(NSString*)token withInfo:(NSDictionary*)info;
//3.7	收件人地址维护
+(NSDictionary*)api_saveAddrInfos:(NSString*)token withInfo:(NSDictionary*)info;
//3.8	用户余额查询
+(NSDictionary*)api_queryAcctBal:(NSString*)token withInfo:(NSDictionary*)info;
//3.9	密码设置
+(NSDictionary*)api_userPwdSet:(NSString*)token withInfo:(NSDictionary*)info;
//3.10	密码重置
+(NSDictionary*)api_userPwdReset:(NSString*)token withInfo:(NSDictionary*)info;
//3.11	用户金融交易查询
+(NSDictionary*)api_queryFinanceTrxn:(NSString*)token withInfo:(NSDictionary*)info;
//3.12	用户店铺列表
+(NSDictionary*)api_queryUserMerchants:(NSString*)token withInfo:(NSDictionary*)info;
//3.13	店铺信息查询
+(NSDictionary*)api_queryMerchantInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.14	店铺商品列表
+(NSDictionary*)api_queryMerchantGoods:(NSString*)token withInfo:(NSDictionary*)info;
//3.15	商品信息查询
+(NSDictionary*)api_queryGoodsInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.16	申请开店
+(NSDictionary*)api_applyShop:(NSString*)token withInfo:(NSDictionary*)info;
//3.17	用户订单查询
+(NSDictionary*)api_queryUserOrders:(NSString*)token withInfo:(NSDictionary*)info;
//3.18	订单信息查询
+(NSDictionary*)api_queryOrderInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.19	订单生成
+(NSDictionary*)api_genOrderInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.20	订单状态维护
+(NSDictionary*)api_updateOrderStatus:(NSString*)token withInfo:(NSDictionary*)info;
//3.21	订单信息维护
//+(NSDictionary*)api_updateOrderStatus:(NSString*)token withInfo:(NSDictionary*)info;
//3.22	工单生成
+(NSDictionary*)api_genWorkOrder:(NSString*)token withInfo:(NSDictionary*)info;
//3.23	工单信息查询
+(NSDictionary*)api_queryWorkOrderInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.24	用户工单列表
+(NSDictionary*)api_queryWorkOrders:(NSString*)token withInfo:(NSDictionary*)info;
//3.25	工单状态维护
+(NSDictionary*)api_updateWorkOrderStatus:(NSString*)token withInfo:(NSDictionary*)info;
//3.26	调查问卷填写
+(NSDictionary*)api_queryQuestionnaires:(NSString*)token withInfo:(NSDictionary*)info;
//3.27	商户商品评价
+(NSDictionary*)api_evaluateMerchantGoods:(NSString*)token withInfo:(NSDictionary*)info;
//3.28	附近小区查询
+(NSDictionary*)api_queryNearCommunity:(NSString*)token withInfo:(NSDictionary*)info;
//3.29	小区模糊查询
+(NSDictionary*)api_queryLikeCommunity:(NSString*)token withInfo:(NSDictionary*)info;
//3.30	小区信息查询
+(NSDictionary*)api_queryCommunity:(NSString*)token withInfo:(NSDictionary*)info;
//3.31	字典项查询
+(NSDictionary*)api_dictItems:(NSString*)token withInfo:(NSDictionary*)info;
//3.32	多字典项查询
+(NSDictionary*)api_dictItemLists:(NSString*)token withInfo:(NSDictionary*)info;
//3.33	短信验证码校验
+(NSDictionary*)api_checkSmsIdCode:(NSString*)token withInfo:(NSDictionary*)info;
//3.35	员工-代收快递录入（接收快递）
+(NSDictionary*)api_empExpIn:(NSString*)token withInfo:(NSDictionary*)info;
//3.36	获取代收快递列表
+(NSDictionary*)api_queryExpInList:(NSString*)token withInfo:(NSDictionary*)info;
//3.37	代收快递派送请求
+(NSDictionary*)api_sendExpIn:(NSString*)token withInfo:(NSDictionary*)info;
//3.38	代收快递派送确认收到
+(NSDictionary*)api_makeSureSendExpIn:(NSString*)token withInfo:(NSDictionary*)info;
//3.39	代发快递请求
+(NSDictionary*)api_outExp:(NSString*)token withInfo:(NSDictionary*)info;
//3.40	员工-代发快递列表
+(NSDictionary*)api_empOutExpList:(NSString*)token withInfo:(NSDictionary*)info;
//3.41	员工-代发快递揽件
+(NSDictionary*)api_empOutExp:(NSString*)token withInfo:(NSDictionary*)info;
//3.42	查询房屋户成员
+(NSDictionary*)api_queryHouseMember:(NSString*)token withInfo:(NSDictionary*)info;
//3.43	快递查询
+(NSDictionary*)api_queryExp:(NSString*)token withInfo:(NSDictionary*)info;
//3.44	查询快递公司列表
+(NSDictionary*)api_queryAllExpCom:(NSString*)token withInfo:(NSDictionary*)info;
//3.45	查询房屋信息
+(NSDictionary*)api_queryHouseByComm:(NSString*)token withInfo:(NSDictionary*)info;
//3.46	获取支付数据
+(NSDictionary*)api_bill99Pay:(NSString*)token withInfo:(NSDictionary*)info;
// 上传货到付款白条
+(NSDictionary*)api_uploadOrderLous:(NSString*)token withInfo:(NSDictionary*)info;
//3.47	代收快递派送取消
+(NSDictionary*)api_sendExpInCancel:(NSString*)token withInfo:(NSDictionary*)info;
//3.48	代收快递删除
+(NSDictionary*)api_sendExpInDelete:(NSString*)token withInfo:(NSDictionary*)info;
//3.49	头像上传
+(NSDictionary*)file_upload:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key withData:(NSData*)data;
+ (NSDictionary*)file_upload:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key withData:(NSData*)data extension:(NSString*)extension;
//3.50	文件下载
+(void)file_download:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key filePath:(NSString*)path;
//3.50	获得文件下载的URL
+(NSString*)file_downloadURLString:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key;
+(NSURL*)file_downloadURL:(NSString*)token attachType:(NSString*)type idKey:(NSString*)key;
// 新的下载api
+(NSURL*)file_download_newURL:(NSString*)token attachType:(NSString*)type imageName:(NSString*)imageName;
+(NSString*)file_download_newURLString:(NSString*)token attachType:(NSString*)type imageName:(NSString*)imageName;
//3.51	代发快递取消
+(NSDictionary*)api_sendExpOutCancel:(NSString*)token withInfo:(NSDictionary*)info;
//3.52	代发快递删除
+(NSDictionary*)api_sendExpOutDelete:(NSString*)token withInfo:(NSDictionary*)info;
//3.53	小区公告列表查询
+(NSDictionary*)api_queryNoticeList:(NSString*)token withInfo:(NSDictionary*)info;
//3.54	小区公告信息查询
+(NSDictionary*)api_queryNoticeInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.55	通过houseCode查询房屋户成员
+(NSDictionary*)api_queryHouseMemberByHouseCode:(NSString*)token withInfo:(NSDictionary*)info;
//3.56	物业员工信息查询
+(NSDictionary*)api_queryqueryEstateEmp:(NSString*)token withInfo:(NSDictionary*)info;
//3.57	支付密码设置
+(NSDictionary*)api_payPwdSet:(NSString*)token withInfo:(NSDictionary*)info;
//3.59	App下载链接
+(NSDictionary*)system_appUrl:(NSDictionary*)info;
//首页面图片接口
+(NSDictionary*)system_covers:(NSDictionary*)info;
/// 智郡热点列表接口
+ (NSDictionary*)system_info_list;
//3.60	物业费账单列表
+(NSDictionary*)api_queryEstateAcctBill:(NSString*)token withInfo:(NSDictionary*)info;
//3.61	查询物业信息
+(NSDictionary*)api_queryEstateInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.63	查询充值商品列表
+(NSDictionary*)api_queryRechargeGoods:(NSString*)token withInfo:(NSDictionary*)info;
//3.64	快递查询(爱查快递)
+(NSDictionary*)api_queryAiExp:(NSString*)token withInfo:(NSDictionary*)info;
//3.65	员工-代发快递揽件取消
+(NSDictionary*)api_empSendExpOutCancel:(NSString*)token withInfo:(NSDictionary*)info;
// 发送快递
+ (NSDictionary*)api_expExpoutexpressSendExpressWithInfo:(NSDictionary*)info;
//3.66	代发快递列表
+(NSDictionary*)api_expOutList:(NSString*)token withInfo:(NSDictionary*)info;
//3.67	代发快递公司列表
+(NSDictionary*)api_expOutCompanyList:(NSString*)token withInfo:(NSDictionary*)info;
//3.68	公告列表查询
+(NSDictionary*)api_queryPushMsgList:(NSString*)token withInfo:(NSDictionary*)info;
//3.69	判断订单是否评价
+(NSDictionary*)api_queryEvaluateInd:(NSString*)token withInfo:(NSDictionary*)info;
//3.70	商户订单查询
+(NSDictionary*)api_queryMerchantOrders:(NSString*)token withInfo:(NSDictionary*)info;
//3.71	支付密码验证
+(NSDictionary*)api_validatePayPwd:(NSString*)token withInfo:(NSDictionary*)info;
//3.72	商户列表查询
+(NSDictionary*)api_queryMerchantList:(NSString*)token withInfo:(NSDictionary*)info;
//3.73	员工工单列表
+(NSDictionary*)api_queryEmpWorkOrders:(NSString*)token withInfo:(NSDictionary*)info;
//3.76  收货地址列表查询
+(NSDictionary *)api_queryReceiveAddrs:(NSString*)token withinfo:(NSDictionary*)info;
//3.77  收货地址维护
+(NSDictionary *)api_receiveAddrMag:(NSString *)token withInfo:(NSDictionary*)info;
//3.78	便民采购特销商品列表
+(NSDictionary*)api_querySpecialGoods:(NSString*)token withInfo:(NSDictionary*)info;
//3.79	员工-水电维修商品
+(NSDictionary*)api_baoxiuOrderCreate:(NSString*)token withInfo:(NSDictionary*)info;
//3.80	获取支付宝支付数据
+(NSDictionary*)api_alipay:(NSString*)token withInfo:(NSDictionary*)info;
//3.80.1	获取微信支付数据
+(NSDictionary*)api_wxpay:(NSString*)token withInfo:(NSDictionary*)info;
//3.81	衣服类型列表查询
+(NSDictionary*)api_xyCategoryList:(NSString*)token withInfo:(NSDictionary*)info;
//3.82	洗衣件数折扣查询
+(NSDictionary*)api_xyDiscontList:(NSString*)token withInfo:(NSDictionary*)info;
//3.83	洗衣订单生成
+(NSDictionary*)api_genXiyiOrderInfo:(NSString*)token withInfo:(NSDictionary*)info;
//3.84	洗衣派送请求
+(NSDictionary *)api_xySend:(NSString*)token withInfo:(NSDictionary*)info;
//3.85	洗衣派送请求更改
+(NSDictionary *)api_xySendUpdate:(NSString*)token withInfo:(NSDictionary*)info;
//3.86	员工-洗衣派送送达确认
+(NSDictionary*)api_xySendConfirm:(NSString*)token withInfo:(NSDictionary*)info;
//3.87	员工-洗衣揽件确认
+(NSDictionary*)api_xyGetConfirm:(NSString*)token withInfo:(NSDictionary*)info;
//3.88	合并支付
+(NSDictionary*)api_mergeOrder:(NSString*)token withInfo:(NSDictionary*)info;
//3.89	员工-洗衣订单查询
+(NSDictionary*)api_xyEmpQueryOrders:(NSString*)token withInfo:(NSDictionary*)info;
//3.1	员工信息查询
+(NSDictionary*)api_xyEmpInfo:(NSString*)token withInfo:(NSDictionary*)info;

// 随手拍
+ (NSDictionary*)api_takereadilyListWithInfo:(NSDictionary*)info;
// 新增随手拍
+ (NSDictionary*)api_takereadilyAddWithInfo:(NSDictionary*)info;
// 修改随手拍状态
+ (NSDictionary*)api_takereadilyUpdateStatusWithInfo:(NSDictionary*)info;
// 删除随手拍
+ (NSDictionary*)api_takereadilyDeleteWithInfo:(NSDictionary*)info;
// 管理人员查询随手拍
+ (NSDictionary*)api_takereadilyGetAssignListWithInfo:(NSDictionary*)info;
// 管理人员更新随手拍处理状态
+ (NSDictionary*)api_takereadilyUpdateProcessWithInfo:(NSDictionary*)info;

// 汽车列表
+ (NSDictionary*)api_autoListWithInfo:(NSDictionary*)info;
// 汽车添加
+ (NSDictionary*)api_autoAddWithInfo:(NSDictionary*)info;
// 汽车更新
+ (NSDictionary*)api_autoUpdateWithInfo:(NSDictionary*)info;

@end
