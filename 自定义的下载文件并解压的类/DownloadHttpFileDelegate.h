//
//  DownloadHttpFileDelegate.h
//  i366
//
//  Created by ran on 13-9-16.
//
//

#import <Foundation/Foundation.h>
#ifndef DownloadHttpFileDelegate_hhhhhhhh
#define DownloadHttpFileDelegate_hhhhhhhh
@class DownloadHttpInfo;

@protocol DownloadHttpFileDelegate <NSObject>

@optional;


-(void)downloadHttpFileFail:(DownloadHttpInfo *)object;
-(void)downloadHttpFileSuc:(DownloadHttpInfo *)object;
-(void)unzipHttpFileFail:(DownloadHttpInfo *)object;
-(void)unzipHttpFileSuc:(DownloadHttpInfo *)object;



- (void)setProgress:(float)newProgress;


-(void)downNormalXmlSuc:(DownloadHttpInfo*)object;
-(void)downNormalXmlFail:(DownloadHttpInfo *)object;

-(void)unZipNormalQuestionSuc:(DownloadHttpInfo*)object;
-(void)unZipNormalQuestionFail:(DownloadHttpInfo *)object;



-(void)unZipRaceQuestionSuc:(DownloadHttpInfo*)object;
-(void)unZipRaceQuestionFail:(DownloadHttpInfo *)object;

@end
#endif