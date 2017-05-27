//
//  CLMScoreRankViewController.m
//  Colour Memory
//
//  Created by Michael Zhai on 27/05/17.
//  Copyright © 2017 Michael Zhai. All rights reserved.
//

#import "CLMScoreRankViewController.h"
#import "CLMScoreRankTableViewCell.h"
#import "UserItem.h"

@interface CLMScoreRankViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *scoreRankTableView;

@end

@implementation CLMScoreRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
}

- (void)initTableView
{
    self.scoreRankTableView.dataSource = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CLMScoreRankTableViewCell";
    CLMScoreRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CLMScoreRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UserItem *item = [[UserItem alloc] initUserItemName:@"Michael" score:10 rank:1];
    [cell setCellWithUserItem:item];
    
    return cell;
}

@end
