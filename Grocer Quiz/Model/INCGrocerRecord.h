//
//  INCGrocerRecord.h
//  Grocer Quiz
//
//  Created by Richard Yeh on 4/9/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INCQuestion.h"

@interface INCGrocerRecord : NSObject <NSCoding>
@property (copy, nonatomic)   NSString *grocerName;
@property (copy, nonatomic)   NSArray<INCQuestion *> *questionsArray;
@property (copy, nonatomic)   NSArray *scoresArray;
@property (assign, nonatomic) NSInteger attemptsCount;

- (id)initWithName:(NSString *)name questionsArray:(NSArray<INCQuestion *> *) questionsArray;
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;
@end
