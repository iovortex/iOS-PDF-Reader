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

@end
