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

- (id)initWithCoder:(NSCoder *)coder {
  if ([super init]) {
    self.itemName = [coder decodeObjectForKey:@"itemName"];
    self.imageUrlArray = [coder decodeObjectForKey:@"imageUrlArray"];
    self.answerUrlString = [coder decodeObjectForKey:@"answerUrlString"];
  }

  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.itemName forKey:@"itemName"];
  [coder encodeObject:self.imageUrlArray forKey:@"imageUrlArray"];
  [coder encodeObject:self.answerUrlString forKey:@"answerUrlString"];
}


@end
