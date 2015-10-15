//
//  DriveCar.h
//  KxMenuExample
//
//  Created by xuming on 15/5/24.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DriveCar : NSObject

//@property (nonatomic, strong) NSString  *idd;//序列号 做主键

//@property (nonatomic, strong) NSString  *username;
@property (nonatomic, strong) NSString  *serverId;//用时间戳做服务器端的车辆id
@property (nonatomic, strong) NSString  *status;//状态（s:上车上传，e:下车上传）
@property (nonatomic, strong) NSString  *imis;//手机imsi号
@property (nonatomic, strong) NSString  *isLocalTime;//该参数需要传递，但未使用
@property (nonatomic, strong) NSString  *licpn;
@property (nonatomic, strong) NSString  *reporter;//上报人
@property (nonatomic, strong) NSString  *driver;//开车人
@property (nonatomic, strong) NSString  *driver_phone;//开车人电话

@property (nonatomic, strong) NSString  *submitStatus_Up;//提交是否成功，@“true”，@“false”
@property (nonatomic, strong) NSString  *submitStatus;//提交是否成功，@“true”，@“false”


@property (nonatomic, strong) NSString  *timeUp;//上下车拍照时间
@property (nonatomic, strong) NSString  *timeDown;//上下车拍照时间
@property (nonatomic, strong) NSString  *photoUp;//该参数未使用
@property (nonatomic, strong) NSString  *photoDown;//该参数未使用
@property (nonatomic, strong) NSString  *memoUp;//备注
@property (nonatomic, strong) NSString  *memoDown;//备注
@property (nonatomic, strong) NSString  *mileUp;//行驶里程
@property (nonatomic, strong) NSString  *mileDown;//行驶里程
@property (nonatomic, strong) NSString  *locationUp;//行驶里程
@property (nonatomic, strong) NSString  *locationDown;//行驶里程
@property (nonatomic, strong) NSString  *md5Up;//
@property (nonatomic, strong) NSString  *md5Down;

@property (nonatomic, strong) NSString  *time;//上传用
@property (nonatomic, strong) NSString  *photo;//上传用
@property (nonatomic, strong) NSString  *memo;//上传用
@property (nonatomic, strong) NSString  *mile;//上传用
//@property (nonatomic, strong) NSString * location;//上传用





+ (id)createWithDict:(NSDictionary *)dict;

@end
