//
//  CPDFPageView.m
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CPDFPageView.h"

#import "CFastTiledLayer.h"
#import "Geometry.h"
#import "CPDFPage.h"

@implementation CPDFPageView

@synthesize page;

//+ (Class)layerClass
//    {
//    return([CFastTiledLayer class]);
//    }

- (id)initWithCoder:(NSCoder *)inCoder
    {
    if ((self = [super initWithCoder:inCoder]) != NULL)
        {
//		CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
//		// levelsOfDetail and levelsOfDetailBias determine how
//		// the layer is rendered at different zoom levels.  This
//		// only matters while the view is zooming, since once the 
//		// the view is done zooming a new TiledPDFView is created
//		// at the correct size and scale.
//        tiledLayer.levelsOfDetail = 4;
//		tiledLayer.levelsOfDetailBias = 4;
//		tiledLayer.tileSize = CGSizeMake(2048, 2048);
        
        self.layer.borderColor = [UIColor purpleColor].CGColor;
        self.layer.borderWidth = 2.0;
        }
    return(self);
    }

- (void)dealloc
    {
    [page release];
    page = NULL;
    
    [super dealloc];
    }

- (void)removeFromSuperview
    {
    [super removeFromSuperview];
    }
    
- (void)setPage:(CPDFPage *)inPage
    {
    if (page != inPage)
        {
        [page release];
        page = [inPage retain];
        
        [self setNeedsDisplay];
        }
    }

// UIView uses the existence of -drawRect: to determine if it should allow its CALayer
// to be invalidated, which would then lead to the layer creating a backing store and
// -drawLayer:inContext: being called.
// By implementing an empty -drawRect: method, we allow UIKit to continue to implement
// this logic, while doing our real drawing work inside of -drawLayer:inContext:
-(void)drawRect:(CGRect)r
    {
    if (page == NULL)
        {
        return;
        }
    
    CGContextRef theContext = UIGraphicsGetCurrentContext();

	CGContextSaveGState(theContext);

	// First fill the background with white.
	CGContextSetRGBFillColor(theContext, 1.0,1.0,1.0,1.0);
    
    CGContextSetFillColorWithColor(theContext, [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor);    
    CGContextFillRect(theContext, self.bounds);


    const CGRect theMediaBox = CGPDFPageGetBoxRect(self.page.cg, kCGPDFMediaBox);

    const CGRect theRenderRect = ScaleAndAlignRectToRect(theMediaBox, self.bounds, ImageScaling_Proportionally, ImageAlignment_Center);

	// Flip the context so that the PDF page is rendered right side up.
	CGContextTranslateCTM(theContext, 0.0, self.bounds.size.height);
	CGContextScaleCTM(theContext, 1.0, -1.0);
	
	// Scale the context so that the PDF page is rendered at the correct size for the zoom level.
    CGContextTranslateCTM(theContext, -(theMediaBox.origin.x - theRenderRect.origin.x), -(theMediaBox.origin.y - theRenderRect.origin.y));
	CGContextScaleCTM(theContext, theRenderRect.size.width / theMediaBox.size.width, theRenderRect.size.height / theMediaBox.size.height);	


    CGContextSetFillColorWithColor(theContext, [UIColor whiteColor].CGColor);    
    CGContextFillRect(theContext, theMediaBox);

	CGContextDrawPDFPage(theContext, self.page.cg);


	CGContextSetRGBStrokeColor(theContext, 1.0,0.0,0.0,1.0);
    CGContextSetLineWidth(theContext, 0.5);
    CGContextStrokeRect(theContext, CGPDFPageGetBoxRect(self.page.cg, kCGPDFCropBox));

	CGContextSetRGBStrokeColor(theContext, 0.0,1.0,0.0,1.0);
    CGContextSetLineWidth(theContext, 0.5);
    CGContextStrokeRect(theContext, CGPDFPageGetBoxRect(self.page.cg, kCGPDFBleedBox));

	CGContextSetRGBStrokeColor(theContext, 0.0,0.0,0.0,1.0);
    CGContextSetLineWidth(theContext, 0.5);
    CGContextStrokeRect(theContext, CGPDFPageGetBoxRect(self.page.cg, kCGPDFMediaBox));


	CGContextRestoreGState(theContext);
    }
//
//
//// Draw the CGPDFPageRef into the layer at the correct scale.
//-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
//    {
//    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
//    CGFloat myScale = self.frame.size.width / pageRect.size.width;
//
//	// First fill the background with white.
//	CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
//    CGContextFillRect(context, self.bounds);
//
//	CGContextSaveGState(context);
//	// Flip the context so that the PDF page is rendered
//	// right side up.
//	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
//	CGContextScaleCTM(context, 1.0, -1.0);
//	
//	// Scale the context so that the PDF page is rendered 
//	// at the correct size for the zoom level.
//	CGContextScaleCTM(context, myScale,myScale);	
//	CGContextDrawPDFPage(context, self.page);
//
//	CGContextRestoreGState(context);
//
//	CGContextSetRGBFillColor(context, 1.0,0.0,0.0,1.0);
//    CGContextStrokeRect(context, self.bounds);
//	
//
//
//
//    }
    

@end
