//
//  InvestmentModel.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "InvestmentModel.h"

@implementation InvestmentModel


//INSTANCE METHODS
-(void)deleteInvestment:(success)result{
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"investments"];
    [relation delete:self.parseObject];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        result(succeeded, error);
    }];
}

-(void)addChallange:(PFObject *)challange block:(success)result{
    self.parseObject[@"challange"] = challange;
    [self.parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        result(succeeded,error);
    }];
}


-(id)initWithPFObject:(PFObject *)object{
    if (self=[super init]) {
        self.parseObject = object;
    }
    return self;
}

//DATA GETTERS
-(NSString *)name{
    return self.parseObject[@"name"];
}

-(NSNumber *)goal{
    return  self.parseObject[@"goal"];
}

-(NSNumber *)currentValue{
    return  self.parseObject[@"currentValue"];
}

-(NSDate *)completeDate{
    return self.parseObject[@"completeDate"];
}

-(UserModel *)owner{
    return [[UserModel alloc]initWithPFObject:[self.parseObject[@"owner"]fetch]];
}

-(SocialChallangeModel *)challange{
    return [self.parseObject[@"challange"] fetch];
}

@end
