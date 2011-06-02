//
//  PDFReaderAppDelegate.m
//  PDFReader
//
//  Created by Jonathan Wight on 02/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "PDFReaderAppDelegate.h"

@implementation PDFReaderAppDelegate

@synthesize window;

- (void)dealloc
    {
    [window release];
    [super dealloc];
    }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
    [self.window makeKeyAndVisible];

    return YES;
    }

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
    if ([url isFileURL])
        {
        NSString *theDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSURL *theDestinationURL = [[NSURL fileURLWithPath:theDocumentsPath] URLByAppendingPathComponent:[url lastPathComponent]];
        
        NSError *theError = NULL;
        BOOL theResult = [[NSFileManager defaultManager] moveItemAtURL:url toURL:theDestinationURL error:&theError];
        
        NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
            sourceApplication, @"sourceApplication",
            annotation, @"annotation",
            theDestinationURL, @"URL",
            NULL];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidOpenURL" object:application userInfo:theUserInfo];
        
        return(theResult);
        }
    return(NO);
    }

@end
