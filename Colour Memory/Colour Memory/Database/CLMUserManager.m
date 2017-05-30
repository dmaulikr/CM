//
//  CLMUserManager.m
//  Colour Memory
//
//  Created by Michael Zhai on 30/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMUserManager.h"
#import "User+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "UserEntity.h"


@implementation CLMUserManager

+ (void)saveUserName:(NSString *)userName score:(NSInteger)score completion:(void(^)(NSInteger rank))completion
{
    NSArray<User *> *allUserList = [CLMUserManager fetchUserListWithPredicate:nil];
    NSArray<User *> *highScoreUserList = [CLMUserManager fetchHighScoreUserList];
    NSInteger highScoreListCount = highScoreUserList.count;
    BOOL isHighScore = NO;
    NSUInteger rank = 0;
    
    // the table is empty
    if (highScoreListCount == 0) {
        isHighScore = YES;
        rank = 1;
    } else {
        User *hightScoreLastUser = highScoreUserList[highScoreListCount-1];
        
        // user score less than current high score
        if (score < hightScoreLastUser.score) {
            isHighScore = NO;
            
            // all records of user are high score
            if (allUserList.count == highScoreListCount) {
                rank = highScoreListCount+1;
            } else {
                rank = [CLMUserManager calculateRankInUserList:allUserList score:score];
            }
        } else { // user score higher than current high score
            isHighScore = YES;
            rank = [CLMUserManager calculateRankInUserList:highScoreUserList score:score];
        }
    }
    
    
    [CLMUserManager saveUserName:userName score:score isHighScore:isHighScore];
    completion(rank);
}

+ (NSUInteger)calculateRankInUserList:(NSArray<User *> *)userList score:(NSInteger)score
{
    __block NSUInteger rank = 0;
    [userList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(User * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0 || (score >= user.score && score <= [userList objectAtIndex:idx-1].score)) {
            rank = idx+1;
            *stop = YES;
        }
    }];
    
    return rank;
}

/**
- (void)currentRank:(NSInteger)rank
{
    if ([self.delegate respondsToSelector:(@selector(userManager:currentRank:))]) {
        [self.delegate userManager:self currentRank:rank];
    }
}
*/

static NSString * const SORT_KEY = @"score";

+ (NSArray<User *> *)fetchUserListWithPredicate:(NSPredicate *)predicate
{
    NSPersistentContainer *container = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    NSManagedObjectContext *context = [container viewContext];
    
    if (context != nil) {
        NSFetchRequest *request = [User fetchRequest];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SORT_KEY ascending:NO]];
        request.predicate = predicate;
        
        return [context executeFetchRequest:request error:nil];
    }
    
    return nil;
}

+ (void)saveUserName:(NSString *)userName score:(NSInteger)score isHighScore:(BOOL)isHighScore
{
    NSPersistentContainer  *container =  ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    [container performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        User *user = [[User alloc] initWithContext:context];
        user.name = userName;
        user.score = (int32_t)score;
        user.finished_time = [NSDate date];
        user.is_high_score = isHighScore;
        
        [context save:nil];
    }];
}

#pragma mark - fetch high score

+ (NSArray<User *> *)fetchHighScoreUserList
{
    return [CLMUserManager fetchUserListWithPredicate:[NSPredicate predicateWithFormat:@"is_high_score=YES"]];
}

+ (NSFetchedResultsController *)fetchHighScoreResults
{
    NSPersistentContainer *container = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    NSManagedObjectContext *context = [container viewContext];
    
    if (context != nil) {
        NSFetchRequest *request = [User fetchRequest];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SORT_KEY ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"is_high_score=YES"];
        
        NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                                 managedObjectContext:context
                                                                                                   sectionNameKeyPath:nil
                                                                                                            cacheName:nil];
        [fetchResultsController performFetch:nil];
        
        return fetchResultsController;
    }
    
    return nil;
}

@end
