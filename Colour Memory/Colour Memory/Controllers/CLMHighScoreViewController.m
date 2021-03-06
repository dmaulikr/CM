//
//  CLMHighScoreViewController.h
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMHighScoreViewController.h"
#import "CLMScoreRankTableViewCell.h"
#import <CoreData/CoreData.h>
#import "User+CoreDataClass.h"
#import "CLMUserManager.h"
#import "AppDelegate.h"
#import "UserEntity.h"

static NSString * const  IDENTIFIER = @"CLMScoreRankTableViewCell";

@interface CLMHighScoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *scoreRankTableView;
@property (strong, nonatomic) NSFetchedResultsController<User *> *fetchResultsController;

@end

@implementation CLMHighScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarTitle];
    [self initTableView];
    
    self.fetchResultsController = [CLMUserManager fetchHighScoreResults];
    [self.scoreRankTableView reloadData];
}

- (void)initTableView
{
    self.scoreRankTableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0, [UIScreen mainScreen].bounds.size.width, 1}];
    footerView.backgroundColor = [UIColor lightGrayColor];
    self.scoreRankTableView.tableFooterView = footerView;
}

- (void)setNavigationBarTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"High Score Ranking";
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray<id<NSFetchedResultsSectionInfo>> *sections = self.fetchResultsController.sections;
    return sections.count > 0 ? sections[section].numberOfObjects : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMScoreRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
    
    User *userEntity = [self.fetchResultsController objectAtIndexPath:indexPath];
    UserEntity *item = [[UserEntity alloc] initUserWithName:userEntity.name score:userEntity.score rank:indexPath.row+1];
    [cell setCellWithUser:item];
    
    return cell;
}

@end
