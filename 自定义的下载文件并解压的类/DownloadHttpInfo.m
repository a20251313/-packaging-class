//
//  DownloadHttpInfo.m
//  i366
//
//  Created by ran on 13-9-16.
//
//

#import "DownloadHttpInfo.h"

@implementation DownloadHttpInfo
@synthesize fileName;
@synthesize downLoadUrl;
@synthesize infoMessage;
@synthesize isNeedUnzip;
@synthesize downType;
@synthesize delegate;
@synthesize saveFilePath;
@synthesize isStop;
@synthesize isNeedProgress;



-(id)initWithDelegate:(id<DownloadHttpFileDelegate>)tempdelegate downUrl:(NSString*)utf8FileUrl fileName:(NSString *)TempfileName
{
    self = [super init];
    if (self)
    {
        self.delegate = tempdelegate;
        self.downLoadUrl = utf8FileUrl;
        self.fileName = TempfileName;
        self.isStop = NO;
    }
    return self;
}


-(id)initWithDelegate:(id<DownloadHttpFileDelegate>)tempdelegate fileUrl:(NSString*)utf8FileUrl fileName:(NSString *)strFielName downType:(DownloadHttpFileDownType)TempdownLoadType
{
    self = [super init];
    if (self)
    {
        self.delegate = tempdelegate;
        self.downLoadUrl = utf8FileUrl;
        self.downType = TempdownLoadType;
        self.fileName = strFielName;
        self.isStop = NO;
        
    }
    return self;
}


-(void)dealloc
{
    
    self.delegate = nil;
    self.downLoadUrl = nil;
    self.fileName = nil;
    self.infoMessage = nil;
    self.saveFilePath = nil;
    self.delegate = nil;

    [super dealloc];
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"class:DownloadHttpInfo <<%p>>,delegate:%@ fileName:%@ downLoadUrl:%@,infoMessage:%@,isNeedUnzip:%d downType:%d saveFilePath:%@",self,self.delegate,self.fileName,self.downLoadUrl,self.infoMessage,self.isNeedUnzip,self.downType,self.saveFilePath];
}
@end
