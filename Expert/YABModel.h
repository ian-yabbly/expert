//
//  YABModel.h
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface YABModel : NSObject {
    sqlite3 *_db;
}

+ (YABModel *) singleton;

- (void)createUser:(YABUser *)user;
- (YABExpertUser *)findExpertUserById:(NSInteger)expertId;
- (void)createExpertUser:(YABExpertUser *)expertUser;
- (YABUser *)findUserById:(NSInteger)userId;
- (NSArray *)findAllExpertUsers;

@end
