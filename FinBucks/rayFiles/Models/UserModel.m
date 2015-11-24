//
//  UserModel.m
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

//CLASS METHODS
+ (UserModel *)currentUser {
    static UserModel *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[self alloc] initWithPFObject:[PFUser currentUser]];
    });
    return currentUser;
}


+(void)loginFacebook:(success)callback{
    
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            callback(false,error);
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            if ([FBSDKAccessToken currentAccessToken]) {
                
                NSDictionary *params = @{@"fields": @"email, birthday, first_name, last_name, id, picture"};
                
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     if (!error) {
                         NSLog(@"%@",result);
                         [UserModel createUserProfile:result block:^(BOOL success, NSError *error) {
                             [BucketModel createAllBuckets:^(BOOL success, NSError *error) {
                                 callback(success,error);
                             }];
                         }];
                     }else{
                         callback(false,error);
                     }
                 }];
            }else{
                callback(false,error);
            }
        } else {
            NSLog(@"User logged in through Facebook!");
            callback(true,error);
        }
    }];
}

+(void)createUserProfile:(NSDictionary *)data block:(success)callback{
    NSString *firstName = data[@"first_name"];
    NSString *lastName = data[@"last_name"];
    NSString *email = data[@"email"];
    NSString *birthday = data[@"birthday"];
    NSString *pictureUrl = [[[data objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:pictureUrl];
    NSData *pictureData = [NSData dataWithContentsOfURL:url];
    
    PFFile *file = [PFFile fileWithData:pictureData];
    
    PFUser *user = [PFUser currentUser];
    user[@"firstName"] = firstName ? firstName : [NSNull null];
    user[@"lastName"] = lastName? lastName : [NSNull null];
    user[@"email"] = email? email : [NSNull null];
    user[@"birthday"] = birthday? birthday : [NSNull null];
    user[@"profilePhoto"] = file;
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"owner"] = user;
    [currentInstallation saveInBackground];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        NSLog(@"%@",[PFUser currentUser]);
        callback(succeeded, error);
    }];
}

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object{
    if (self=[super init]) {
        self.parseObject = object;
    }
    return self;
}

-(void)getAllBuckets:(models)result{
    NSString *type = @"buckets";
    [self getAll:type block:^(NSArray *array, NSError *error) {
        result(array,error);
    }];
}

-(void)getAllInvestments:(models)result{
    NSString *type = @"investments";
    [self getAll:type block:^(NSArray *array, NSError *error) {
        NSLog(@"this is an error %@",error);
        result(array,error);
    }];
}

-(void)getProfilePhoto:(profilePhoto)result{
    PFUser *user = (PFUser *)self.parseObject;
    PFFile *file = user[@"profilePhoto"];
    [file getDataInBackgroundWithBlock:^(NSData* data, NSError* error) {
        UIImage *image = nil;
        if (!error) {
            image = [UIImage imageWithData:data];
        }
        result(image,error);
    }];
}


-(void)setSavingsGoal:(int)goal block :(success)result{
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        currentUser[@"savingsGoal"] = [NSNumber numberWithInteger:goal];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            result(succeeded, error);
        }];
    }else{
        result(false, nil);
    }
}

-(void)getAllFriends:(models)result{
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"friends"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * error) {
        NSMutableArray *temp = [NSMutableArray new];
        for (PFUser *user in objects) {
            UserModel *model = [[UserModel alloc]initWithPFObject:user];
            [temp addObject:model];
        }
        result(temp, error);
    }];
}

-(void)getAllPendingChallanges:(models)result{
    PFQuery *query = [PFQuery queryWithClassName:@"ChallangeRequest"];
    [query whereKey:@"accepted" equalTo:@NO];
    [query whereKey:@"declined" equalTo:@NO];
    [query includeKey:@"challange"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        NSMutableArray *temp = [NSMutableArray new];
        for (PFObject *request in objects) {
            RequestModel *model = [[RequestModel alloc]initWithPFObject:request];
            [temp addObject:model];
        }
        result(temp,error);
    }];
}

-(void)sendUsers:(NSArray *)users request:(SocialChallangeModel *)challange  block:(success)result{
    NSMutableArray *requests = [NSMutableArray new];
    for (UserModel *user in users) {
        PFObject *request = [PFObject objectWithClassName:@"ChallangeRequest"];
        request[@"sender"] = (PFUser *)self.parseObject;
        request[@"reciever"] = (PFUser *)[user parseObject];
        request[@"accepted"] = @NO;
        request[@"declined"] = @NO;
        request[@"challange"] = challange.parseObject;
        [requests addObject:request];
    }
    [PFObject saveAllInBackground:requests block:^(BOOL succeeded, NSError * error) {
        result(succeeded, error);
    }];
}

-(void)createInvestment:(NSString *)name goal:(NSNumber *)amount by:(NSDate *)date withChallange:(BOOL)withChallange block:(investmentModel)result{
    PFObject *investment = [PFObject objectWithClassName:@"Investment"];
    investment[@"name"] = name;
    investment[@"completeDate"] = date;
    investment[@"owner"] = [PFUser currentUser];
    investment[@"goal"] = amount;
    investment[@"amount"] = @0;
    [investment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        PFUser *user = [PFUser currentUser];
        if (user) {
            PFRelation *relation = [user relationForKey:@"investments"];
            [relation addObject:investment];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
                InvestmentModel *model = [[InvestmentModel alloc]initWithPFObject:investment];
                result(model, error);
            }];
        }
    }];
}

-(void)createChallange:(InvestmentModel *)model participants:(NSArray *)friends block:(success)result{
    
    PFObject *challange = [PFObject objectWithClassName:@"SocialChallange"];
    challange[@"name"] = [model name];
    challange[@"goal"] = [model goal];
    challange[@"completeDate"] = [model completeDate];
    challange[@"owner"] = [PFUser currentUser];
    PFRelation *relation = [challange relationForKey:@"investments"];
    [relation addObject:model.parseObject];
    [challange saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [model addChallange:challange block:^(BOOL success, NSError *error) {
                result(success,error);
            }];
        }else{
            result(succeeded,error);
        }
    }];
}

-(void)getAllTransactions:(models)result{
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *temp = [NSMutableArray new];
        for (PFObject *investment in objects) {
            TransactionModel *model = [[TransactionModel alloc]initWithPFObject:investment];
            [temp addObject:model];
        }
        result(temp,error);
        
    }];
}

-(void)getAllSocialChallanges:(models)result{
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"investments"];
    PFQuery *query = [relation query];
    [query includeKey:@"challange"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        NSMutableArray *temp = [NSMutableArray new];
        for (PFObject *investment in objects) {
            SocialChallangeModel *model = [[SocialChallangeModel alloc]initWithPFObject:investment[@"challange"]];
            [temp addObject:model];
        }
        result(temp,error);
    }];
}


//DATA GETTERS
-(NSString *)firstname{
    return [self getParam:@"firstName"];
}

-(NSString *)lastname{
    return [self getParam:@"lastName"];
}

-(NSString *)birthday{
    return [self getParam:@"birthday"];
}

-(NSString *)getParam:(NSString *)param{
    NSString *result;
    if ([self parseObject]) {
        result = ((PFUser *)self.parseObject)[param];
    }
    return result;
}


//PRIVATE METHODS
-(void)getAll:(NSString *)type block:(models)result{
    PFRelation *relation = [self.parseObject relationForKey:type];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        NSMutableArray *array = [NSMutableArray new];
        for (PFObject *object in objects) {
            
            if ([type isEqualToString:@"investments"]) {
                InvestmentModel *model = [[InvestmentModel alloc]initWithPFObject:object];
                [array addObject:model];
            }else{
                BucketModel *model = [[BucketModel alloc]initWithPFObject:object];
                [array addObject:model];
            }
        }
        result(array, error);
    }];
}




@end
