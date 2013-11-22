//
//  YABExpertTableCell.m
//  Expert
//
//  Created by Ian Shafer on 11/21/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import "YABExpertTableCell.h"

@implementation YABExpertTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup:(YABExpertUser *)expertUser
{
    _expertUser = expertUser;
    _nameLabel.text = _expertUser.user.name;
}

- (void)layoutSubviews
{
    // TODO
    _nameLabel.frame = CGRectMake(0.f, 0.f, 320.f, 40.f);
}

@end
