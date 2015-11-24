//
//  FinancialProfileModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "BaseModel.h"
#import "Plaid.h"
#import <Foundation/Foundation.h>
typedef void (^success)(NSDictionary* callback);

@interface FinancialProfileModel : BaseModel

+(void)createFinancialProfile:(NSString *)username password:(NSString *)password type:(NSString *)type block:(success)result;

+(void)handleMFA:(NSString *)response withData:(NSDictionary *)dictionary block:(success)result;

@end
