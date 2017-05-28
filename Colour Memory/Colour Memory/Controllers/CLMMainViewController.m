//
//  CLMMainViewController.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMMainViewController.h"
#import "CLMCardCollectionViewCell.h"
#import <CoreData/CoreData.h>
#import "User+CoreDataClass.h"
#import "AppDelegate.h"
#import "CardEntity.h"

@interface CLMMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cardsCollectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (strong, nonatomic) UIAlertAction *okAction;

@property (strong, nonatomic) NSArray<CardEntity *> *cardItemList;
@property (strong, nonatomic) NSIndexPath *previousIndexPath;
@property (assign, nonatomic) NSInteger cardsCount;
@property (assign, nonatomic) NSInteger scoreCount;
@property (assign, nonatomic) NSInteger clickCount;

@property (assign, nonatomic) CGFloat padding;
@property (copy, nonatomic) NSString *userName;

@end


@implementation CLMMainViewController

static NSString * const CELL_REUSEID = @"CLMCardCollectionViewCell";
static CGFloat const IMAGE_ASPECT_RATIO = 1.25;
static CGFloat const IPHONE_PADDING_GAP = 15;
static NSInteger const HORIZON_NUMBER = 4;
static NSInteger const SCORE_STEP = 4;

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    
    [self initDataSource];
    [self initCollectionView];
}

- (void)initCollectionView
{
    self.cardsCollectionView.dataSource = self;
    self.cardsCollectionView.delegate = self;
}

- (void)initDataSource
{
    self.cardItemList = [CardListItem cardItemList];
    self.cardsCount = self.cardItemList.count;
    self.previousIndexPath = nil;
    self.padding = IPHONE_PADDING_GAP;
    self.scoreCount = 0;
    self.clickCount = 0;
    self.userName = @"";
}

#pragma mark - Control screen rotation
-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cardsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLMCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSEID forIndexPath:indexPath];
    CardEntity *cardItem = [self.cardItemList objectAtIndex:indexPath.row];
    [cell setImageWithName:cardItem.backgroundImageName animation:NO completion:nil];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if ([device userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.padding = IPHONE_PADDING_GAP*2;
    } else {
        self.padding = IPHONE_PADDING_GAP;
    }
    
    CGFloat itemWidth = (screenWidth - (HORIZON_NUMBER + 1) * self.padding) / HORIZON_NUMBER;
    CGFloat itemHeight = itemWidth*IMAGE_ASPECT_RATIO;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return IPHONE_PADDING_GAP;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.padding;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(IPHONE_PADDING_GAP*2, self.padding, IPHONE_PADDING_GAP, self.padding);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.previousIndexPath) {
        return;
    }
    
    CLMCardCollectionViewCell *cell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:indexPath];
    if (cell.isRemoved == YES) {
        return;
    }

    [self overturnCardAtIndexPath:indexPath];
}

- (void)overturnCardAtIndexPath:(NSIndexPath * )indexPath
{
    CardEntity *currentItem = [self.cardItemList objectAtIndex:indexPath.row];
    CLMCardCollectionViewCell *cell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:indexPath];
    
    if (self.clickCount == 2) {
        self.cardsCollectionView.userInteractionEnabled = NO;
        return;
    } else {
        self.clickCount++;
    }
    
    if (self.previousIndexPath == nil) {
        self.previousIndexPath = indexPath;
    }
    
    __weak typeof(self) weakSelf = self;
    [cell setImageWithName:currentItem.cardImageName animation:YES completion:^(BOOL finished) {
        if (weakSelf.previousIndexPath != indexPath) {
            [weakSelf performSelector:@selector(updateCardsStatusAtIndexPath:) withObject:indexPath afterDelay:1.0];
            
        }
    }];
}

- (void)updateCardsStatusAtIndexPath:(NSIndexPath *)indexPath
{
    CardEntity *previousItem = [self.cardItemList objectAtIndex:self.previousIndexPath.row];
    CardEntity *currentItem = [self.cardItemList objectAtIndex:indexPath.row];
    CLMCardCollectionViewCell *cell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:indexPath];
    CLMCardCollectionViewCell *previousCell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:self.previousIndexPath];

    BOOL isSameType = ([currentItem.type isEqualToString:previousItem.type]) ? YES : NO;
    
    if (isSameType) {
        [cell removeCard];
        [previousCell removeCard];
    } else {
        [cell setImageWithName:currentItem.backgroundImageName animation:NO completion:nil];
        [previousCell setImageWithName:previousItem.backgroundImageName animation:NO completion:nil];
    }
    
    self.clickCount = 0;
    self.previousIndexPath = nil;
    self.cardsCollectionView.userInteractionEnabled = YES;
    
    [self updateScore:isSameType];
}

- (void)updateScore:(BOOL)isScorePlus
{
    if (isScorePlus) {
        self.scoreCount += SCORE_STEP;
        self.cardsCount -= 2;
    } else {
        self.scoreCount -= SCORE_STEP/2;
    }
}

#pragma mark - Setter

- (void)setCardsCount:(NSInteger)cardsCount
{
    _cardsCount = cardsCount;
    
    if (cardsCount == 0) {
        [self showInputUserNameAlter];
    }
}

- (void)setScoreCount:(NSInteger)scoreCount
{
    _scoreCount = scoreCount;
    
    [self.scoreButton setTitle:[NSString stringWithFormat:@"Score: %@", @(self.scoreCount)] forState:UIControlStateNormal];
}

#pragma mark - Show input name alert

- (void)showInputUserNameAlter
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"Congratulation!" message:@"Please enter your name" preferredStyle: UIAlertControllerStyleAlert];
    [alterController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"User name";
    }];
    
    UITextField *userNameTextField = [alterController textFields][0];
    userNameTextField.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    self.okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.userName.length != 0) {
            [self SaveUserData];
        } else {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    self.okAction.enabled = NO;
    [alterController addAction:self.okAction];

    [self presentViewController:alterController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = textField.text;
    text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // validate text input
    if ((text.length == 0 && string.length == 0) || (string.length == 0 && (text.length - range.length) == 0)) {
        self.okAction.enabled = NO;
    } else {
        self.okAction.enabled = YES;
        self.userName = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    
    return  YES;
}

#pragma mark - save user data

- (void)SaveUserData
{
    NSArray<User *> *allUserList = [self fetchUserListWithPredicate:nil];
    NSArray<User *> *highScoreUserList = [self fetchUserListWithPredicate:[NSPredicate predicateWithFormat:@"is_high_score=YES"]];
    NSInteger highScoreListCount = highScoreUserList.count;
    
    // the table is empty
    if (highScoreListCount == 0) {
        [self addNewRecordToDatabase:YES];
        [self showRankResultAlert:1];
    } else {
        User *hightScoreLastUser = highScoreUserList[highScoreListCount-1];
        
        // user score less than current high score
        if (self.scoreCount < hightScoreLastUser.score) {
            [self addNewRecordToDatabase:NO];
            
            // all records of user are high score
            if (allUserList.count == highScoreListCount) {
                [self showRankResultAlert:highScoreListCount+1];
            } else {
                [self processRankInUserList:allUserList];
            }
        } else { // user score higher than current high score
            [self addNewRecordToDatabase:YES];
            [self processRankInUserList:highScoreUserList];
        }
    }
}

- (void)processRankInUserList:(NSArray<User *> *)userList
{
    __weak typeof(self) weakSelf = self;
    [userList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(User * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0 || (weakSelf.scoreCount >= user.score && weakSelf.scoreCount <= [userList objectAtIndex:idx-1].score)) {
            [weakSelf showRankResultAlert:idx+1];
            
            return;
        }
    }];
}

static NSString * const SORT_KEY = @"score";

- (NSArray<User *> *)fetchUserListWithPredicate:(NSPredicate *)predicate
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

- (void)addNewRecordToDatabase:(BOOL)isHighScore
{
    NSPersistentContainer  *container =  ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    [container performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        User *userEntity = [[User alloc] initWithContext:context];
        userEntity.name = self.userName;
        userEntity.score = (int32_t)self.scoreCount;
        userEntity.finished_time = [NSDate date];
        userEntity.is_high_score = isHighScore;
        
        [context save:nil];
    }];
}

#pragma mark - Show rank result alert

- (void)showRankResultAlert:(NSInteger)rank
{
    NSString *message = [NSString stringWithFormat:@"Your 👍rank: %@, 👏score: %@", @(rank), @(self.scoreCount)];
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"Excellent"
                                                                             message:message
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self startNewGame];
                                                     }];
    [alterController addAction:okAction];
    
    [self presentViewController:alterController animated:YES completion:nil];
}

#pragma mark - Reset the Game

- (IBAction)resetGame:(id)sender
{
    [self showRestartAlter];
}

- (void)startNewGame
{
    [self initDataSource];
    [self.cardsCollectionView reloadData];
}

#pragma mark - Show reset alter

- (void)showRestartAlter
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:@"Do your want to restart a game?"
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self startNewGame];
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alterController addAction:cancelAction];
    [alterController addAction:okAction];
    
    [self presentViewController:alterController animated:YES completion:nil];
}

@end
