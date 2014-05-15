//
//  NSString+Validate.h
//  cocacolaOA
//
//  Created by mac on 14-4-9.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

// 判断是否为空字符串
+ (BOOL)isNil:(NSString *)string;

+ (NSString *)stringRidNull:(NSString *)str;

@end
