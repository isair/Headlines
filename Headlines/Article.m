//
//  Article.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "Article.h"

@implementation Article

- (instancetype)copyWithZone:(NSZone *)zone
{
    Article *copy = [[[self class] alloc] init];
    copy.headline = self.headline;
    copy.body = self.body;
    copy.publishDate = self.publishDate;
    copy.imageUrl = self.imageUrl;
    return copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, headline: %@, image: %@>", NSStringFromClass([self class]), self, self.headline, self.imageUrl];
}

@end
