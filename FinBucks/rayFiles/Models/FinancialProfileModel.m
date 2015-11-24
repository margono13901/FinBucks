//
//  FinancialProfileModel.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "FinancialProfileModel.h"

@implementation FinancialProfileModel

+(void)createFinancialProfile:(NSString *)username password:(NSString *)password type:(NSString *)type block:(success)result{
    
    NSString *webhook = @"https://rMumiAvVoZcu84eYaKs96j4mEQHeWgOYxNz5C7dW:javascript-key=mfBRrPPL1edbOcf1vsq85BbWGiC4AZg2aIQo4556@api.parse.com/1/functions/transaction";
    
    [Plaid setClient:@"5646df2bbb7f38241cca3b77" setSecret:@"9dbd52be18a526147cc7a8b7d020c1" inProduction:NO];
    [Plaid addUserWithUsername:username Password:password Type:type Webhook:webhook Login_only:YES WithCompletionHandler:^(NSDictionary *output) {
        
        if (output[@"mfa"]) {
            result(output);
        }else{
            [FinancialProfileModel createFinancialProfile:output type:type block:^(NSDictionary *callback) {
                result(callback);
            }];
        }
    }];
}

+(void)handleMFA:(NSString *)response withData:(NSDictionary *)dictionary block:(success)result{
    [Plaid submitMfaCredentialWithAccessToken:dictionary[@"access_token"] MFA:response WithCompletionHandler:^(NSDictionary *output) {
        if ((int)output[@"code"]!=200) {
            NSDictionary *dict = @{@"success":@NO};
            result(dict);
        }else{
            if (output[@"mfa"]) {
                result(dictionary);
            }else{
                NSDictionary *dict = @{@"success":@NO};
                result(dict);
            }
        }
    }];
}

+(void)createFinancialProfile:(NSDictionary *)dict type:(NSString *)type block:(success)result{
    
    PFObject *financialProfile = [PFObject objectWithClassName:@"FinancialProfile"];
    financialProfile[@"type"] = type;
    financialProfile[@"accountID"] = dict[@"access_token"];
    financialProfile[@"owner"] = [PFUser currentUser];
    
    [financialProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[@"accountID"] = dict[@"access_token"];;
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSDictionary *dictionary = @{@"Success":@YES};
            result(dictionary);
        }];
    }];
}

@end
