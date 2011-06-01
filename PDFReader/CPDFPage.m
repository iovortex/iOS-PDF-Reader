//
//  CPDFPage.m
//  PDFReader
//
//  Created by Jonathan Wight on 02/20/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CPDFPage.h"

#import "CPDFDocument.h"

@interface CPDFPage ()
@property (readwrite, nonatomic, assign) CPDFDocument *document;
@property (readwrite, nonatomic, assign) NSInteger pageNumber;
@end

#pragma mark -

@implementation CPDFPage

@synthesize document;
@synthesize pageNumber;
@synthesize cg;

- (id)initWithDocument:(CPDFDocument *)inDocument pageNumber:(NSInteger)inPageNumber;
	{
	if ((self = [super init]) != NULL)
		{
        document = inDocument;
        pageNumber = inPageNumber;
		}
	return(self);
	}

- (void)dealloc
    {
    document = NULL;
    
    if (cg != NULL)
        {
        CGPDFPageRelease(cg);
        cg = NULL;
        }
    //
    [super dealloc];
    }

- (CGPDFPageRef)cg
    {
    if (cg == NULL)
        {
        cg = CGPDFPageRetain(CGPDFDocumentGetPage(self.document.cg, self.pageNumber));
        }
    return(cg);
    }

@end
