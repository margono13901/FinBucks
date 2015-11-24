//
//  InvestmentModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SocialChallangeModel.h"
#import "UserModel.h"

typedef void (^success)(BOOL success, NSError* error);
typedef void (^investmentModel)(id investmentModel, NSError* error);
typedef void (^challangeModel)(id challangeModel, NSError* error);

@interface InvestmentModel : BaseModel

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object;

-(void)deleteInvestment:(success)result;

-(void)addChallange:(PFObject *)challange block:(success)result;

//DATA GETTERS
-(NSString *)name;
-(NSNumber *)goal;
-(NSDate *)completeDate;
-(UserModel *)owner;
-(SocialChallangeModel *)challange;
-(NSNumber *)currentValue;

@end

