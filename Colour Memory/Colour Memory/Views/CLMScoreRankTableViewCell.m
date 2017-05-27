//
//  CLMScoreRankTableViewCell.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMScoreRankTableViewCell.h"
#import "UserEntity.h"

@interface CLMScoreRankTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CLMScoreRankTableViewCell

- (void)setCellWithUser:(UserEntity *)user
{
    self.rankLabel.text = [@(user.rank) stringValue];
    self.scoreLabel.text = [@(user.score) stringValue];
    self.nameLabel.text = user.userName;
}

@end
