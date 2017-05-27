//
//  CardItem.m
//  Colour Memory
//
//  Created by Michael Zhai on 26/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CardItem.h"

@interface CardItem ()

@property (strong, nonatomic, readwrite) NSString *backgroundImageName;
@property (strong, nonatomic, readwrite) NSString *cardImageName;
@property (strong, nonatomic, readwrite) NSString *type;

@end

@implementation CardItem
@end


@implementation CardListItem

static NSString * const BACKGROUND_IMAGE_NAME = @"card_bg.png";
static NSInteger const MAX_NUM = 9;

+ (NSArray<CardItem *> *)cardItemList
{
    NSMutableArray *numberListM = [NSMutableArray array];
    for (NSInteger i=1; i<MAX_NUM; i++) {
        [numberListM addObject:@(i)];
        [numberListM addObject:@(i)];
    }
    
    NSArray *disorderNumberList = [[numberListM sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        NSInteger seed = arc4random_uniform(3);
        if (seed > 0) {
            return [obj1 compare:obj2];
        } else {
            return [obj2 compare:obj1];
        }
        
    }] copy];
    
    NSMutableArray *nameListM = [NSMutableArray array];
    for (NSInteger i=0; i<disorderNumberList.count; i++) {
        CardItem *item = [[CardItem alloc] init];
        NSNumber *number = disorderNumberList[i];
        item.cardImageName = [NSString stringWithFormat:@"colour%@.png",number];
        item.backgroundImageName = BACKGROUND_IMAGE_NAME;
        item.type = [NSString stringWithFormat:@"type_%@", number];
        
        [nameListM addObject:item];
    }
    
    return [nameListM copy];
}

@end
