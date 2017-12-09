//
//  DownloadTool.m
//  LazyLoadingTableView
//
//  Created by 凌       陈 on 10/19/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicDownloader.h"
#import <AFNetworking/AFNetworking.h>
#import "MJExtension/MJExtension.h"
#import "OMHotSongInfo.h"
#import "OMSongInfo.h"


#define kAppIconSize 48


@interface MusicDownloader()

// the queue to run our "ParseOperation"
@property (nonatomic, strong) NSOperationQueue *queue;

// url session task
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end


@implementation MusicDownloader

-(instancetype) init {
    
    self = [super init];
    if (self) {
        _songInfo = OMSongInfo.sharedManager;
    }
    return self;
}



// -------------------------------------------------------------------------------
//	startDownload
// -------------------------------------------------------------------------------
- (void)startDownload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.hotSonginfo.pic_small]];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
       // in case we want to know the response status code
       //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
       
       if (error != nil)
       {
           if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
           {
               // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
               // then your Info.plist has not been properly configured to match the target server.
               //
               abort();
           }
       }
       
       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
           
           // Set appIcon and clear temporary data/image
           UIImage *image = [[UIImage alloc] initWithData:data];
           
           if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
           {
               CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
               UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
               CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
               [image drawInRect:imageRect];
               self.hotSonginfo.albumImage_small = UIGraphicsGetImageFromCurrentImageContext();
               UIGraphicsEndImageContext();
           }
           else
           {
               self.hotSonginfo.albumImage_small = image;
           }
           
           // call our completion handler to tell our client that our icon is ready for display
           if (self.completionHandler != nil)
           {
               self.completionHandler();
           }
       }];
   }];
    
    [self.sessionTask resume];
}

// -------------------------------------------------------------------------------
//	cancelDownload
// -------------------------------------------------------------------------------
- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}


// -------------------------------------------------------------------------------
//	handleError:error
//  Reports any error with an alert which was received from connection or loading failures.
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    
    // alert user that our current record was deleted, and then we leave this view controller
    //
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Show Top Paid Apps"
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         // dissmissal of alert completed
                                                     }];
    [alert addAction:OKAction];
}

@end
