//
//  RequestModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "BaseModel.h"
#import "InvestmentModel.h"
#import "UserModel.h"
#import "SocialChallangeModel.h"

@class SocialChallangeModel;
@class UserModel;
typedef void (^success)(BOOL success, NSError* error);

@interface RequestModel : BaseModel

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object;
-(void)decline:(success)result;
-(void)accept:(success)result;
-(void)acceptPendingRequest:(BOOL)accept block:(success)result;


//DATA GETTERS
-(UserModel *)sender;
-(UserModel *)reciever;
-(BOOL)isAccepted;
-(BOOL)isDeclined;
-(SocialChallangeModel *)challange;


@end
