//
//  PlaybackViewController.h
//  P2PCamera
//


#import <UIKit/UIKit.h>
#import "IJKSDLGLView.h"

@interface RemotePlaybackViewController : UIViewController<UINavigationBarDelegate>{
    IBOutlet UIImageView *imageView;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIActivityIndicatorView *progressView;
    IBOutlet UILabel *LblProgress;
    
    
    NSString *strDID;
    
    UIView *bottomView;
    UIButton *playButton;
    UILabel *startLabel;
    UILabel *endLabel;
    
        
    int m_nTotalTime;
    
    BOOL m_bPlayPause;
    BOOL m_bHideToolBar;
    
    IJKSDLGLView *myGLViewController;
    int m_nScreenHeight;
    int m_nScreenWidth;
    
    NSCondition *m_playbackstoplock;
    
    NSString *m_strFileName;
    //CPPPPChannelManagement *m_pPPPPMgnt;
    NSString *m_strName;
    
}

@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UIActivityIndicatorView *progressView;
@property (nonatomic, retain) UILabel *LblProgress;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, retain) NSString *m_strFileName;
//@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPMgnt;
@property (nonatomic, copy) NSString *m_strName;
@property (nonatomic, assign) int record_Size;
@property (nonatomic, assign) NSInteger playLength;

- (void) StopPlayback;


@end
