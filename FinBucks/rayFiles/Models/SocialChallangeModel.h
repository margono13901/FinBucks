//
//  SocialChallangeModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "BaseModel.h"
#import "InvestmentModel.h"

@class UserModel;

typedef void (^success)(BOOL success, NSError* error);
typedef void (^allInvestments)(NSArray* array, NSError* error);

@interface SocialChallangeModel : BaseModel

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object;

//DATA GETTERS
-(NSString *)name;
-(NSNumber *)goal;
-(NSDate *)completeDate;
-(UserModel *)owner;
-(void)getAllInvestments:(allInvestments)result;

@end
