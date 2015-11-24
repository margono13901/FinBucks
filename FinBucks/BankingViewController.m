//
//  BankingViewController.m
//  
//
//  Created by Guillermo Lopez on 14/11/15.
//
//

#import "BankingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CRMotionView.h"


@interface BankingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UITextField *passfielf;
@property (weak, nonatomic) IBOutlet UITextField *passwrodrealfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButt;
@property (weak, nonatomic) IBOutlet UIView *blackZone;

@end

@implementation BankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
    [motionView setImage:[UIImage imageNamed:@"memo.png"]];
    
    [self.view addSubview:motionView];
    [self.view bringSubviewToFront:self.blackZone];
    [self.view bringSubviewToFront:self.lab1];
    [self.view bringSubviewToFront:self.lab2];
    [self.view bringSubviewToFront:self.passfielf];
    [self.view bringSubviewToFront:self.passwrodrealfield];
    [self.view bringSubviewToFront:self.loginButt];
    
    self.passwrodrealfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passfielf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    self.passwrodrealfield.layer.borderWidth = 0.7f;
    self.passwrodrealfield.layer.borderColor = [[UIColor whiteColor] CGColor];
  self.passwrodrealfield.layer.cornerRadius = 5;
   self.passwrodrealfield.clipsToBounds      = YES;
    
    
    self.passfielf.layer.borderWidth = 1.0f;
    self.passfielf.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.passfielf.layer.cornerRadius = 5;
    self.passfielf.clipsToBounds      = YES;




    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
