//
//  SettingViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-2.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraEditViewController.h"
#import "CameraListMgt.h"
#import "mytoast.h"
#import "obj_common.h"
#import "EditCameraProtocol.h"
#import "VSNetProtocol.h"

@protocol SettingViewControllerDelegate <NSObject>

- (void) deletecam:(int) camIndex;
- (void) rebootCam:(int) camIndex;

@end

@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate,UIAlertViewDelegate,UITextFieldDelegate,VSNetControlProtocol>{

    NSString *m_strDID;
    NSString *m_strPWD;
    IBOutlet UINavigationBar *navigationBar;
    
    NSDictionary* cameraDic;
    
    CameraListMgt* cameraListMgt;
    id<EditCameraProtocol> editCamerDelegate;
}

@property (copy, nonatomic) NSString *m_strDID;
@property (copy, nonatomic) NSString *m_strPWD;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, assign) id<EditCameraProtocol> editCamerDelegate;
@property (nonatomic, retain) NSDictionary* cameraDic;
@property (nonatomic, retain) CameraListMgt* cameraListMgt;

@property (nonatomic, assign) id<SettingViewControllerDelegate>delegate;
@property (nonatomic, assign) int SetCamIndex;
@property (nonatomic, retain) UITextField* camNameTF;
@property (nonatomic, retain) UITextField* camPwdTF;
@property (nonatomic, retain) IBOutlet UITableView* m_TableView;
@end
