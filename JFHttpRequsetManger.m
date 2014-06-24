//
//  JFHttpRequsetManger.m
//  chengyuwar
//
//  Created by ran on 13-12-20.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//




#import "JFHttpRequsetManger.h"
#import "Base64.h"

NSString   *const       BNRNetWorkErrorOccur = @"BNRNetWorkErrorOccur";
#define dataKey(requestString,index)  [NSString stringWithFormat:@"%@%d",requestString,index]
#ifndef SERVERAPPURL
#define SERVERAPPURL        @"http://10.0.5.120:8080/mobile/"
#endif
@implementation JFURLConnection
@synthesize index;
@synthesize firstUrl;
@synthesize secondUrl;
@synthesize dicParam;
@synthesize LastUrl;
@synthesize isFirst;
@synthesize method;


-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate index:(int)myindex
{
    self = [super initWithRequest:request delegate:delegate];
    if (self)
    {
        self.index = myindex;
    }
    return self;
}
-(void)dealloc
{
    
    DEBUGLog(@"JFURLConnection dealloc");
    self.firstUrl = nil;
    self.secondUrl = nil;
    self.dicParam = nil;
    self.LastUrl = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}
@end

@implementation JFHttpRequsetManger
@synthesize delegate;

-(id)init
{
    self = [super init];
    if (self)
    {

        m_dicStoreData = [[NSMutableDictionary alloc] init];
        m_index = 0;
     
    }
    
    return self;
}

-(void)startRequestData:(NSDictionary*)dicInfo  requestURL:(NSString*)LastUrl method:(NSString*)method
{
    if (![dicInfo count])
    {
        DEBUGLog(@"startRequestData return by no values:%@",dicInfo);
       // return;
    }
   
    for (NSString *key in m_dicStoreData.allKeys)
    {
        DEBUGLog(@"key:%@\n",key);
    }
    NSMutableData   *data = [m_dicStoreData objectForKey:dataKey(LastUrl, m_index)];
    DEBUGLog(@"currentKey:%@\n",dataKey(LastUrl, m_index));
    if (data)
    {
        [data setData:nil];
    }else
    {
        data = [NSMutableData data];
        [data setData:nil];
        [m_dicStoreData setObject:data forKey:dataKey(LastUrl, m_index)];
    }

    
    
    NSString *postString = @"";
    
    for (NSString *key in dicInfo)
    {
        if ([postString isEqualToString:@""])
        {
            postString = [postString stringByAppendingFormat:@"%@=%@",key,[dicInfo valueForKey:key]];
        }else
        {
            postString = [postString stringByAppendingFormat:@"&%@=%@",key,[dicInfo valueForKey:key]];
        }
        
    }

    NSString    *strUrl = SERVERAPPURL;
 //   DEBUGLog(@"startRequestData:headurl:%@",strUrl);
    
    NSString *requreststring = [strUrl stringByAppendingString:LastUrl];
    NSURL *url = [NSURL URLWithString:requreststring];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postString length]];
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:method];
    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    JFURLConnection *conn = [[JFURLConnection alloc] initWithRequest:req delegate:self index:m_index];
    conn.dicParam = dicInfo;
    conn.LastUrl = LastUrl;
    conn.isFirst = NO;
    conn.method = method;
    m_index++;
    [conn start];
    if (!conn)
    {
        DEBUGLog(@"startRequestData fail:%@",req);
    }
   // [conn release];
    
    
    DEBUGLog(@"\n\n----------\n\nparams:\n%@  actions:%@\n\n----------\n\n",dicInfo,LastUrl);
    
}

#pragma mark  NSURLConnectiondelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    

    NSHTTPURLResponse  *httprespone = (NSHTTPURLResponse*)response;
    
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];

    if (httprespone.statusCode != 200)
    {
        
        
      //  JFURLConnection *con = (JFURLConnection*)connection;
      /*  if (con.isFirst)
        {
            [self startTrySecondRequestData:con.dicParam requestURL:con.LastUrl method:con.method];
            return;
        }*/
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(getNetError:requsetString:)])
            {
                [delegate getNetError:[NSString stringWithFormat:@"%d",0] requsetString:lastUrl];
            }else
            {
                DEBUGLog(@"connection didFailWithError not callback......................");
            }
        });
        
    }
    
    
    
    
    
    
 //   DLOG(@"httprespone status:%d",httprespone.statusCode);
    //statusCode
 //   DLOG(@"connection:%@ didReceiveResponse:%@",connection,response);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  //  DLOG(@"connection:%@ didReceiveData:%@",connection,data);
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    
    JFURLConnection *con = (JFURLConnection*)connection;
    NSMutableData   *mutabledata = [m_dicStoreData objectForKey:dataKey(lastUrl, con.index)];
    [mutabledata appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DEBUGLog(@"connection:%@ didFailWithError:%@",connection,error);
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    JFURLConnection *con = (JFURLConnection*)connection;
    NSMutableData   *mutabledata = [m_dicStoreData objectForKey:dataKey(lastUrl, con.index)];
    [mutabledata setData:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:BNRNetWorkErrorOccur object:nil];
        if (delegate && [delegate respondsToSelector:@selector(getNetError:requsetString:)])
        {
            [delegate getNetError:[NSString stringWithFormat:@"%d",0] requsetString:lastUrl];
        }else
        {
              DEBUGLog(@"connection didFailWithError not callback......................");
        }
    });
  
    DEBUGLog(@"requsetString:%@",lastUrl);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    JFURLConnection *con = (JFURLConnection*)connection;
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    NSMutableData   *mutabledata = [m_dicStoreData objectForKey:dataKey(lastUrl, con.index)];
    
    
    if ([mutabledata length] <= 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:BNRNetWorkErrorOccur object:nil];
        if (delegate && [delegate respondsToSelector:@selector(getNetError:requsetString:)])
        {
            [delegate getNetError:[NSString stringWithFormat:@"%d",0] requsetString:lastUrl];
        }else
        {
            DEBUGLog(@"connection didFailWithError not callback......................");
        }
        [m_dicStoreData removeObjectForKey:dataKey(lastUrl, con.index)];
        
        DEBUGLog(@"connectionDidFinishLoading no data");
        return;
    }
    
    
     NSString  *strTest = [[NSString alloc] initWithData:mutabledata encoding:NSUTF8StringEncoding];
    
     NSDictionary  *dicInfo = [strTest objectFromJSONString];
    if (dicInfo == nil || strTest == nil)
    {
      
        
        NSString    *datastring = [[NSString alloc] initWithCString:[mutabledata bytes] encoding:NSUTF8StringEncoding];
        NSDictionary  *dicInfo = [datastring objectFromJSONString];
          DEBUGLog(@"connectionDidFinishLoading mutabledata:%@ datastring:%@ dicInfo:%@",mutabledata,datastring,dicInfo);
        ReleaseObject(datastring);
    }
    
   
    NSMutableDictionary *dicMutInfo = [NSMutableDictionary dictionaryWithDictionary:dicInfo];
    
    for (id key in dicInfo)
    {
        id value = [dicInfo valueForKey:key];
        if ([value isKindOfClass:[NSNumber class]])
        {
            [dicMutInfo setObject:[value description] forKey:key];
        }
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       if (delegate && [delegate isKindOfClass:[NSObject class]] && [delegate respondsToSelector:@selector(getServerResult:requsetString:)])
                       {
                           [delegate getServerResult:dicMutInfo requsetString:lastUrl];
                       }else
                       {
                           DEBUGLog(@"connectionDidFinishLoading not callback......................");
                       }
                   });
  
    DEBUGLog(@"dicInfo:%@  requeststring:%@",dicMutInfo,lastUrl);
    ReleaseObject(strTest);
    
    [m_dicStoreData removeObjectForKey:dataKey(lastUrl, con.index)];
}



-(void)dealloc
{
    DEBUGLog(@"JFHttpRequsetManger dealloc");
    ReleaseObject(m_dicStoreData);
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end
