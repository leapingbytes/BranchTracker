//
//  LBSettingsPopupViewController.m
//  BranchTracker
//
//  Created by Andrei Tchijov on 12/7/12.
//  Copyright (c) 2012 Andrei Tchijov. All rights reserved.
//

#import "NSButton+Extended.h"
#import "LBSettingsPopupViewController.h"

@interface LBSettingsPopupViewController ()

@end

@implementation LBSettingsPopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) restoreDefaults {
    NSUserDefaults* defaults = [ NSUserDefaults standardUserDefaults];
    NSError* error = nil;
    BOOL isStale = NO;
    BOOL success = NO;

    NSData* repSecureBookmark = [ defaults objectForKey: @"rep-bookmark-data" ];
    NSURL* repURL = repSecureBookmark == nil ? nil : [ NSURL URLByResolvingBookmarkData: repSecureBookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL: nil bookmarkDataIsStale: &isStale error: &error ];
    
    if (repURL != nil) {
        success = [ repURL startAccessingSecurityScopedResource ];
        if (success) {
            [_rep_path setURL: repURL ];
        }
    }

    NSData* gitSecureBookmark = [ defaults objectForKey: @"git-bookmark-data" ];
    NSURL* gitURL = gitSecureBookmark == nil ? nil : [ NSURL URLByResolvingBookmarkData: gitSecureBookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL: nil bookmarkDataIsStale: &isStale error: &error ];
    
    if (gitURL != nil) {
        [ gitURL startAccessingSecurityScopedResource ];
        [_git_path setURL: gitURL ];
    }
    else {
        [_git_path setURL: [NSURL fileURLWithPath: @"/usr/bin/git"]];
    }
}

- (void) saveDefaults {
    NSURL* repURL = _rep_path.URL;
    NSURL* gitURL = _git_path.URL;
    
    NSError* error = nil;
    
    NSData* repSecureBookmark = [repURL
        bookmarkDataWithOptions: NSURLBookmarkCreationWithSecurityScope
        includingResourceValuesForKeys: nil
        relativeToURL: nil
        error:&error ];

    NSData* gitSecureBookmark = [gitURL
        bookmarkDataWithOptions: NSURLBookmarkCreationWithSecurityScope | NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess 
        includingResourceValuesForKeys: nil
        relativeToURL: nil
        error:&error ];
    
    NSUserDefaults* defaults = [ NSUserDefaults standardUserDefaults];
    
    [ defaults setObject: repSecureBookmark forKey: @"rep-bookmark-data" ];
    [ defaults setObject: gitSecureBookmark forKey: @"git-bookmark-data" ];
}

- (void) awakeFromNib {
    [_quit_button setTextColor: [ NSColor whiteColor ]];
    [_save_button setTextColor: [ NSColor whiteColor ]];
    
    [_rep_path setBackgroundColor: [NSColor colorWithCalibratedWhite: 1.0 alpha:0.8]];
    [_rep_path.layer setCornerRadius: 5.0 ];
    [_rep_path.layer setMasksToBounds: YES];
    
    [_git_path setBackgroundColor: [NSColor colorWithCalibratedWhite: 1.0 alpha:0.8]];
    [_git_path.layer setCornerRadius: 5.0 ];
    [_git_path.layer setMasksToBounds: YES];
    
    [ self restoreDefaults ];
}


- (NSURL*) repURL {
    return [ _rep_path URL ];
}


- (NSURL*) gitURL {
    return [ _git_path URL ];
}

@end
