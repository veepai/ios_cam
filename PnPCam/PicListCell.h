//
//  PicListCell.h
//  P2PCamera
//
//  Created by mac on 12-11-15.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicListCell : UITableViewCell{
    IBOutlet UIImageView *imageView1;
    IBOutlet UIImageView *imageView2;
    IBOutlet UIImageView *imageView3;
    IBOutlet UIImageView *imageView4;
}

@property (nonatomic, retain) UIImageView *imageView1;
@property (nonatomic, retain) UIImageView *imageView2;
@property (nonatomic, retain) UIImageView *imageView3;
@property (nonatomic, retain) UIImageView *imageView4;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel1;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel2;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel3;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel4;
@end
