//
//  Article.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "Article.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation Article

@dynamic identifier;
@dynamic headline;
@dynamic body;
@dynamic publishDate;
@dynamic imageUrlString;

- (void)setImageUrl:(NSURL *)imageUrl
{
    self.imageUrlString = imageUrl.absoluteString;
}

- (NSURL *)imageUrl
{
    return [NSURL URLWithString:self.imageUrlString];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    Article *copy = [[self class] MR_createEntityInContext:nil];
    copy.identifier = self.identifier;
    copy.headline = self.headline;
    copy.body = self.body;
    copy.publishDate = self.publishDate;
    copy.imageUrlString = self.imageUrlString;
    return copy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, headline: %@, image: %@>", NSStringFromClass([self class]), self, self.headline, self.imageUrl];
}

@end
