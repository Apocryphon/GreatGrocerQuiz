//
//  INCQuizViewController.m
//  Grocer Quiz
//
//  Created by Richard Yeh on 3/7/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import "INCQuizViewController.h"
#import "INCQuestion.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface INCQuizViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIImageView *answerView1;
@property (weak, nonatomic) IBOutlet UIImageView *answerView2;
@property (weak, nonatomic) IBOutlet UIImageView *answerView3;
@property (weak, nonatomic) IBOutlet UIImageView *answerView4;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign, nonatomic) BOOL isQuizInProgress;
@property (assign, nonatomic) int currentQuestionNumber;

@property (strong, nonatomic) NSMutableArray *questionsArray;

@end

@implementation INCQuizViewController

//TODO: two minute timer + countdown clock

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  [self retrieveQuestions];
}

- (void)retrieveQuestions {
  NSString *questionsFilePath = [[NSBundle mainBundle] pathForResource:@"zquestions"
                                                                ofType:@"json"];
  NSData *jsonData = [NSData dataWithContentsOfFile:questionsFilePath];
  NSDictionary *jsonQuestionsDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                          options:0
                                                                            error:nil];
  self.questionsArray = [NSMutableArray arrayWithCapacity:[jsonQuestionsDictionary count]];
  
  for (NSString *itemName in jsonQuestionsDictionary) {
    INCQuestion *newQuestion = [[INCQuestion alloc] initWithName:itemName
                                                        urlArray:jsonQuestionsDictionary[itemName]];
    [self.questionsArray addObject:newQuestion];
  }
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

- (void)updateForQuestion {
  INCQuestion *currentQuestion = self.questionsArray[self.currentQuestionNumber-1];
  self.promptLabel.text = [NSString stringWithFormat:@"Select the %@", currentQuestion.itemName];
  [self.answerView1 sd_setImageWithURL:[NSURL URLWithString:currentQuestion.imageUrlArray[0]]
                      placeholderImage:[UIImage imageNamed:@"groceries-placeholder.png"]];
  [self.answerView2 sd_setImageWithURL:[NSURL URLWithString:currentQuestion.imageUrlArray[1]]
                      placeholderImage:[UIImage imageNamed:@"groceries-placeholder.png"]];
  [self.answerView3 sd_setImageWithURL:[NSURL URLWithString:currentQuestion.imageUrlArray[2]]
                      placeholderImage:[UIImage imageNamed:@"groceries-placeholder.png"]];
  [self.answerView4 sd_setImageWithURL:[NSURL URLWithString:currentQuestion.imageUrlArray[3]]
                      placeholderImage:[UIImage imageNamed:@"groceries-placeholder.png"]];


  
}


- (IBAction)startQuiz:(id)sender {
  self.isQuizInProgress = YES;
  self.startButton.hidden = YES;
  self.answerView1.hidden = NO;
  self.answerView2.hidden = NO;
  self.answerView3.hidden = NO;
  self.answerView4.hidden = NO;
  self.promptLabel.hidden = NO;
  self.submitButton.hidden = NO;
  self.currentQuestionNumber = 1;
  
  [self updateForQuestion];
}


@end
