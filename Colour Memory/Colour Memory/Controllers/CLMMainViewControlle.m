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

@interface CLMMainViewControlle ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *cardsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSArray<CardItem *> *cardItemList;
@property (strong, nonatomic) NSIndexPath *previousIndexPath;
@property (assign, nonatomic) NSInteger cardsCount;
@property (assign, nonatomic) NSInteger scoreCount;
@property (strong, nonatomic) NSString *userName;

@end

@implementation CLMMainViewControlle

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
    CGFloat screenWitdh = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemWidth = (screenWitdh - (HORIZON_NUMBER+1)*PADDING_GAP)/HORIZON_NUMBER;
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
}

- (void)overturnCardAtIndexPath:(NSIndexPath * )indexPath
{
}

- (void)updateCardsStatusAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)updateScore:(BOOL)isScorePlus
{
}

#pragma mark - Reset the Game

- (IBAction)resetGame:(id)sender
{
}

#pragma mark - Setter

- (void)setCardsCount:(NSInteger)cardsCount
{
}

- (void)setScoreCount:(NSInteger)scoreCount
{
}

#pragma mark - Alter
- (void)inputUserName
{
}

@end
