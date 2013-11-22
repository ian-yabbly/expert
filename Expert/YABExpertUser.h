//
//  YABExpert.h
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import "YABRootModel.h"
#import "YABUser.h"

@interface YABExpertUser : YABRootModel

@property (nonatomic, strong) YABUser *user;
@property (nonatomic, strong) NSArray *tags;

@end
