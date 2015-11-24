//
//  ParseUtils.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "ParseUtils.h"

@implementation ParseUtils

+(void)setUpParse:(NSDictionary *)launchOptions{
    [Parse setApplicationId:@"rMumiAvVoZcu84eYaKs96j4mEQHeWgOYxNz5C7dW"
                  clientKey:@"X9k9J9AnF65WgmSkR2154gYxEDcFb8l4jtdCs7Ig"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
}

+(bool)handleFacebookApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

+(void)activateFacebook{
    [FBSDKAppEvents activateApp];
}


@end
