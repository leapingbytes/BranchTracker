//
//  LBAppDelegate.m
//  BranchTracker
//
//  Created by Andrei Tchijov on 12/3/12.
//  Copyright (c) 2012 Andrei Tchijov. All rights reserved.
//

#import "LBAppDelegate.h"
#import "LBGitHelperProtocol.h"

@implementation LBClickableView

- (void) mouseDown:(NSEvent *)theEvent {
    self.onMouseDownBlock();
}

@end

@interface LBAppDelegate()

@property (getter=_gitHelper,readonly) id<LBGitHelperProtocol> gitHelper;

@end

@implementation LBAppDelegate

- (id<LBGitHelperProtocol>) _gitHelper {
    static id<LBGitHelperProtocol> helper = nil;
    
    if (helper == nil) {
        NSXPCInterface *gitHelperInterface = [NSXPCInterface interfaceWithProtocol: @protocol(LBGitHelperProtocol)];
        
        NSXPCConnection *serviceConnection =    [[NSXPCConnection alloc] initWithServiceName:@"com.leapingbytes.githelper"];
        serviceConnection.remoteObjectInterface = gitHelperInterface;
        [serviceConnection resume];
        
        helper = [serviceConnection remoteObjectProxy];
    }
    NSData* bookmark = [ self makeBookmark: [_settings_controller gitURL]];
    if (bookmark != nil) {
        [helper setGitURL: bookmark];
    }
    
    return helper;
}

- (NSData*) makeBookmark: (NSURL*) url {
    NSError* error = nil;
    url = [ url filePathURL];
    
    NSData* secureBookmark = [[url filePathURL] bookmarkDataWithOptions: NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys: nil relativeToURL: nil error: &error];
    
    if (secureBookmark == nil) {
        NSLog( @"Fail to create bookmark : %@", error);
    }
    return secureBookmark;
}

- (void) checkBranch {
    NSURL* repoURL = [ _settings_controller repURL ];
    NSData* secureBookmark = [self makeBookmark: repoURL];
    [self.gitHelper sync: secureBookmark reply:^(NSString* currentBranch){
        [self setBranchText: currentBranch] ;
    }];
}

- (void) startChecking {
    NSURL* rep_URL = [ _settings_controller repURL ];
    NSURL* git_URL = [ _settings_controller gitURL ];
    
    if (rep_URL == nil || git_URL == nil ) {
        [ self showSettings: nil ];
    }
    else {
        _checkTimer = [ NSTimer scheduledTimerWithTimeInterval: 3.0 target: self selector: @selector(checkBranch) userInfo: nil repeats: YES ];
        [ self checkBranch ];
    }
}

- (void) setBranchText: (NSString*) text {
    [_status_text setStringValue: text];
    
    NSRect frame = _status_text.frame;
    [_status_text sizeToFit];
    frame.size.width = _status_text.frame.size.width;
    [_status_text setFrame: frame ];
    
    NSRect viewFrame = _status_view.frame;
    viewFrame.size.width = viewFrame.size.height + frame.size.width;
    [_status_view setFrame: viewFrame ];
    
    [self.branchesPopUp setTitle: [ NSString stringWithFormat: @"%@", text]];
    [self.branchesMenu setTitle: [ NSString stringWithFormat: @"%@", text]];
}

- (IBAction) showSettings:(id)sender {
    if ( _settings_popover == nil ) {
        _settings_popover = [[ NSPopover alloc] init ];
        _settings_popover.contentViewController = _settings_controller;
        _settings_popover.animates = TRUE;
        _settings_popover.appearance = NSPopoverAppearanceHUD;
        _settings_popover.behavior = NSPopoverBehaviorApplicationDefined;
        _settings_popover.delegate = self;
    }

    [_settings_popover showRelativeToRect:[_status_view frame] ofView: _status_view preferredEdge: NSMaxYEdge];
}

- (IBAction) quitApp:(id)sender {
    [[NSApplication sharedApplication] terminate: self ];
}

- (IBAction) saveSettings:(id)sender {
    [ _settings_popover close ];
    [ _settings_controller saveDefaults ];
    [ self startChecking ];
}

- (void) awakeFromNib {
    _status_bar_item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    float bar_thickness = _status_bar_item.statusBar.thickness;
    float top = bar_thickness * 0.1;
    float t = bar_thickness * 0.8;

    _status_view = [[ LBClickableView alloc] initWithFrame: NSMakeRect(0, 0, 5*bar_thickness, bar_thickness)];
    __weak LBAppDelegate* me = self;
    _status_view.onMouseDownBlock = ^(){
        [ me showSettings: nil ];
    };
    
    NSImage* icon = [ NSImage imageNamed: @"logo_v2_low_rez"];
    [ icon setSize: NSMakeSize( t, t )];
    NSImageView* status_icon = [[ NSImageView alloc] initWithFrame:NSMakeRect(0, top, t, t)];
    [ status_icon setEnabled: YES ];
    [ status_icon setImage: icon ];
    
    [ _status_view addSubview: status_icon ];
    
    _status_text = [[ NSTextField alloc ] initWithFrame: NSMakeRect(t, top, 4*bar_thickness, t)];
    _status_text.backgroundColor = [ NSColor clearColor ];
    _status_text.bezeled = NO;
    _status_text.editable = NO;
    [ _status_view addSubview: _status_text ];
    
    [_status_bar_item setView: _status_view];
    
    [ self setBranchText: @"???" ];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [ self startChecking ];    
}


#pragma mark - NSMenuDelegate

- (void) switchBranch: (id) sender {
    NSString* branchName = [(NSMenuItem*)sender title];
    NSLog( @"menu : %@", branchName);    
}

- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu {
//    return [self.gitHelper.branches count];
    return 0;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel {
//    NSString* branch = [self.gitHelper.branches objectAtIndex: index];
//    BOOL currentBranch = [branch isEqualToString: self.gitHelper.currentBranch];
//    
//    [item setTitle: branch];
//    [item setTarget: self];
//    [item setAction: @selector(switchBranch:)];
//    
//    [item setState: currentBranch ? NSOnState : NSOffState];
//    
    return YES;
}

- (void)menuWillOpen:(NSMenu *)menu {
}

@end
