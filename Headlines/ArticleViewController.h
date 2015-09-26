//
//  ArticleViewController.h
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

@import UIKit;
#import "Article.h"

@interface ArticleViewController : UIViewController

@property (assign, nonatomic) NSInteger articleIndex;
@property (copy, nonatomic) Article *article;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end
