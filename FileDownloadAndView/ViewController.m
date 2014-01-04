//
//  ViewController.m
//  FileDownloadAndView
//
//  Created by Barry on 1/2/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ReaderViewController.h"

@interface ViewController ()<ReaderViewControllerDelegate>

@end

@implementation ViewController

#pragma mark Constants

#define DEMO_VIEW_CONTROLLER_PUSH FALSE

#pragma mark UIViewController methods


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.progress setProgress:0];
    
}

/*
 ###################### Download Task
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Temporary File :%@\n", location);
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"test1.pdf"]];
    if ([fileManager moveItemAtURL:location
                             toURL:docsDirURL
                             error: &err])
    {
        NSLog(@"File is saved as =%@",docsDirURL);
        
        
    }
    else
    {
        NSLog(@"failed to move: %@",[err userInfo]);
    }
    
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(),^ {
        [self.progress setProgress:progress animated:YES];
    });
    NSLog(@"Progress =%f",progress);
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    
}

-(void) downloadFileWithProgress
{
    NSURL * url = [NSURL URLWithString:@"http://speedyreference.com/bicsi/newsstand/jits/JournalITS.pdf"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask * downloadTask =[ defaultSession downloadTaskWithURL:url];
    [downloadTask resume];
    
    
    
    
}

-(void) downloadFileWithProgress2
{
    NSURL * url = [NSURL URLWithString:@"http://speedyreference.com/bicsi/newsstand/jits/JITS.pdf"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask * downloadTask =[ defaultSession downloadTaskWithURL:url];
    [downloadTask resume];
    
    
}


/*
 ###################### Download Task END
 */

/*
 ###################### Data Task  Start
 */


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"### handler 2");
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"### handler 1");
    
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received String %@",str);
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        NSLog(@"Download is Succesfull");
    }
    else
        NSLog(@"Error %@",[error userInfo]);
}

-(IBAction)  fileDownload:(id)sender
{
    [self downloadFileWithProgress];
}

-(IBAction)  fileDownload2:(id)sender
{
    [self downloadFileWithProgress2];
}

- (IBAction)handleSingleTap:(id)sender {
    
    
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
//    
//	NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
//    
//	NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to last PDF file
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *pdfs = [[NSBundle bundleWithPath:[paths objectAtIndex:0]] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self

        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
	}
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
