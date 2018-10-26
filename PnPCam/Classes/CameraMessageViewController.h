

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EditCameraProtocol.h"
#import "SearchAddCameraInfoProtocol.h"
#import "CustomMessageCameraCell.h"
#import "ScanStringDelegate.h"
#define TAG_CAMERA_NAME 0
#define TAG_CAMERA_ID 1
//#define TAG_USER_NAME 2
#define TAG_PASSWORD 2
#define STR_DEFAULT_CAMERA_NAME "P2PCam"
#define STR_DEFAULT_USER_NAME "admin"

@interface CameraMessageViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SearchAddCameraInfoProtocol, UINavigationBarDelegate,ScanStringDelegate> {
           
    
    CGFloat textFieldAnimatedDistance;
    BOOL bAddCamera;
    id<EditCameraProtocol> editCameraDelegate;
    NSString *strCameraName;
    NSString *strCameraID;
    NSString *strPwd;
    UITextField *currentTextField;
    UITextView *messageView;
   
    //outlet
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
}

@property BOOL bAddCamera;
@property (nonatomic, assign) id<EditCameraProtocol> editCameraDelegate;
@property (nonatomic, copy) NSString *strCameraName;
@property (nonatomic, copy) NSString *strCameraID;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, assign) CGSize winsize;
@property (nonatomic, assign) UITextView *messageView;

- (void)keyboardWillShowNotification:(NSNotification *)aNotification;
- (void)keyboardWillHideNotification:(NSNotification* )aNotification;
- (void)btnFinished:(id)sender;
//- (CGSize)sceal
- (CGSize)scaleImage:(UIImage*)image;
@end
