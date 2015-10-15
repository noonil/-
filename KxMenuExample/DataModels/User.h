//
//  User.h
//  KxMenuExample
//
//  Created by xuming on 15/5/24.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
//@property (nonatomic, strong) NSString  *idd;// 做主键
@property(nonatomic, strong)NSString *username;
@property(nonatomic, strong)NSString *password;
@end
