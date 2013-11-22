//
//  YABUser.h
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import "YABRootModel.h"

@interface YABUser : YABRootModel

@property (nonatomic, strong) NSString *name, *firstName, *lastName, *email;

@end
