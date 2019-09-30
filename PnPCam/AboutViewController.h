//
//  AboutViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-15.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface AboutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationBarDelegate>{
    
    IBOutlet UINavigationBar *navigationBar;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;

@end
