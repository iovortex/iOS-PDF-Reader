//
//  CPreviewBar.m
//  PDFReader
//
//  Created by Jonathan Wight on 02/20/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CPreviewBar.h"

#import <QuartzCore/QuartzCore.h>

@interface CPreviewBar ()
@end

#pragma mark -

@implementation CPreviewBar

@synthesize selectedPreviewIndex;
@synthesize previewSize;
@synthesize previewGap;
@synthesize placeholderImage;
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)inCoder
    {
    if ((self = [super initWithCoder:inCoder]) != NULL)
        {
//        self.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;

        previewSize = (CGSize){ self.frame.size.height, self.frame.size.height };
        previewGap = 4.0;
        
        UIGraphicsBeginImageContextWithOptions(previewSize, YES, 1.0);
        
        CGContextRef theContext = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(theContext, [UIColor redColor].CGColor);
        CGContextFillRect(theContext, (CGRect){ .size = previewSize });
        
        
        self.placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        self.opaque = NO;
        
        [self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] autorelease]];
        }
    return(self);
    }

- (void)setSelectedPreviewIndex:(NSUInteger)inSelectedPreviewIndex
    {
    if (selectedPreviewIndex != inSelectedPreviewIndex)
        {
        CALayer *theLayer = [self.layer.sublayers objectAtIndex:selectedPreviewIndex];
        theLayer.borderWidth = 0.0;


        selectedPreviewIndex = inSelectedPreviewIndex;
        theLayer = [self.layer.sublayers objectAtIndex:selectedPreviewIndex];
        theLayer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        theLayer.borderWidth = 5.0;
        }
    }

- (void)setDelegate:(id<CPreviewBarDelegate>)inDelegate
    {
    if (delegate != inDelegate)
        {
        delegate = inDelegate;
        
        [self setNeedsLayout];
        }
    }

- (CGSize)sizeThatFits:(CGSize)inSize
    {
    NSInteger N = [self.delegate numberOfPreviewsInPreviewBar:self];
    N = MAX(N, 1);
    CGSize theSize = (CGSize){ self.previewSize.width * N + self.previewGap * (N - 1), self.previewSize.height };
    return(theSize);
    }

- (void)layoutSubviews
    {
    NSInteger theCount = [self.delegate numberOfPreviewsInPreviewBar:self];
    for (NSUInteger N = 0; N != theCount; ++N)
        {
        CALayer *theLayer = [CALayer layer];
        theLayer.bounds = (CGRect){ .size = self.previewSize };
        theLayer.position = (CGPoint){ .x = N * (self.previewSize.width + self.previewGap), .y = 0 };
//        theLayer.borderColor = [UIColor greenColor].CGColor;
//        theLayer.borderWidth = 1.0;
        theLayer.anchorPoint = CGPointZero;
        [theLayer setValue:[NSNumber numberWithUnsignedInteger:N] forKey:@"previewIndex"];

        UIImage *theImage = [self.delegate previewBar:self previewAtIndex:N];
        if (theImage)
            {
            theLayer.contents = (id)theImage.CGImage;
            }
        else
            {
            theLayer.contents = (id)self.placeholderImage.CGImage;
            }



        [self.layer addSublayer:theLayer];
        }
    }

- (void)tap:(UIGestureRecognizer *)inSender
    {
    CGPoint theLocation = [inSender locationInView:self];
//    theLocation = [self.layer convertPoint:theLocation toLayer:self.layer.superlayer];
    CALayer *theLayer = [self.layer hitTest:theLocation];
    NSUInteger thePreviewIndex = [[theLayer valueForKey:@"previewIndex"] unsignedIntegerValue];
    NSLog(@"%d", thePreviewIndex);
    
    self.selectedPreviewIndex = thePreviewIndex;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    }

//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//    {
//    return(NO);
//    }
//    
//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//    {
//    return(YES);
//    }
//    
//- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//    {
//    CGPoint theLocation = [touch locationInView:self];
//    CALayer *theLayer = [self.layer hitTest:theLocation];
//    NSUInteger thePreviewIndex = [[theLayer valueForKey:@"previewIndex"] unsignedIntegerValue];
//    NSLog(@"%d", thePreviewIndex);
//    
//    self.selectedPreviewIndex = thePreviewIndex;
//    
//    [self sendActionsForControlEvents:UIControlEventValueChanged];
//    }
//    
//- (void)cancelTrackingWithEvent:(UIEvent *)event
//    {
//    }
//

- (void)updatePreviewAtIndex:(NSInteger)inIndex;
    {
    CALayer *theLayer = [self.layer.sublayers objectAtIndex:inIndex];
    
    UIImage *theImage = [self.delegate previewBar:self previewAtIndex:inIndex];
    if (theImage)
        {
        theLayer.contents = (id)theImage.CGImage;
        }
    }

@end
