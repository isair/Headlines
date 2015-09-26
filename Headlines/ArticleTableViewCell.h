//
//  ArticleTableViewCell.h
//  Headlines
//
//  Created by Baris Sencan
//  Copyright © 2015 Buy n Large. All rights reserved.
//

@import UIKit;

@interface ArticleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;

@end
