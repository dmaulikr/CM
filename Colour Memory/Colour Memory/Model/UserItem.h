//
//  UserItem.h
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject

@property (readonly, nonatomic) NSString *userName;
@property (readonly, nonatomic) NSInteger score;
@property (readonly, nonatomic) NSInteger rank;

- (instancetype)initUserItemName:(NSString *)userName score:(NSInteger)score rank:(NSInteger)rank;

@end
