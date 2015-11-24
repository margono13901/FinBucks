//
//  BucketModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "BaseModel.h"
#import "TransactionModel.h"

@class UserModel;
typedef void (^success)(BOOL success, NSError* error);
typedef void (^allTransactions)(NSArray* array, NSError* error);
typedef void (^totalAmount)(float amount, NSError* error);


@interface BucketModel : BaseModel

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object;
-(void)getAllTransactions:(allTransactions)result;
-(void)fraction:(totalAmount)result;

//CLASS METHODS
+(void)createAllBuckets:(success)result;

//DATA METHODS
-(NSString *)name;
-(NSNumber *)amount;
-(NSNumber *)max;
-(UserModel *)owner;

@end
