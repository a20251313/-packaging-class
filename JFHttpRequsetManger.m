//
//  JFHttpRequsetManger.m
//  chengyuwar
//
//  Created by ran on 13-12-20.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//




#import "JFHttpRequsetManger.h"
#import "DomainNameParser.h"

NSString   *const       BNRNetWorkErrorOccur = @"BNRNetWorkErrorOccur";
#define dataKey(requestString,index)  [NSString stringWithFormat:@"%@%d",requestString,index]



@implementation JFURLConnection
@synthesize index;
@synthesize firstUrl;
@synthesize secondUrl;
@synthesize dicParam;
@synthesize LastUrl;
@synthesize isFirst;


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
    
    DLOG(@"JFURLConnection dealloc");
    self.firstUrl = nil;
    self.secondUrl = nil;
    self.dicParam = nil;
    self.LastUrl = nil;
    [super dealloc];
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

-(void)startRequestData:(NSDictionary*)dicInfo  requestURL:(NSString*)LastUrl
{
   

  
    NSMutableData   *data = [m_dicStoreData objectForKey:dataKey(LastUrl, m_index)];
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

    NSString    *strUrl = [DomainNameParser getFirstHttpUrl];
    DLOG(@"startRequestData:headurl:%@",strUrl);
    
    NSString *requreststring = [strUrl stringByAppendingString:LastUrl];
    NSURL *url = [NSURL URLWithString:requreststring];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    JFURLConnection *conn = [[JFURLConnection alloc] initWithRequest:req delegate:self index:m_index];
    conn.dicParam = dicInfo;
    conn.LastUrl = LastUrl;
    conn.isFirst = YES;
    m_index++;
    [conn start];
    if (!conn)
    {
        DLOG(@"startRequestData fail:%@",req);
    }
    [conn release];
    
    
    DLOG(@"startRequestData:%@  requestString:%@",postString,LastUrl);
    
}


-(void)startTrySecondRequestData:(NSDictionary*)dicInfo  requestURL:(NSString*)LastUrl
{
    
    
    
    NSMutableData   *data = [m_dicStoreData objectForKey:dataKey(LastUrl, m_index)];
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
    
    NSString    *strUrl = [DomainNameParser getSecondHttpUrl];

    
    NSString *requreststring = [strUrl stringByAppendingString:LastUrl];
    NSURL *url = [NSURL URLWithString:requreststring];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    JFURLConnection *conn = [[JFURLConnection alloc] initWithRequest:req delegate:self index:m_index];
    conn.isFirst = NO;
    m_index++;
    [conn start];
    if (!conn)
    {
        DLOG(@"startRequestData fail:%@",req);
    }
    [conn release];
    
    
    DLOG(@"startTrySecondRequestData:%@  requestString:%@",postString,LastUrl);
    
}



#pragma mark  delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    
    
    
    NSHTTPURLResponse  *httprespone = (NSHTTPURLResponse*)response;
    
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];

    if (httprespone.statusCode != 200)
    {
        
        
        JFURLConnection *con = (JFURLConnection*)connection;
        if (con.isFirst)
        {
            [self startTrySecondRequestData:con.dicParam requestURL:con.LastUrl];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(getNetError:requsetString:)])
            {
                [delegate getNetError:[NSString stringWithFormat:@"%d",0] requsetString:lastUrl];
            }else
            {
                DLOG(@"connection didFailWithError not callback......................");
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
    DLOG(@"connection:%@ didFailWithError:%@",connection,error);
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    JFURLConnection *con = (JFURLConnection*)connection;
    NSMutableData   *mutabledata = [m_dicStoreData objectForKey:dataKey(lastUrl, con.index)];
    [mutabledata setData:nil];
    
    
    if (con.isFirst)
    {
        [self startTrySecondRequestData:con.dicParam requestURL:lastUrl];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BNRNetWorkErrorOccur object:nil];
        if (delegate && [delegate respondsToSelector:@selector(getNetError:requsetString:)])
        {
            [delegate getNetError:[NSString stringWithFormat:@"%d",0] requsetString:lastUrl];
        }else
        {
              DLOG(@"connection didFailWithError not callback......................");
        }
    });
  
    DLOG(@"requsetString:%@",lastUrl);
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
            DLOG(@"connection didFailWithError not callback......................");
        }
        [m_dicStoreData removeObjectForKey:dataKey(lastUrl, con.index)];
        
        DLOG(@"connectionDidFinishLoading no data");
        return;
    }
    
    
     NSString  *strTest = [[NSString alloc] initWithData:mutabledata encoding:NSUTF8StringEncoding];
     NSDictionary  *dicInfo = [mutabledata objectFromJSONData];
    if (dicInfo == nil || strTest == nil)
    {
      
        
        NSString    *datastring = [[NSString alloc] initWithCString:[mutabledata bytes] encoding:NSUTF8StringEncoding];
        NSDictionary  *dicInfo = [mutabledata objectFromJSONData];
          DLOG(@"connectionDidFinishLoading mutabledata:%@ datastring:%@ dicInfo:%@",mutabledata,datastring,dicInfo);
        [datastring release];
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
                           DLOG(@"connectionDidFinishLoading not callback......................");
                       }
                   });
  
    DLOG(@"dicInfo:%@  requeststring:%@",dicMutInfo,lastUrl);
    [strTest release];
    
    [m_dicStoreData removeObjectForKey:dataKey(lastUrl, con.index)];
}



-(void)dealloc
{

    [m_dicStoreData release];
    m_dicStoreData = nil;
    [super dealloc];
}

@end
