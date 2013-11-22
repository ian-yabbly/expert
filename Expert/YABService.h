//
//  YABService.h
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "YABModel.h"
#import "YABRestClient.h"

@interface YABService : NSObject {
    YABModel *_model;
    YABRestClient *_rest;
}

+ (YABService *) singleton;

- (YABUser *)findUserById:(NSInteger)userId;

- (NSArray *)findAllExpertUsers;

@end
