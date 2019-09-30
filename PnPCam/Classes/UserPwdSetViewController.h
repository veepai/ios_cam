//
//  UserPwdSetViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-24.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CameraListMgt.h"
#import "PPPPDefine.h"
#import "VSNetProtocol.h"

#define TAG_USER 0
#define TAG_PWD 1


@interface UserPwdSetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate,UIAlertViewDelegate,VSNetControlProtocol>{
    
    NSString *m_user1;
    NSString *m_pwd1;
    NSString *m_user2;
    NSString *m_pwd2;
    NSString *m_strDID;
   
    CGFloat textFieldAnimatedDistance;
    
    NSString *m_strUser;
    NSString *m_strPwd;
    UITextField *currentTextField;
    UITextField *textUser;
    UITextField *textPassword;
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;

    NSTimer* timer;
    
    UIAlertView* alertView;
}
@property (retain, nonatomic) UIAlertView* alertView;
@property (retain, nonatomic) NSTimer* timer;
@property (copy, nonatomic) NSString *m_strDID;

@property (copy, nonatomic) NSString *cameraName;

@property (copy,nonatomic) NSString *m_user1;
@property (copy,nonatomic) NSString *m_pwd1;
@property (copy,nonatomic) NSString *m_user2;
@property (copy,nonatomic) NSString *m_pwd2;

@property (copy, nonatomic) NSString *m_strUser;
@property (copy, nonatomic) NSString *m_strPwd;
@property (nonatomic, retain) UITextField *currentTextField;
@property (retain, nonatomic) UITextField *textUser;
@property (retain, nonatomic) UITextField *textPassword;

@property (nonatomic, retain) UITableView *tableView;
@property (retain, nonatomic) UINavigationBar *navigationBar;

@property (nonatomic, retain) CameraListMgt* cameraListMgt;

- (void)keyboardWillShowNotification:(NSNotification *)aNotification;
- (void)keyboardWillHideNotification:(NSNotification* )aNotification;
- (void) btnSetUserPwd:(id) sender;

@end
