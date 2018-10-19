//
//  PictureShowViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureShowViewController.h"
#import "obj_common.h"
#import "CustomToast.h"

@interface PictureShowViewController ()

@end

@implementation PictureShowViewController

@synthesize strDID;
@synthesize picPathArray;
@synthesize m_currPic;
@synthesize strDate;
@synthesize m_pPicPathMgt;
@synthesize NotifyReloadDataDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) image: (UIImage*)image didFinishSavingWithError: (NSError*) error contextInfo: (void*)contextInfo
{
    if (error != nil) {
        NSLog(@"take picture failed");
    }else {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"SavePictureSuccess", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view 
                        bLandScap:NO];
    }
}

- (void) btnAction: (id) sender
{
    UIImage *image = [self GetImageByName:strDID filename:[picPathArray objectAtIndex:m_currPic]];
    if (image == nil) {
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void) btnDelete: (id) sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Message", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"DeletePicture", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    
    [alert show];
    [alert release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.wantsFullScreenLayout = YES;
    self.view.frame = [[UIScreen mainScreen] bounds];

    camDelete = NO;
    cycleScrollView = [[XLCycleScrollView alloc] initWithFrame:self.view.bounds];
    cycleScrollView.currentPage = m_currPic;
    cycleScrollView.delegate = self;
    cycleScrollView.datasource = self;
    [self.view addSubview:cycleScrollView];
    deleteMark = 0;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    NSString* picPath = [picPathArray objectAtIndex:m_currPic];
    int length = [picPath length];
    self.navigationItem.title = [NSString stringWithFormat:@"%@_%@",_strName,[[picPathArray objectAtIndex:m_currPic] substringWithRange:NSMakeRange(length - 12, 8)]];
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 57 - 44, self.view.frame.size.width , 49)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;

    UIBarButtonItem *ActionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnAction:)];
    UIBarButtonItem *FlexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *DeleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(btnDelete:)];

    NSArray *toolBarItems = [[NSArray alloc] initWithObjects:ActionItem, FlexItem, DeleteItem, nil];

    [toolBar setItems:toolBarItems animated:YES];

    [self.view addSubview:toolBar];
    [ActionItem release];
    [FlexItem release];
    [DeleteItem release];
    [toolBarItems release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) dealloc
{
    self.strName = nil;
    self.cameraListMgt = nil;
    self.strDID = nil;
    self.picPathArray = nil;
    self.m_currPic = nil;
    if (navigationBar != nil) {
        [navigationBar release];
        navigationBar = nil;
    }
    if (toolBar != nil) {
        [toolBar release];
        toolBar = nil;
    }
    self.strDate = nil;
    self.m_pPicPathMgt = nil;
    if (cycleScrollView != nil) {
        [cycleScrollView release];
        cycleScrollView = nil;
    }
    self.NotifyReloadDataDelegate = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIImage*) GetImageByName: (NSString*)did filename:(NSString*)filename
{
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];
    strPath = [strPath stringByAppendingPathComponent:filename];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *image = [UIImage imageWithContentsOfFile:strPath];
    return image;
}

- (UIImageView*) GetImageViewRectByImage: (UIImage*) image
{
    if (image == nil) {
        return nil;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect imageViewFrame;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float screenWidth = screenRect.size.width;
    float screenHeight = screenRect.size.height;
    float imageScreenWidth = 0;
    float imageScreenHeight = screenWidth * imageHeight / imageWidth ;
    if (imageScreenHeight > screenHeight) {
        imageScreenHeight = screenHeight;
        imageScreenWidth = imageWidth * screenHeight / imageHeight ;
    }else {
        imageScreenWidth = screenWidth;
    }
    
    float centerX = screenWidth / 2;
    float centerY = screenHeight / 2;
    
    imageViewFrame.origin.x = centerX - imageScreenWidth / 2;
    imageViewFrame.origin.y = centerY - imageScreenHeight / 2;
    imageViewFrame.size.width = imageScreenWidth;
    imageViewFrame.size.height = imageScreenHeight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = image;
    [imageView autorelease];
    
    return imageView;
}


#pragma mark XLCycleScrollViewDelegate
- (void)popView{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfPages
{
    return [picPathArray count];
}

- (UILabel*) newLable
{
    return [[[UILabel alloc] init] autorelease];
}

//不能返回nil
- (UIView *)pageAtIndex:(NSInteger)index
{
    if (index >= [picPathArray count]) {
        camDelete = NO;
        return [self newLable];
    }
    
    UIImage *image = [self GetImageByName:strDID filename:[picPathArray objectAtIndex:index]];
    if (deleteMark == 3) {
        deleteMark = 0;
    }
    if (++deleteMark == 2) {
        NSString* picPath = [picPathArray objectAtIndex:index];
        int length = [picPath length];
        self.navigationItem.title = [NSString stringWithFormat:@"%@_%@",_strName,[[picPathArray objectAtIndex:index] substringWithRange:NSMakeRange(length - 12, 8)]];
        if (camDelete) {
            camDelete = NO;
            
        }
    }
     
    
    UIImageView * imageView = [self GetImageViewRectByImage:image];
    if (imageView == nil) {
        return [self newLable];
    }
    
    return imageView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
 
}

- (void) currentPage:(NSInteger)index
{
    m_currPic = index;

}


#pragma mark AlertViewDelete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{  
    if (buttonIndex == 1) {
        if(m_currPic >= [picPathArray count])
            return ;
        
        NSString *fileName = [picPathArray objectAtIndex:m_currPic];
        if (fileName == nil) {
            return ;
        }
        if([m_pPicPathMgt RemovePicPath:strDID PicDate:strDate PicPath:fileName]){
            camDelete = YES;
            //deleteMark = 3;
            [NotifyReloadDataDelegate NotifyReloadData];
            [cycleScrollView reloadData];
        }
    }

}


#pragma mark navigationBardelegate
- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

@end
