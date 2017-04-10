//
//  INCGrocerRecord.m
//  Grocer Quiz
//
//  Created by Richard Yeh on 4/9/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import "INCGrocerRecord.h"

@implementation INCGrocerRecord

- (id)initWithName:(NSString *)name questionsArray:(NSArray<INCQuestion *> *) questionsArray {
  if ([super init]) {
    self.grocerName = name;
    self.questionsArray = questionsArray;
    self.scoresArray = @[];
    self.attemptsCount = 0;
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  if ([super init]) {
    self.grocerName = [coder decodeObjectForKey:@"grocerName"];
    self.questionsArray = [coder decodeObjectForKey:@"questionsArray"];
    self.scoresArray = [coder decodeObjectForKey:@"scoresArray"];
    self.attemptsCount = [coder decodeIntegerForKey:@"attemptsCount"];
  }
  
  return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.grocerName forKey:@"grocerName"];
  [coder encodeObject:self.questionsArray forKey:@"questionsArray"];
  [coder encodeObject:self.scoresArray forKey:@"scoresArray"];
  [coder encodeInteger:self.attemptsCount forKey:@"attemptsCount"];
}

@end
