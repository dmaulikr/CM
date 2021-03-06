//
//  CardEntity.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CardEntity.h"

@interface CardEntity ()

@property (copy, nonatomic, readwrite) NSString *backgroundImageName;
@property (copy, nonatomic, readwrite) NSString *cardImageName;
@property (copy, nonatomic, readwrite) NSString *type;

@end

@implementation CardEntity
@end


@implementation CardListItem

static NSString * const BACKGROUND_IMAGE_NAME = @"card_bg.png";
static NSInteger const MAX_NUM = 9;

+ (NSArray<CardEntity *> *)cardItemList
{
    NSMutableArray *numberListM = [NSMutableArray array];
    for (NSInteger i=1; i<MAX_NUM; i++) {
        [numberListM addObject:@(i)];
        [numberListM addObject:@(i)];
    }
    
    NSArray *disorderNumberList = [[numberListM sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        NSInteger seed = arc4random_uniform(2);
        //NSLog(@"obj1: %@,obje2: %@, random: %@", obj1, obj2, @(seed));
        
        if (seed > 0) {
            return [obj1 compare:obj2];
        } else {
            return [obj2 compare:obj1];
        }
        
    }] copy];
    
    NSMutableArray *nameListM = [NSMutableArray array];
    for (NSInteger i=0; i<disorderNumberList.count; i++) {
        CardEntity *item = [[CardEntity alloc] init];
        NSNumber *number = disorderNumberList[i];
        
        item.cardImageName = [NSString stringWithFormat:@"colour%@.png",number];
        item.backgroundImageName = BACKGROUND_IMAGE_NAME;
        item.type = [NSString stringWithFormat:@"type_%@", number];
        
        [nameListM addObject:item];
    }
    
    return [nameListM copy];
}

@end
