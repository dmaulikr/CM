//
//  CLMScoreRankViewController.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMScoreRankViewController.h"
#import "CLMScoreRankTableViewCell.h"
#import <CoreData/CoreData.h>
#import "User+CoreDataClass.h"
#import "AppDelegate.h"
#import "UserEntity.h"

@interface CLMScoreRankViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *scoreRankTableView;
@property (strong, nonatomic) NSFetchedResultsController<User *> *fetchResultsController;

@end

@implementation CLMScoreRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
    [self fetchData];
}

- (void)initTableView
{
    self.scoreRankTableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0, [UIScreen mainScreen].bounds.size.width, 1}];
    footerView.backgroundColor = [UIColor whiteColor];
    self.scoreRankTableView.tableFooterView = footerView;
}

static NSString * const SORT_KEY = @"score";

- (void)fetchData
{
    NSPersistentContainer *container = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    NSManagedObjectContext *context = [container viewContext];
    
    if (context != nil) {
        NSFetchRequest *request = [User fetchRequest];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:SORT_KEY ascending:false]];
        self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
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
    static NSString *identifier = @"CLMScoreRankTableViewCell";
    CLMScoreRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CLMScoreRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    User *userEntity = [self.fetchResultsController objectAtIndexPath:indexPath];
    UserEntity *item = [[UserEntity alloc] initUserWithName:userEntity.name score:userEntity.score rank:indexPath.row+1];
    [cell setCellWithUser:item];
    
    return cell;
}

@end
