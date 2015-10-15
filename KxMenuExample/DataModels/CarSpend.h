//
//  CarSpend.h
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CarSpend : NSObject
@property (nonatomic, strong) NSString  *username;//用户名，为空时返回N
@property (nonatomic, strong) NSString  *spend;//过停费
@property (nonatomic, strong) NSString  *licpn;//车牌号
@property (nonatomic, strong) NSString  *time;//添加时间
@property (nonatomic, strong) NSString  *longitude;//经度
@property (nonatomic, strong) NSString  *latitude;//维度
@property (nonatomic, strong) NSString  *imsi;//手机imsi号

@end
