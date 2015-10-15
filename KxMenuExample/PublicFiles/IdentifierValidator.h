//
//  IdentifierValidator.h
//  KxMenuExample
//
//  Created by xuming on 15/6/10.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentifierValidator : NSObject

+ (BOOL)isFloat:(NSString*)string;
+(BOOL) isValidateCarNo:(NSString*)carNo;
 + (BOOL) isValidPhone:(NSString*)value ;
+(BOOL)isInsideTwo:(NSString *)miles;
@end
