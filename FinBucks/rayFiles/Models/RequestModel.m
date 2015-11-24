//
//  RequestModel.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

-(id)initWithPFObject:(PFObject *)object{
    if (self=[super init]) {
        self.parseObject = object;
    }
    return self;
}

-(void)acceptPendingRequest:(BOOL)accept block:(success)result{
    if (accept) {
        [self accept:^(BOOL success, NSError *error) {
            result(success,error);
        }];
    }else{
        [self decline:^(BOOL success, NSError *error) {
            result(success,error);
        }];
    }
}


-(void)decline:(success)result{
    PFObject *request = self.parseObject;
    request[@"declined"] = @YES;
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        result(succeeded, error);
    }];
}

-(void)accept:(success)result{
    PFObject *request = self.parseObject;
    request[@"accepted"] = @YES;
    
    PFObject *challange = request[@"challange"];
    NSString *name = challange[@"name"];
    NSNumber *goal = challange[@"goal"];
    NSDate *completeDate = challange[@"completeDate"];
    
    [[UserModel currentUser] createInvestment:name goal:goal by:completeDate withChallange:@NO block:^(id investmentModel, NSError *error) {
       
        if (!error) {
            
            InvestmentModel *model = (InvestmentModel *)investmentModel;
            PFRelation *relation = [challange relationForKey:@"investments"];
            [relation addObject:model.parseObject];
            
            [model addChallange:challange block:^(BOOL success, NSError *error){
                NSArray *needSaving = @[request, challange];
                [PFObject saveAllInBackground:needSaving block:^(BOOL succeeded, NSError * error) {
                    result(success,error);
                }];
            }];
        }else{
            result(false, error);
        }
        
    }];
}

-(UserModel *)sender{
    return [self getUser:@"sender"];
}

-(UserModel *)reciever{
    return [self getUser:@"reciever"];
}

-(UserModel *)getUser:(NSString *)user{
    return [[UserModel alloc]initWithPFObject:[self.parseObject[@"sender"]fetch]];
}

-(BOOL)isAccepted{
    return  [self getBool:@"accepted"];
}

-(BOOL)isDeclined{
    return  [self getBool:@"declined"];
}

-(BOOL)getBool:(NSString *)type{
    return self.parseObject[type];
}

-(SocialChallangeModel *)challange{
    return [[SocialChallangeModel alloc]initWithPFObject:[self.parseObject[@"challange"]fetch]];

}

@end
