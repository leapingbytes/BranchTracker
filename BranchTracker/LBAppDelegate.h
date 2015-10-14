//
//  LBAppDelegate.h
//  BranchTracker
//
//  Created by Andrei Tchijov on 12/3/12.
//  Copyright (c) 2012 Andrei Tchijov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LBSettingsPopupViewController.h"
#import "LBGitHelper.h"

typedef void (^ABlock)() ;

@interface LBClickableView : NSView

//@property (assign) SEL action;
//@property (retain) NSObject* __strong target;

@property (copy) ABlock       onMouseDownBlock;

@end

@interface LBAppDelegate : NSObject <NSApplicationDelegate, NSPopoverDelegate, NSMenuDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (retain) IBOutlet LBSettingsPopupViewController* settings_controller;
@property (retain) IBOutlet NSPopover*                      settings_popover;

@property (retain) NSStatusItem*    status_bar_item;
@property (retain) LBClickableView* status_view;
@property (retain) NSTextField*     status_text;

@property (retain) NSButton*        branch_button;

@property (retain) NSTimer*         checkTimer;

@property (retain) IBOutlet NSMenu* branchesMenu;
@property (retain) IBOutlet NSPopUpButton* branchesPopUp;
@property (retain) NSMutableArray*      branches;

@property (retain) IBOutlet NSButton*   useStashCheckbox;

- (IBAction) showSettings:(id)sender;
- (IBAction) saveSettings:(id)sender;

- (IBAction) quitApp:(id)sender;

@end
