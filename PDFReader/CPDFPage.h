//
//  CPDFPage.h
//  PDFReader
//
//  Created by Jonathan Wight on 02/20/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPDFDocument;

@interface CPDFPage : NSObject {
    
}

@property (readonly, nonatomic, assign) CPDFDocument *document;
@property (readonly, nonatomic, assign) NSInteger pageNumber;
@property (readonly, nonatomic, assign) CGPDFPageRef cg;

- (id)initWithDocument:(CPDFDocument *)inDocument pageNumber:(NSInteger)inPageNumber;

@end
