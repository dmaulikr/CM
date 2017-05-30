//
//  CLMUserManager.h
//  Colour Memory
//
//  Created by Michael Zhai on 30/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSFetchedResultsController;

@interface CLMUserManager : NSObject

+ (void)saveUserName:(NSString *)userName score:(NSInteger)score completion:(void(^)(NSInteger rank))completion;

+ (NSFetchedResultsController *)fetchHighScoreResults;

@end
