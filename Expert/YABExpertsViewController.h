//
//  YABExpertsViewController.h
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YABService.h"

@interface YABExpertsViewController : UITableViewController {
    YABService *_service;
    NSArray *_experts;
}

@end
