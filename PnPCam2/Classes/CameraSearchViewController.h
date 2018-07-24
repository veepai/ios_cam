//
//  CameraSearchViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchListMgt.h"
#import "SearchCameraResultProtocol.h"
#import "CameraViewController.h"
#import "SearchAddCameraInfoProtocol.h"

#import "VSNetProtocol.h"
#import "VSNet.h"

@interface CameraSearchViewController : UIViewController<VSNetSearchCameraResultProtocol,
UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>{
    IBOutlet UITableView *SearchListView;
    IBOutlet UINavigationBar *navigationBar;
    
    SearchListMgt *searchListMgt;
    NSTimer *searchTimer;
    
    BOOL bSearchFinished;
    
    CameraViewController *cameraViewController;
    
    id<SearchAddCameraInfoProtocol> SearchAddCameraDelegate;
}

@property (nonatomic,assign) CameraViewController *cameraViewController;
@property (nonatomic, retain) IBOutlet UITableView *SearchListView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, assign) id<SearchAddCameraInfoProtocol> SearchAddCameraDelegate;

@end
