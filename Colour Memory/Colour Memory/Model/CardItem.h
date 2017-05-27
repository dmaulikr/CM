//
//  CardItem.h
//  Colour Memory
//
//  Created by Michael Zhai on 26/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardItem : NSObject

@property (readonly, nonatomic) NSString *backgroundImageName;
@property (readonly, nonatomic) NSString *cardImageName;
@property (readonly, nonatomic) NSString *type;

@end

@interface CardListItem : NSObject

+ (NSArray<CardItem *> *)cardItemList;

@end
