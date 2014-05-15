//
//  RechargeHTTPRequest.m
//  QMic
//
//  Created by wurong on 13-12-10.
//  Copyright (c) 2013年 WuRong. All rights reserved.
//

#import "RechargeHTTPRequestManger.h"
#import "NSString+Crypto.h"
#import <Frontia/Frontia.h>
#import "DomainNameParser.h"


#if INLINE_TEST
#define         SERCERNAME          @"serverapicert"
#define         CLIENTCERNAME       @"key_pair"
#define         SERVERPASSWORD      "652842"      
#elif WLANLINE_TEST
#define         SERCERNAME          @"serverapicert"
#define         CLIENTCERNAME       @"key_pair"
#define         SERVERPASSWORD      "652842"
#else
#define         SERCERNAME          @"idiomwarclienttrustcert"
#define         CLIENTCERNAME       @"idiomwarclient"
#define         SERVERPASSWORD      "PsnG94"
#endif

NSString      *const    BNRHttpsNetWorkError = @"BNRHttpsNetWorkError";

#define DATAKEY(url,index)  [NSString stringWithFormat:@"%@%d",url,index]
@implementation JFMyURLConnection

@synthesize startIndex;
@synthesize firstUrl;
@synthesize secondUrl;
@synthesize dicParam;
@synthesize LastUrl;
@synthesize isFirst;

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startIndex:(int)index
{
    self = [super initWithRequest:request delegate:delegate];
    if (self)
    {
        self.startIndex = index;
    }
    return self;
}


-(void)dealloc
{
    self.firstUrl = nil;
    self.secondUrl = nil;
    self.dicParam = nil;
    self.LastUrl = nil;
    [super dealloc];
}
@end
@implementation RechargeHTTPRequestManger

@synthesize delegate;



-(id)init
{
    self = [super init];
    if (self)
    {
        m_dicStoreData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [m_dicStoreData release];
    m_dicStoreData = nil;
    [super dealloc];
}


-(void)startRequestData:(NSDictionary*)dicInfo  requestURL:(NSString*)LastUrl
{
    

    NSMutableData   *mutableData = [m_dicStoreData objectForKey:DATAKEY(LastUrl, m_index)];
    if (mutableData)
    {
        [mutableData setData:nil];
    }else
    {
        mutableData = [NSMutableData data];
        [m_dicStoreData setObject:mutableData forKey:DATAKEY(LastUrl, m_index)];
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
    

    NSString *headUrl = [DomainNameParser getFirstHttpsUrl];
    NSString *requreststring =[headUrl stringByAppendingString:LastUrl];
    NSURL *url = [NSURL URLWithString:requreststring];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    JFMyURLConnection *conn = [[JFMyURLConnection alloc] initWithRequest:req delegate:self startIndex:m_index];
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
    
    
    NSMutableData   *mutableData = [m_dicStoreData objectForKey:DATAKEY(LastUrl, m_index)];
    if (mutableData)
    {
        [mutableData setData:nil];
    }else
    {
        mutableData = [NSMutableData data];
        [m_dicStoreData setObject:mutableData forKey:DATAKEY(LastUrl, m_index)];
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
    
    
    NSString *headUrl = [DomainNameParser getSecondHttpsUrl];
    NSString *requreststring =[headUrl stringByAppendingString:LastUrl];
    NSURL *url = [NSURL URLWithString:requreststring];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    JFMyURLConnection *conn = [[JFMyURLConnection alloc] initWithRequest:req delegate:self startIndex:m_index];
    
    m_index++;
    
    [conn start];
    if (!conn)
    {
        DLOG(@"startRequestData fail:%@",req);
    }
    [conn release];
    DLOG(@"startRequestData:%@  requestString:%@",postString,LastUrl);
    
}



#pragma mark  delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    
    NSHTTPURLResponse  *httprespone = (NSHTTPURLResponse*)response;
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    if (httprespone.statusCode != 200)
    {
        JFMyURLConnection *con = (JFMyURLConnection*)connection;
        if (con.isFirst)
        {
            [self startTrySecondRequestData:con.dicParam requestURL:con.LastUrl];
            return;
        }
        
        if (delegate && [delegate respondsToSelector:@selector(getHttpNetError:requestString:)])
        {
            [delegate getHttpNetError:[NSString stringWithFormat:@"%d",httprespone.statusCode] requestString:lastUrl];
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    JFMyURLConnection *con = (JFMyURLConnection*)connection;
    NSMutableData   *mutabledata = [m_dicStoreData valueForKey:DATAKEY(lastUrl, con.startIndex)];
    [mutabledata appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
    JFMyURLConnection *con = (JFMyURLConnection*)connection;
    if (con.isFirst)
    {
        [self startTrySecondRequestData:con.dicParam requestURL:con.LastUrl];
        return;
    }
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    if (delegate && [delegate respondsToSelector:@selector(getHttpNetError:requestString:)])
    {
        [delegate getHttpNetError:[error localizedDescription] requestString:lastUrl];
    }
    DLOG(@"connection:%@ didFailWithError:%@",connection,error);
    DLOG(@"m_postString:%@ requsetString:%@",connection,lastUrl);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *lastUrl = [[[[connection originalRequest] URL] absoluteString] lastPathComponent];
    JFMyURLConnection *con = (JFMyURLConnection*)connection;
    NSMutableData   *mutabledata = [m_dicStoreData valueForKey:DATAKEY(lastUrl, con.startIndex)];
    NSString  *strTest = [[NSString alloc] initWithData:mutabledata encoding:NSUTF8StringEncoding];
    
    NSDictionary  *dicInfo = [strTest objectFromJSONString];
    NSMutableDictionary *dicMutInfo = [NSMutableDictionary dictionaryWithDictionary:dicInfo];
    
    for (id key in dicInfo)
    {
        id value = [dicInfo valueForKey:key];
        //  DLOG(@"value class:%@ value:%@",[value class],value);
        if ([value isKindOfClass:[NSNumber class]])
        {
            [dicMutInfo setObject:[value description] forKey:key];
        }
    }
    if (delegate  && [delegate respondsToSelector:@selector(getHttpsResult:requestString:)])
    {
        [delegate getHttpsResult:dicMutInfo requestString:lastUrl];
    }
    
    [m_dicStoreData removeObjectForKey:DATAKEY(lastUrl, con.startIndex)];
    //DLOG(@"strTest:%@ dicInfo:%@  requeststring:%@",strTest,dicMutInfo,self.requsetString);
    [strTest release];
}



- (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSString *certPath = [[NSBundle mainBundle] pathForResource:SERCERNAME ofType:@"der"];
    NSData *certData = [[NSData alloc] initWithContentsOfFile:certPath];
    CFDataRef certDataRef = CFRetain((CFDataRef)certData);
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, certDataRef);
    
    CFArrayRef certArrayRef = CFArrayCreate(NULL, (void *)&cert, 1, NULL);
    SecTrustRef serverTrust = protectionSpace.serverTrust;
    SecTrustSetAnchorCertificates(serverTrust, certArrayRef);
    
    SecTrustResultType trustResult;
    SecTrustEvaluate(serverTrust, &trustResult);
    
    if (trustResult == kSecTrustResultRecoverableTrustFailure) {
        
        CFDataRef errDataRef = SecTrustCopyExceptions(serverTrust);
        SecTrustSetExceptions(serverTrust, errDataRef);
        
        SecTrustEvaluate(serverTrust, &trustResult);
        
        CFRelease(errDataRef);
    }
    
    CFRelease(certArrayRef);
    CFRelease(cert);
    CFRelease(certDataRef);
    [certData release];
    
    return trustResult == kSecTrustResultUnspecified ||
    trustResult == kSecTrustResultProceed;
}


-(NSInvocation*)draw
{
    NSMethodSignature   *exec = [self methodSignatureForSelector:@selector(startTrySecondRequestData:requestURL:)];
    NSInvocation    *drawinvo = [NSInvocation invocationWithMethodSignature:exec];
    [drawinvo setTarget:self];
    [drawinvo setSelector:@selector(startTrySecondRequestData:requestURL:)];
    NSDictionary *dicInfo = nil;
    [drawinvo setArgument:&dicInfo atIndex:2];
    return drawinvo;
}
- (void)cancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

}

- (void)continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

}

- (void)useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    id <NSURLAuthenticationChallengeSender> sender = challenge.sender;
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
     
        SecTrustRef trust = [protectionSpace serverTrust];
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];
        [sender useCredential:credential forAuthenticationChallenge:challenge];
        
    }else if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]) {
        
        [self loadMyCert:challenge];
    }
}

- (void)loadMyCert:(NSURLAuthenticationChallenge *)challenge
{
    NSString *thePath = [[NSBundle mainBundle] pathForResource:CLIENTCERNAME ofType:@"p12"];
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (CFDataRef)PKCS12Data;
    SecIdentityRef identity = NULL;
    
    // extract the ideneity from the certificate
    [self extractIdentity :inPKCS12Data identity:&identity];
    
    SecCertificateRef certificate = NULL;
    SecIdentityCopyCertificate (identity, &certificate);
    
    const void *certs[] = {certificate};
    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
    
    // create a credential from the certificate and ideneity, then reply to the challenge with the credential
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    
    CFRelease(certArray);
    
    [PKCS12Data release];
}

- (OSStatus)extractIdentity:(CFDataRef)inP12Data identity:(SecIdentityRef*)identity {
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR(SERVERPASSWORD);
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}

@end
