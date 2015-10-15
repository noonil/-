//
//  NSString+JSONCategories.m
//  LKDBHelper
//
//  Created by syy on 13-7-9.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import "NSString+JSONCategories.h"

@implementation NSString (JSONCategories)

-(id)JSONValueCategorie
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
