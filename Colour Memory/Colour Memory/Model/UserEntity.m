//
//  UserEntity.m
//  Colour Memory
//
//  Created by Michael Zhai on 26/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "UserEntity.h"

@interface UserEntity ()

@property (copy, nonatomic, readwrite) NSString *userName;
@property (assign, nonatomic, readwrite) NSInteger score;
@property (assign, nonatomic, readwrite) NSUInteger rank;

@end

@implementation UserEntity

- (instancetype)initUserWithName:(NSString *)userName score:(NSInteger)score rank:(NSUInteger)rank;
{
    self = [super init];
    if (self) {
        _userName = userName;
        _score = score;
        _rank = rank;
    }
    
    return self;
}

@end
