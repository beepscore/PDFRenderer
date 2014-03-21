//
//  PDFViewController.m
//  PDFRenderer
//
//  Created by Steve Baker on 3/20/14.
//  Copyright (c) 2014 Beepscore LLC. All rights reserved.
//

#import "PDFViewController.h"

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
    [self drawText];
    [self showPDFFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawText {
    NSString *pdfFileName = [self pathFileName];

    NSString* textToDraw = @"Hello World";
    CTFramesetterRef framesetter = [self createFramesetterFromString:textToDraw];

    CTFrameRef frameRef = [self createFrameRef:framesetter];

    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);

    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);

    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);

    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);

    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);

    CFRelease(frameRef);
    CFRelease(framesetter);

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

- (NSString *)pathFileName {
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

// CoreFoundation naming convention for functions
// Function name with copy or create means caller is responsible for releasing returned object
// http://stackoverflow.com/questions/14064336/arc-and-cfrelease

- (CTFramesetterRef)createFramesetterFromString:(NSString *)string {
    CFStringRef stringRef = (__bridge CFStringRef)string;
    
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    // I think at this point it's safe to release currentText to avoid leak
    CFRelease(currentText);
    return framesetter;
}

- (CTFrameRef)createFrameRef:(CTFramesetterRef)framesetter {
    CGRect frameRect = CGRectMake(0, 0, 300, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    return frameRef;
}

- (void)showPDFFile {
    NSString* fileName = @"Invoice.PDF";

    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString *pdfFileName = [path stringByAppendingPathComponent:fileName];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

    [self.view addSubview:webView];
}

@end
