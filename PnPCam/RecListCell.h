//
//  RecListCell.h
//  P2PCamera
//
//  Created by mac on 12-11-22.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecListCell : UITableViewCell{
    IBOutlet UIImageView *imageView1;
    IBOutlet UIImageView *imageView2;
    IBOutlet UIImageView *imageView3;
}

@property (nonatomic, retain) UIImageView *imageView1;
@property (nonatomic, retain) UIImageView *imageView2;
@property (nonatomic, retain) UIImageView *imageView3;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel1;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel2;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel3;

@end
