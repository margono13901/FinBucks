//
//  SharedGoalView.m
//  FinBucksProfile
//
//  Created by Sudeep Agarwal on 11/14/15.
//  Copyright © 2015 Sudeep Agarwal. All rights reserved.
//

#import "SharedGoalView.h"
#import "LDProgressView.h"

@implementation SharedGoalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    NSLog(@"awaking from nib");
    LDProgressView *ld0 = [[LDProgressView alloc] initWithFrame:self.bar0.bounds];
    ld0.progress = 0.4;
    ld0.showText = @NO;
    ld0.type = LDProgressSolid;
    ld0.background = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self.bar0 addSubview:ld0];
    LDProgressView *ld1 = [[LDProgressView alloc] initWithFrame:self.bar1.bounds];
    ld1.progress = 0.3;
    ld1.showText = @NO;
    ld1.type = LDProgressSolid;
    ld1.background = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self.bar1 addSubview:ld1];
    LDProgressView *ld2 = [[LDProgressView alloc] initWithFrame:self.bar2.bounds];
    ld2.progress = 0.1;
    ld2.showText = @NO;
    ld2.type = LDProgressSolid;
    ld2.background = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self.bar2 addSubview:ld2];

}

- (void)layoutSubviews {
    
    NSLog(@"laying out subviews");
    self.img0.layer.cornerRadius = self.img0.frame.size.height / 2.0;
    self.img0.layer.masksToBounds = YES;
    self.img1.layer.cornerRadius = self.img0.frame.size.height / 2.0;
    self.img1.layer.masksToBounds = YES;
    self.img2.layer.cornerRadius = self.img0.frame.size.height / 2.0;
    self.img2.layer.masksToBounds = YES;
    
}

@end
