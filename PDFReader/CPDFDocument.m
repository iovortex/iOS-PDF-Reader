//
//  CPDFDocument.m
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CPDFDocument.h"

#import "CPDFDocument_Private.h"

@interface CPDFDocument ()
@property (readwrite, assign) dispatch_queue_t queue;

- (void)startGeneratingThumbnails;
@end

#pragma mark -

@implementation CPDFDocument

@synthesize URL;
@synthesize cg;
@synthesize delegate;

@synthesize queue;

- (id)initWithURL:(NSURL *)inURL;
	{
	if ((self = [super init]) != NULL)
		{
        URL = [inURL retain];
        
        cg = CGPDFDocumentCreateWithURL((CFURLRef)self.URL);

        [self startGeneratingThumbnails];
		}
	return(self);
	}
    
- (void)dealloc
    {
    if (queue != NULL)
        {
        dispatch_release(queue);
        queue = NULL;
        }
    
    [URL release];
    URL = NULL;
    
    if (cg)
        {
        CGPDFDocumentRelease(cg);
        cg = NULL;
        }
    //
    [super dealloc];
    }
    
- (NSUInteger)numberOfPages
    {
    return(CGPDFDocumentGetNumberOfPages(self.cg));
    }
    
- (CPDFPage *)pageAtIndex:(NSInteger)inIndex
    {
    return(NULL);
    }

- (UIImage *)previewForPageAtIndex:(NSInteger)inIndex
    {
    return([self.cache objectForKey:[NSNumber numberWithInteger:inIndex]]);
    }

- (void)startGeneratingThumbnails
    {
//    self.thumbnailCache = [[[NSCache alloc] init] autorelease];

    const size_t theNumberOfPages = CGPDFDocumentGetNumberOfPages(self.cg);

    queue = dispatch_queue_create("com.example.MyQueue", NULL);
    
    NSURL *theURL = self.URL;
    __block CGPDFDocumentRef theDocument = NULL;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {

        dispatch_apply(theNumberOfPages, self.queue, ^(size_t inPageNumber) {

            inPageNumber++;
    
            if (theDocument == NULL)
                {
                theDocument = CGPDFDocumentCreateWithURL((CFURLRef)theURL);
                }
            CGPDFPageRef thePage = CGPDFDocumentGetPage(theDocument, inPageNumber);

            CGRect theMediaBox = CGPDFPageGetBoxRect(thePage, kCGPDFMediaBox);
            CGFloat pdfScale = 0.125;
            theMediaBox.size = CGSizeMake(theMediaBox.size.width*pdfScale, theMediaBox.size.height*pdfScale);
            
            
            // Create a low res image representation of the PDF page to display before the TiledPDFView
            // renders its content.
            UIGraphicsBeginImageContext(theMediaBox.size);
            
            CGContextRef theContext = UIGraphicsGetCurrentContext();
            
            // First fill the background with white.
            CGContextSetRGBFillColor(theContext, 1.0,1.0,1.0,1.0);
            CGContextFillRect(theContext,theMediaBox);
            
            CGContextSaveGState(theContext);
            // Flip the context so that the PDF page is rendered right side up.
            CGContextTranslateCTM(theContext, 0.0, theMediaBox.size.height);
            CGContextScaleCTM(theContext, 1.0, -1.0);
            
            // Scale the context so that the PDF page is rendered 
            // at the correct size for the zoom level.
            CGContextScaleCTM(theContext, pdfScale,pdfScale);	
            CGContextDrawPDFPage(theContext, thePage);
            CGContextRestoreGState(theContext);
            
            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();

            [self.cache setObject:theImage forKey:[NSNumber numberWithInteger:inPageNumber]];

            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.delegate PDFDocument:self didUpdateThumbnailForPageAtIndex:inPageNumber];
                });
            
            if (theNumberOfPages == inPageNumber)
                {
                }
            });
        });
    }

- (void)stopGeneratingThumbnails
    {
    }



@end
