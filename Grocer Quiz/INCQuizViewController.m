//
//  INCQuizViewController.m
//  Grocer Quiz
//
//  Created by Richard Yeh on 3/7/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import "INCQuizViewController.h"

@interface INCQuizViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *answerView1;
@property (weak, nonatomic) IBOutlet UIImageView *answerView2;
@property (weak, nonatomic) IBOutlet UIImageView *answerView3;
@property (weak, nonatomic) IBOutlet UIImageView *answerView4;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation INCQuizViewController

//TODO: Stat Quiz button
//TODO: two minute timer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
