//
//  YABModel.m
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import "YABModel.h"

@implementation YABModel

+ (YABModel *)singleton
{
    static dispatch_once_t pred;
    static YABModel *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[YABModel alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

        // Build the path to the database file
        NSString *dbPath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"yabbly.db"]];

        NSFileManager *fileManager = [NSFileManager defaultManager];

        if ([fileManager fileExistsAtPath: dbPath ] == NO) {
            if (sqlite3_open([dbPath UTF8String], &_db) == SQLITE_OK) {
                char *errMsg;

                char *stmt = "create table if not exists users (id bigint not null primary key, name varchar(256), email varchar(128), first_name varchar(128), last_name varchar(128))";
                //char *stmt = "CREATE TABLE IF NOT EXISTS users (id BIGINT NOT NULL PRIMARY KEY, name VARCHAR(256), email VARCHAR(128), first_name VARCHAR(128), last_name VARCHAR(128))";
                if (sqlite3_exec(_db, stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                    [NSException raise:@"Database" format:@"Creating table [users] [%s]", errMsg];
                }

                stmt = "create table if not exists expert_users (id bigint not null primary key, user_id bigint not null)";
                if (sqlite3_exec(_db, stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                    [NSException raise:@"Database" format:@"Creating table [expert_users] [%s]", errMsg];
                }

                sqlite3_close(_db);
            } else {
                [NSException raise:@"Database" format:@"Could not open database 1"];
            }
        }

        if (sqlite3_open([dbPath UTF8String], &_db) != SQLITE_OK) {
            [NSException raise:@"Database" format:@"Could not open database 2"];
        }
    }
    return self;
}

- (void)createUser:(YABUser *)user
{
    NSString *stmtStr = @"insert into users (id, name, email, first_name, last_name) values (?, ?, ?, ?, ?)";
    sqlite3_stmt *stmt = [self prepare:stmtStr];
    sqlite3_bind_int(stmt, 1, user.objectId);
    sqlite3_bind_text(stmt, 2, [user.name UTF8String], -1, SQLITE_TRANSIENT); // TODO Not sure about this
    sqlite3_bind_text(stmt, 3, [user.email UTF8String], -1, SQLITE_TRANSIENT); // TODO Not sure about this
    sqlite3_bind_text(stmt, 4, [user.firstName UTF8String], -1, SQLITE_TRANSIENT); // TODO Not sure about this
    sqlite3_bind_text(stmt, 4, [user.lastName UTF8String], -1, SQLITE_TRANSIENT); // TODO Not sure about this
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        [NSException raise:@"Database" format:@"Error inserting user [%@]", stmtStr];
    }
    sqlite3_finalize(stmt);
}

- (YABExpertUser *)findExpertUserById:(NSInteger)objectId
{
    NSString *stmtStr = @"select id, user_id from expert_users where id = ?";
    sqlite3_stmt *stmt;

    if (sqlite3_prepare(_db, [stmtStr UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, objectId);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            YABExpertUser *expert = [[YABExpertUser alloc] init];
            expert.objectId = sqlite3_column_int(stmt, 0);
            expert.user = [self findUserById:sqlite3_column_int(stmt, 1)];
            return expert;
        } else {
            return nil;
        }
    } else {
        [NSException raise:@"Database" format:@"Error preparing statement [%@]", stmtStr];
    }

    return nil;
}

- (void)createExpertUser:(YABExpertUser *)expertUser
{
    NSString *stmtStr = @"insert into expert_users (id, user_id) values (?, ?)";
    sqlite3_stmt *stmt = [self prepare:stmtStr];
    sqlite3_bind_int(stmt, 1, expertUser.objectId);
    sqlite3_bind_int(stmt, 2, expertUser.user.objectId);
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        [NSException raise:@"Database" format:@"Error inserting user [%@]", stmtStr];
    }
    sqlite3_finalize(stmt);
}

- (YABUser *)findUserById:(NSInteger)userId
{
    NSString *stmtStr = @"select id, name, email, first_name, last_name from users where id = ?";
    sqlite3_stmt *stmt;

    if (sqlite3_prepare_v2(_db, [stmtStr UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, userId);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            YABUser *user = [[YABUser alloc] init];
            user.objectId = sqlite3_column_int(stmt, 0);

            char *v = (char *) sqlite3_column_text(stmt, 1);
            if (v) {
                user.name = [NSString stringWithUTF8String:v];
            }

            v = (char *) sqlite3_column_text(stmt, 2);
            if (v) {
                user.email = [NSString stringWithUTF8String:v];
            }

            v = (char *) sqlite3_column_text(stmt, 3);
            if (v) {
                user.firstName = [NSString stringWithUTF8String:v];
            }

            v = (char *) sqlite3_column_text(stmt, 4);
            if (v) {
                user.lastName = [NSString stringWithUTF8String:v];
            }

            return user;
        } else {
            return nil;
        }
    } else {
        [NSException raise:@"Database" format:@"Error preparing statement [%@]", stmtStr];
    }

    return nil;
}

- (NSArray *)findAllExpertUsers
{
    NSString * stmtStr = @"select id, user_id from expert_users order by id desc";
    sqlite3_stmt *stmt;

    if (sqlite3_prepare_v2(_db, [stmtStr UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        NSMutableArray *expertUsers = [[NSMutableArray alloc] init];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            YABExpertUser *expert = [[YABExpertUser alloc] init];
            expert.objectId = sqlite3_column_int(stmt, 0);

            NSInteger userId = sqlite3_column_int(stmt, 1);
            expert.user = [self findUserById:userId];

            [expertUsers addObject:expert];
        }
        return expertUsers;
    } else {
        [NSException raise:@"Database" format:@"Error preparing statement [%@]", stmtStr];
    }
    
    // Should not get here
    return nil;
}

- (sqlite3_stmt *)prepare:(NSString *)stmtStr
{
    sqlite3_stmt *stmt;

    if (sqlite3_prepare_v2(_db, [stmtStr UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        return stmt;
    }
    [NSException raise:@"Database" format:@"Failed to prepare statement [%@]", stmtStr];
    return nil;
}

@end
