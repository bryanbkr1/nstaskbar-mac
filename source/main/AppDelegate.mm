/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Nicolas Jinchereau. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

#import "AppDelegate.h"
#include <ui/TaskBarWindow.h>
#import <Cocoa/Cocoa.h>
#include <ui/Utils.h>


@interface AppDelegate ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, TaskBarWindow *> *taskbars;
@property (nonatomic, strong) Workspace *workspace;
@end

@implementation Workspace
-(void)applicationCreated:(ax::Application*)app
{
    //cout << "   app created: " << app->title() << endl;
}
-(void)applicationDestroyed:(ax::Application*)app
{
    //cout << "   app destroyed: " << app->title() << endl;
}
-(void)windowCreated:(ax::Window*)window
{
    //cout << "window created: " << window->title() << endl;
    [_taskbar addWindow:window];
}

-(void)windowDestroyed:(ax::Window*)window
{
    //cout << "window destroyed: " << window->title() << endl;
    [_taskbar removeWindow:window];
}
-(void)windowRenamed:(ax::Window*)window
{
    //cout << "window renamed: " << window->title() << endl;
    [_taskbar renameWindow:window];
}
-(void)windowResized:(ax::Window*)window
{
    //cout << "window resized: " << window->title() << endl;
}
-(void)windowMoved:(ax::Window*)window
{
    //cout << "window moved: " << window->title() << endl;
}
-(void)windowFocusChanged:(ax::Window*)window focused:(bool)focused
{
    //if(focused)
    //    cout << "window focused: " << window->title() << endl;
    [_taskbar setWindowFocus:window focused:focused];
}
-(id)initWithTaskbar:(TaskBarWindow*)taskbar
{
    _taskbar = [taskbar retain];
    self = [super init];
    return self;
}
-(void)dealloc
{
    [super dealloc];
    [_taskbar release];
}
@end




@implementation AppDelegate





-(void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    [AXWorkspace assertAccessibilityEnabled];
    
    self.taskbars = [NSMutableDictionary dictionary];

    // Initialize the workspace
    TaskBarWindow *initialTaskbar = [[TaskBarWindow alloc] init];
    self.workspace = [[Workspace alloc] initWithTaskbar:initialTaskbar];

    // Listen for notifications related to space changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activeSpaceDidChange:)
                                                 name:NSWorkspaceActiveSpaceDidChangeNotification
                                               object:nil];
 }

 - (void)applicationWillTerminate:(NSNotification *)aNotification {
     // Release all taskbars
     for (TaskBarWindow *taskbar in self.taskbars) {
         [taskbar release];
     }

     // Remove the observer for space change notifications
     [[NSNotificationCenter defaultCenter] removeObserver:self
                                                     name:NSWorkspaceActiveSpaceDidChangeNotification
                                                   object:nil];
 }

 // Handle the active space change in this method
 - (void)activeSpaceDidChange:(NSNotification *)notification {
     // Get the new active space identifier
     NSString *newSpaceIdentifier = [[NSWorkspace sharedWorkspace] activeSpaceIdentifier];

     // Check if a taskbar for the new space already exists, create one if not
     TaskBarWindow *taskbar = self.taskbars[newSpaceIdentifier];
     if (!taskbar) {
         TaskBarWindow *taskbar = [[TaskBarWindow alloc] init];
         self.taskbars[newSpaceIdentifier] = taskbar;
     }
 }


@end
