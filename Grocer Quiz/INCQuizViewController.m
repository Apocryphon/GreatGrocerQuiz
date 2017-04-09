//
//  INCQuizViewController.m
//  Grocer Quiz
//
//  Created by Richard Yeh on 3/7/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import "INCQuizViewController.h"
#import "INCQuestion.h"

#import <SDWebImage/UIButton+WebCache.h>

@interface INCQuizViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *answerButton1;
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign, nonatomic) BOOL isQuizInProgress;
@property (assign, nonatomic) int currentQuestionNumber;
@property (assign, nonatomic) NSInteger selectedAnswerNumber;

@property (copy, nonatomic) NSArray *questionsArray;

@end

@implementation INCQuizViewController

//TODO: two minute timer + countdown clock

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  self.selectedAnswerNumber = 0;
  
  [self retrieveQuestions];
}

- (void)retrieveQuestions {
  NSString *questionsFilePath = [[NSBundle mainBundle] pathForResource:@"zquestions"
                                                                ofType:@"json"];
  NSData *jsonData = [NSData dataWithContentsOfFile:questionsFilePath];
  NSDictionary *jsonQuestionsDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                          options:0
                                                                            error:nil];
  NSMutableArray *tempQuestionsArray = [NSMutableArray arrayWithCapacity:[jsonQuestionsDictionary count]];
  
  for (NSString *itemName in jsonQuestionsDictionary) {
    INCQuestion *newQuestion = [[INCQuestion alloc] initWithName:itemName
                                                        urlArray:jsonQuestionsDictionary[itemName]];
    NSMutableArray *copyOfImageUrlArray = [newQuestion.imageUrlArray mutableCopy];
    newQuestion.imageUrlArray = [[self shuffleArray:copyOfImageUrlArray] copy];
    [tempQuestionsArray addObject:newQuestion];
  }
  
  self.questionsArray = [[self shuffleArray:tempQuestionsArray] copy];

}

// Fisher-Yates implementation
- (NSMutableArray *)shuffleArray:(NSMutableArray *)array {
  for (NSUInteger i = [array count] - 1; i > 0 ; i--) {
    NSUInteger firstIndex = i;
    NSUInteger secondIndex = arc4random() % (i+1);
    [array exchangeObjectAtIndex:firstIndex withObjectAtIndex:secondIndex];
  }
  return array;
}


- (IBAction)selectedAnswer:(id)sender {
  UIButton *nowSelectedButton = (UIButton *)sender;

  // do nothing if same as currently selected answer
  if (self.selectedAnswerNumber == nowSelectedButton.tag) {
    return;
  }

  if (self.selectedAnswerNumber > 0) {
    UIButton *previouslySelectedButton = (UIButton *)[self.view viewWithTag:self.selectedAnswerNumber];
    previouslySelectedButton.selected = NO;
    // TODO: change appearance of deselected former answer
  }
  
  self.selectedAnswerNumber = nowSelectedButton.tag;
  nowSelectedButton.selected = YES;
  
  // TODO: change appearance of selected answer
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
  
  NSArray *answerButtonsArray = @[self.answerButton1, self.answerButton2, self.answerButton3, self.answerButton4];

  int answerCounter = 0;
  for (UIButton *button in answerButtonsArray) {
    [button sd_setImageWithURL:[NSURL URLWithString:currentQuestion.imageUrlArray[answerCounter]]
                      forState:UIControlStateNormal
              placeholderImage:[UIImage imageNamed:@"groceries-placeholder.png"]];
    answerCounter++;
  }
  
}

- (IBAction)startQuiz:(id)sender {
  self.isQuizInProgress = YES;
  self.startButton.hidden = YES;
  self.answerButton1.hidden = NO;
  self.answerButton2.hidden = NO;
  self.answerButton3.hidden = NO;
  self.answerButton4.hidden = NO;
  self.promptLabel.hidden = NO;
  self.submitButton.hidden = NO;
  self.currentQuestionNumber = 1;
  
  [self updateForQuestion];
}

- (IBAction)submitAnswer:(id)sender {
  UIAlertController *confirmAnswerAlert = [UIAlertController alertControllerWithTitle:@"Submit Answer" message:@"Are you sure of your answer?" preferredStyle:UIAlertControllerStyleAlert];
  [confirmAnswerAlert addAction:[UIAlertAction actionWithTitle:@"No"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil]];
  __weak typeof (self) weakSelf = self;
  [confirmAnswerAlert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                         [weakSelf saveAnswer];
                                                       }]
   ];

  [self presentViewController:confirmAnswerAlert animated:YES completion:nil];
}

- (void)saveAnswer {
  
}



@end
