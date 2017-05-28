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
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) NSDate *finishedDate;
@property (assign, nonatomic) CGFloat padding;

@end


@implementation CLMMainViewController

static NSString * const CELL_REUSEID = @"CLMCardCollectionViewCell";
static CGFloat const IMAGE_ASPECT_RATIO = 1.25;
static CGFloat const IPHONE_PADDING_GAP = 15;
static NSInteger const HORIZON_NUMBER = 4;

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
    self.userName = @"";
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
    [cell setImageWithName:cardItem.backgroundImageName];
    
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
    
    CGFloat itemWidth = (screenWidth - (HORIZON_NUMBER+1)*self.padding)/HORIZON_NUMBER;
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
    [cell setImageWithName:currentItem.cardImageName];
    
    if (self.previousIndexPath == nil) {
        self.previousIndexPath = indexPath;
    } else {
        self.cardsCollectionView.userInteractionEnabled = YES;
        [self performSelector:@selector(updateCardsStatusAtIndexPath:) withObject:indexPath afterDelay:1.0];
    }
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
        [cell setImageWithName:currentItem.backgroundImageName];
        [previousCell setImageWithName:previousItem.backgroundImageName];
    }
    
    [self updateScore:isSameType];
    self.previousIndexPath = nil;
    self.cardsCollectionView.userInteractionEnabled = YES;
}

- (void)updateScore:(BOOL)isScorePlus
{
    if (isScorePlus) {
        self.scoreCount += 10;
        self.cardsCount -= 2;
    } else {
        self.scoreCount -= 2;
    }
}

#pragma mark - Setter

- (void)setCardsCount:(NSInteger)cardsCount
{
    _cardsCount = cardsCount;
    
    if (cardsCount == 0) {
        [self showInputUserNameAlter];
        self.finishedDate = [NSDate date];
    }
}

- (void)setScoreCount:(NSInteger)scoreCount
{
    _scoreCount = scoreCount;
    
    [self.scoreButton setTitle:[NSString stringWithFormat:@"Score:%@", @(self.scoreCount)] forState:UIControlStateNormal];
}

#pragma mark - Reset the Game

- (IBAction)resetGame:(id)sender {
    //[self showRestartAlter];
    [self showInputUserNameAlter];
}

#pragma mark - show Alter

- (void)showInputUserNameAlter /** TODO: optimizing*/
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"Information" message:@"Please enter your name" preferredStyle: UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    self.okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (weakSelf.userName.length != 0) {
            [weakSelf addNewRecordToDatabase];
            [weakSelf showRankResultAlert];
        } else {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alterController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"User name";
    }];
    
    UITextField *userNameTextField = [alterController textFields][0];
    userNameTextField.delegate = self;
    
    self.okAction.enabled = NO;
    [alterController addAction:self.okAction];

    [self presentViewController:alterController animated:YES completion:nil];
}

- (void)showRankResultAlert
{
    // get rank data
    NSNumber *score = [NSNumber numberWithInteger:self.scoreCount];
    NSNumber *rank = [NSNumber numberWithInteger:[self getRankNumber]];
    
    // show alert
    NSString *message = [NSString stringWithFormat:@"Your rank: %@, score: %@", rank, score];
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"Congratulation" message:message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alterController addAction:okAction];
    
    [self presentViewController:alterController animated:YES completion:nil];
}

static NSString * const SORT_KEY = @"score";

- (NSInteger)getRankNumber
{
    NSPersistentContainer *container = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    NSManagedObjectContext *context = [container viewContext];
    __block NSInteger rank = 0;
    
    if (context != nil) {
        NSFetchRequest *request = [User fetchRequest];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SORT_KEY ascending:NO]];
        //request.predicate = [NSPredicate predicateWithFormat:@"name=%@, finished_time=%@",self.userName, self.finishedDate];
        
        __weak typeof(self) weakSelf = self;
        NSArray<User *> *userList = [context executeFetchRequest:request error:nil];
        [userList enumerateObjectsUsingBlock:^(User * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"user name:%@", user.name);
            if ([user.name isEqualToString:weakSelf.userName]) {
                rank = idx + 1;
            }
        }];
    }
    
    return rank;
}

- (void)showRestartAlter
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"" message:@"Do your want restart a game?" preferredStyle: UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf initDataSource];
        [weakSelf.cardsCollectionView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alterController addAction:cancelAction];
    [alterController addAction:okAction];
    
    [self presentViewController:alterController animated:YES completion:nil];
}

- (void)addNewRecordToDatabase
{
    NSPersistentContainer  *container =  ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    [container performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        User *userEntity = [[User alloc] initWithContext:context];
        userEntity.name = self.userName;
        userEntity.score = (int32_t)self.scoreCount;
        userEntity.finished_time = self.finishedDate;
        
        [context save:nil];
        // TODO: handle erro
//        NSError *error = nil;
//        BOOL success = [context save:&error];
//        if (success == NO) {
//            NSAssert(@"Failed to execute: %@",error);
//        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = textField.text;
    text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (text.length > 0) {
        self.okAction.enabled = YES;
        self.userName = text;
    } else {
        self.okAction.enabled = NO;
    }

    return  YES;
}

@end
