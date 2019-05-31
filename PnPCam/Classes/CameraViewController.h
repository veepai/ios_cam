

#import <UIKit/UIKit.h>
#import "EditCameraProtocol.h"
#import "CameraListMgt.h"
#import "PicPathManagement.h"
#import "NotifyEventProtocol.h"
#import "RecPathManagement.h"
#import "PictrueDateViewController.h"
#import "RecordDateViewController.h"
#import "RemoteRecordFileListViewController.h"
#import "AboutViewController.h"
#import "RecordViewController.h"
#import "PopupListComponent.h"
#import "FPPopoverController.h"
#import "PlayViewController.h"
#import "SettingViewController.h"
#import "VSNetProtocol.h"

@interface CameraViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, EditCameraProtocol, VSNetStatueProtocol, VSNetControlProtocol,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationBarDelegate,PopupListComponentDelegate,FPPopoverControllerDelegate,SettingViewControllerDelegate>{
    
    BOOL bEditMode;
    CameraListMgt *cameraListMgt;   
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    NSCondition *ppppChannelMgntCondition;
    
    IBOutlet UITableView *cameraList;
    IBOutlet UINavigationBar *navigationBar;
    
    IBOutlet UIButton *btnAddCamera;
    IBOutlet UIButton *setPushCamera;
    
    id<NotifyEventProtocol> PicNotifyEventDelegate;
    id<NotifyEventProtocol> RecordNotifyEventDelegate;
 
    int cellRow;
    
    PopupListComponent* _actionPop;
    
    FPPopoverController* _fppviewctr;
}
@property (nonatomic, retain) PopupListComponent* actionPop;
@property (nonatomic, retain) FPPopoverController* fppviewctr;
@property (nonatomic, retain) UITableView *cameraList;
@property (nonatomic, retain) UINavigationBar *navigationBar;

@property (nonatomic, retain) UIButton *btnAddCamera;
@property (nonatomic, retain) UIButton *setPushCamera;
@property (nonatomic, assign) CameraListMgt *cameraListMgt;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> PicNotifyEventDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> RecordNotifyEventDelegate;
@property (nonatomic, assign) NSIndexPath* indPath;
@property (nonatomic, retain) PlayViewController* playViewController;
@property (nonatomic, assign) int setCamIndex;


- (void) StopPPPP;
- (void) StartPPPPThread;

- (IBAction)btnAddCameraTouchDown:(id)sender;
- (IBAction)btnAddCameraTouchUp:(id)sender;

- (IBAction)setPushCameraTouchDown:(id)sender;
- (IBAction)setPushCameraTouchUp:(id)sender;

- (NSString*)PathForDocumentStrDID:(NSString*)strDID;
- (NSString*)getPPPPString:(NSString*)strDID;

- (void)pushtoView:(UIViewController*)ViewCtr;
- (void)deleteCamera;
@end
