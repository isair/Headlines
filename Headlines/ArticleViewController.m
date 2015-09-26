//
//  ArticleViewController.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "ArticleViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ArticleViewController ()

@end

@implementation ArticleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"article" options:0 context:NULL];
    [self updateSubviews];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"article"]) {
        [self updateSubviews];
    }
}

- (void)updateSubviews
{
    if (self.article != nil) {
        [self.activityIndicator stopAnimating];
        self.headlineLabel.text = self.article.headline;
        self.bodyLabel.text = self.article.body;
        [self.imageView sd_setImageWithURL:self.article.imageUrl];
    } else {
        [self.activityIndicator startAnimating];
        self.headlineLabel.text = @"";
        self.bodyLabel.text = @"";
        self.imageView.image = nil;
    }
}

- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:@"article"];
    }
    @catch (__unused NSException *exception) {}
}

@end
