//
//  LBGitHelper.m
//  BranchTracker
//
//  Created by Andrei Tchijov on 3/1/13.
//  Copyright (c) 2013 Andrei Tchijov. All rights reserved.
//

#import "LBGitHelperService.h"
#import "LBGitHelper.h"

@interface LBGitHelper()

@property NSMutableArray*      _branches;
@property NSMutableArray*      _stashes;

@property NSString*            _currentBranch;

@property NSURL*               _repoURL;
@property LBGitHelperService*  _service;

- (NSArray*) runGitWithArguments: (NSArray*) arguments;

@end

@implementation LBGitHelper

- (id) initWithRepoURL: (NSURL*) repoURL andService: (LBGitHelperService*) service {
    self = [super init];
    
    self._repoURL = repoURL;
    self._service = service;
    
    return self;
}

- (NSArray*) branches {
    return self._branches;
}

- (NSString*) currentBranch {
    return self._currentBranch;
}

- (void) sync {
    NSArray* lines = [ self runGitWithArguments: [NSArray arrayWithObject: @"branch" ]];
    
    self._branches = self._branches == nil ? [[ NSMutableArray alloc] init] : self._branches;
    [self._branches removeAllObjects];
    for ( int i = 0; i < [ lines count ]; i++) {
        NSString* line = [[ lines objectAtIndex: i ] stringByTrimmingCharactersInSet: [ NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([ line length ] == 0) {
            continue;
        }
        
        if ([ line characterAtIndex: 0 ] == '*') {
            self._currentBranch = [ line substringFromIndex: 2 ];
            [self._branches addObject: self._currentBranch];
        }
        else {
            [self._branches addObject: line];
        }
    }

    lines = [ self runGitWithArguments: [NSArray arrayWithObjects: @"stash", @"list", nil ]];
    self._stashes = self._stashes == nil ? [[ NSMutableArray alloc] init] : self._branches;
    [self._stashes removeAllObjects];
    for ( int i = 0; i < [ lines count ]; i++) {
        NSString* line = [[ lines objectAtIndex: i ] stringByTrimmingCharactersInSet: [ NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([ line length ] == 0) {
            continue;
        }
        NSArray* parts = [line componentsSeparatedByString: @":"];
        [ self._branches addObject: [ NSDictionary dictionaryWithObjectsAndKeys:
            @"id", [parts objectAtIndex: 0],
            @"branch", [[parts objectAtIndex: 1 ] substringFromIndex: 5 ], // skip ' On '
            @"message", [parts objectAtIndex: 0],
            nil
        ]];
    }
    
    NSLog(@"stashes : %@", self._stashes);
}

- (NSArray*) runGitWithArguments: (NSArray*) arguments {
    return [ self._service runCommand: self._service.gitURL.path atPath: self._repoURL.path withArguments: arguments ];
}


@end
