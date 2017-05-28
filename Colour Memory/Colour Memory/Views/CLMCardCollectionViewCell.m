//
//  CLMCardCollectionViewCell.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMCardCollectionViewCell.h"

@interface  CLMCardCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (assign, nonatomic, readwrite) NSInteger isRemoved;

@end

@implementation CLMCardCollectionViewCell

- (void)setImageWithName:(NSString *)name
{
    [self.cardImageView setImage:[UIImage imageNamed:name]];
    self.cardImageView.hidden = NO;
    self.isRemoved = NO;
}

- (void)setImageWithName:(NSString *_Nonnull)name animation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion
{
    if (animation == NO) {
        [self setImageWithName:name];
    } else {
        [UIView transitionWithView:self.cardImageView duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self setImageWithName:name];
        } completion:completion];
    }
}

- (void)removeCard
{
    self.cardImageView.hidden = YES;
    self.isRemoved = YES;
}

@end
