//
//  CLMCardCollectionViewCell.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMCardCollectionViewCell.h"

@interface CLMCardCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (assign, nonatomic, readwrite) NSInteger isRemoved;

@end

@implementation CLMCardCollectionViewCell

- (void)setImageWithName:(NSString *)name
{
    [self.cardImageView setImage:[UIImage imageNamed:name]];
    self.cardImageView.hidden = false;
    self.isRemoved = false;
}

- (void)removeCard
{
    self.cardImageView.hidden = true;
    self.isRemoved = true;
}

@end
