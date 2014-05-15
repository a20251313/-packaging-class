//
//  DownloadHttpInfo.h
//  i366
//
//  Created by ran on 13-9-16.
//
//


#ifndef DownloadHttpInfo__________________________H
#define DownloadHttpInfo__________________________H
#import <Foundation/Foundation.h>
#import "DownloadHttpFileDelegate.h"


typedef enum
{
    DownloadHttpFileDownTypeDefault,
    DownloadHttpFileDownTypeNormalXml,
    DownloadHttpFileDownTypeNormalQusetionZip,
    DownloadHttpFileDownTypeRaceQusetionZip
}DownloadHttpFileDownType;

@interface DownloadHttpInfo : NSObject
@property(nonatomic,retain)NSString *downLoadUrl;
@property(nonatomic,retain)NSString *saveFilePath;
@property(nonatomic,retain)NSString *fileName;
@property(nonatomic)BOOL    isNeedProgress;
@property(nonatomic,retain)id      infoMessage;
@property(nonatomic)BOOL           isNeedUnzip;
@property(nonatomic)DownloadHttpFileDownType   downType;
@property(nonatomic)BOOL    isStop;
@property(nonatomic,assign)id<DownloadHttpFileDelegate> delegate;


-(id)initWithDelegate:(id<DownloadHttpFileDelegate>)tempdelegate downUrl:(NSString*)utf8FileUrl fileName:(NSString *)TempfileName;
-(id)initWithDelegate:(id<DownloadHttpFileDelegate>)tempdelegate fileUrl:(NSString*)utf8FileUrl fileName:(NSString *)strFielName downType:(DownloadHttpFileDownType)TempdownLoadType;

@end
#endif