//
//  CLMCardCollectionViewCell.h
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLMCardCollectionViewCell : UICollectionViewCell

@property (readonly, nonatomic) NSInteger isRemoved;

- (void)setImageWithName:(NSString *_Nonnull)name animation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion;
- (void)removeCard;

@end
