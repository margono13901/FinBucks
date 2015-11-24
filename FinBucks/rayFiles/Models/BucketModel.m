//
//  BucketModel.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "BucketModel.h"

@implementation BucketModel

//CLASS METHODS
+(void)createAllBuckets:(success)result{
    
    NSString *foodDrink = @"Food and Drink";
    NSString *healthcare = @"Healthcare";
    NSString *recreation = @"Recreation";
    NSString *shops = @"Shops";
    NSString *travel = @"Travel";
    
    NSArray *keys = @[foodDrink,healthcare,recreation,shops,travel];
    NSMutableArray *parseObjects = [NSMutableArray new];
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"buckets"];
    for (NSString *key in keys) {
        PFObject *bucket = [PFObject objectWithClassName:@"Bucket"];
        bucket[@"name"] = key;
        bucket[@"amount"] = [NSNumber numberWithFloat:0];
        bucket[@"owner"] = [PFUser currentUser];
        bucket[@"max"] = [BucketModel maxValues:key];
        [parseObjects addObject:bucket];
    }
    [PFObject saveAllInBackground:parseObjects block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            for (PFObject *object in parseObjects) {
                [relation addObject:object];
            }
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                result(succeeded,error);
            }];
        }else{
            result(succeeded,error);
        }
    }];
}

+(NSNumber *)maxValues:(NSString *)category{
    if ([category isEqualToString:@"Food and Drink"]) {
        return [NSNumber numberWithInt:100];
    }
    if ([category isEqualToString:@"Healthcare"]) {
        return [NSNumber numberWithInt:50];
    }
    if ([category isEqualToString:@"Recreation"]) {
        return [NSNumber numberWithInt:150];
    }
    if ([category isEqualToString:@"Shops"]) {
        return [NSNumber numberWithInt:75];
    }else{
        return [NSNumber numberWithInt:25];
    }
}

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object{
    if (self=[super init]) {
        self.parseObject = object;
    }
    return self;
}

-(void)getAllTransactions:(allTransactions)result{
    PFObject *parseObject = self.parseObject;
    PFRelation *relation = [parseObject relationForKey:@"transactions"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * error) {
        if (!error) {
            NSMutableArray *temp = [NSMutableArray new];
            for (PFObject *transaction in objects) {
                TransactionModel *model = [[TransactionModel alloc]initWithPFObject:transaction];
                [temp addObject:model];
            }
            result(temp,error);
        }else{
            result(nil,error);
        }
    }];
}

-(void)fraction:(totalAmount)result{
    [self getAllTransactions:^(NSArray *array, NSError *error) {
        float amount = 0;
        for (TransactionModel *model in array) {
            amount += [model amount];
        }
        result(amount/[[self max] floatValue], error);
    }];
}

//DATA METHODS
-(NSNumber *)amount{
    return self.parseObject[@"amount"];
}

-(NSNumber *)max{
    return self.parseObject[@"max"];
}

-(NSString *)name{
   return self.parseObject[@"name"];
}

-(UserModel *)owner{
    return [[UserModel alloc]initWithPFObject:[self.parseObject[@"owner"]fetch]];
}

@end
