//
//  LBGitHelperProtocol.h
//  BranchTracker
//
//  Created by Me on 8/3/14.
//  Copyright (c) 2014 Andrei Tchijov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LBGitHelperProtocol <NSObject>

- (void) setGitURL: (NSData*) gitBookmark;

- (void) branches: (NSData*) repoBookmark reply:(void (^)(NSArray* branches))reply;

- (void) currentBranch: (NSData*) repoBookmark reply:(void (^)(NSString* currentBranch))reply;

- (void) sync: (NSData*) repoBookmark reply: (void (^)(NSString* currentBranch))reply;

@end
