//
//  RecListCell.m
//  P2PCamera
//
//  Created by mac on 12-11-22.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import "RecListCell.h"

@implementation RecListCell

@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc
{
    self.imageView1 = nil;
    self.imageView2 = nil;
    self.imageView3 = nil;
    self.dateLabel1 = nil;
    self.dateLabel2 = nil;
    self.dateLabel3 = nil;
    [super dealloc];
}

@end
