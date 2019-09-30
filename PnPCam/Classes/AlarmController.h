//
//  AlarmController.h
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropListProtocol.h"

#import "VSNetProtocol.h"

@interface AlarmController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,DropListProtocol, UINavigationBarDelegate,VSNetControlProtocol>
{
    NSString *m_strDID;
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    
    int m_motion_armed;
    int m_motion_sensitivity;
    int m_input_armed;
    int m_ioin_level;
    
    int m_alarmpresetsit;
    
    int m_iolinkage;
    int m_ioout_level;

    int m_mail;
    int m_snapshot;
    int m_record;
    int m_upload_interval;
    
    int m_enable_alarm_audio;
}

@property (copy,nonatomic) NSString *m_strDID;
@property (nonatomic, retain) UITableView *tableView;
@property (retain, nonatomic) UINavigationBar *navigationBar;

@end
