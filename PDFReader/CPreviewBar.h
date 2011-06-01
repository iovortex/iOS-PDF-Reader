//
//  CPreviewBar.h
//  PDFReader
//
//  Created by Jonathan Wight on 02/20/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPreviewBarDelegate;

@interface CPreviewBar : UIControl {
    
}

@property (readwrite, nonatomic, assign) NSUInteger selectedPreviewIndex;


@property (readwrite, nonatomic, assign) CGSize previewSize;
@property (readwrite, nonatomic, assign) CGFloat previewGap;
@property (readwrite, nonatomic, retain) UIImage *placeholderImage;
@property (readwrite, nonatomic, assign) id <CPreviewBarDelegate> delegate;

- (void)updatePreviewAtIndex:(NSInteger)inIndex;

@end

#pragma mark -

@protocol CPreviewBarDelegate <NSObject>
@required
- (NSInteger)numberOfPreviewsInPreviewBar:(CPreviewBar *)inPreviewBar;
- (UIImage *)previewBar:(CPreviewBar *)inPreviewBar previewAtIndex:(NSInteger)inIndex;
@end