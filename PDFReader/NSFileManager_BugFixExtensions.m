//
//  NSFileManager_BugFixExtensions.m
//  PDFReader
//
//  Created by Jonathan Wight on 06/01/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "NSFileManager_BugFixExtensions.h"

@interface CBlockEnumerator : NSEnumerator
@property (readwrite, nonatomic, copy) id (^block)(void);
@end

#pragma mark -

@implementation NSFileManager (NSFileManager_BugFixExtensions)

- (NSEnumerator *)tx_enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler;
    {
    NSAssert(mask == 0, @"We don't handle masks");
    NSAssert(keys == NULL, @"We don't handle non-null keys");
    
    NSDirectoryEnumerator *theInnerEnumerator = [self enumeratorAtPath:[url path]];

    CBlockEnumerator *theEnumerator = [[[CBlockEnumerator alloc] init] autorelease];
    theEnumerator.block = ^id(void) {
        NSString *thePath = [theInnerEnumerator nextObject];
        if (thePath != NULL)
            {
            return([url URLByAppendingPathComponent:thePath]);
            }
        else
            {
            return(NULL);
            }
         };
    
    return(theEnumerator);
    }

@end

#pragma mark -

@implementation CBlockEnumerator

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