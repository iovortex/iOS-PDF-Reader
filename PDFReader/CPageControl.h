//
//  CPagingView.h
//  PDFReader
//
//  Created by Jonathan Wight on 02/20/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CPageControl : UIControl {
    
}

@property (readwrite, nonatomic, retain) IBOutlet UIView *leftView;
@property (readwrite, nonatomic, retain) IBOutlet UIView *rightView;
@property (readwrite, nonatomic, retain) IBOutlet UIView *topView;
@property (readwrite, nonatomic, retain) IBOutlet UIView *bottomView;

@property (readwrite, nonatomic, assign) id target;
@property (readwrite, nonatomic, assign) SEL nextAction;
@property (readwrite, nonatomic, assign) SEL previousAction;

@end
