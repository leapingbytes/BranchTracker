//
//  LBGitHelperService.m
//  BranchTracker
//
//  Created by Me on 8/3/14.
//  Copyright (c) 2014 Andrei Tchijov. All rights reserved.
//

#import "LBGitHelperService.h"
#import "LBGitHelper.h"

@interface LBGitHelperService()
@property(retain,nonatomic) NSURL* _gitURL;

- (NSArray*) runCommand: (NSString*) command_path atPath: (NSString*) current_dir_path withArguments: (NSArray*) arguments;

@end

@implementation LBGitHelperService

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol: @protocol(LBGitHelperProtocol)];
    newConnection.exportedObject = self;
    [newConnection resume];
    
    return YES;
}

- (LBGitHelper*) getHelperForRepoURL: (NSURL*) anURL {
    static NSMutableDictionary*  _helpers = nil;
    
    if (_helpers == nil) {
        _helpers = [[ NSMutableDictionary alloc] init];
    }
    
    LBGitHelper* helper = [_helpers objectForKey: anURL];
    if (helper == nil) {
        helper = [[ LBGitHelper alloc] initWithRepoURL: anURL andService: self];
        [ _helpers setObject: helper forKey: anURL];
        
        [ helper sync ];
    }
    
    return helper;
}

- (NSURL*) resolveBookmark: (NSData*) bookmark {
    BOOL isStale = NO;
    NSError* error = nil;
    
    NSURL* result = [ NSURL URLByResolvingBookmarkData: bookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale: &isStale error: &error];
    if (result == nil) {
        NSLog(@"Fail to resolve bookmark : %@", error);
        exit(1);
    }
    else {
        [ result startAccessingSecurityScopedResource];
    }

    return result;
}


- (void) setGitURL:(NSData *) bookmark {
    if( bookmark == nil) {
        NSLog(@"setGitURL - bookmark == nil");
        return;
    }
    NSLog(@"setGitURL - start");
    if( self._gitURL != nil) {
        [ self._gitURL stopAccessingSecurityScopedResource];
    }
    self._gitURL = [self resolveBookmark: bookmark];
    NSLog(@"setGitURL - end : %@", self._gitURL);
}

- (NSURL*) gitURL {
    return self._gitURL == nil ? [NSURL fileURLWithPath: @"/usr/bin/git" ] : self._gitURL;
}

- (void) branches: (NSData*) bookmark reply:(void (^)(NSArray*))reply {
    NSLog(@"branches: start");

    LBGitHelper* helper = [self getHelperForRepoURL: [self resolveBookmark: bookmark]];
    
    reply(helper.branches);
    NSLog(@"branches: end");
}

- (void) currentBranch: (NSData*) bookmark reply:(void (^)(NSString*))reply {
    NSLog(@"currentBranch: start");
    LBGitHelper* helper = [self getHelperForRepoURL: [self resolveBookmark: bookmark]];

    reply(helper.currentBranch);
    NSLog(@"currentBranch: end");
}

- (void) sync: (NSData*) bookmark reply: (void (^)(NSString*))reply {
    NSLog(@"sync: start");
    LBGitHelper* helper = [self getHelperForRepoURL: [self resolveBookmark: bookmark]];

    [helper sync];
    
    reply(helper.currentBranch);
    NSLog(@"sync: end");
}

#pragma mark -

- (NSArray*) runCommand:(NSString *)command_path atPath: (NSString*) current_dir_path withArguments:(NSArray *)arguments {
    NSTask* task = [[ NSTask alloc] init];
    
    [ task setLaunchPath: command_path ];
    [ task setArguments: arguments ];
    
    [ task setCurrentDirectoryPath: current_dir_path];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];

    NSFileHandle *file;
    file = [pipe fileHandleForReading];

    [task launch];

    NSData *data;
    data = [file readDataToEndOfFile];

    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    NSArray* lines = [ string componentsSeparatedByString: @"\n" ];
    
    return lines;
}

@end
