//
//  CarManager.h
//  KxMenuExample
//
//  Created by xuming on 15/5/23.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarManager : NSObject

+(CarManager *)shareManager;
-(void)addCar:(NSDictionary *)dic success:(void(^)(NSString *carId))successBlock failed:(void(^)())failedBlock;
-(void)delCar:(NSString *)carId success:(void(^)())successBlock failed:(void(^)())failedBlock;
@end
