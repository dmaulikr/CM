//
//  UserEntity.m
//  Colour Memory
//
//  Created by Michael Zhai on 26/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "UserEntity.h"

@interface UserEntity ()

@property (strong, nonatomic, readwrite) NSString *userName;
@property (assign, nonatomic, readwrite) NSInteger score;
@property (assign, nonatomic, readwrite) NSInteger rank;

@end

@implementation UserEntity

- (instancetype)initUserWithName:(NSString *)userName score:(NSInteger)score rank:(NSInteger)rank;
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
