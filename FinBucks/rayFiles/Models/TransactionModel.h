//
//  TransactionModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@class UserModel;

@interface TransactionModel : BaseModel

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object;

//DATA METHODS
-(UserModel *)owner;
-(float)amount;

@end
