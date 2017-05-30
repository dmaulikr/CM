//
//  CardEntity.h
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardEntity : NSObject

@property (readonly, copy, nonatomic) NSString *backgroundImageName;
@property (readonly, copy, nonatomic) NSString *cardImageName;
@property (readonly, copy, nonatomic) NSString *type;

@end

@interface CardListItem : NSObject

+ (NSArray<CardEntity *> *)cardItemList;

@end
