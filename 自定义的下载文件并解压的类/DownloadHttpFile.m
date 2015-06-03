//
//  DownloadHttpFIle.m
//  i366
//
//  Created by ran on 13-9-16.
//
//
#import "DownloadHttpFile.h"
#import "ZipArchive.h"
#import "DownloadHttpInfo.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "UtilitiesFunction.h"

#define USERINFOKEY     @"USERINFOKEY"
@implementation DownloadHttpFile
static  DownloadHttpFile  *staticDownloadHttpFile = nil;

+(id)shareInstance
{
    if (staticDownloadHttpFile == nil)
    {
        staticDownloadHttpFile = [[DownloadHttpFile alloc] init];
    }
    return staticDownloadHttpFile;
}



-(NSString*)getDefaultDownloadFilePath:(NSString*)strFilePath
{
    NSString  *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSString *docPath = [strPath stringByAppendingPathComponent:@"chengyudazhan"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath])
    {
        NSError  *error = nil;
        BOOL suc =  [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (!suc || error)
        {
            DLOG(@"getDefaultDownloadFilePath error:%@",error);
            return nil;
        }
    }
    NSString  *destionPath = [docPath stringByAppendingString:strFilePath];
    return destionPath;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        
        m_lock = [[NSConditionLock alloc] init];
        queue = [[ASINetworkQueue alloc] init];
        m_arrayInfo = [[NSMutableArray alloc] init];
        [queue setShowAccurateProgress:YES];//高精度进度
        [queue go];//启动
    }
    
    return  self;
}

-(void)dealloc
{
    
    [m_arrayInfo release];
    m_arrayInfo = nil;
    [m_lock release];
    m_lock = nil;
    [queue release];
    queue = nil;
    [super dealloc];
}


+(void)CleanDelegateOfObject:(id)object
{
    [staticDownloadHttpFile CleanDelegateOfObject:object];
}

+(void)CleanDelegateOfObjectClass:(Class)objectClass
{
    [staticDownloadHttpFile CleanDelegateOfObjectClass:objectClass];
}
-(void)CleanDelegateOfObjectClass:(Class)objectClass
{
    [m_lock lock];
    for (ASIHTTPRequest *request in [queue operations])
    {
        NSDictionary  *dic = [request userInfo];
        DownloadHttpInfo *objectInfo  = [dic valueForKey:USERINFOKEY];
        
        if ([objectInfo.delegate isKindOfClass:objectClass])
        {
            request.delegate = nil;
            objectInfo.delegate = nil;
            request.downloadProgressDelegate = nil;
        }
        
    }
    for (ASIHTTPRequest *request in m_arrayInfo)
    {
        NSDictionary  *dic = [request userInfo];
        DownloadHttpInfo *objectInfo  = [dic valueForKey:USERINFOKEY];
        
        if ([objectInfo.delegate isKindOfClass:objectClass])
        {
            request.delegate = nil;
            objectInfo.delegate = nil;
            request.downloadProgressDelegate = nil;
            //  [request cancel];
        }
        
    }
    
    [m_lock unlock];
}


+(void)addDownFileObjects:(DownloadHttpInfo*)downInfo
{
    if (staticDownloadHttpFile == nil)
    {
        staticDownloadHttpFile = [[DownloadHttpFile alloc] init];
    }
    [staticDownloadHttpFile addDownFileObjects:downInfo];
}


-(void)CleanDelegateOfObject:(id)object
{
    
    [m_lock lock];
    for (ASIHTTPRequest *request in m_arrayInfo)
    {
        NSDictionary  *dic = [request userInfo];
        DownloadHttpInfo *objectInfo  = [dic valueForKey:USERINFOKEY];
        
        if ([objectInfo.delegate isEqual:object])
        {
            request.delegate = nil;
            [request setUserInfo:nil];
            request.downloadProgressDelegate = nil;
            objectInfo.delegate = nil;
        }
        
    }
    for (ASIHTTPRequest *request in [queue operations])
    {
        NSDictionary  *dic = [request userInfo];
        DownloadHttpInfo *objectInfo  = [dic valueForKey:USERINFOKEY];
        
        if ([objectInfo.delegate isEqual:object])
        {
            
            [request setUserInfo:nil];
            request.delegate = nil;
            request.downloadProgressDelegate = nil;
            objectInfo.delegate = nil;
            
        }
        
    }
    [m_lock unlock];
    
}

-(void)addDownFileObjects:(DownloadHttpInfo*)downInfo
{
    
    
    DLOG(@"addDownFileObjects:%@",downInfo);
    
    if (downInfo.downLoadUrl == nil || [downInfo.downLoadUrl length] < 10)
    {
        
        DLOG(@"***************error************  url unvalid url:%@ addDownFileObjects:%@",downInfo.downLoadUrl,downInfo);
        return;
    }
    
    [m_lock lock];
    NSURL *url = [NSURL URLWithString:downInfo.downLoadUrl];
    //创建请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;//代理
    [request setDownloadDestinationPath:[self getDownLoadPath:downInfo]];//下载路径
    downInfo.saveFilePath = request.downloadDestinationPath;
    if (downInfo.isNeedProgress)
    {
        request.downloadProgressDelegate = downInfo.delegate;//下载进度代理
    }
    if (downInfo.isNeedUnzip)
    {
        [request setTemporaryFileDownloadPath:[self getTempFilePath:downInfo]];//缓存路径
        [request setAllowResumeForFileDownloads:YES];//断点续传
    }
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:downInfo,USERINFOKEY,nil]];
    [queue addOperation:request];//添加到队列，队列启动后不需重新启动
    [m_arrayInfo addObject:request];
    
    [m_lock unlock];
    
}


-(NSString *)getDownLoadPath:(DownloadHttpInfo*)downLoadInfo
{
    NSString    *strFilePath = nil;
    switch (downLoadInfo.downType)
    {
        case DownloadHttpFileDownTypeDefault:
            if (downLoadInfo.isNeedUnzip)
            {
                strFilePath = [strFilePath stringByAppendingString:@".zip"];
            }
            break;
        case DownloadHttpFileDownTypeNormalXml:
            strFilePath = [UtilitiesFunction getNormalXmlPath:downLoadInfo.fileName];
            break;
        case DownloadHttpFileDownTypeNormalQusetionZip:
            strFilePath = [UtilitiesFunction getNormalQustionZip:downLoadInfo.fileName];
            strFilePath = [strFilePath stringByAppendingString:@".zip"];
            break;
        case DownloadHttpFileDownTypeRaceQusetionZip:
            strFilePath = [UtilitiesFunction getRaceQustionZip:downLoadInfo.fileName];
            strFilePath = [strFilePath stringByAppendingString:@".zip"];
            break;
        default:
            // strFilePath = [UtilitiesFunction getCommonHttpFilePath:downLoadInfo.fileName];
            if (downLoadInfo.isNeedUnzip)
            {
                strFilePath = [strFilePath stringByAppendingString:@".zip"];
            }
            break;
    }
    
    
    DLOG(@"getDownLoadPath:%@",strFilePath);
    return strFilePath;
    
}

-(NSString *)getTempFilePath:(DownloadHttpInfo *)downLoadInfo
{
    
    NSString    *strFilePath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"dowHttpFileTempDoc"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    if (downLoadInfo.fileName && [downLoadInfo.fileName length])
    {
        
        strFilePath = [NSString stringWithFormat:@"%@.temp",downLoadInfo.fileName];
    }else
    {
        NSDateFormatter  *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYYMMddHHMMssSSuu"];
        NSString  *strDate = [format stringFromDate:[NSDate date]];
        strFilePath = [NSString stringWithFormat:@"%@.temp",strDate];
        [format release];
        
    }
    
    
    strFilePath = [dataPath stringByAppendingPathComponent:strFilePath];
    
    DLOG(@"getTempFilePath:%@ strFilePath:%@",downLoadInfo,strFilePath);
    return strFilePath;
    
}



#pragma mark downHttpdelegate

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    
    
    DLOG(@"downLoadInfo:didReceiveResponseHeaders:%@",[request.userInfo valueForKey:USERINFOKEY]);
}

- (void)setProgress:(float)newProgress
{
    DLOG(@"setProgress:%f",newProgress);
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
    DLOG(@"requestStarted:%@",[request.userInfo valueForKey:USERINFOKEY]);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [m_lock lock];
    [m_arrayInfo removeObject:request];
    [m_lock unlock];
    
    DownloadHttpInfo  *downLoadInfo = [request.userInfo valueForKey:USERINFOKEY];
    
    [self downFileFinish:downLoadInfo];
    
    DLOG(@"requestFinished:%@",downLoadInfo);
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [m_lock lock];
    [m_arrayInfo removeObject:request];
    [m_lock unlock];
    
    
    DownloadHttpInfo  *downLoadInfo = [request.userInfo valueForKey:USERINFOKEY];
    DLOG(@"requestFailed:%@",downLoadInfo);
    
    
    switch (downLoadInfo.downType)
    {
        case DownloadHttpFileDownTypeDefault:
            if (downLoadInfo.delegate  && [downLoadInfo.delegate respondsToSelector:@selector(downloadHttpFileFail:)])
            {
                [downLoadInfo.delegate downloadHttpFileFail:downLoadInfo];
            }
            break;
        case DownloadHttpFileDownTypeNormalXml:
            [self performSelectorOnMainThread:@selector(downLoadNormalXmlFail:) withObject:downLoadInfo waitUntilDone:YES];
            break;
        case DownloadHttpFileDownTypeNormalQusetionZip:
            [self performSelectorOnMainThread:@selector(unzipNormalQuestionFail:) withObject:downLoadInfo waitUntilDone:YES];
            break;
        case DownloadHttpFileDownTypeRaceQusetionZip:
            [self performSelectorOnMainThread:@selector(unzipRaceQuestionSuc:) withObject:downLoadInfo waitUntilDone:YES];
            break;
            
        default:
            if (downLoadInfo.delegate  && [downLoadInfo.delegate respondsToSelector:@selector(downloadHttpFileFail:)])
            {
                [downLoadInfo.delegate downloadHttpFileFail:downLoadInfo];
            }
            
            break;
    }
    
}


-(void)downFileFinish:(DownloadHttpInfo*)object
{
    
    if (object.delegate == nil)
    {
        DLOG(@"downFileFinish  but  delegate is nil,object:%@",object);
        return;
    }
    
    switch (object.downType)
    {
            
        case DownloadHttpFileDownTypeDefault:
        {
            
            NSString  *strFilePath = [[self getDefaultDownloadFilePath:object.fileName] stringByAppendingString:@".zip"];
            ZipArchive  *zipInfo = [[ZipArchive alloc] init];
            if ([zipInfo UnzipOpenFile:strFilePath])
            {
                BOOL    result = [zipInfo UnzipFileTo:[self getDefaultDownloadFilePath:object.fileName] overWrite:YES];
                
                if (result)
                {
                    [self performSelectorOnMainThread:@selector(unzipCommonHttpFileSuc:) withObject:object waitUntilDone:YES];
                }else
                {
                    
                    [self performSelectorOnMainThread:@selector(unzipCommonFileFail:) withObject:object waitUntilDone:YES];
                }
            }else
            {
                [self performSelectorOnMainThread:@selector(unzipCommonFileFail:) withObject:object waitUntilDone:YES];
            }
            [zipInfo release];
            zipInfo = nil;
        }
            break;
        case DownloadHttpFileDownTypeNormalXml:
            [self performSelectorOnMainThread:@selector(downLoadNormalXmlSuc:) withObject:object waitUntilDone:YES];
            break;
        case DownloadHttpFileDownTypeNormalQusetionZip:
        {
            NSString  *strFilePath = [[UtilitiesFunction getNormalQustionZip:object.fileName] stringByAppendingString:@".zip"];
            ZipArchive  *zipInfo = [[ZipArchive alloc] init];
            if ([zipInfo UnzipOpenFile:strFilePath])
            {
                BOOL    result = [zipInfo UnzipFileTo:[UtilitiesFunction getNormalQustionZip:object.fileName] overWrite:YES];
                
                if (result)
                {
                    [self performSelectorOnMainThread:@selector(unzipNormalQuestionSuc:) withObject:object waitUntilDone:YES];
                }else
                {
                    
                    [self performSelectorOnMainThread:@selector(unzipNormalQuestionFail:) withObject:object waitUntilDone:YES];
                }
            }else
            {
                [self performSelectorOnMainThread:@selector(unzipNormalQuestionFail:) withObject:object waitUntilDone:YES];
            }
            [zipInfo release];
            zipInfo = nil;
        }
            break;
        case DownloadHttpFileDownTypeRaceQusetionZip:
        {
            NSString  *strFilePath = [[UtilitiesFunction getRaceQustionZip:object.fileName] stringByAppendingString:@".zip"];
            ZipArchive  *zipInfo = [[ZipArchive alloc] init];
            if ([zipInfo UnzipOpenFile:strFilePath])
            {
                BOOL    result = [zipInfo UnzipFileTo:[UtilitiesFunction getRaceQustionZip:object.fileName] overWrite:YES];
                
                if (result)
                {
                    [self performSelectorOnMainThread:@selector(unzipRaceQuestionSuc:) withObject:object waitUntilDone:YES];
                }else
                {
                    
                    [self performSelectorOnMainThread:@selector(unzipRaceQuestionFail:) withObject:object waitUntilDone:YES];
                }
            }else
            {
                [self performSelectorOnMainThread:@selector(unzipRaceQuestionFail:) withObject:object waitUntilDone:YES];
            }
            [zipInfo release];
            zipInfo = nil;
        }
            break;
            
    }
    
}



#pragma nark unzipRaceAuestionZip
-(void)unzipRaceQuestionSuc:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(unZipRaceQuestionSuc:)])
    {
        [object.delegate unZipRaceQuestionSuc:object];
    }
    
}
-(void)unzipRaceQuestionFail:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(unZipRaceQuestionFail:)])
    {
        [object.delegate unZipRaceQuestionFail:object];
    }
    
}

#pragma mark  unzipNormalAuestionZip
-(void)unzipNormalQuestionSuc:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(unZipNormalQuestionSuc:)])
    {
        [object.delegate unZipNormalQuestionSuc:object];
    }
    
}
-(void)unzipNormalQuestionFail:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(unZipNormalQuestionFail:)])
    {
        [object.delegate unZipNormalQuestionFail:object];
    }
    
}
#pragma mark downLoadNormalXml
-(void)downLoadNormalXmlSuc:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(downNormalXmlSuc:)])
    {
        [object.delegate downNormalXmlSuc:object];
    }
    
}
-(void)downLoadNormalXmlFail:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(downNormalXmlFail:)])
    {
        [object.delegate downNormalXmlFail:object];
    }
    
}


#pragma  mark downloadCommonFile
-(void)downloadHttpFileFail:(DownloadHttpInfo *)object
{
    
    if (object.delegate  && [object.delegate respondsToSelector:@selector(downloadHttpFileSuc:)])
    {
        [object.delegate downloadHttpFileSuc:object];
    }
    
}
-(void)downloadHttpFileSuc:(DownloadHttpInfo *)object
{
    
    if (object.delegate  && [object.delegate respondsToSelector:@selector(downloadHttpFileSuc:)])
    {
        [object.delegate downloadHttpFileSuc:object];
    }
    
}
-(void)unzipCommonHttpFileSuc:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(unzipHttpFileSuc:)])
    {
        [object.delegate unzipHttpFileSuc:object];
    }
    
}

-(void)unzipCommonFileFail:(DownloadHttpInfo*)object
{
    if (object.delegate  && [object.delegate respondsToSelector:@selector(unzipHttpFileFail:)])
    {
        [object.delegate unzipHttpFileFail:object];
    }
    
}
@end
