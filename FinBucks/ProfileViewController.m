//
//  ProfileViewController.m
//  FinBucks
//
//  Created by Sudeep Agarwal on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "ProfileViewController.h"
#import "LDProgressView.h"
#import "SwipeView.h"
#import "SharedGoalView.h"

@interface ProfileViewController () <SwipeViewDataSource, SwipeViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSDictionary *resultJSON;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.socialChallanges = [NSMutableArray new];
    LDProgressView *ldView = [[LDProgressView alloc] initWithFrame:CGRectMake(0, 0, self.progressView.frame.size.width, self.progressView.frame.size.height)];
    ldView.progress = 0.4;
    ldView.showText = @NO;
    [self.progressView addSubview:ldView];
    
    self.swipeView.pagingEnabled = YES;
    self.swipeView.delegate = self;
    self.swipeView.dataSource = self;
    
    self.userName.text = [NSString stringWithFormat:@"%@ %@", [[UserModel currentUser]firstname],[[UserModel currentUser]lastname]];
    
    [[UserModel currentUser]getProfilePhoto:^(UIImage *image, NSError *error) {
        self.profileImageView.image = image;
    }];
    
    [[UserModel currentUser]getAllSocialChallanges:^(NSArray *array, NSError *error) {
        for (SocialChallangeModel *challange in array) {
            PFObject *object = challange.parseObject;
            PFQuery *query = [PFQuery queryWithClassName:@"Investment"];
            [query whereKey:@"challange" equalTo:object];
            [query includeKey:@"owner"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
                [self.socialChallanges addObject:objects];
                [self.swipeView reloadData];
            }];
        }
    }];
    
}

- (void)setResultJSON:(NSDictionary *)resultJSON {
    
    resultJSON = @{@"Food and Drink": @"0.000000",
                   @"Recreation": @"0.999908",
                   @"Travel": @"0.000009",
                   @"Rent": @"0.000084"};
}

- (NSString *) selectedChallenge {
    NSString *lowestKey = nil;
    int lowestValue = 0;
    for (NSString *key in self.resultJSON)
    {
        int value = [self.resultJSON[key] intValue];
        if (!lowestKey || value < lowestValue)
        {
            lowestKey = key;
            lowestValue = value;
        }
    }
    return lowestKey;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0;
    self.profileImageView.layer.masksToBounds = YES;
    
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.socialChallanges.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    SharedGoalView *sharedGoalView = [[[NSBundle mainBundle] loadNibNamed:@"SharedGoalView" owner:self options:nil] firstObject];
    
    NSArray *investments = self.socialChallanges[index];
    sharedGoalView.title.text = investments[0][@"name"];
    NSLog(@"%@",investments);
    PFUser *user1 = investments[0][@"owner"];
    UserModel  *model1 = [[UserModel alloc]initWithPFObject:user1];
    sharedGoalView.t1.text = [model1 firstname];
    [model1 getProfilePhoto:^(UIImage *image, NSError *error) {
        sharedGoalView.img0.image = image;
    }];
    
    PFUser *user2 = investments[1][@"owner"];
    UserModel  *model2 = [[UserModel alloc]initWithPFObject:user2];
    sharedGoalView.t2.text = [model2 firstname];

    [model2 getProfilePhoto:^(UIImage *image, NSError *error) {
        sharedGoalView.img1.image = image;
    }];
    
    PFUser *user3 = investments[2][@"owner"];
    UserModel  *model3 = [[UserModel alloc]initWithPFObject:user3];
    sharedGoalView.t3.text = [model3 firstname];

    [model3 getProfilePhoto:^(UIImage *image, NSError *error) {
        sharedGoalView.img2.image = image;
    }];
    
    //sharedGoalView.title.text = @"Car";
    
    //    //set background color
    //    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    //    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    //    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    //    theView.backgroundColor = [UIColor colorWithRed:red
    //                                           green:green
    //                                            blue:blue
    //                                           alpha:1.0];
    return sharedGoalView;
    
    
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.swipeView.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = self.swipeView.currentPage;
    
    
}

@end
