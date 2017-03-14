//
//  INCQuestion.m
//  Grocer Quiz
//
//  Created by Richard Yeh on 3/12/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import "INCQuestion.h"

@implementation INCQuestion

- (id)initWithName:(NSString *)name urlArray:(NSArray *)urls {
  
  if ([super init]) {
    self.itemName = name;
    self.imageUrlArray = urls;
    self.answerUrlString = self.imageUrlArray[0];
  }
  
  return self;
}

@end
