//
//  CLMMainViewController.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMMainViewController.h"
#import "CLMCardCollectionViewCell.h"
#import "CardItem.h"

static NSString * const CELL_REUSEID = @"CLMCardCollectionViewCell";
static CGFloat const IMAGE_ASPECT_RATIO = 1.25;
static NSInteger const HORIZON_NUMBER = 4;
static CGFloat const PADDING_GAP = 15;


@interface CLMMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *cardsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic, ) NSArray<CardItem *> *cardItemList;
@property (strong, nonatomic) NSIndexPath *previousIndexPath;
@property (assign, nonatomic) NSInteger cardsCount;
@property (assign, nonatomic) NSInteger scoreCount;
@property (strong, nonatomic) NSString *userName;

@end


@implementation CLMMainViewController

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
    CardItem *cardItem = [self.cardItemList objectAtIndex:indexPath.row];
    [cell setImageWithName:cardItem.backgroundImageName];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemWidth = (screenWidth - (HORIZON_NUMBER+1)*PADDING_GAP)/HORIZON_NUMBER;
    CGFloat itemHeight = itemWidth*IMAGE_ASPECT_RATIO;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return PADDING_GAP;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return PADDING_GAP;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING_GAP*2, PADDING_GAP, 0, PADDING_GAP);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.previousIndexPath) {
        return;
    }
    
    CLMCardCollectionViewCell *cell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:indexPath];
    if (cell.isRemoved == true) {
        return;
    }

    [self overturnCardAtIndexPath:indexPath];
}

- (void)overturnCardAtIndexPath:(NSIndexPath * )indexPath
{
    CardItem *currentItem = [self.cardItemList objectAtIndex:indexPath.row];
    CLMCardCollectionViewCell *cell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:indexPath];
    [cell setImageWithName:currentItem.cardImageName];
    
    if (self.previousIndexPath == nil) {
        self.previousIndexPath = indexPath;
    } else {
        self.cardsCollectionView.userInteractionEnabled = false;
        [self performSelector:@selector(updateCardsStatusAtIndexPath:) withObject:indexPath afterDelay:1.0];
    }
}

- (void)updateCardsStatusAtIndexPath:(NSIndexPath *)indexPath
{
    CardItem *previousItem = [self.cardItemList objectAtIndex:self.previousIndexPath.row];
    CardItem *currentItem = [self.cardItemList objectAtIndex:indexPath.row];
    CLMCardCollectionViewCell *cell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:indexPath];
    CLMCardCollectionViewCell *previousCell = (CLMCardCollectionViewCell *)[self.cardsCollectionView cellForItemAtIndexPath:self.previousIndexPath];

    BOOL isSameType = ([currentItem.type isEqualToString:previousItem.type]) ? true : false;
    
    if (isSameType) {
        [cell removeCard];
        [previousCell removeCard];
    } else {
        [cell setImageWithName:currentItem.backgroundImageName];
        [previousCell setImageWithName:previousItem.backgroundImageName];
    }
    
    [self updateScore:isSameType];
    self.previousIndexPath = nil;
    self.cardsCollectionView.userInteractionEnabled = true;

}

- (void)updateScore:(BOOL)isScorePlus
{
    if (isScorePlus) {
        self.scoreCount += 10;
        self.cardsCount -= 2;
    } else {
        self.scoreCount -=10;
    }
}

#pragma mark - Reset the Game

- (IBAction)resetGame:(id)sender {
    [self initDataSource];
    [self.cardsCollectionView reloadData];
}

#pragma mark - Setter

- (void)setCardsCount:(NSInteger)cardsCount
{
    _cardsCount = cardsCount;
    
    if (cardsCount == 0) {
        [self inputUserName];
    }
}

- (void)setScoreCount:(NSInteger)scoreCount
{
    _scoreCount = scoreCount;
    
    [self.scoreButton setTitle:[NSString stringWithFormat:@"Score:%@", @(self.scoreCount)] forState:UIControlStateNormal];
}

#pragma mark - Alter
- (void)inputUserName /** TODO: optimizing*/
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"Congratulation!" message:@"You won the match" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *userNameTextField = [actionSheetController textFields][0];
        self.userName = userNameTextField.text;
        
        if (self.userName.length != 0) {
            // set user object
        } else {
            [self presentViewController:actionSheetController animated:true completion:nil];
        }
    }];
    
    [actionSheetController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"User name";
    }];
    
    [actionSheetController addAction:okAction];
    [self presentViewController:actionSheetController animated:true completion:nil];
}

@end
