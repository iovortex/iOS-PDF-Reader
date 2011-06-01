//
//  CContentScrollView.m
//  PDFReader
//
//  Created by Jonathan Wight on 05/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CContentScrollView.h"

@implementation CContentScrollView

@synthesize contentView;

- (void)setFrame:(CGRect)frame
    {
    [super setFrame:frame];
    //
    if (self.contentView)
        {
        CGRect theFrame = self.contentView.frame;
        
        self.contentSize = theFrame.size;
        
        if (self.contentSize.width < self.bounds.size.width)
            {
            const CGFloat D = self.bounds.size.width - self.contentSize.width;
            self.contentInset = (UIEdgeInsets){ .left = D * 0.5, .right = D * 0.5 };
            }
        }
    }

//- (void)setContentView:(UIView *)inContentView
//    {
//    if (contentView != inContentView)
//        {
//        NSLog(@"SET CONTENT VIEW");
//        
//        [contentView release];
//        contentView = [inContentView retain];
//        
//        [contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:0];
//        
//        self.contentSize = self.contentView.frame.size;
//        }
//    }
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
//    {
//    NSLog(@"CHANGE: %@", change);
//    
//    CGRect theFrame = [[change objectForKey:@"new"] CGRectValue];
//    
//    self.contentSize = theFrame.size;
//    
//    if (self.contentSize.width < self.bounds.size.width)
//        {
//        const CGFloat D = self.bounds.size.width - self.contentSize.width;
//        self.contentInset = (UIEdgeInsets){ .left = D * 0.5, .right = D * 0.5 };
//        }
//    }

@end
