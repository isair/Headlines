//
//  ViewController.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "ViewController.h"
#import "APIController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FavouritesViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[APIController sharedController] fetchArticlesWithCompletion:^(NSArray *articles, NSError *error) {
        Article *article = articles.firstObject;
        self.headlineLabel.text = article.headline;
        self.bodyLabel.text = article.body;
        [self.imageView sd_setImageWithURL:article.imageUrl];
    }];
}

- (IBAction)favouritesButtonPressed
{
    FavouritesViewController *favouritesController = [[FavouritesViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:favouritesController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)starButtonPressed
{
    
}

@end
