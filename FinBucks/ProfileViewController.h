//
//  ProfileViewController.h
//  FinBucks
//
//  Created by Sudeep Agarwal on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *levelName;
@property (strong, nonatomic) NSMutableArray *socialChallanges;
@end
