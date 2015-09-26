//
//  Article.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "Article.h"

@implementation Article

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, headline: %@, image: %@>", NSStringFromClass([self class]), self, self.headline, self.imageUrl];
}

@end
