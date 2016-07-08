

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
// 账号帐户资料
//更改商户把相关参数后可测试

#define APP_ID          @"wx54ec63a8d4b60179"               //APPID
#define APP_SECRET      @"d4624c36b6795d1d99dcf0547af5443d" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1295029801"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"qingchuanghuiqingchuanghuiyfb001"
//支付结果回调页面
//#define NOTIFY_URL      @"http://www.lvyoule.net/payment/scenic/np_andriod/p02"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://www.cn-qch.com/TenPayV3/PayNotifyUrl2"

@class OrderModel;

@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;

    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}
//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例测试
- ( NSMutableDictionary *)sendPay_demo:(OrderModel *)model;

@end