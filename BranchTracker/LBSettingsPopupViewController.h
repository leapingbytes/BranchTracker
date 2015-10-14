//
//  LBSettingsPopupViewController.h
//  BranchTracker
//
//  Created by Andrei Tchijov on 12/7/12.
//  Copyright (c) 2012 Andrei Tchijov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LBSettingsPopupViewController : NSViewController 

@property (retain) IBOutlet NSPathControl*  rep_path;
@property (retain) IBOutlet NSPathControl*  git_path;

@property (retain) IBOutlet NSButton*       quit_button;
@property (retain) IBOutlet NSButton*       save_button;

- (void) restoreDefaults;
- (void) saveDefaults;

- (NSURL*) repURL;
- (NSURL*) gitURL;

@end
