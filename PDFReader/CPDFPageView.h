//
//  CPDFPageView.h
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPDFPage;

@interface CPDFPageView : UIView {
    
}

@property (readwrite, nonatomic, retain) CPDFPage *page;

@end
