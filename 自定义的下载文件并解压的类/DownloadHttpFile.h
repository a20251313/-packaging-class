//
//  DownloadHttpFIle.h
//  i366
//
//  Created by ran on 13-9-16.
//
//


#ifndef DownloadHttpFile__________________________H
#define DownloadHttpFile__________________________H


#import <Foundation/Foundation.h>
#import "DownloadHttpInfo.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "UtilitiesFunction.h"

@interface DownloadHttpFile:NSObject
{
    ASINetworkQueue *queue;
    NSConditionLock *m_lock;
    NSMutableArray  *m_arrayInfo;
}


//get single instance
+(id)shareInstance;

//add object file to queue and download it
+(void)addDownFileObjects:(DownloadHttpInfo*)downInfo;

//make some delegate as nil
+(void)CleanDelegateOfObject:(id)object;

//make some kind of delegate class as nil
+(void)CleanDelegateOfObjectClass:(Class)objectClass;
@end

#endif