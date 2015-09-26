//
//  FavouritesViewController.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "FavouritesViewController.h"
#import "APIController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FavouritesViewController ()

@property (strong, nonatomic) NSArray <Article *> *articles;

@end

@implementation FavouritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
    
    [[APIController sharedController] fetchArticlesWithCompletion:^(NSArray<Article *> *articles, NSError *error) {
        _articles = articles;
        [self.tableView reloadData];
    }];
}

- (void)doneButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const kCellIdentifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    Article *article = self.articles[indexPath.row];
    cell.textLabel.text = article.headline;
    cell.detailTextLabel.text = article.publishDate.description;
    [cell.imageView sd_setImageWithURL:article.imageUrl];
    
    return cell;
}

@end
