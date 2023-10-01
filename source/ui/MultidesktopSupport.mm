/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Nicolas Jinchereau. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

#import <Cocoa/Cocoa.h>

void enableMultidesktopSupport() {
    NSApplication *sharedApp = [NSApplication sharedApplication];
    [sharedApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [sharedApp activateIgnoringOtherApps:YES];
}