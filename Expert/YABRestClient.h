//
//  YABRestClient.h
//  Expert
//
//  Created by Ian Shafer on 11/20/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YABRestClient : NSObject

+ (YABRestClient *)singleton;

@property (nonatomic, strong) NSURLSession *urlSession;

- (void)findAllExpertsOnSuccess:(void (^)(NSArray *))successHandler
                        onError:(void (^)(NSError *))errorHandler;

- (void)findUserByPhoneNumber:(NSString *)phoneNumber
                    onSuccess:(void (^)(NSArray *))successHandler
                      onError:(void (^)(NSError *))errorHandler;

@end
