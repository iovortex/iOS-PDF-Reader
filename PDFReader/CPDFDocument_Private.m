//
//  CPDFDocument_Private.m
//  PDFReader
//
//  Created by Jonathan Wight on 06/01/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CPDFDocument_Private.h"

#import <objc/runtime.h>

@implementation CPDFDocument (CPDFDocument_Private)

- (NSCache *)cache
    {
    const void *theCacheKey = "cache";
    NSCache *theCache = objc_getAssociatedObject(self, theCacheKey);
    if (theCache == NULL)
        {
        theCache = [[[NSCache alloc] init] autorelease];
        objc_setAssociatedObject(self, theCacheKey, theCache, OBJC_ASSOCIATION_RETAIN);
        }
    return(theCache);
    
    }

@end
