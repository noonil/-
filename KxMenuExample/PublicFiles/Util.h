//
//  Util.h
//  PMS_Iphone
//
//  Created by lvmeng on 14-6-9.
//  Copyright (c) 2014年 xbk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"


@interface Util : NSObject

//+ (CGFloat)statusBarHeight;
//+ (CGFloat)navBarHeight;
//
///*
// *  获取Dictionary中的元素,主要防止服务器发送@""或者obje-c转化成NSNull
// */
//+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict;
//+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict forClass:(Class)class;

+(LKDBHelper *)getUsingLKDBHelper;
+(NSString *)getUsingUDID;
+(NSString *)getTimeStamp;

+(NSString *)getUserName;

@end
