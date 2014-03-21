//
//  PDFRenderer.m
//  PDFRenderer
//
//  Created by Steve Baker on 3/20/14.
//  Copyright (c) 2014 Beepscore LLC. All rights reserved.
//

#import "PDFRenderer.h"

@implementation PDFRenderer

+ (void)drawPDF:(NSString*)fileName {
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);

    // if drawImage is after drawText, logo isn't visible
    UIImage *logo = [UIImage imageNamed:@"ray-logo"];
    CGRect frame = CGRectMake(20, 100, 300, 60);
    [PDFRenderer drawImage:logo inRect:frame];

    [self drawText];

    CGPoint from = CGPointMake(0, 0);
    CGPoint to = CGPointMake(200, 300);
    [PDFRenderer drawLineFromPoint:from toPoint:to];

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+ (void)drawText {

    NSString* textToDraw = @"Hello World";
    CTFramesetterRef framesetter = [PDFRenderer createFramesetterFromString:textToDraw];

    CTFrameRef frameRef = [PDFRenderer createFrameRef:framesetter];

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
}

// CoreFoundation naming convention for functions
// Function name with copy or create means caller is responsible for releasing returned object
// http://stackoverflow.com/questions/14064336/arc-and-cfrelease

+ (CTFramesetterRef)createFramesetterFromString:(NSString *)string {
    CFStringRef stringRef = (__bridge CFStringRef)string;
    
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    // I think at this point it's safe to release currentText to avoid leak
    CFRelease(currentText);
    return framesetter;
}

+ (CTFrameRef)createFrameRef:(CTFramesetterRef)framesetter {
    CGRect frameRect = CGRectMake(0, 0, 300, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    return frameRef;
}

+ (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 2.0);

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};

    CGColorRef color = CGColorCreate(colorspace, components);

    CGContextSetStrokeColorWithColor(context, color);


    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);

    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

+ (void)drawImage:(UIImage*)image inRect:(CGRect)rect {
    [image drawInRect:rect];
}

@end
