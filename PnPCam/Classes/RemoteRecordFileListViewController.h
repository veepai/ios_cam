//
//  RemoteRecordFileListViewController.h
//  P2PCamera
//
//  Created by Tsang on 12-12-14.
//
//

#import <UIKit/UIKit.h>
#import "CameraListMgt.h"
#import "RecPathManagement.h"
#import "RecordViewController.h"
#import "RemoteRecordCell.h"
#import "RemoteRecordGroupCell.h"

@interface RemoteRecordFileListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UINavigationBarDelegate,UIActionSheetDelegate>
{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    
    NSCondition *m_timerLock;
    NSTimer *m_timer;
    BOOL m_bFinished;
    CameraListMgt* cameraListMgt;
    RecPathManagement* recPathMgt;
    RecordViewController* recViewCtr;
    NSString *m_strDID;
    NSString *m_strName;
    NSString *m_strPWD;
    
    NSMutableArray *m_RecordFileList;
    
    NSMutableArray* _m_RecordTypeparameter;
    
    NSMutableArray* _m_RecordDate;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, copy) NSString *m_strDID;
@property (nonatomic, copy) NSString *m_strName;
@property (nonatomic, retain) CameraListMgt* cameraListMgt;
@property (nonatomic, retain) RecPathManagement* recPathMgt;
@property (nonatomic, retain) RecordViewController* recViewCtr;
@property (nonatomic, retain) NSMutableArray* m_RecordTypeparameter;
@property (nonatomic, retain) NSMutableArray* m_RecordDate;
@property (nonatomic, retain) NSString* dateStr;
@property (nonatomic, retain) NSString*m_strPWD;

@property int pageindex;
@property int recordCount;
- (void)refreshData:(NSIndexPath*)anIndexPath;
- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height;
@end
