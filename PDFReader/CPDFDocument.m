//
//  CPDFDocument.m
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CPDFDocument.h"

@interface CPDFDocument ()
@property (readwrite, retain) NSCache *thumbnailCache;

- (void)startGeneratingThumbnails;
@end

#pragma mark -

@implementation CPDFDocument

@synthesize URL;
@synthesize cg;
@synthesize delegate;

@synthesize thumbnailCache;

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
    return([self.thumbnailCache objectForKey:[NSNumber numberWithInteger:inIndex]]);
    }

- (void)startGeneratingThumbnails
    {
    self.thumbnailCache = [[[NSCache alloc] init] autorelease];

    const size_t theNumberOfPages = CGPDFDocumentGetNumberOfPages(self.cg);

    dispatch_queue_t queue = dispatch_queue_create("com.example.MyQueue", NULL);
    
    NSURL *theURL = self.URL;
    __block CGPDFDocumentRef theDocument = NULL;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {

        dispatch_apply(theNumberOfPages, queue, ^(size_t inPageNumber) {

            inPageNumber++;
    
            if (theDocument == NULL)
                {
                theDocument = CGPDFDocumentCreateWithURL((CFURLRef)theURL);
                }
            CGPDFPageRef thePage = CGPDFDocumentGetPage(theDocument, inPageNumber);

            CGRect pageRect = CGPDFPageGetBoxRect(thePage, kCGPDFMediaBox);
            CGFloat pdfScale = 0.5;
            pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
            
            
            // Create a low res image representation of the PDF page to display before the TiledPDFView
            // renders its content.
            UIGraphicsBeginImageContext(pageRect.size);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            // First fill the background with white.
            CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
            CGContextFillRect(context,pageRect);
            
            CGContextSaveGState(context);
            // Flip the context so that the PDF page is rendered right side up.
            CGContextTranslateCTM(context, 0.0, pageRect.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            
            // Scale the context so that the PDF page is rendered 
            // at the correct size for the zoom level.
            CGContextScaleCTM(context, pdfScale,pdfScale);	
            CGContextDrawPDFPage(context, thePage);
            CGContextRestoreGState(context);
            
            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();

            [self.thumbnailCache setObject:theImage forKey:[NSNumber numberWithInteger:inPageNumber]];

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
