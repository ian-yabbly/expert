//
//  YABService.m
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import <sqlite3.h>

#import "YABService.h"
#import "YABModel.h"

@implementation YABService

+ (YABService *)singleton
{
    static dispatch_once_t pred;
    static YABService *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[YABService alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [YABModel singleton];
        _rest = [YABRestClient singleton];
    }
    return self;
}

- (YABUser *)findUserById:(NSInteger)userId
{
    return [_model findUserById:userId];
}

- (NSArray *)findAllExpertUsers
{
    [_rest findAllExpertsOnSuccess:^(NSArray *experts) {
        for (NSDictionary *d in experts) {
            NSInteger expertId = [[d objectForKey:@"id"] integerValue];
            if (![_model findExpertUserById:expertId]) {
                YABExpertUser *expert = [[YABExpertUser alloc] init];
                expert.objectId = [[d objectForKey:@"id"] integerValue];

                NSInteger userId = [[d valueForKeyPath:@"user.id"] integerValue];
                YABUser *user = [_model findUserById:userId];
                if (!user) {
                    user = [[YABUser alloc] init];
                    user.objectId = userId;
                    user.name = [d valueForKeyPath:@"user.name"];
                    user.email = [d valueForKeyPath:@"user.email"];
                    user.firstName = [d valueForKeyPath:@"user.firstName"];
                    user.lastName = [d valueForKeyPath:@"user.lastName"];
                    [_model createUser:user];
                    user = [_model findUserById:userId];
                }

                expert.user = user;

                [_model createExpertUser:expert];
            }
        }
    } onError:^(NSError *error) {
        NSLog(@"Error finding all experts [%@]", error.description);
    }];

    return [_model findAllExpertUsers];
}

@end
