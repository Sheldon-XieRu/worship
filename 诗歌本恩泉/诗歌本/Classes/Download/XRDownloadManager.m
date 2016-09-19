//
//  XRDownloadManager.m
//  诗歌本恩泉
//
//  Created by Ru on 18/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRDownloadManager.h"

#define downloadFileLength [[[NSFileManager defaultManager]attributesOfItemAtPath:self.filePath error:nil][NSFileSize] integerValue]

@interface XRDownloadManager ()<NSURLSessionDataDelegate>

@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic,strong) NSURLSessionDataTask *task;


@property (nonatomic,assign) NSInteger fileTotalLength;


@property (nonatomic,strong) NSOutputStream *stream;


@property (nonatomic,copy) NSString *filePath;

//** <#注释#> */
@property (nonatomic,copy) NSString *fileName;
@end


@implementation XRDownloadManager


static id _instance;




- (void)downloadWithUrl:(NSString *)url fileName:(NSString *)fileName
{

    
    NSString *urlUTF8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    NSMutableURLRequest  *requst = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlUTF8]];
   
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    
    self.fileName = fileName;
    
    fileName = [fileName stringByAppendingString:@".zip"];
    self.filePath = [filePath stringByAppendingPathComponent:fileName];
    
    

    //stream
    self.stream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];


    
    
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",downloadFileLength];
    [requst setValue:range forHTTPHeaderField:@"Range"];
    
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:requst];
    
    
    [task resume];

    
}

#pragma mark - <NSURLSessionDataDelegate>




- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.stream open];
   
    self.fileTotalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + downloadFileLength;
    
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.stream write:data.bytes maxLength:data.length];
    
    CGFloat progress = 1.0 * downloadFileLength / self.fileTotalLength;
    if ([self.delegate respondsToSelector:@selector(downloadManagerDidUpdateProgress:)]) {
        [self.delegate downloadManagerDidUpdateProgress:progress];
    }
    

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        return;
    }
    [self.stream close];
    self.stream = nil;

 
    
   NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

    NSString *fileFolderPath = [cachePath stringByAppendingPathComponent:self.fileName];
    
//    [SSZipArchive unzipFileAtPath:self.filePath toDestination:fileFolderPath];
    
    if ([self.delegate respondsToSelector:@selector(downloadManagerDidCompleteDownloadWithOriginal:FilefolderPath:)]) {
        [self.delegate downloadManagerDidCompleteDownloadWithOriginal:self.filePath FilefolderPath:fileFolderPath];
    }
//    [[NSFileManager defaultManager]removeItemAtPath:self.filePath error:nil];
}

#pragma mark - lazy

-(NSURLSession *)session
{
    if (_session==nil) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    }
    return _session;
}


@end
