/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Nicolas Jinchereau. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

#include <ui/Utils.h>
#include <Cocoa/Cocoa.h>



@implementation Utils

+ (NSGradient*)backgroundBorderGradient {
    // Create a gradient with your desired colors
    NSColor *startColor = [NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    NSColor *endColor = [NSColor colorWithCalibratedRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    
    return gradient;
}

+ (NSImage*)iconForPath:(NSString*)path
{
    NSImage *icon = nil;
    
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    if(isDir)
        icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
    else
        icon = [[NSWorkspace sharedWorkspace] iconForFileType:[path pathExtension]];
    
    return icon;
}

+ (NSString*)titleForPath:(NSString*)path
{
    return [[path lastPathComponent] stringByDeletingPathExtension];
}

+ (NSImage*)iconForHighlightedItem:(NSImage*)icon
{
    NSImage *ret = [icon copy];
    
    NSRect bounds = NSMakeRect(0, 0, icon.size.width, icon.size.height);
    
    [ret lockFocus];
    [[NSColor controlBackgroundColor] set];
    NSRectFillUsingOperation(bounds, NSCompositingOperationSourceAtop);
    [ret unlockFocus];
    
    return [ret autorelease];
}

+ (NSImage *)iconWithRotation:(NSImage*)icon angle:(float)angle
{
    NSImage *ret = [[[NSImage alloc] autorelease] initWithSize:icon.size];
    
    [ret lockFocus];
    
    NSAffineTransform *xf = [NSAffineTransform transform];
    NSPoint center = NSMakePoint(icon.size.width / 2, icon.size.height / 2);
    
    [xf translateXBy:center.x yBy:center.y];
    [xf rotateByDegrees:angle];
    [xf translateXBy:-center.y yBy:-center.x];
    [xf concat];
    
    [icon drawInRect:NSMakeRect(0, 0, icon.size.width, icon.size.height)];
    
    [ret unlockFocus];
    
    return ret;
}

+ (BOOL)isDir:(NSString*)path
{
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    return isDir && ![[NSWorkspace sharedWorkspace] isFilePackageAtPath:path];
}

+ (BOOL)isFastDockEnabled
{
    NSDictionary *domain = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.dock"];
    NSNumber* autohideDelay = [domain objectForKey:@"autohide-delay"];
    NSNumber* autohideTimeModifier = [domain objectForKey:@"autohide-time-modifier"];
    
    
    return autohideDelay != nil && autohideDelay.intValue == 0 && autohideTimeModifier != nil && autohideTimeModifier.intValue == 0;
}

+ (void)enableFastDock:(BOOL)enable
{
    NSDictionary *domain = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.dock"];
    
    if(enable)
    {
        NSMutableDictionary* dict = domain.mutableCopy;
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"autohide-delay"];
        [dict setObject:[NSNumber numberWithInt:32] forKey:@"tilesize"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"autohide-time-modifier"];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:dict forName:@"com.apple.dock"];
    }
    else
    {
        NSMutableDictionary* dict = domain.mutableCopy;
        [dict removeObjectForKey:@"autohide-delay"];
        [dict removeObjectForKey:@"tilesize"];
        [dict removeObjectForKey:@"autohide-time-modifier"];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:dict forName:@"com.apple.dock"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    auto dock = [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dock"] objectAtIndex:0];
    [dock terminate];
}

+ (BOOL)isDisableDockEnabled
{
    NSDictionary *domain = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.dock"];
    NSNumber* autohideDelay = [domain objectForKey:@"autohide-delay"];
    NSNumber* autohideTimeModifier = [domain objectForKey:@"autohide-time-modifier"];
    
    return autohideDelay != nil && autohideDelay.intValue == 1000 && autohideTimeModifier != nil && autohideTimeModifier.intValue == 0;
}

+ (void)enableDisableDock:(BOOL)enable
{
    NSDictionary *domain = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.dock"];
    
    if(enable)
    {
        NSMutableDictionary* dict = domain.mutableCopy;
        [dict setObject:[NSNumber numberWithInt:1000] forKey:@"autohide-delay"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"tilesize"];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:dict forName:@"com.apple.dock"];
    }
    else
    {
        NSMutableDictionary* dict = domain.mutableCopy;
        [dict removeObjectForKey:@"autohide-delay"];
        [dict removeObjectForKey:@"tilesize"];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:dict forName:@"com.apple.dock"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    auto dock = [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dock"] objectAtIndex:0];
    [dock terminate];
}

    

+ (NSColor*)backgroundColor {
    return [NSColor windowBackgroundColor];
}

+ (NSColor*)backgroundColorHot {
    NSColor *originalColor = [NSColor   blackColor]; // Use your base color here
    CGFloat darkeningFactor = 0.5; // Adjust this factor to make it darker (0.0 to 1.0)

    // Create a darker color by reducing brightness
    NSColor *darkerColor = [originalColor colorWithAlphaComponent:darkeningFactor];

    return darkerColor;
}
+ (NSColor*)backgroundColorFocused {
    NSColor *originalColor = [NSColor   blackColor]; // Use your base color here
    CGFloat darkeningFactor = 0.3; // Adjust this factor to make it darker (0.0 to 1.0)

    // Create a darker color by reducing brightness
    NSColor *darkerColor = [originalColor colorWithAlphaComponent:darkeningFactor];

    return darkerColor;
}
+ (NSColor*)backgroundBorderColor {
  NSColor *originalColor = [NSColor   disabledControlTextColor]; // Use your base color here
   CGFloat darkeningFactor = 0.1; // Adjust this factor to make it darker (0.0 to 1.0)

    // Create a darker color by reducing brightness
    NSColor *darkerColor = [originalColor colorWithAlphaComponent:darkeningFactor];
    
    return darkerColor;
 }

+ (NSColor*)textColor {
    return [NSColor windowFrameTextColor];
}

+ (NSColor*)textColorHot {
    return [NSColor selectedMenuItemTextColor];
}

+ (NSColor*)textColorFocused {
    return [NSColor selectedControlTextColor];
}




@end
