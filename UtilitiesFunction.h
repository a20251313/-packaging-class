//
//  UtilitiesFunction.h
//  I366_V1_4
//
//  Created by  on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "GDataXMLNode.h"

typedef enum
{
    JFPicNumberTypeGoldNumber,
    JFPicNumberTypeLevelNumber,
    JFPicNumberTypeAnswerRightNumber,
    JFPicNumberTypeAnswerconwinNumber
    
}JFPicNumberType;
@interface UtilitiesFunction : NSObject









//根据平台号获取平台
+ (NSString *)getPlatformWithPlatformID:(int)pID;

//判断字符串是否为纯数字
+ (BOOL)isPureInt:(NSString*)string;

//判断字符串是否是手机号
+(BOOL)isMobileNumber:(NSString *)mobileNum;




//计算两个日期之间的天数
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

//判断字符串长度合法性
+ (BOOL)checkStringSize:(NSString*)string minSize:(int)minSize maxSize:(int)maxSize;

//获取当前的网络类型
+ (int)getCurrentNetType;


//获取当前的网络是否是2G
+ (BOOL)getCurrentNetTypeis2G;

//当前网络是否可用
+ (BOOL)networkCanUsed;

//获取当前时间
+ (NSString *)getSystemTime;



//判断大小端
+ (BOOL)isBigEndian;

//大小端转换：字符型int型互转
+ (void)copyBytesByLittleEndianOrder:(uint8_t *)destBytes SrcBytes:(uint8_t *)srcBytes
                              Length:(uint32_t)length;

//获取UUID
+ (NSString *)getUUID;

//UUID转换至imsi
+ (void)uuidConvertToImsi:(NSString *)UUID andImsi:(char *)imsi;

//获取用户年龄
+ (int)getUserAgeWithBirthYear:(int)year;


//判断单个字符是否是邮箱地址的非法字符
+ (BOOL)checkEmailSingTextisIsValid:(NSString *)_text;

//判断单个字符是否是汉字的非法字符
+ (BOOL)checkChineseSingTextisIsValid:(NSString *)_text;

//判断单个字符是否是字母
+ (BOOL)checkSingTextisIsLetter:(NSString *)_text;

+ (CGFloat)calculateTextHeight:(CGFloat)widthInput Content:(NSString *)strContent  font:(UIFont*)font;

//判断当前时间是否大于时间戳  如果是 返回YES
+(BOOL)isExpireFromNowDate:(NSTimeInterval)expireStamp nowTime:(NSTimeInterval)nowTime;








/**
 *
 *
 *  @param timerInterverce timerInterverce
 *
 *  @return among @"昨天" @"2天前" @"3天前" @"4天前" @"5天前" @"6天前" @"7天前"
 */
+(NSString*)getTimeStringAccordTimeInterveral:(int)timerInterverce;

/// 判断是否为越狱设备
+ (BOOL)isJailbreakSystem;

//获取一个类的变量以及变量的值
+(NSString *)getdescriptionOfobject:(id)object;


+(NSString*)getNUmberStringUserFormat:(int)value format:(NSNumberFormatterStyle)type;


/**
 *  check this string is all space
 *
 *  @param strInfo check string
 *
 *  @return check result
 */

/// 判断是否为全部空格
+ (BOOL)checkStringIsAllSpace:(NSString*)strInfo;


/**
 *
 *
 *  @param strTitle 图片内容
 *
 *  @return 图片
 */
+(UIImage *)getImageAccordTitle:(NSString*)strTitle;

/**
 *  根据胜利场数判定等级名称
 *
 *  @param wintCount 胜利场数
 *
 *  @return 等级名称
 */
+(NSString*)getLevelStringAccordWinCount:(int)wintCount;

/**
 *  根据数字大小获得图片view。
 *
 *  @param number 数字大小
 *  @param type   图片类型
 *
 *  @return  图片view  不需要释放
 */
+(UIImageView *)getImagewithNumber:(int)number  type:(JFPicNumberType)type;

/**
 *  获取当前的xml存贮路径
 *
 *  @param imageName 后缀名
 *
 *  @return 绝对路径
 */
+ (NSString *)getNormalXmlPath:(NSString *)imageName;

/**
 *  获取当前的zip文件存贮路径
 *
 *  @param imageName 后缀名
 *
 *  @return 绝对路径
 */
+ (NSString *)getNormalQustionZip:(NSString *)imageName;

/**
 *  获取当前的race zip文件存贮路径
 *
 *  @param imageName 后缀名
 *
 *  @return 绝对路径
 */

+ (NSString *)getRaceQustionZip:(NSString *)imageName;


/**
 *  校验文件的MD5
 *
 *  @param path 文件路径
 *
 *  @return 校验码
 */
+(NSString *)file_md5:(NSString*) path;



+(BOOL)checkIsChineseString:(NSString*)strText;

/**
 *  <#Description#>
 *
 *  @param strPath <#strPath description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)deleteNomalXmlPath:(NSString*)strPath;

+(BOOL)deleteRaceQustionZip:(NSString*)strPath;

+(BOOL)deleteNormalQustionZip:(NSString*)strPath;

+(int)getlastLevelAccordWinCount:(int)wintCount;

+(NSString*)stroreDBPathInDoc;
@end
