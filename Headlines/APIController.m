//
//  APIController.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "APIController.h"
#import "AppDelegate.h"
#import <ISO8601/ISO8601.h>
#import <MagicalRecord/MagicalRecord.h>

NSString *const kAPIKey = @"enj8pstqu5yat6yesfsdmd39";

@interface APIController ()

@end

@implementation APIController

+ (instancetype)sharedController
{
    static id sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (void)fetchArticlesWithCompletion:(ArticleCompletion)completion
{
    NSString *url = [NSString stringWithFormat:@"http://content.guardianapis.com/search?q=fintech&show-fields=main,body&api-key=%@", kAPIKey];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        } else {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in dictionary[@"response"][@"results"]) {
                Article *article = [Article MR_createEntityInContext:nil];
                article.identifier = result[@"id"];
                article.headline = result[@"webTitle"];
                article.body = [self stringByStrippingTagsFromString:result[@"fields"][@"body"]];
                article.publishDate = [NSDate dateWithISO8601String:result[@"webPublicationDate"]];
                article.imageUrl = [self extractUrlFromString:result[@"fields"][@"main"]];
                article.webUrl = [NSURL URLWithString:result[@"webUrl"]];
                [array addObject:article];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array, error);
            });
        }
    }];
}

- (NSURL *)extractUrlFromString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            return [match URL];
        }
    }
    
    return nil;
}

- (NSString *)stringByStrippingTagsFromString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"</p> <p>" withString:@"\n\n"];
    
    NSRange range;
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return string;
}

@end
