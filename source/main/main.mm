/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Nicolas Jinchereau. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#include <Foundation/Foundation.h>





int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate]; // Assign the app delegate
        return NSApplicationMain(argc, argv);
    }


    
    return 0;
}
