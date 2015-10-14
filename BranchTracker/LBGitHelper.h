//
//  LBGitHelper.h
//  BranchTracker
//
//  Created by Andrei Tchijov on 3/1/13.
//  Copyright (c) 2013 Andrei Tchijov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBGitHelperService;

@interface LBGitHelper : NSObject

- (id) initWithRepoURL: (NSURL*) repoURL andService: (LBGitHelperService*) service;

- (NSArray*) branches;
- (NSString*) currentBranch;
- (void) sync;

@end
