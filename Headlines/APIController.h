//
//  APIController.h
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

@import UIKit;
#import "Article.h"

typedef void (^ArticleCompletion)(NSArray <Article *> *articles, NSError *error);

@interface APIController : NSObject

+ (instancetype)sharedController;

- (void)fetchArticlesWithCompletion:(ArticleCompletion)completion;

@end
