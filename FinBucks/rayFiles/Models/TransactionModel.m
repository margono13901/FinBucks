//
//  TransactionModel.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "TransactionModel.h"

@implementation TransactionModel

-(id)initWithPFObject:(PFObject *)object{
    if (self=[super init]) {
        self.parseObject = object;
    }
    return self;
}

-(UserModel *)owner{
    return [[UserModel alloc]initWithPFObject:[self.parseObject[@"owner"]fetch]];
}

-(float)amount{
    return [self.parseObject[@"amount"] floatValue];
}

@end
