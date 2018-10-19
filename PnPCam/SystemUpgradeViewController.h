//
//  SystemUpgradeViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-7-26.
//
//

#import <UIKit/UIKit.h>
#import "CameraStatusProtocol.h"

@interface SystemUpgradeViewController : UIViewController< NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
}

@property (nonatomic, retain) NSString* str_uid;
@property (nonatomic, retain) NSString* str_ipaddr;
@property (nonatomic, retain) NSString* str_pwd;
@property (nonatomic, retain) NSString* str_port;
@property (nonatomic, retain) UITableView* aTabelView;
@end
