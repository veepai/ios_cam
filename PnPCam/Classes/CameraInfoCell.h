//
//  CameraInfoCell.h
//  IpCameraClient
//
//  Created by apple on 12-6-6.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraInfoCell : UITableViewCell
{
    IBOutlet UILabel *keyLable;
    IBOutlet UITextField *textField;
}

@property (nonatomic, retain) UILabel *keyLable;
@property (nonatomic, retain) UITextField *textField;

@end
