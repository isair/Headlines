//
//  ArticleGalleryViewController.h
//  Headlines
//
//  Created by Baris Sencan
//  Copyright © 2015 Buy n Large. All rights reserved.
//

@import UIKit;
#import "Article.h"

@interface ArticleGalleryViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favouritesButton;

- (instancetype)initWithArticles:(NSArray <Article *> *)articles;

@end
