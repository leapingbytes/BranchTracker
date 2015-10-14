//
//  LBGitHelperService.h
//  BranchTracker
//
//  Created by Me on 8/3/14.
//  Copyright (c) 2014 Andrei Tchijov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBGitHelperProtocol.h"

@interface LBGitHelperService : NSObject <LBGitHelperProtocol, NSXPCListenerDelegate>
-(NSURL*) gitURL;
- (NSArray*) runCommand:(NSString *)command_path atPath: (NSString*) current_dir_path withArguments:(NSArray *)arguments;
@end
