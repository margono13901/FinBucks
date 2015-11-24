//
//  NetworkManager.m
//  FinBucks
//
//  Created by Sudeep Agarwal on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (id)sharedManager {
    static NetworkManager *sharedNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworkManager = [[self alloc] init];
    });
    return sharedNetworkManager;
}



@end
