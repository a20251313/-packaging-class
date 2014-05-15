//
//  JFHttpRequsetManger.h
//  chengyuwar
//
//  Created by ran on 13-12-20.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "sdstatus.h"




@class JFHttpRequsetManger;

@protocol JFHttpRequsetMangerDelegate <NSObject>
-(void)getServerResult:(NSDictionary*)dicInfo requsetString:(NSString*)requestString;
-(void)getNetError:(NSString*)statusCode requsetString:(NSString*)requestString;
@end



@interface JFURLConnection : NSURLConnection


@property(nonatomic)int index;
@property(nonatomic,copy)NSString   *firstUrl;
@property(nonatomic,copy)NSString   *secondUrl;
@property(nonatomic,copy)NSString   *LastUrl;
@property(nonatomic,retain)NSDictionary *dicParam;
@property(nonatomic)BOOL   isFirst;

@end
@interface JFHttpRequsetManger : NSObject
{
    NSMutableDictionary                 *m_dicStoreData;
    id<JFHttpRequsetMangerDelegate>     delegate;
    int                                 m_index;
}
@property(nonatomic,assign)id<JFHttpRequsetMangerDelegate> delegate;



-(void)startRequestData:(NSDictionary*)dicInfo  requestURL:(NSString*)requsetString;
@end
