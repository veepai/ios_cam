//
//  IpCameraClientAppDelegate.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "PlayViewController.h"
#import "CameraViewController.h"
#import "CameraListMgt.h"
#import "PicPathManagement.h"
#import "RecPathManagement.h"

#import "PictureViewController.h"
#import "RecordViewController.h"
#import "RemotePlaybackViewController.h"
#import "Split-screenViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "MyNavigationController.h"
#define IOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define IOS10 ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@class LoginViewController;
@interface IpCameraClientAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate,UNUserNotificationCenterDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSXMLParserDelegate> {
    
    IBOutlet UIWindow *window;    
    MyNavigationController *navigationController;
    StartViewController *startViewController;    
    PlayViewController *playViewController;
    CameraViewController *cameraViewController;
   
    PictureViewController *picViewController;
    RecordViewController *recViewController;
    RemotePlaybackViewController *remotePlaybackViewController;
    
    CameraListMgt *m_pCameraListMgt;
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    
    NSString* DownVer;
    Split_screenViewController* spliteScreenVc;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MyNavigationController *navigationController;
@property (nonatomic, retain) StartViewController *startViewController;
@property (nonatomic, retain) PlayViewController *playViewController;
@property (nonatomic, retain) RemotePlaybackViewController *remotePlaybackViewController;
@property (nonatomic, retain) NSMutableData* downLoadData;
@property (nonatomic, retain) NSString* DownVer;
@property (nonatomic, retain) NSString* DownUpdataContents;
@property (nonatomic, retain) NSString* UpdaUrl;
@property (nonatomic, retain) NSMutableString* DowntmpStr;
@property (nonatomic, retain) CameraViewController* cameraViewController;
@property (nonatomic, retain) LoginViewController* loginVc;

- (void) switchPlayView: (PlayViewController *)playViewController;
- (void) switchRemotePlaybackView: (RemotePlaybackViewController*)_remotePlaybackViewController;
- (void) switchBack;
- (void) switchSpliteScreen:(Split_screenViewController*)_split;
+(BOOL)is43Version;

@end

