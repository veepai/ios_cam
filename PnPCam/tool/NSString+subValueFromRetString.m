//
//  NSString+subValueFromRetString.m
//  66666
//
//  Created by Cuiheng on 16/9/1.
//  Copyright © 2016年 xiaoma. All rights reserved.
//

#import "NSString+subValueFromRetString.h"

@implementation NSString (subValueFromRetString)


+ (NSString *)subValueByKeyString:(NSString *)string fromRetString:(NSString *)retString
{
    NSMutableString *mutRetStr = [NSMutableString stringWithString:retString];
    NSString *rootStr = [mutRetStr stringByReplacingOccurrencesOfString:@"var" withString:@""];
    NSMutableString *mutStr1 = [NSMutableString stringWithString:rootStr];
    NSString *rootStr1 = [mutStr1 stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    NSRange range = [rootStr1 rangeOfString:string];
    if (range.length == 0)
    {
        return nil;
    }
    NSString *lastStr = [rootStr1 substringFromIndex:range.location];
    
    NSRange range1 = [lastStr rangeOfString:string];
    NSRange range2 = [lastStr rangeOfString:@";"];
    
    NSString *keyStr = [lastStr substringWithRange:NSMakeRange(range1.length, range2.location - range1.length)];
    
    NSMutableString *mutKeyStr = [NSMutableString stringWithString:keyStr];
    NSString *str3 = [mutKeyStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return str3;
}


@end
