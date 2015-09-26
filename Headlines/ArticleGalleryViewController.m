//
//  ArticleGalleryViewController.m
//  Headlines
//
//  Created by Baris Sencan
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "ArticleGalleryViewController.h"
#import "APIController.h"
#import <Masonry/Masonry.h>
#import <Reachability/Reachability.h>
#import <MagicalRecord/MagicalRecord.h>
#import "ArticleViewController.h"
#import "FavouritesViewController.h"

@interface ArticleGalleryViewController ()

@property (copy, nonatomic) NSArray <Article *> *articles;
@property (weak, nonatomic) Reachability *internetReach; // Retains itself on startNotifier call.

@end

@implementation ArticleGalleryViewController

- (instancetype)initWithArticles:(NSArray <Article *> *)articles
{
    if (self = [super initWithNibName:@"ArticleGalleryViewController" bundle:nil]) {
        self.articles = articles;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
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

    if (!self.articles) {
        self.internetReach = [Reachability reachabilityForInternetConnection];
        if (self.internetReach.isReachable) {
            [self fetchArticles];
        } else {
            self.internetReach.reachableBlock = ^(Reachability *reach) {
                [self fetchArticles];
            };
            [self.internetReach startNotifier];
        }
    } else {
        self.favouritesButton.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshStarButton];
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
        [self refreshStarButton];
    }];
}

- (ArticleViewController *)viewControllerForArticleAtIndex:(NSUInteger)articleIndex
{
    ArticleViewController *articleViewController = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
    articleViewController.articleIndex = articleIndex;
    articleViewController.article = self.articles[articleIndex];
    return articleViewController;
}

- (Article *)viewedArticle
{
    return ((ArticleViewController *) self.pageViewController.viewControllers.firstObject).article;
}

- (void)refreshStarButton
{
    if ([Article MR_findByAttribute:@"identifier" withValue:self.viewedArticle.identifier].count > 0) {
        [self.starButton setImage:[UIImage imageNamed:@"favourite-on"] forState:UIControlStateNormal];
    } else {
        [self.starButton setImage:[UIImage imageNamed:@"favourite-off"] forState:UIControlStateNormal];
    }
}

- (IBAction)favouritesButtonPressed
{
    FavouritesViewController *favouritesController = [[FavouritesViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:favouritesController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)starButtonPressed
{
    Article *viewedArticle = [self viewedArticle];
    if ([Article MR_findByAttribute:@"identifier" withValue:viewedArticle.identifier].count > 0) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [Article MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"identifier", viewedArticle.identifier]
                                         inContext:localContext];
        }];
        [self.starButton setImage:[UIImage imageNamed:@"favourite-off"] forState:UIControlStateNormal];
    } else {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Article *article = [Article MR_createEntityInContext:localContext];
            article.identifier = viewedArticle.identifier;
            article.headline = viewedArticle.headline;
            article.body = viewedArticle.body;
            article.publishDate = viewedArticle.publishDate;
            article.imageUrlString = viewedArticle.imageUrlString;
        }];
        [self.starButton setImage:[UIImage imageNamed:@"favourite-on"] forState:UIControlStateNormal];
    }
    [self bounceStarButtonUp];
}

- (IBAction)bounceStarButtonIn
{
    CABasicAnimation *bounceIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bounceIn.fromValue = @1;
    bounceIn.toValue = @0.5;
    bounceIn.duration = 0.15;
    bounceIn.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :1.8 :1 :1];
    bounceIn.removedOnCompletion = NO;
    bounceIn.fillMode = kCAFillModeForwards;
    [self.starButton.layer addAnimation:bounceIn forKey:@"transform.scale"];
}

- (IBAction)bounceStarButtonUp
{
    CABasicAnimation *bounceOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bounceOut.fromValue = @0.5;
    bounceOut.toValue = @1;
    bounceOut.duration = 0.15;
    bounceOut.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :1.8 :1 :1];
    bounceOut.removedOnCompletion = NO;
    bounceOut.fillMode = kCAFillModeForwards;
    [self.starButton.layer addAnimation:bounceOut forKey:@"transform.scale"];
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

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) return;
    [self refreshStarButton];
}

@end
