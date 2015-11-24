//
//  ViewController.m
//  Voyage
//
//  Created by Guillermo Vera on 03/10/15.
//  Copyright (c) 2015 memo. All rights reserved.
//

#import "ViewController.h"
#import "CRMotionView.h"
#import "UserModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *FBView;
@property (weak, nonatomic) IBOutlet UIButton *contBut;
@property (weak, nonatomic) IBOutlet UIView *logozone;

@end

@implementation ViewController
- (IBAction)openfb:(id)sender
{
    [UserModel loginFacebook:^(BOOL success, NSError *error) {
        if (success) {
            [self performSegueWithIdentifier:@"mainSegue" sender:self];
        }else{
            
        }
    }];
}
- (IBAction)continuar:(id)sender
{
    //[self performSegueWithIdentifier:@"conteaza" sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // basic
       CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
    [motionView setImage:[UIImage imageNamed:@"memo.png"]];

    [self.view addSubview:motionView];
    
    [self.view bringSubviewToFront:self.FBView];
    [self.view bringSubviewToFront:self.logozone];

    [self.view bringSubviewToFront:self.logoView];[self.view bringSubviewToFront:self.contBut];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];


    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Welcome to Finbucks";
    page1.desc = @"Your Personal assistant on savings";
    // custom
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"With Finbucks you'll be part of the revolution";
    page2.desc = @"of personal finances";
    page2.titlePositionY = 220;
    page2.descFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    page2.descPositionY = 200;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    page2.titleIconPositionY = 100;
    NSLog(@"memovoy entrando");
    page1.bgImage = [UIImage imageNamed:@"prague_blur"];
    page2.bgImage = [UIImage imageNamed:@"Voyage_Home"];
    
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"With challenges, shared goals, levels and more";

    page3.desc = @"you will become a badass money saver";

    page3.bgImage = [UIImage imageNamed:@"biz.png"];

    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page2,page3]];
    [intro showInView:self.view animateDuration:0.3];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
