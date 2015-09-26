//
//  Article.h
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

@import UIKit;

@interface Article : NSObject <NSCopying>

@property (copy, nonatomic) NSString *headline;
@property (copy, nonatomic) NSString *body;
@property (copy, nonatomic) NSDate *publishDate;
@property (copy, nonatomic) NSURL *imageUrl;

@end
