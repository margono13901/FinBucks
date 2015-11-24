//
//  UserModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "InvestmentModel.h"
#import "BucketModel.h"
#import "RequestModel.h"

@class InvestmentModel;
typedef void (^success)(BOOL success, NSError* error);
typedef void (^models)(NSArray* array, NSError* error);
typedef void (^profilePhoto)(UIImage* image, NSError* error);
typedef void (^investmentModel)(id investmentModel, NSError* error);

@interface UserModel : BaseModel

//CLASS METHODS
+(void)loginFacebook:(success)result;
+ (UserModel *)currentUser;

//INSTANCE METHODS
-(id)initWithPFObject:(PFObject *)object;

-(void)getAllBuckets:(models)result;

-(void)getAllInvestments:(models)result;

-(void)setSavingsGoal:(int)goal block:(success)result;

-(void)getAllFriends:(models)result;

-(void)getAllPendingChallanges:(models)result;

-(void)getAllSocialChallanges:(models)result;

-(void)createInvestment:(NSString *)name goal:(NSNumber *)amount by:(NSDate *)date withChallange:(BOOL)withChallange block:(investmentModel)result;

-(void)createChallange:(InvestmentModel *)model participants:(NSArray *)friends block:(success)result;

-(void)getAllTransactions:(models)result;


//DATA GETTERS
-(NSString *)firstname;
-(NSString *)lastname;
-(NSString *)birthday;
-(void)getProfilePhoto:(profilePhoto)result;

@end
