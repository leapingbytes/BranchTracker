//
//  main.m
//  githelper
//
//  Created by Me on 8/3/14.
//  Copyright (c) 2014 Andrei Tchijov. All rights reserved.
//

#include <xpc/xpc.h>
#include <Foundation/Foundation.h>

#include "LBGitHelperService.h"

int main(int argc, const char *argv[]) {
    LBGitHelperService *service = [[LBGitHelperService alloc]init];
    
    
    NSXPCListener *listener = [NSXPCListener serviceListener];
 
    listener.delegate = service;
    [listener resume];
 
    // The resume method never returns.
    exit(EXIT_FAILURE);
    
    return 0;
}
