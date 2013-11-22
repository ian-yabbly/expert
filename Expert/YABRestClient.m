//
//  YABRestClient.m
//  Expert
//
//  Created by Ian Shafer on 11/20/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import "YABRestClient.h"
#import "NSString+UrlEncode.h"

#define YABBLY_WEB_PROTOCOL @"http"
#define YABBLY_WEB_HOST @"yabbly.local"
#define YABBLY_WEB_PORT 4000

#define YABBLY_NEW_REST_PROTOCOL @"http"
#define YABBLY_NEW_REST_HOST @"yabbly.local"
#define YABBLY_NEW_REST_PORT 4002
#define YABBLY_NEW_REST_URL_CONTEXT @"/r"

#define YABBLY_REST_PROTOCOL @"http"
#define YABBLY_REST_HOST @"yabbly.local"
#define YABBLY_REST_PORT 5000
#define YABBLY_REST_URL_CONTEXT @"/rest"

@implementation YABRestClient

+ (YABRestClient *)singleton
{
    static dispatch_once_t pred;
    static YABRestClient *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[YABRestClient alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                    delegate:nil
                                               delegateQueue:nil];
    }
    return self;
}

- (void)findAllExpertsOnSuccess:(void (^)(NSArray *))successHandler
                        onError:(void (^)(NSError *))errorHandler
{
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@:%d%@/expert/user",
                        YABBLY_NEW_REST_PROTOCOL,
                        YABBLY_NEW_REST_HOST,
                        YABBLY_NEW_REST_PORT,
                        YABBLY_NEW_REST_URL_CONTEXT];

    NSURL *url = [NSURL URLWithString:urlStr];

    NSURLSessionDataTask *task =
    [_urlSession dataTaskWithURL:url
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if (error) {
                       if (errorHandler) {
                           errorHandler(error);
                       }
                   } else if (successHandler) {
                       NSError *jsonError;
                       NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                       if (jsonError) {
                           if (errorHandler) {
                               errorHandler(jsonError);
                           }
                       } else {
                           successHandler([jsonDict objectForKey:@"values"]);
                       }
                   }
               }];

    [task resume];
}

- (void)findUserByPhoneNumber:(NSString *)phoneNumber
                    onSuccess:(void (^)(NSArray *))successHandler
                      onError:(void (^)(NSError *))errorHandler
{
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@:%d%@/user?phone-number=%@",
                        YABBLY_NEW_REST_PROTOCOL,
                        YABBLY_NEW_REST_HOST,
                        YABBLY_NEW_REST_PORT,
                        YABBLY_NEW_REST_URL_CONTEXT,
                        [phoneNumber urlEncode]];

    NSURL *url = [NSURL URLWithString:urlStr];

    NSURLSessionDataTask *task =
    [_urlSession dataTaskWithURL:url
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if (error) {
                       if (errorHandler) {
                           errorHandler(error);
                       }
                   } else if (successHandler) {
                       NSError *jsonError;
                       NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                       if (jsonError) {
                           if (errorHandler) {
                               errorHandler(jsonError);
                           }
                       } else {
                           successHandler([jsonDict objectForKey:@"values"]);
                       }
                   }
               }];

    [task resume];
}

@end
