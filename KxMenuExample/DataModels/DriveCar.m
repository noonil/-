//
//  DriveCar.m
//  KxMenuExample
//
//  Created by xuming on 15/5/24.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "DriveCar.h"
#import "Car.h"
#import "User.h"

@implementation DriveCar

+ (id)createWithDict:(NSDictionary *)dict
{
    return [[DriveCar alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
       // self.rowid =[[dict valueForKey:@"id"]  integerValue];
        self.serverId =[dict valueForKey:@"id"];
        self.photoUp = [dict valueForKey:@"photoUrl"] ;
        self.licpn = [dict valueForKey:@"licpn"] ;
        self.driver = [dict valueForKey:@"driver"] ;
        self.driver_phone = [dict valueForKey:@"driverPhone"] ;
        self.mileUp = [dict valueForKey:@"miles"] ;
        self.timeUp = [dict valueForKey:@"sphStime"] ;
        
//        self.rowid =[[(NSArray *)[dict valueForKey:@"id"] objectAtIndex:0] integerValue];
//        self.photoUp = [(NSArray *)[dict valueForKey:@"photoUrl"] objectAtIndex:0];
//        self.licpn = [(NSArray *)[dict valueForKey:@"licpn"] objectAtIndex:0];
//        self.driver = [(NSArray *)[dict valueForKey:@"driver"]objectAtIndex:0] ;
//        self.driver_phone = [(NSArray *)[dict valueForKey:@"driverPhone"] objectAtIndex:0];
//        self.mileUp = [(NSArray *)[dict valueForKey:@"miles"] objectAtIndex:0];
//        self.timeUp = [(NSArray *)[dict valueForKey:@"sphStime"] objectAtIndex:0];
//
//        
        
//        self.articleTitle = [dict valueForKey:@"articleTitle"];
//        if (!self.articleTitle)
//        {
//            self.articleTitle = @"";
//        }
//        
//        self.modifyDate = [dict valueForKey:@"modificationDate"];
//        if (!self.modifyDate)
//        {
//            self.modifyDate = @"";
//        }
//        
//        self.commentCount = [dict valueForKey:@"articleCommentCount"];
//        if (!self.commentCount)
//        {
//            self.commentCount = @"0";
//        }
    }
    return self;
}

//// 重载    返回自己处理过的 要插入数据库的值
//-(id)userGetValueForModel:(LKDBProperty *)property
//{
//    if([property.sqlColumnName isEqualToString:@"reporter"])
//    {
//        if(self.reporter == nil)
//            return @"";
//        [User insertToDB:self.reporter];
//        return @(self.reporter.rowid);
//    }
//    else if([property.sqlColumnName isEqualToString:@"car"])
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
//    if([property.sqlColumnName isEqualToString:@"reporter"])
//    {
//        self.reporter = nil;
//        
//        NSMutableArray* array  = [User searchWithWhere:[NSString stringWithFormat:@"rowid = %@",value ] orderBy:nil offset:0 count:1];
//        
//        if(array.count>0)
//            self.reporter = [array objectAtIndex:0];
//    }
//    else if([property.sqlColumnName isEqualToString:@"car"])
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
////主键
//+(NSString *)getPrimaryKey
//{
//    return @"idd";
//}

//表名
+(NSString *)getTableName
{
    return @"DriverCarTable";
}

@end
