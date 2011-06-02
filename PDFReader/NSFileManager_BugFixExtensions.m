//
//  NSFileManager_BugFixExtensions.m
//  PDFReader
//
//  Created by Jonathan Wight on 06/01/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "NSFileManager_BugFixExtensions.h"

@interface CMyDirectoryEnumerator : NSEnumerator
@property (readwrite, nonatomic, copy) id (^block)(void);
@end

#pragma mark -

@implementation NSFileManager (NSFileManager_BugFixExtensions)

- (NSEnumerator *)tx_enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler;
    {
    NSDirectoryEnumerator *theInnerEnumerator = [self enumeratorAtPath:[url path]];

    CMyDirectoryEnumerator *theEnumerator = [[[CMyDirectoryEnumerator alloc] init] autorelease];
    theEnumerator.block = (id)^(void) {
        NSString *thePath = [theInnerEnumerator nextObject];
        if (thePath != NULL)
            {
            return([url URLByAppendingPathComponent:thePath]);
            }
        else
            {
            return((NSURL *)NULL);
            }
         };
    
    return(theEnumerator);
    }

@end

#pragma mark -

@implementation CMyDirectoryEnumerator

@synthesize block;

- (void)dealloc
    {
    [block release];
    block = NULL;
    //
    [super dealloc];
    }

- (id)nextObject
    {
    id theObject = self.block();
    return(theObject);
    }

@end