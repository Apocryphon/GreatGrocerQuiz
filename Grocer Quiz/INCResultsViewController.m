//
//  INCResultsViewController.m
//  Grocer Quiz
//
//  Created by Richard Yeh on 4/27/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import "INCResultsViewController.h"
#import "INCQuizViewController.h"

@interface INCResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation INCResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.scoreLabel.text = [NSString stringWithFormat:@"%ld/21", self.finalScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retakeTest:(id)sender {
  
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
