//
//  PlaybackViewController.m
//  P2PCamera

#import "RemotePlaybackViewController.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"

#import "VSNet.h"
#import "VSNetProtocol.h"
#import <Photos/Photos.h>
#import "PHPhotoLibrary+SaveAndGetVideo.h"
#import "CustomToast.h"


@interface RemotePlaybackViewController ()<TFCardProtocol>
{
    BOOL changeSliderValue;
    float mfCachePospos;
    BOOL userTouch;
}
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@end



@implementation RemotePlaybackViewController

@synthesize navigationBar;
@synthesize imageView;
@synthesize strDID;
@synthesize m_strFileName;
@synthesize m_strName;
@synthesize progressView;
@synthesize LblProgress;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"回放开始");
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) StopPlayback
{
    [m_playbackstoplock lock];
    [[VSNet shareinstance] stopPlayBack:strDID];
    IpCameraClientAppDelegate *IPCamDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    [IPCamDelegate switchBack];
    [m_playbackstoplock unlock];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    userTouch = NO;
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    CGPoint center = CGPointMake(winsize.height/2, winsize.width/2);
    progressView.center = center;
    LblProgress.center = center;
    m_bPlayPause = NO;
    m_bHideToolBar = NO;
    myGLViewController = nil;
    
    self.imageView.backgroundColor = [UIColor grayColor];
    m_playbackstoplock = [[NSCondition alloc] init];

    CGRect getFrame = [[UIScreen mainScreen]applicationFrame];
    m_nScreenHeight = getFrame.size.width;
    m_nScreenWidth = getFrame.size.height;
    
    navigationBar.barStyle = UIBarStyleBlackTranslucent;
    navigationBar.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"navbk.png"];
    if ([IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBar.alpha = 0.6f;
    
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:m_strName];
    
    NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    [navigationBar setItems:array];
    
    [item release];
    [back release];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
    [imageGR setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:imageGR];
    [imageGR release];
    
    
   
    
    
    //-------------bottomView--------------------------------------
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame] ;
    float bottomViewHeight = 60 ;
    float bottomViewX = 0;
    float bottomViewY = screenRect.size.width - bottomViewHeight ;
    float bottomViewWidth = screenRect.size.height;
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    bottomView.alpha = 0.6f ;
    bottomView.userInteractionEnabled = YES;
    CGRect rectLabel = bottomView.bounds;
    
    UILabel *fileNameLabel = [[UILabel alloc] initWithFrame:rectLabel];
    fileNameLabel.textAlignment = NSTextAlignmentCenter;
    fileNameLabel.text = m_strFileName;
    fileNameLabel.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    fileNameLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:fileNameLabel];
    fileNameLabel.userInteractionEnabled = YES;
    [fileNameLabel release];
    
    [self.view addSubview:bottomView];
    CGRect rect = bottomView.bounds;
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20.f, 0.f, CGRectGetWidth(rect) - 40.f, 20.f)];
    [self.slider addTarget:self action:@selector(dragVideoProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(begindragVideoPress:) forControlEvents:UIControlEventTouchDown];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1;
    [bottomView addSubview:self.slider];
    self.LblProgress.text = NSLocalizedStringFromTable(@"Connecting", @STR_LOCALIZED_FILE_NAME,nil);
    self.LblProgress.textColor = [UIColor whiteColor];
    [self.progressView startAnimating];
    self.playLength = 0;
    
    //=====================================================================
    NSLog(@"strDID%@",strDID);
    NSLog(@"m_strFileName%@",m_strFileName);
    [[VSNet shareinstance] startPlayBack:strDID fileName:m_strFileName withOffset:0 fileSize:_record_Size delegate:self SupportHD:1];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



- (void)begindragVideoPress:(UISlider *)slider {
    userTouch = YES;
}

- (void) dragVideoProgress:(UISlider*) slider {
    float pos =  slider.value;
    float newPos = pos / mfCachePospos ;
    NSLog(@"dragVideoProgress pos:%f CachePospos:%f newPos:%f",pos,mfCachePospos,newPos);
    //拖动的进度不能超出缓冲的进度，比如缓冲进度是50%那么拖的就不能超过半个进度条（也就是50%）
    if(pos >= mfCachePospos)
        newPos = 1.0;
    
    [m_playbackstoplock lock];
    NSTimeInterval time = [[VSNet shareinstance] movePlaybackPos:strDID POS:newPos];
    NSLog(@"dragVideoProgress time:%f",time);
    if (time >0)
        [[VSNet shareinstance] setPlaybackPos:strDID time:time];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        userTouch = NO;
    }];
    [m_playbackstoplock unlock];
}



- (void) startPlayBackLiveStream
{
     [[VSNet shareinstance] startPlayBack:strDID fileName:m_strFileName withOffset:0 fileSize:_record_Size delegate:self SupportHD:1];
}

- (void) stopPlaybackLiveStream{
    
    [m_playbackstoplock lock];
    
    [[VSNet shareinstance] stopPlayBack:strDID];
    [m_playbackstoplock unlock];
    
}

- (void) PlayEnd:(id) sender{
    self.playLength = self.record_Size;
    self.slider.value = self.playLength;
    [mytoast showWithText:@"播放结束"];
    
}

- (void) imageTouched: (UITapGestureRecognizer*)sender
{
    m_bHideToolBar = !m_bHideToolBar ;
    [navigationBar setHidden:m_bHideToolBar];
    [bottomView setHidden:m_bHideToolBar];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 6.0) {//ios6
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        CGRect rectScreen = [[UIScreen mainScreen] applicationFrame];
        self.view.frame = rectScreen;//CGRectMake(0,0,480,320);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    if (bottomView != nil) {
        [bottomView release];
        bottomView = nil;
    }
    if (playButton != nil) {
        [playButton release];
        playButton = nil;
    }
}

- (void) CreateGLView
{
    if (myGLViewController != nil) {
        return;
    }
    
    myGLViewController = [[IJKSDLGLView alloc] initWithFrame:CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight)];
    myGLViewController.backgroundColor = [UIColor blackColor];
    myGLViewController.userInteractionEnabled = YES;
    
   
    [self.view addSubview:myGLViewController];
    [self.view bringSubviewToFront:navigationBar];
    [self.view bringSubviewToFront:bottomView];
    
    //下载功能
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(0 , self.view.frame.size.height/2, 60, 35);
    downloadButton.backgroundColor = [UIColor redColor];
    [downloadButton addTarget:self action:@selector (downstartBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [downloadButton setTitle:@"下载" forState:0];
   // downloadButton.tag = 1;
      NSLog(@" download");
    [self.view addSubview:downloadButton];
}

- (void) downstartBtn
{
    NSLog(@"start download");
    NSArray *temArr = [m_strFileName componentsSeparatedByString:@"."];
    NSString *temPath = NSTemporaryDirectory();
    NSString *path = [NSString stringWithFormat:@"%@%@%@.mp4",temPath,strDID,temArr.firstObject];
    NSLog(@"start download %@",path);
    //NSLog(@"start download%@",m_strFileName);
    //NSLog(@"start download%@",strDID);
    //NSLog(@"start download%d",_height);
    //NSLog(@"start download%d",_width);
    // [[VSNet shareinstance]startRcrodTF:self.strDID m_strFileName:m_strFileName width:(int)_width height:(int)_height];
    [[VSNet shareinstance]startRcrodTF:self.strDID fileName:path width:(int)_width height:(int)_height];
}

- (void) dealloc
{
    self.navigationBar = nil;
    self.imageView = nil;
    self.strDID = nil;
    self.m_strFileName = nil;
    self.m_strName = nil;
    self.progressView = nil;
    self.LblProgress = nil;
    
    if (bottomView != nil) {
        [bottomView release];
        bottomView = nil;
    }
    
    if (myGLViewController != nil) {
        [myGLViewController release];
        myGLViewController = nil;
    }
    
    if (m_playbackstoplock != nil) {
        [m_playbackstoplock release];
        m_playbackstoplock = nil;
    }
    [super dealloc];
}

#pragma mark performOnMainThread
- (void) updateImage: (UIImage*) image
{
    imageView.image = image;
    // [image release];
}

- (void) hideView
{
    [self.progressView setHidden:YES];
    [self.LblProgress setHidden:YES];
}

#pragma mark navigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self StopPlayback];
    return NO;
}


#pragma mark - TFCardProtocol(TF卡视频播放回调)
- (void) TFYUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp szdid:(NSString*)szdid pos:(float)fpos cachePos:(float)fCachePospos VType:(int)nType
{
    [self performSelectorOnMainThread:@selector(hideView) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:NO];
    mfCachePospos = fCachePospos;
    SDL_VoutOverlay stOverlay;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timestamp];
    //NSLog(@"cachePos : %f pos: %f ",fCachePospos,fpos);
    //NSLog(@"date : %@ ,  pos : %f",date,fpos);
    _width = width;
    _height = height;
    memset(&stOverlay, 0, sizeof(stOverlay));
    stOverlay.w = (int)width ;
    stOverlay.h = (int)height;
    stOverlay.pitches[0] = width;
    stOverlay.pitches[1] = stOverlay.pitches[2] = width /2;
    stOverlay.pixels[0] = yuv;
    stOverlay.pixels[1] = yuv + width*height;
    stOverlay.pixels[2] = yuv + width*height*5/4;
    [myGLViewController display:&stOverlay];
    if (userTouch == NO) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.slider setValue:fpos];

        }];
    }
 
}

- (void) TFImageNotify: (id)image timestamp: (NSInteger)timestamp szdid:(NSString*)szdid pos:(float)fpos cachePos:(float)fCachePospos
{
    [self performSelectorOnMainThread:@selector(hideView) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
}

//ret 1 &&fpos == 1成功;  -1 失败
- (void) TFRECORDNotify:(int)ret  pos:(float)fpos szdid:(NSString*)szdid
{
    //NSLog(@"vst download%d",ret);
     //NSLog(@"vst download%f",fpos);
     if (fpos == 1 && ret == 1 ) {
         [self saveVideo];
     }
}

-(void)saveVideo {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        NSLog(@"status %ld",(long)status);
        
        if (status == PHAuthorizationStatusAuthorized ) {
            NSString *albumName = @"pnpcam";
            NSString *localVideoPath = [self getPathWithFileName:self.m_strFileName];
             NSLog(@"保存视频成功 dict %@",albumName);
            NSLog(@"保存视频成功 localVideoPath %@",localVideoPath);
            [PHPhotoLibrary saveVideo:localVideoPath assetCollection: albumName result:^(BOOL success, NSString *identify) {
                if (success) {
                   
                    NSMutableDictionary *dict = [([[NSUserDefaults standardUserDefaults]objectForKey:@"pnpcam"] ?:@{}) mutableCopy];
                    NSString *localKey = [self getLocalVideoKey];
                    dict[localKey] = identify; //创建索引,以视频路径为key,identify用于获取视频.
                    [[NSUserDefaults standardUserDefaults]setObject:(id)dict forKey: @"pnpcam"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    NSLog(@"保存视频成功 dict %@",@"suc");
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [CustomToast showWithText:NSLocalizedStringFromTable(@"TakePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
//                                        superView:self.view
//                                        bLandScap:YES];
                
                    });
                }else {
                    //[SVProgressHUD showErrorWithStatus:@"OperationFailure"];
                    NSLog(@"fail");
                }
            }];
            
        }else {
              NSLog(@"status %ld",(long)status);
            
        }
    }];
    
}

-(NSString *)getLocalVideoKey {
    NSString *videoKey = [NSString stringWithFormat:@"%@%@",strDID,self.m_strFileName];

    NSInteger correctModel = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",strDID,@FactoryParamCorrectModelTag]] integerValue];
    if (correctModel == CorrectModelC60 || correctModel == CorrectModelD93){
        videoKey = [NSString stringWithFormat:@"%@%@%@",strDID,self.m_strFileName,@"QuanJinKey"];
    }
    return videoKey;
}

- (NSString *)getPathWithFileName:(NSString *)fileName {//底层缓存的格式为: 没有后缀的，UID+文件名+playback
    NSArray *temArr = [fileName componentsSeparatedByString:@"."];
    NSString *temPath = NSTemporaryDirectory();
    NSString *path = [NSString stringWithFormat:@"%@%@%@.mp4",temPath,strDID,temArr.firstObject];
    NSLog(@"filePath %@",path);
    return path;
}
@end
