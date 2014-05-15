//
//  UtilitiesFunction.m
//  I366_V1_4
//
//  Created by  on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UtilitiesFunction.h"
#import "PublicClass.h"
#import "Reachability.h"
#import "RegexKitLite.h"
#if DEBUG
    #import <objc/runtime.h>
#endif

#import "commoncrypto/commondigest.h"

@implementation UtilitiesFunction



+(NSString*)stroreDBPathInDoc
{
    // NSString  *bundPath = [[NSBundle mainBundle] bundlePath];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"localinfo.db"];
}

+ (NSString *)getConstellationWithMonth: (int)month andDay: (int)day
{
    NSString *constellation;
    
    switch (month) {
        case 1:
            if (day >=20 && day <= 31) {
                constellation = [NSString stringWithFormat:@"水瓶座"];
            }else {
                constellation =  [NSString stringWithFormat:@"摩羯座"];
            }
            break;
        case 2:
            if (day >=19 && day <= 29) {
                constellation = [NSString stringWithFormat:@"双鱼座"];
            }else {
                constellation =  [NSString stringWithFormat:@"摩羯座"];
            }
            break;
        case 3:
            if (day >=21 && day <= 31) {
                constellation =  [NSString stringWithFormat:@"白羊座"];
            }else {
                constellation =  [NSString stringWithFormat:@"双鱼座"];
            }
            break;
        case 4:
            if (day >=21 && day <= 30) {
                constellation =  [NSString stringWithFormat:@"金牛座"];
            }else {
                constellation =  [NSString stringWithFormat:@"白羊座"];
            }
            break;
        case 5:
            if (day >=21 && day <= 31) {
                constellation =  [NSString stringWithFormat:@"双子座"];
            }else {
                constellation =  [NSString stringWithFormat:@"金牛座"];
            }
            break;
        case 6:
            if (day >=22 && day <= 31) {
                constellation =  [NSString stringWithFormat:@"巨蟹座"];
            }else {
                constellation =  [NSString stringWithFormat:@"双子座"];
            }
            break;
        case 7:
            if (day >=23 && day <= 31) {
                constellation =  [NSString stringWithFormat:@"狮子座"];
            }else {
                constellation =  [NSString stringWithFormat:@"巨蟹座"];
            }
            break;
        case 8:
            if (day >=23 && day <= 31) {
                constellation =  [NSString stringWithFormat:@"处女座"];
            }else {
                constellation =  [NSString stringWithFormat:@"狮子座"];
            }
            break;
        case 9:
            if (day >=23 && day <= 30) {
                constellation =  [NSString stringWithFormat:@"天枰座"];
            }else {
                constellation =  [NSString stringWithFormat:@"处女座"];
            }
            break;
        case 10:
            if (day >=23 && day <= 31) {
                constellation =  [NSString stringWithFormat:@"天蝎座"];
            }else {
                constellation =  [NSString stringWithFormat:@"天枰座"];
            }
            break;
        case 11:
            if (day >=22 && day <= 30) {
                constellation =  [NSString stringWithFormat:@"射手座"];
            }else {
                constellation =  [NSString stringWithFormat:@"天蝎座"];
            }
            break;
        case 12:
            if (day >=22 && day <= 31) {
                constellation =  [NSString stringWithFormat:@"摩羯座"];
            }else {
                constellation =  [NSString stringWithFormat:@"射手座"];
            }
            break;
            
        default:
            if (day >=20 && day <= 31) {
                constellation = [NSString stringWithFormat:@"水瓶座"];
            }else {
                constellation =  [NSString stringWithFormat:@"摩羯座"];
            }
            break;
    }
    
    return constellation;
}

+ (NSString *)getBloodType:(int)type
{
    NSString *bloodType;
    
    switch (type) {
        case 1:
            bloodType =  [NSString stringWithFormat:@"A型"];
            break;
        case 2:
            bloodType =  [NSString stringWithFormat:@"B型"];
            break;
        case 3:
            bloodType =  [NSString stringWithFormat:@"AB型"];
            break;
        case 4:
            bloodType =  [NSString stringWithFormat:@"O型"];
            break;
        case 5:
            bloodType =  [NSString stringWithFormat:@"其他"];
            break;
        default:
            bloodType =  [NSString stringWithFormat:@"其他"];
            break;
    }
    
    return bloodType;
}

+ (BOOL)checkInputPassword:(NSString *)_text
{
    NSString *Regex = @"^[a-zA-Z0-9]{6,14}$";  //@"^[A-Za-z0-9]+{6,14}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+ (BOOL)checkPasswordSingText:(NSString *)_text
{
    NSString *Regex = @"^[a-zA-Z0-9]{0,14}$";  //@"^[A-Za-z0-9]+{6,14}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    BOOL  isPWDChar = [emailTest evaluateWithObject:_text];
    DLOG(@"_text:%@ is EmailSingText:%d",_text,isPWDChar);
    return isPWDChar;
}

+ (BOOL)checkEmailSingTextisIsValid:(NSString *)_text
{
    //A-Z0-9a-z._%+-@
   // NSString
    NSString   *strChar = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._%+-@";
    NSCharacterSet  *set = [NSCharacterSet characterSetWithCharactersInString:strChar];
   
    NSRange  range = [_text rangeOfCharacterFromSet:set];
    
    BOOL  isEmailChar = YES;
    if (range.location == NSNotFound)
    {
        isEmailChar = NO;
    }
    /*NSString *emailRegex = @"^[A-Z0-9a-z.+_%-@]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL  isEmailChar = [emailTest evaluateWithObject:_text];*/
    DLOG(@"_text:%@ is EmailSingText:%d",_text,isEmailChar);
    return isEmailChar;
}

+ (BOOL)checkChineseSingTextisIsValid:(NSString *)_text
{
  //  NSString *emailRegex = @"^[A-Z0-9a-z._%+-]";
    
    NSString *regex = @"^[\u4e00-\u9fa5➋-➒]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL  isChinese = YES;
    for (int i = 0; i < [_text length]; i++)
    {
        NSString  *strTemp = [_text substringWithRange:NSMakeRange(i, 1)];
        isChinese &= [emailTest evaluateWithObject:strTemp];
    }
   // BOOL  isCHinese = [emailTest evaluateWithObject:_text];
    DLOG(@"_text:%@ is chinese:%d",_text,isChinese);
    return isChinese;
}

+ (BOOL)checkSingTextisIsLetter:(NSString *)_text
{
    //A-Z0-9a-z._%+-@
    // NSString
    NSString   *strChar = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSCharacterSet  *set = [NSCharacterSet characterSetWithCharactersInString:strChar];
    
    NSRange  range = [_text rangeOfCharacterFromSet:set];
    
    BOOL  isletter = YES;
    if (range.location == NSNotFound)
    {
        isletter = NO;
    }
    /*NSString *emailRegex = @"^[A-Z0-9a-z.+_%-@]";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     BOOL  isEmailChar = [emailTest evaluateWithObject:_text];*/
    DLOG(@"_text:%@ is letter:%d",_text,isletter);
    return isletter;
}

+ (BOOL)checkEmailFormat:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}




+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)wipeCountryCodeFromTeleNumber:(NSString *)teleNumber andCountryCode:(NSString *)myCountryCode
{
    NSString *returnString = nil;;
    
    NSRange range = {0};
    range.location = 0;
    if ([teleNumber length] >= 2) {
        range.length = 2;
    }else {
        range.length = 1;
    }
    
    if ([teleNumber length] > 2) {
        if ([[teleNumber substringWithRange:range] isEqualToString:@"00"]) {
            NSString *newNumber = [teleNumber substringFromIndex:2];
            NSRange rangeCode = {0};
            rangeCode.location = 0;
            rangeCode.length = myCountryCode.length;
            
            if ([newNumber length] > rangeCode.length) {
                if ([[newNumber substringWithRange:rangeCode] isEqualToString:myCountryCode]) {
                    returnString = [newNumber substringFromIndex:myCountryCode.length];
                }else {
                    returnString = teleNumber;
                }
            }
        
        }else {
            returnString = teleNumber;
        }
    }
    
    return returnString;
}
/*
+ (NSString *)unicodeToUTF8ForNSString:(char *)string
{
    if (!string) {
        return nil;
    }
    
    NSString *returnString = nil;
    
    char *stringUnicode = unicode2bigendian(string, uni_strlen(string));
    NSString *contentUnicode = [[NSString alloc] initWithCharacters:(const unichar *)stringUnicode length:uni_strlen(stringUnicode)/2];
    char *stringUtf8 = (char *)[contentUnicode UTF8String];
    if (stringUtf8)
    {
        returnString = [NSString stringWithUTF8String:stringUtf8];
    }
    free(stringUnicode);
    stringUnicode = NULL;
    
    [contentUnicode release];
    contentUnicode = nil;
    
    return returnString;
}

+ (NSString *)unicodeToUTF8ForNSString:(char *)string andMaxLength:(int)maxLength
{
    if (!string) {
        return nil;
    }
    
    NSString *returnString = nil;
    
    int length = uni_strlen(string) > maxLength ? maxLength : uni_strlen(string);
    
    char *stringUnicode = unicode2bigendian(string, length);
    
    NSString *contentUnicode = [[NSString alloc] initWithCharacters:(const unichar *)stringUnicode length:length/2];
    
    char *stringUtf8 = (char *)[contentUnicode UTF8String];
    
    if (stringUtf8) {
        returnString = [NSString stringWithUTF8String:stringUtf8];
    }
    
    free(stringUnicode);
    
    [contentUnicode release];
    contentUnicode = nil;
    
    return returnString;
}*/



+ (NSDate *)NSStringDateToNSDate:(NSString *)string 
{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
    return date;
}

+ (NSString *)cleanUpTeleNumber:(NSString *)teleNum
{
    NSMutableString *teleNum_new = [[NSMutableString alloc] initWithCapacity:0];
    int length = 0;
    for (int i = [teleNum length]; i > 0 ; i--) {
        if ([teleNum characterAtIndex:i-1] >= '0' && [teleNum characterAtIndex:i-1] <= '9') {
            NSString *number = [NSString stringWithFormat:@"%c", [teleNum characterAtIndex:i-1]];
            [teleNum_new insertString:number atIndex:0];
            length++;
        }
    }
    
    return [teleNum_new autorelease];
}

+ (NSString *)getPlatformWithPlatformID:(int)pID
{
    NSString *platform;
    switch (pID) {
        case 4:
            platform = @"Android";
            break;
        case 5:
            platform = @"iphone";
            break;
        case 9:
            platform = @"iphone";
            break;
        default:
            platform = @"iphone";
            break;
    }
    
    return platform;
}

+ (BOOL)isPureInt:(NSString*)string
{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}


+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}



/******************************************************************************
 函数名称  : checkIsChineseString
 函数描述  : 检测输入的strText是否是中文
 输入参数  :    strText：要判断的string
 输出参数  : N/A
 返回值     : BOOL:是否是中文
 备注      :
 ******************************************************************************/
+(BOOL)checkIsChineseString:(NSString*)strText
{
     NSString *regex = @"^[\u4e00-\u9fa5]";
    return [strText isMatchedByRegex:regex];
}
/******************************************************************************
 函数名称  : checkStringSize
 函数描述  : string 字数限制
 输入参数  :    string：要判断的string ；minSize：最小字数限制；maxSize：最大字数限制
 输出参数  : N/A
 返回值      : BOOL:是否超出限制
 备注      :    一个汉字占两个字符，其他字母占一个字符
 ******************************************************************************/
+ (BOOL)checkStringSize:(NSString*)string minSize:(int)minSize maxSize:(int)maxSize
{
    NSString *regex = @"^[\u4e00-\u9fa5]";
    int length=[string length];
    int currentStringSize=0;
    for (int i=0;i<length;i++)
    {//逐步判断string中的每个字符是否为汉字，是，占两个字符，不是，占一个字符
        NSString *subString  = [string substringWithRange:NSMakeRange( i, 1)] ;
        if ([subString isMatchedByRegex:regex]) {
            currentStringSize+=2;
        }else {
            currentStringSize+=1;
        }
        
    }
    if (currentStringSize>=minSize&&currentStringSize<=maxSize) {
        return YES;
    }else {
        return NO;
    }
}

//获取当前的网络类型
+ (int)getCurrentNetType
{
    Reachability* reach=[Reachability reachabilityForInternetConnection];
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            return 4;
            break;
        case ReachableViaWWAN:
            return 3;
            break;
        default:
            return 3;
            break;
    }
}


//获取当前的网络是否是2G
+ (BOOL)getCurrentNetTypeis2G
{
    Reachability* reach=[Reachability reachabilityForInternetConnection];
    return [reach isReachableVia2G];
}

+ (BOOL)networkCanUsed
{
    BOOL ret=NO;
    
	Reachability *reach=[Reachability reachabilityForInternetConnection];
	if(reach!=nil && [reach isReachable]){
        
		ret=YES;
	}
    
	return ret;
}

//获取当前时间
+ (NSString *)getSystemTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *datestr = [formatter stringFromDate:date];
    [formatter release];
    formatter = nil;
    return datestr;
}

//判断大小端
+ (BOOL)isBigEndian
{
    union w
	{
		int   a;
		char  b;
	} c;
	memset(&c, 0 , sizeof(c));
	c.a = 1;
	return c.b != 1;
}

//大小端转换：字符型int型互转
+ (void)copyBytesByLittleEndianOrder:(uint8_t *)destBytes SrcBytes:(uint8_t *)srcBytes
                              Length:(uint32_t)length
{
    if (destBytes && srcBytes) {
        if (![UtilitiesFunction isBigEndian]) {
            //length = length - 1;
            uint8_t *pDst = destBytes;
            uint8_t *pSrc = srcBytes;
            pSrc = pSrc + length - 1;
            for (uint32_t i = 0 ; i < length; i++) {
                *pDst = *pSrc;
                pDst++;
                pSrc--;
            }
        }
        else
        {
            memcpy(destBytes, srcBytes, length);
        }
    }
}

+ (NSString *)getUUID
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result autorelease];
}

+ (void)uuidConvertToImsi:(NSString *)UUID andImsi:(char *)imsi
{
    int j = 0;
    
    char *uuidStr = (char *)[UUID UTF8String];
    for (int i = 0; i < 20; ) {
        
        if (uuidStr[i] >= '0' && uuidStr[i] <= '9') {
            imsi[j++] = uuidStr[i];
        }else if (uuidStr[i+1] >= '0' && uuidStr[i+1] <= '9') {
            imsi[j++] = uuidStr[i+1];
        }else {
            int first = uuidStr[i] - 'a';
            int second = uuidStr[i+1] - 'a';
            int total = first + second;
            
            char value = total % 10 + '0';
            imsi[j++] = value;
        }
        
        i += 2;
    }
    
    for (int i = 20; i < 35; ) {
        
        if (uuidStr[i] >= '0' && uuidStr[i] <= '9') {
            imsi[j++] = uuidStr[i];
        }else if (uuidStr[i+1] >= '0' && uuidStr[i+1] <= '9') {
            imsi[j++] = uuidStr[i+1];
        }else if (uuidStr[i+2] >= '0' && uuidStr[i+2] <= '9') {
            imsi[j++] = uuidStr[i+2];
        }else {
            int first = uuidStr[i] - 'a';
            int second = uuidStr[i+1] - 'a';
            int third = uuidStr[i+2] - 'a';
            int total = first + second + third;
            
            char value = total % 10 + '0';
            imsi[j++] = value;
        }
        
        i += 3;
    }
}

+ (int)getUserAgeWithBirthYear:(int)year
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYear = [formatter stringFromDate:date];
    int y = [currentYear intValue];
    
    int age = 0;
    
    if (y > year) {
        age = y - year;
    }else {
        age = 1;
    }
    
    return age;
}

+ (BOOL)isInputInValidCharacter:(NSString *)text
{
    NSString *regex = @"^[a-zA-Z\u4e00-\u9fa5]";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return ![predicate evaluateWithObject:text];
}


+(CGFloat)calculateTextHeight:(CGFloat)widthInput Content:(NSString *)strContent  font:(UIFont*)font
{
    
    CGSize constraint = CGSizeMake(widthInput, 20000.0f);
    CGSize size = [strContent sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, 0.0f);
    
    return height;
}

+(BOOL)isExpireFromNowDate:(NSTimeInterval)expireStamp nowTime:(NSTimeInterval)nowTime;
{
    return expireStamp > nowTime ? NO:YES;
}


/**
 *
 *
 *  @param timerInterverce timerInterverce
 *
 *  @return among @"昨天" @"2天前" @"3天前" @"4天前" @"5天前" @"6天前" @"7天前"
 */
+(NSString*)getTimeStringAccordTimeInterveral:(int)timerInterverce
{
    
    int  fdealt = ([[NSDate date] timeIntervalSince1970] - timerInterverce)/(3600*24);
    
    
    NSString  *dateStr = nil;
    if (fdealt < 1)
    {
        NSDateFormatter *timerForm = [[[NSDateFormatter alloc] init] autorelease];
        [timerForm setDateFormat:@"YYYYMMdd"];
        NSString *time = [timerForm stringFromDate:[NSDate date]];
        NSString *oldDate = [timerForm stringFromDate:[NSDate dateWithTimeIntervalSince1970:timerInterverce]];
        //   NSLog(@"time:%@ oldDate:%@",time,oldDate);
        
        
        if (![time isEqualToString:oldDate])
        {
            return @"昨天";
        }
        
    }
    switch (fdealt)
    {
        case 0:
        {
            NSDateFormatter *timerForm = [[[NSDateFormatter alloc] init] autorelease];
            [timerForm setDateFormat:@"HH:mm"];
            dateStr = [timerForm stringFromDate:[NSDate dateWithTimeIntervalSince1970:timerInterverce]];
        }
            break;
        case 1:
            dateStr = @"昨天";
            break;
        case 2:
            dateStr = @"2天前";
            break;
        case 3:
            dateStr = @"3天前";
            break;
        case 4:
            dateStr = @"4天前";
            break;
        case 5:
            dateStr = @"5天前";
            break;
        case 6:
            dateStr = @"6天前";
            break;
        default:
            dateStr = @"7天前";
            break;
    }
    
    
    
    return dateStr;
    
}

static const char* jailbreak_apps[] =
{
    "/Applications/Cydia.app",
    "/Applications/limera1n.app",
    "/Applications/greenpois0n.app",
    "/Applications/blackra1n.app",
    "/Applications/blacksn0w.app",
    "/Applications/redsn0w.app",
    "/Applications/Absinthe.app",
    NULL,
};

+ (BOOL)isJailbreakSystem
{
    for (int i = 0; jailbreak_apps[i] != NULL; ++i)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_apps[i]]])
        {
            //NSLog(@"isjailbroken: %s", jailbreak_apps[i]);
            return YES;
        }
    }
    
    // TODO: Add more checks? This is an arms-race we're bound to lose.
    
    return NO;
}



+(NSString *)getdescriptionOfobject:(id)object
{
    
    NSString  *strInfo = nil;
    #if DEBUG
    const char *className = class_getName([object class]);
    NSString  *strClassName = [NSString stringWithCString:className encoding:NSUTF8StringEncoding];
    
    strInfo = [NSString stringWithFormat:@"baseclass:%@ <<%p>> %d",strClassName,object,__LINE__];
    
  //  @encode(NSDate);
    unsigned int  count = 0;
    Ivar *list  =   class_copyIvarList([object class], &count);
    for (int i = 0; i < count; i++)
    {
        Ivar ivar = list[i];
        
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSString  *ivarName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSString  *ivarTye = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        //id realType = nil; //id object_getIvar(id obj, Ivar ivar)
        //id value = object_getIvar(self, ivar);
        
        if ([ivarTye rangeOfString:@"@"].location != NSNotFound)
        {
            id value = object_getIvar(object, ivar);
            strInfo = [strInfo stringByAppendingFormat:@"\n%@: %@ ",ivarName,value];
            //  NSLog();
        }else
        {
            if ([ivarTye length] == 1)
            {
                switch (type[0])
                {
                    case 'c':
                    {
                        char c = (char)object_getIvar(object, ivar);
                        //  NSLog(@"%@: %c",ivarName,c);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %c",ivarName,c];
                    }
                        
                        break;
                    case 'i':
                    {
                        int c = (int)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %i",ivarName,c];
                        // NSLog(@"%@: %i",ivarName,c);
                        
                    }
                        break;
                    case 's':
                    {
                        short c = (short)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %i",ivarName,c];
                        // NSLog(@"%@: %i",ivarName,c);
                        
                    }
                        break;
                    case 'l':
                    {
                        long c = (long)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %ld",ivarName,c];
                        // NSLog(@"%@: %ld",ivarName,c);
                        
                    }
                        break;
                    case 'q':
                    {
                        long long c = (long long)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %lld",ivarName,c];
                        //   NSLog(@"%@: %lld",ivarName,c);
                        
                    }
                        
                        break;
                    case 'C':
                    {
                        unsigned char c = (unsigned char)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %c",ivarName,c];
                        //  NSLog(@"%@: %c",ivarName,c);
                        
                    }
                        break;
                    case 'I':
                    {
                        unsigned int c = (unsigned int)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %d",ivarName,c];
                        //  NSLog(@"%@: %d",ivarName,c);
                        
                    }
                        break;
                    case 'S':
                    {
                        unsigned short c = (unsigned short)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %d",ivarName,c];
                        //  NSLog(@"%@: %d",ivarName,c);
                        
                    }
                        break;
                    case 'L':
                    {
                        unsigned long c = (unsigned long)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %ld",ivarName,c];
                        // NSLog(@"%@: %ld",ivarName,c);
                        
                    }
                        break;
                    case 'Q':
                    {
                        unsigned long long c = (unsigned long long)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %lld",ivarName,c];
                        // NSLog(@"%@: %lld",ivarName,c);
                        
                    }
                        break;
                    case 'f':
                    case 'd':
                    {
                        float  value = 0;
                        object_getInstanceVariable(object,name,(void*)&value);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %f",ivarName,value];
                        
                    }
                        break;
                    case 'B':
                    {
                        
                        int  value = 0;
                        object_getInstanceVariable(object,name,(void*)&value);
                        strInfo = [strInfo stringByAppendingFormat:@"\n%@: %d",ivarName,value];
                      /*  int c = (int)object_getIvar(object, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %d",ivarName,c];*/
                        //NSLog(@"%@: %d",ivarName,c);
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        
        // NSLog(@"name:%@ type:%@",ivarName,ivarTye);
    }
    
    free(list);
    #endif
    
    return strInfo;
}


/**
 *
 *
 *  @param value number value
 *  @param type NSNumberFormatterStyle type
 *
 *  @return the string after format
 */
+(NSString*)getNUmberStringUserFormat:(int)value format:(NSNumberFormatterStyle)type
{
    NSNumberFormatter   *number = [[NSNumberFormatter alloc] init];
  //  [NSNumberFormatter setDefaultFormatterBehavior:type];
    
    [number setNumberStyle:type];
    
    NSString  *strFormat = [number stringFromNumber:@(value)];
    
    [number release];
    number = nil;
   
    return strFormat;
}

/**
 *  check this string is all space
 *
 *  @param strInfo check string
 *
 *  @return check result
 */
+ (BOOL)checkStringIsAllSpace:(NSString*)strInfo
{
    if (strInfo == nil)
    {
        return YES;
    }
    for (int i = 0;i < [strInfo length];i++)
    {
        NSString  *strTemp = [strInfo substringWithRange:NSMakeRange(i, 1)];
        if (![strTemp isEqualToString:@" "])
        {
            return NO;
        }
    }
    return YES;

}


/**
 *
 *
 *  @param strTitle 图片内容
 *
 *  @return 图片
 */
+(UIImage *)getImageAccordTitle:(NSString*)strTitle
{
    UIImage  *image = nil;
    if ([strTitle isEqualToString:@"充值"])
    {
        image = [PublicClass getImageAccordName:@"alert_charge.png"];
    }else if ([strTitle isEqualToString:@"取消"])
    {
        image = [PublicClass getImageAccordName:@"alert_cancel.png"];
    }else if ([strTitle isEqualToString:@"我知道了"])
    {
        image = [PublicClass getImageAccordName:@"alert_iknow.png"];
    }else if ([strTitle isEqualToString:@"更新"])
    {
        image = [PublicClass getImageAccordName:@"alert_update.png"];
    }else if ([strTitle isEqualToString:@"残忍拒绝"])
    {
        image = [PublicClass getImageAccordName:@"alert_refuse.png"];
    }else if ([strTitle isEqualToString:@"确定"])
    {
        image = [PublicClass getImageAccordName:@"alert_ensure.png"];
    }else if ([strTitle isEqualToString:@"离开"])
    {
        image = [PublicClass getImageAccordName:@"alert_leave.png"];
    }else if ([strTitle isEqualToString:@"解锁"])
    {
        image = [PublicClass getImageAccordName:@"alert_unlock.png"];
    }else if ([strTitle isEqualToString:@"设置"])
    {
        image = [PublicClass getImageAccordName:@"alert_set.png"];
    }else if ([strTitle isEqualToString:@"购买"])
    {
        image = [PublicClass getImageAccordName:@"alert_purchase.png"];
    }else if ([strTitle isEqualToString:@"赐个5星"])
    {
        image = [PublicClass getImageAccordName:@"alert_vote5stars.png"];
    }else if ([strTitle isEqualToString:@"返回"])
    {
        image = [PublicClass getImageAccordName:@"alert_back.png"];
    }else if ([strTitle isEqualToString:@"退出"])
    {
        image = [PublicClass getImageAccordName:@"alert_quit.png"];
    }else if ([strTitle isEqualToString:@"领取奖励"])
    {
        image = [PublicClass getImageAccordName:@"alert_gainward.png"];
    }else if ([strTitle isEqualToString:@"分享"])
    {
        image = [PublicClass getImageAccordName:@"answer_right_share.png"];
    }else if ([strTitle isEqualToString:@"重置"])
    {
        image = [PublicClass getImageAccordName:@"alert_reset.png"];
    }else if ([strTitle isEqualToString:@"丞相"])
    {
        image = [PublicClass getImageAccordName:@"rank_chengxiang.png"];
    }else if ([strTitle isEqualToString:@"举人"])
    {
        image = [PublicClass getImageAccordName:@"rank_juren.png"];
    }else if ([strTitle isEqualToString:@"尚书"])
    {
        image = [PublicClass getImageAccordName:@"rank_shangshu.png"];
    }else if ([strTitle isEqualToString:@"布衣"])
    {
        image = [PublicClass getImageAccordName:@"rank_buyi.png"];
    }else if ([strTitle isEqualToString:@"探花"])
    {
        image = [PublicClass getImageAccordName:@"rank_tanhua.png"];
    }else if ([strTitle isEqualToString:@"状元"])
    {
        image = [PublicClass getImageAccordName:@"rank_zhuangyuan.png"];
    }else if ([strTitle isEqualToString:@"榜眼"])
    {
        image = [PublicClass getImageAccordName:@"rank_bangyan.png"];
    }else if ([strTitle isEqualToString:@"皇帝"])
    {
        image = [PublicClass getImageAccordName:@"rank_huangdi.png"];
    }else if ([strTitle isEqualToString:@"秀才"])
    {
        image = [PublicClass getImageAccordName:@"rank_xiucai.png"];
    }else if ([strTitle isEqualToString:@"进士"])
    {
        image = [PublicClass getImageAccordName:@"rank_jinshi.png"];
    }
    
    
    return image;
}




+(NSString*)getLevelStringAccordWinCount:(int)wintCount
{
    int score = wintCount*3;
    NSString *strLevel = nil;
/*#if USETESTDATA
    if (score <= 3)
    {
        strLevel = @"布衣";
    }else if (score <= 6)
    {
        strLevel = @"秀才";
    }else if (score <= 9)
    {
        strLevel = @"举人";
    }else if (score <= 12)
    {
        strLevel = @"进士";
    }else if (score <= 15)
    {
        strLevel = @"探花";
    }else if (score <= 18)
    {
        strLevel = @"榜眼";
    }else if (score <= 21)
    {
        strLevel = @"状元";
    }else if (score <= 24)
    {
        strLevel = @"尚书";
    }else if (score <= 27)
    {
        strLevel = @"丞相";
    }else if (score > 27)
    {
        strLevel = @"皇帝";
    }
#else
    if (score <= 30)
    {
        strLevel = @"布衣";
    }else if (score <= 90)
    {
        strLevel = @"秀才";
    }else if (score <= 180)
    {
        strLevel = @"举人";
    }else if (score <= 360)
    {
        strLevel = @"进士";
    }else if (score <= 600)
    {
        strLevel = @"探花";
    }else if (score <= 900)
    {
        strLevel = @"榜眼";
    }else if (score <= 1500)
    {
        strLevel = @"状元";
    }else if (score <= 3000)
    {
        strLevel = @"尚书";
    }else if (score <= 6000)
    {
        strLevel = @"丞相";
    }else if (score > 6000)
    {
        strLevel = @"皇帝";
    }
#endif*/
    
    
    
    if (score < 30)
    {
        strLevel = @"布衣";
    }else if (score < 90)
    {
        strLevel = @"秀才";
    }else if (score < 180)
    {
        strLevel = @"举人";
    }else if (score < 360)
    {
        strLevel = @"进士";
    }else if (score < 600)
    {
        strLevel = @"探花";
    }else if (score < 900)
    {
        strLevel = @"榜眼";
    }else if (score < 1500)
    {
        strLevel = @"状元";
    }else if (score < 3000)
    {
        strLevel = @"尚书";
    }else if (score < 6000)
    {
        strLevel = @"丞相";
    }else if (score >= 6000)
    {
        strLevel = @"皇帝";
    }
    return strLevel;
}


+(int)getlastLevelAccordWinCount:(int)wintCount
{
    int score = wintCount*3;
  
    
    if (score < 30)
    {
        score = 30;
    }else if (score < 90)
    {
        score = 90;
    }else if (score < 180)
    {
        score = 180;
    }else if (score < 360)
    {
        score = 360;
    }else if (score < 600)
    {
        score = 600;
    }else if (score < 900)
    {
        score = 900;
    }else if (score < 1500)
    {
        score = 1500;
    }else if (score < 3000)
    {
        score = 3000;
    }else if (score < 6000)
    {
        score = 6000;
    }else if (score >= 6000)
    {
        score = 6001;
    }
    return score;
}


+(UIImageView *)getImagewithNumber:(int)number  type:(JFPicNumberType)type
{
    NSString  *strImage = [NSString stringWithFormat:@"%d",number];
    
    NSString  *strPre = nil;
    switch (type)
    {
        case JFPicNumberTypeGoldNumber:
            strPre = @"gold_number";
            break;
        case JFPicNumberTypeLevelNumber:
            strPre = @"level_number";
            break;
        case JFPicNumberTypeAnswerRightNumber:
            strPre = @"answer_right";
            break;//racewin_number0
        case JFPicNumberTypeAnswerconwinNumber:
            strPre = @"racewin_number";
            break;//racewin_number0
            
        default:
            break;
    }
    UIImage  *tempimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@0.png",strPre]];
    
   
    
    UIImageView  *bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    CGFloat   fxpoint = 0;
    for (int i = 0; i < [strImage length]; i++)
    {
        NSString  *strName =  [NSString stringWithFormat:@"%@%@.png",strPre,[strImage substringWithRange:NSMakeRange(i, 1)]];
      //  DLOG(@"strName:%@ strImage:%@",strName,strImage);
        UIImage  *image = [UIImage imageNamed:strName];//[UIImage imageNamed:strName];
        UIImageView  *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(fxpoint, 0, image.size.width/2, image.size.height/2)];
        [bgView addSubview:tempView];
        tempView.image = image;
        [tempView release];
        
        fxpoint += image.size.width/2;
    }
    
    [bgView setFrame:CGRectMake(0, 0, fxpoint,tempimage.size.height/2)];
    
    
    return [bgView autorelease];;
}






+ (NSString *)getNormalXmlPath:(NSString *)strPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"GuessImageWarnormal"];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    return [dataPath stringByAppendingPathComponent:strPath];
}

+(BOOL)deleteNomalXmlPath:(NSString*)strPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"GuessImageWarnormal"];
    NSString *filePath = [dataPath stringByAppendingPathComponent:strPath];
    BOOL  bSuc = NO;
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        bSuc  =  [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!bSuc || error)
        {
            DLOG(@"deleteNomalXmlPath fail:%@  error:%@",filePath,error);
        }
        
    }
    
    return bSuc;
}
+ (NSString *)getNormalQustionZip:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"cywarqusetion"];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    return [dataPath stringByAppendingPathComponent:imageName];
}
+(BOOL)deleteNormalQustionZip:(NSString*)strPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"cywarqusetion"];
    NSString *filePath = [dataPath stringByAppendingPathComponent:strPath];
    BOOL  bSuc = NO;
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        bSuc  =  [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!bSuc || error)
        {
            DLOG(@"deleteNomalXmlPath fail:%@  error:%@",filePath,error);
        }
        
    }
    
    return bSuc;
}
+ (NSString *)getRaceQustionZip:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"cywarracequsetion"];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    return [dataPath stringByAppendingPathComponent:imageName];
}

+(BOOL)deleteRaceQustionZip:(NSString*)strPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"cywarracequsetion"];
    NSString *filePath = [dataPath stringByAppendingPathComponent:strPath];
    BOOL  bSuc = NO;
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        bSuc  =  [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!bSuc || error)
        {
            DLOG(@"deleteNomalXmlPath fail:%@  error:%@",filePath,error);
        }
        
    }
    
    return bSuc;
}
#define CHUNK_SIZE 1024

+(NSString *)file_md5:(NSString*) path

{
    
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if(handle == nil)
    {
       
        
        BOOL  isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
         DLOG(@"file is not exist:%@ isExist:%d",path,isExist);
        return nil;
        
    }
    
    
    
    
    CC_MD5_CTX md5_ctx;
    
    CC_MD5_Init(&md5_ctx);
    
    
    
    NSData* filedata;
    
    do {
        
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
        
    }
    
    while([filedata length]);
    
    
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(result, &md5_ctx);
    
    
    
    [handle closeFile];
    
    
    
    NSMutableString *hash = [NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
        
    {
        
        [hash appendFormat:@"%02x",result[i]];
        
    }
    
    return [hash lowercaseString];
    
}

@end
