//
//  oSwitchCell.h
//  P2PCamera
//
//  Created by mac on 12-10-26.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface oSwitchCell : UITableViewCell
{
IBOutlet UILabel *keyLable;
IBOutlet UISwitch *keySwitch;
}

@property (nonatomic, retain) UILabel *keyLable;
@property (nonatomic, retain) UISwitch *keySwitch;
@end
