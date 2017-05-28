//
//  CLMHightScoreViewController.h
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMHightScoreViewController.h"
#import "CLMScoreRankTableViewCell.h"
#import <CoreData/CoreData.h>
#import "User+CoreDataClass.h"
#import "AppDelegate.h"
#import "UserEntity.h"

static NSString * const  IDENTIFIER = @"CLMScoreRankTableViewCell";

@interface CLMHightScoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *scoreRankTableView;
@property (strong, nonatomic) NSFetchedResultsController<User *> *fetchResultsController;

@end

@implementation CLMHightScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarTitle];
    [self initTableView];
    [self fetchData];
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
    titleLabel.text = @"Hight Score Ranking";
    
    self.navigationItem.titleView = titleLabel;
}

static NSString * const SORT_KEY = @"score";

- (void)fetchData
{
    NSPersistentContainer *container = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    NSManagedObjectContext *context = [container viewContext];
    
    if (context != nil) {
        NSFetchRequest *request = [User fetchRequest];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SORT_KEY ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"is_high_score=YES"];
        
        self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
        [self.fetchResultsController performFetch:nil];
        [self.scoreRankTableView reloadData];
    }
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
