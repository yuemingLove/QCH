//
//  AlipayConfig.h
//  qch
//
//  Created by 苏宾 on 16/3/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#ifndef AlipayConfig_h
#define AlipayConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088121267209200"
//收款支付宝账号
#define SellerID  @"qingchuanghui001@sina.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"yu3mejwq3tz4qqi3dk1y4z4npkq1cbu7"
//

//商户私钥，自助生成

#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAM3OzymuYyk1nfqVjciaBlqD+f+VkbGaHoQnPgHqeAI1uv+mtFJ8F27ymecukukk1NHT3ouIFH2FlL5i5H73KbwdzPbm10lTMZPgEYZ6WCMhSM9grEHNzgq+4zvtLkM4edAiHqta58ThJ5mlQ3R67OkiL0vf29ILEWBWV31F3olTAgMBAAECgYEAwoy9SKmRE2Ob80VswjTXzLj1mqXJFBqcvlBaTXVX/L7OBt2PmGm1vSuYUPG17q7if3fI6B27QO0FrvPNDDiZOYhwwDZcylZz0lFItz4miKzDDcuQmq4XFhQzif2cu17z4Ta9/rrBF8aJlXZ6F4E3ENNag2bHwK7zW0JQyFZsYAECQQDxRB6pgjgPG3xs7VZvbkTHLHxHfVzoOI+283lFOQJP/MJ0Yie+OIuXe4ZieaW6OQUEnvgm+MYYz8EsHrT4apq5AkEA2mBYm1x4MdiRWJVXrwWb5GBQZLGlKqrihYRDgsXxlk9M+T5oqrOkoM6aqmS5nXgMRVGOKcQ0tkXPmrNy+8fOawJBAOS2bdbFIj14EfD04P6LatnhWwMuXVeq3tpRXsH3dDC9bN2FeyWBVxtINzG9HhU2HoKt7JKNPMWilP4tMeNYs8kCQBD3k2re0GfvD7v2Po3WvboM0bJBKzgZdugw0p4CizbGipCDDNbWhmAILXQ3x0Q445svLwCHwiC3Y939O13ctGkCQC2qXItN5iCytxJh+XlRfVAY3sju0sqq74WY+n9u9ixJg6oeaGKR/QRQwhJZCcM0denWXyDmVoPs67jB7zdK5bk="
//回调网址
#define CallBackWeb @"http://h5.hdxiyi.com/pay/alipay_notify.json"

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDNzs8prmMpNZ36lY3ImgZag/n/lZGxmh6EJz4B6ngCNbr/prRSfBdu8pnnLpLpJNTR096LiBR9hZS+YuR+9ym8Hcz25tdJUzGT4BGGelgjIUjPYKxBzc4KvuM77S5DOHnQIh6rWufE4SeZpUN0euzpIi9L39vSCxFgVld9Rd6JUwIDAQAB"



#endif
