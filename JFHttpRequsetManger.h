//
//  JFHttpRequsetManger.h
//  chengyuwar
//
//  Created by ran on 13-12-20.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"


#if !__has_feature(objc_arc)
#define RetainPropery   retain
#define CopyPropery     copy
#define AssignPropery   assign
#define ReleaseObject(_name)    [_name release];_name = nil;
#else
#define CopyPropery     strong
#define RetainPropery   strong
#define AssignPropery   weak
#define ReleaseObject(_name)      _name = nil;
#endif


@class JFHttpRequsetManger;
@protocol JFHttpRequsetMangerDelegate <NSObject>
-(void)getServerResult:(NSDictionary*)dicInfo requsetString:(NSString*)requestString;
-(void)getNetError:(NSString*)statusCode requsetString:(NSString*)requestString;
@end


@interface JFURLConnection : NSURLConnection
@property(nonatomic)int index;
@property(nonatomic,RetainPropery)NSString   *firstUrl;
@property(nonatomic,RetainPropery)NSString   *secondUrl;
@property(nonatomic,RetainPropery)NSString   *LastUrl;
@property(nonatomic,RetainPropery)NSDictionary *dicParam;
@property(nonatomic)BOOL   isFirst;
@property(nonatomic,RetainPropery)NSString   *method;

@end
@interface JFHttpRequsetManger : NSObject
{
    NSMutableDictionary                 *m_dicStoreData;
    int                                 m_index;
}
@property(nonatomic,AssignPropery)id<JFHttpRequsetMangerDelegate> delegate;



-(void)startRequestData:(NSDictionary*)dicInfo  requestURL:(NSString*)LastUrl method:(NSString*)method;
@end
