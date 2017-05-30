//
//  UserEntity.h
//  Colour Memory
//
//  Created by Michael Zhai on 26/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject

@property (readonly, copy, nonatomic) NSString *userName;
@property (readonly, nonatomic) NSInteger score;
@property (readonly, nonatomic) NSUInteger rank;

- (instancetype)initUserWithName:(NSString *)userName score:(NSInteger)score rank:(NSUInteger)rank;

@end
