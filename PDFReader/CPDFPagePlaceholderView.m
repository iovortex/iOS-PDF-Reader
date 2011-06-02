//
//  CPDFPagePlaceholderView.m
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CPDFPagePlaceholderView.h"


@implementation CPDFPagePlaceholderView

@synthesize page;

- (void)dealloc
    {
    CGPDFPageRelease(page);
    //
    [super dealloc];
    }

- (void)setPage:(CGPDFPageRef)inPage
    {
    if (page != inPage)
        {
        page = inPage;
        
		// determine the size of the PDF page
		CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
//		CGFloat pdfScale = self.frame.size.width/pageRect.size.width;
        CGFloat pdfScale = 0.125;
		pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
		
		
		// Create a low res image representation of the PDF page to display before the TiledPDFView
		// renders its content.
		UIGraphicsBeginImageContext(pageRect.size);
		
		CGContextRef theContext = UIGraphicsGetCurrentContext();
		
		// First fill the background with white.
		CGContextSetRGBFillColor(theContext, 1.0,1.0,1.0,1.0);
		CGContextFillRect(theContext,pageRect);
		        
		CGContextSaveGState(theContext);
		// Flip the context so that the PDF page is rendered
		// right side up.
		CGContextTranslateCTM(theContext, 0.0, pageRect.size.height);
		CGContextScaleCTM(theContext, 1.0, -1.0);
		
		// Scale the context so that the PDF page is rendered 
		// at the correct size for the zoom level.
		CGContextScaleCTM(theContext, pdfScale,pdfScale);	
		CGContextDrawPDFPage(theContext, page);
		CGContextRestoreGState(theContext);

		CGContextSetRGBFillColor(theContext, 0.0,0.0,1.0,1.0);
        CGContextStrokeRect(theContext, pageRect);
		
		UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();

        self.image = backgroundImage;
        }
    }


@end
