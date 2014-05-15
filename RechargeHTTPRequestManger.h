//
//  RechargeHTTPRequest.h
//  QMic
//
//  Created by wurong on 13-12-10.
//  Copyright (c) 2013年 WuRong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"
#import "sdstatus.h"
@class RechargeHTTPRequestManger;

@protocol RechargeHTTPRequestMangerDelegate <NSObject>
-(void)getHttpsResult:(NSDictionary*)dicInfo requestString:(NSString*)requestString;
-(void)getHttpNetError:(NSString*)statusCode requestString:(NSString*)requestString;
@end


@interface JFMyURLConnection : NSURLConnection

@property(nonatomic)int startIndex;
@property(nonatomic,copy)NSString   *firstUrl;
@property(nonatomic,copy)NSString   *secondUrl;
@property(nonatomic,copy)NSString   *LastUrl;
@property(nonatomic,retain)NSDictionary *dicParam;
@property(nonatomic)BOOL   isFirst;

@end

@interface RechargeHTTPRequestManger : NSObject<NSURLAuthenticationChallengeSender, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    
    int     m_index;
    NSMutableDictionary     *m_dicStoreData;
    id<RechargeHTTPRequestMangerDelegate> delegate;
}

@property(nonatomic,assign)id<RechargeHTTPRequestMangerDelegate> delegate;


-(void)startRequestData:(NSDictionary*)dicInfo  requestURL:(NSString*)LastUrl;

@end
