//
//  NSFileManager_BugFixExtensions.h
//  PDFReader
//
//  Created by Jonathan Wight on 06/01/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (NSFileManager_BugFixExtensions)

- (NSEnumerator *)tx_enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler;


@end
