//
//  ViewController.h
//  FileDownloadAndView
//
//  Created by Barry on 1/2/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

-(IBAction) fileDownload:(id)sender;
-(IBAction)  fileDownload2:(id)sender;
- (IBAction)handleSingleTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end
