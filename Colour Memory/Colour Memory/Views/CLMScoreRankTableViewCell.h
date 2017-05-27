//
//  CLMScoreRankTableViewCell.h
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserEntity;

@interface CLMScoreRankTableViewCell : UITableViewCell

- (void)setCellWithUser:(UserEntity *)user;

@end
