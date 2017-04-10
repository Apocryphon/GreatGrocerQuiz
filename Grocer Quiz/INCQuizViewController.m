//
//  INCQuizViewController.m
//  Grocer Quiz
//
//  Created by Richard Yeh on 3/7/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import "INCQuizViewController.h"
#import "INCQuestion.h"
#import "INCGrocerRecord.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface INCQuizViewController ()

@property (weak, nonatomic) IBOutlet UILabel *namePromptLabel;
@property (weak, nonatomic) IBOutlet UITextField *grocerNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *answerButton1;
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (copy, nonatomic) NSArray *questionsArray;

@property (assign, nonatomic) BOOL isQuizInProgress;
@property (strong, nonatomic) INCGrocerRecord *currentGrocer;
@property (assign, nonatomic) NSInteger currentScore;

@property (assign, nonatomic) NSInteger currentQuestionNumber;
@property (strong, nonatomic) INCQuestion *currentQuestion;
@property (assign, nonatomic) NSInteger currentSelectedAnswerNumber;

@end

@implementation INCQuizViewController

//TODO: two minute timer + countdown clock

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  self.grocerNameTextField.delegate = self;
  self.currentSelectedAnswerNumber = 0;
  
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
  if (self.currentSelectedAnswerNumber == nowSelectedButton.tag) {
    return;
  }

  if (self.currentSelectedAnswerNumber > 0) {
    UIButton *previouslySelectedButton = (UIButton *)[self.view viewWithTag:self.currentSelectedAnswerNumber];
    previouslySelectedButton.selected = NO;
    // TODO: change appearance of deselected former answer
  }
  
  self.currentSelectedAnswerNumber = nowSelectedButton.tag;
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

- (void)startQuiz {
  self.isQuizInProgress = YES;

  self.namePromptLabel.hidden = YES;
  self.grocerNameTextField.hidden = YES;

  self.answerButton1.hidden = NO;
  self.answerButton2.hidden = NO;
  self.answerButton3.hidden = NO;
  self.answerButton4.hidden = NO;
  self.promptLabel.hidden = NO;
  self.submitButton.hidden = NO;

  self.currentQuestionNumber = 1;
  self.currentScore = 0;
  [self updateQuestion];
}


- (void)updateQuestion {
  self.currentQuestion = self.questionsArray[self.currentQuestionNumber-1];
  self.promptLabel.text = [NSString stringWithFormat:@"Select the %@", self.currentQuestion.itemName];
  
  self.currentSelectedAnswerNumber = 0;
  
  NSArray *answerButtonsArray = @[self.answerButton1, self.answerButton2, self.answerButton3, self.answerButton4];
  int answerCounter = 0;
  for (UIButton *button in answerButtonsArray) {
    [button sd_setImageWithURL:[NSURL URLWithString:self.currentQuestion.imageUrlArray[answerCounter]]
                      forState:UIControlStateNormal
              placeholderImage:[UIImage imageNamed:@"groceries-placeholder.png"]];
    answerCounter++;
  }
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  [self submitGrocerName];
  return NO;
}

- (void)submitGrocerName {

  [self.grocerNameTextField resignFirstResponder];
  NSString *grocerName = self.grocerNameTextField.text;
  
  if (grocerName) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // load preexisting record to current grocer if name already exists in defaults
    NSData *grocerData = [defaults objectForKey:grocerName];
    if (grocerData) {
      INCGrocerRecord *existingRecordWithGrocerName = [NSKeyedUnarchiver unarchiveObjectWithData:grocerData];
      UIAlertController *retryAlert = [UIAlertController alertControllerWithTitle:@"Retry quiz?"
                                                                          message:[NSString stringWithFormat:@"Your latest score is: %@ out of %ld", [existingRecordWithGrocerName.scoresArray lastObject], [existingRecordWithGrocerName.questionsArray count]]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
      
      [retryAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
      __weak typeof (self) weakSelf = self;
      [retryAlert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                     weakSelf.currentGrocer = existingRecordWithGrocerName;
                                                     weakSelf.questionsArray = weakSelf.currentGrocer.questionsArray;
                                                     [weakSelf startQuiz];
                                                   }]];
      
      [self presentViewController:retryAlert animated:YES completion:nil];
      
    } else {
      // create new grocer record
      self.currentGrocer = [[INCGrocerRecord alloc] initWithName:grocerName questionsArray:self.questionsArray];
      [self startQuiz];
    }
  } else {
    UIAlertController *invalidNameAlert = [UIAlertController alertControllerWithTitle:@"No name entered!"
                                                                              message:@"Please submit a valid grocer name."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [invalidNameAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:invalidNameAlert animated:YES completion:nil];
  }
}


- (IBAction)submitAnswer:(id)sender {

  // submitting grocer record with name
  if (self.isQuizInProgress == NO) {
    [self submitGrocerName];
    return;
  }
  
  if (self.currentSelectedAnswerNumber == 0) {
    return;
  }

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
  // user the image url as the key for identifying which answer the grocer picked
  NSString *selectedAnswerImageUrl = self.currentQuestion.imageUrlArray[self.currentSelectedAnswerNumber-1];

  if ([selectedAnswerImageUrl isEqualToString:self.currentQuestion.answerUrlString]) {
    self.currentScore++;
  }
  
  // check if we're on the final question
  if (self.currentQuestionNumber == [self.questionsArray count]) {
    self.currentGrocer.scoresArray = [self.currentGrocer.scoresArray arrayByAddingObject:@(self.currentScore)];
    self.currentGrocer.attemptsCount++;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.currentGrocer] forKey:self.currentGrocer.grocerName];
    [defaults synchronize];
  } else {
    self.currentQuestionNumber++;
    [self updateQuestion];
  }
}



@end
