//
//  oTextCell.h
//  P2PCamera
//
//  Created by mac on 12-10-26.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface oTextCell : UITableViewCell
{
    
    IBOutlet UILabel *keyLable;
    IBOutlet UITextField *textField;
}
    
@property (nonatomic, retain) UILabel *keyLable;
@property (nonatomic, retain) UITextField *textField;

@end
