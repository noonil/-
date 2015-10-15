//
//  Util.m
//  PMS_Iphone
//
//  Created by lvmeng on 14-6-9.
//  Copyright (c) 2014年 xbk. All rights reserved.
//

#import "Util.h"
#import "OpenUDID.h"
#import <CommonCrypto/CommonCrypto.h>



@implementation Util



//思考：根据当前时间和系统所在时区得到和标准时间的Interval，然后得到效验后的时间localeDate，最后[localeDate timeIntervalSince1970]获取效验后的时间和1970年时间的差值，也就是时间戳

+(NSString *)getTimeStamp{
    NSDate *datenow =[NSDate date];//现在时间,你可以输出来看下是什么格式

    NSTimeZone *zone = [NSTimeZone systemTimeZone];

    NSInteger interval = [zone secondsFromGMTForDate:datenow];

    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];

   // NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    return timeSp;
    
}



+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"asd/asd.db"];
        //        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
        //or
        db = [[LKDBHelper alloc]init];
    });
    return db;
}
+(NSString *)getUsingUDID{
    static NSString *udid;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        udid = [OpenUDID value];
    });
    return udid;


}
+(NSString *)getUserName{
return  [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
}



//+(NSString *)md5FromData:(NSData *)data
//{
//    const char *str = [data bytes];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(str, (CC_LONG)strlen(str ), result);
//    
//    NSMutableString *hash = [NSMutableString string];
//    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
//        [hash appendFormat:@"%02X", result[i]];
//    }
//    
//    return [hash lowercaseString];
//}
//
//+ (CGFloat)statusBarHeight
//{
//    if (isIOS7)
//    {
//        return 0;
//    }
//    else
//    {
//        return 20;
//    }
//}
//
//+ (CGFloat)navBarHeight
//{
//    if (isIOS7)
//    {
//        return 64;
//    }
//    else
//    {
//        return 44;
//    }
//}
//
//+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict
//{
//    id obj = [dict objectForKey:key];
//    if ([obj isKindOfClass:[NSString class]] && [obj isEqual:@""]) {
//        return nil; //空字符串
//    } else if ([obj isKindOfClass:[NSNull class]]) {
//        return nil; //空类
//    }
//    return obj;
//}
//
//+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict forClass:(Class)class
//{
//    id obj = [dict objectForKey:key];
//    if ([obj isKindOfClass:class]) {
//        if ([obj isKindOfClass:[NSString class]] && [obj isEqual:@""]) {
//            return nil;
//        } else {
//            return obj;
//        }
//    }
//    return nil;
//}

@end
