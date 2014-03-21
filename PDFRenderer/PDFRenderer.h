//
//  PDFRenderer.h
//  PDFRenderer
//
//  Created by Steve Baker on 3/20/14.
//  Copyright (c) 2014 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreText;

@interface PDFRenderer : NSObject

+ (void)drawText:(NSString *)pdfFileName;

@end
