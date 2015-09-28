//
//  Article.h
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

@import UIKit;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface Article : NSManagedObject <NSCopying>

@property (nullable, copy, nonatomic) NSString *identifier;
@property (nullable, copy, nonatomic) NSString *headline;
@property (nullable, copy, nonatomic) NSString *body;
@property (nullable, copy, nonatomic) NSDate *publishDate;
@property (nullable, copy, nonatomic) NSString *imageUrlString;
@property (nullable, copy, nonatomic) NSString *webUrlString;

- (void)setImageUrl:(NSURL *)imageUrl;
- (NSURL *)imageUrl;

- (void)setWebUrl:(NSURL *)webUrl;
- (NSURL *)webUrl;

@end

NS_ASSUME_NONNULL_END
