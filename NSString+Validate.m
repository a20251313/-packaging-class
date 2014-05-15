//
//  NSString+Validate.m
//  cocacolaOA
//
//  Created by mac on 14-4-9.
//
//

#import "NSString+Validate.h"

@implementation NSString (Validate)
+ (BOOL)isNil:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    
    if (string.length == 0) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)stringRidNull:(NSString *)str{
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }else if(str == nil){
        return @"";
    }else{
        return str;
    }
}

@end
