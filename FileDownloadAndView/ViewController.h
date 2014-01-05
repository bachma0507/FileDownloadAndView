//
//  ViewController.h
//  FileDownloadAndView
//
//  Created by Barry on 1/2/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>


- (IBAction)buttonPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) IBOutlet UIButton *tapButton;
@property  (strong, nonatomic) NSFileManager *fileManager;
@property  (strong, nonatomic) NSArray *paths;
@property  (strong, nonatomic) NSArray *pdfs;
@property  (strong, nonatomic) NSString *filePath;


@end
