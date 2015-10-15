//
//  IdentifierValidator.m
//  KxMenuExample
//
//  Created by xuming on 15/6/10.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//




#import "IdentifierValidator.h"

@implementation IdentifierValidator

+ (BOOL)isFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateCarNo:(NSString*)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    //NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
  //  NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

/*手机号码验证 MODIFIED BY HELENSONG*/

    + (BOOL) isValidPhone:(NSString*)value {
        const char *cvalue = [value UTF8String];
        unsigned long len = strlen(cvalue);
        if (len != 11) {
            return FALSE;
        }
        if (![IdentifierValidator isValidNumber:value])
        {
            return FALSE;
        }
        NSString *preString = [[NSString stringWithFormat:@"%@",value] substringToIndex:2];
        if ([preString isEqualToString:@"13"] ||
            [preString isEqualToString: @"15"] ||
            [preString isEqualToString: @"18"])
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
        return TRUE;
    }



//是否小数位<=2
+(BOOL)isInsideTwo:(NSString *)miles{
    NSRange range;
    range = [miles rangeOfString:@"."];
    NSUInteger xiaoshuCount=[miles length]-range.location-1;
    if (range.location!=NSNotFound && xiaoshuCount>2) {
        return false;
    }
    else
        return true;
}

+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    unsigned long len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}

BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}

@end