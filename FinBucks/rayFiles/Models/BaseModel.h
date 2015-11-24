//
//  BaseModel.h
//  FinBucks
//
//  Created by Raylen Margono on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BaseModel : NSObject

@property(strong,nonatomic) PFObject *parseObject;

@end
