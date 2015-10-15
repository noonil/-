//
//  CarSpend.m
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "CarSpend.h"
#import "Car.h"

@implementation CarSpend
//// 重载    返回自己处理过的 要插入数据库的值
//-(id)userGetValueForModel:(LKDBProperty *)property
//{
//    if([property.sqlColumnName isEqualToString:@"car"])
//    {
//        if(self.car == nil)
//            return @"";
//        [Car insertToDB:self.car];
//        return @(self.car.rowid);
//    }
//    return nil;
//}
//// 重载    从数据库中  获取的值   经过自己处理 再保存
//-(void)userSetValueForModel:(LKDBProperty *)property value:(id)value
//{
//    if([property.sqlColumnName isEqualToString:@"car"])
//    {
//        self.car = nil;
//        
//        NSMutableArray* array  = [Car searchWithWhere:[NSString stringWithFormat:@"rowid = %@",value ] orderBy:nil offset:0 count:1];
//        
//        if(array.count>0)
//            self.car = [array objectAtIndex:0];
//    }
//    
//}
//表名
+(NSString *)getTableName
{
    return @"CarSpendTable";
}

@end
