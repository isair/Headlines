//
//  MainViewController.m
//  Headlines
//
//  Created by Baris Sencan
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "MainViewController.h"
#import "APIController.h"
#import <Masonry/Masonry.h>
#import <Reachability/Reachability.h>
#import "ArticleViewController.h"
#import "FavouritesViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) NSArray <Article *> *articles;
@property (weak, nonatomic) Reachability *internetReach; // Retains itself on startNotifier call.

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    [self.pageViewController setViewControllers:@[[self viewControllerForArticleAtIndex:0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageViewController didMoveToParentViewController:self];

    self.internetReach = [Reachability reachabilityForInternetConnection];
    if (self.internetReach.isReachable) {
        [self fetchArticles];
    } else {
        self.internetReach.reachableBlock = ^(Reachability *reach) {
            [self fetchArticles];
        };
        [self.internetReach startNotifier];
    }
}

- (void)dealloc
{
    [self.internetReach stopNotifier];
}

- (void)fetchArticles
{
    [[APIController sharedController] fetchArticlesWithCompletion:^(NSArray *articles, NSError *error) {
        _articles = articles;
        [self.pageViewController setViewControllers:@[[self viewControllerForArticleAtIndex:0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
    }];
}

- (ArticleViewController *)viewControllerForArticleAtIndex:(NSUInteger)articleIndex
{
    ArticleViewController *articleViewController = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
    articleViewController.articleIndex = articleIndex;
    articleViewController.article = self.articles[articleIndex];
    return articleViewController;
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

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ArticleViewController *)viewController).articleIndex;

    if (index > 0) {
        return [self viewControllerForArticleAtIndex:index - 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ArticleViewController *)viewController).articleIndex;

    if (index < self.articles.count - 1) {
        return [self viewControllerForArticleAtIndex:index + 1];
    }
    return nil;
}

@end
