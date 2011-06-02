//
//  PDFReaderViewController.h
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPDFDocument;
@class CPagingView;
@class CPDFPagePlaceholderView;
@class CPreviewBar;
@class CPageControl;

@interface CPDFDocumentViewController : UIViewController {
    
}

@property (readwrite, nonatomic, retain) CPDFDocument *document;

@property (readwrite, nonatomic, retain) IBOutlet CPagingView *pagingView;
@property (readwrite, nonatomic, retain) IBOutlet CPDFPagePlaceholderView *pagePlaceholderView;
@property (readwrite, nonatomic, retain) IBOutlet CPageControl *pageControl;
@property (readwrite, nonatomic, retain) IBOutlet UIView *chromeView;
@property (readwrite, nonatomic, retain) IBOutlet CPreviewBar *previewBar;

- (id)initWithURL:(NSURL *)inURL;

@end
