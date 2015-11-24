//
//  SocialChallangeModel.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "SocialChallangeModel.h"

@implementation SocialChallangeModel

//INSTANCE METHODS
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

-(NSDate *)completeDate{
    return self.parseObject[@"completeDate"];
}

-(UserModel *)owner{
    return [[UserModel alloc]initWithPFObject:[self.parseObject[@"owner"]fetch]];
}

-(void)getAllInvestments:(allInvestments)result{
    PFRelation *relation = [self.parseObject relationForKey:@"investments"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"amount"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        NSMutableArray *temp = [NSMutableArray new];
        for (PFObject *object in objects) {
            InvestmentModel *model = [[InvestmentModel alloc]initWithPFObject:object];
            [temp addObject:model];
        }
        result(temp,error);
    }];
}


@end
