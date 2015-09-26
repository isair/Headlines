//
//  FavouritesViewController.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "FavouritesViewController.h"
#import "APIController.h"
#import "Article.h"
#import "ArticleTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MagicalRecord/MagicalRecord.h>
#import "ArticleGalleryViewController.h"

#define kCellIdentifier @"ArticleCell"

@interface FavouritesViewController ()

@property (strong, nonatomic) NSArray <Article *> *articles;

@end

@implementation FavouritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Favourites" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.articles = [Article MR_findAllSortedBy:@"publishDate" ascending:NO];
    self.navigationItem.title = [NSString stringWithFormat:@"%lu favourites", (unsigned long) self.articles.count];
    [self.tableView reloadData];
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
    ArticleTableViewCell *articleCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    Article *article = self.articles[indexPath.row];
    articleCell.headlineLabel.text = article.headline;
    articleCell.publishDateLabel.text = [NSDateFormatter localizedStringFromDate:article.publishDate
                                                                       dateStyle:NSDateFormatterShortStyle
                                                                       timeStyle:NSDateFormatterNoStyle];
    [articleCell.articleImageView sd_setImageWithURL:article.imageUrl];
    
    return articleCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.articles[indexPath.row];
    ArticleGalleryViewController *articleGallery = [[ArticleGalleryViewController alloc] initWithArticles:@[article]];
    [self.navigationController pushViewController:articleGallery animated:YES];
}

@end
