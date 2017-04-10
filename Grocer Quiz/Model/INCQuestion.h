//
//  INCQuestion.h
//  Grocer Quiz
//
//  Created by Richard Yeh on 3/12/17.
//  Copyright © 2017 Richard Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INCQuestion : NSObject <NSCoding>
@property (copy, nonatomic) NSString *itemName;
@property (copy, nonatomic) NSArray *imageUrlArray;
@property (copy, nonatomic) NSString *answerUrlString;

- (id)initWithName:(NSString *)name urlArray:(NSArray *)urls;
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;
@end
