//
//  CPDFPagePlaceholderView.h
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CPDFPagePlaceholderView : UIImageView {
    
}

@property (readwrite, nonatomic, assign) CGPDFPageRef page;

@end
