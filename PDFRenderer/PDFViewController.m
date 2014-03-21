//
//  PDFViewController.m
//  PDFRenderer
//
//  Created by Steve Baker on 3/20/14.
//  Copyright (c) 2014 Beepscore LLC. All rights reserved.
//

#import "PDFViewController.h"
#import "PDFRenderer.h"

@interface PDFViewController ()

@end

@implementation PDFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fileName = [self getPDFFileName];
    [PDFRenderer drawPDF:fileName];
    [self showPDFFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)getPDFFileName {
    NSString* fileName = @"Invoice.PDF";

    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];

    return pdfFileName;
}

- (void)showPDFFile {
    NSString* fileName = @"Invoice.PDF";

    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
    NSString *path = arrayPaths[0];
    NSString *pdfFileName = [path stringByAppendingPathComponent:fileName];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    // url is similar to
    // file:///Users/stevebaker/Library/Application%20Support/iPhone%20Simulator/7.1/Applications/7115BE49-C9C3-4874-9A85-583147BC5A97/Documents/Invoice.PDF
    // Can run app on simulator, get url, then on Mac set web browser to url and view pdf file.
    NSLog(@"url %@", url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

    [self.view addSubview:webView];
}

@end
