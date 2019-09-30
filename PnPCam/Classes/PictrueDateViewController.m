//
//  PictrueDateViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import "PictrueDateViewController.h"
#import "obj_common.h"
#import "PictureListViewController.h"
#import "PicDirCell.h"
#import "APICommon.h"
#import "CameraListCell.h"
#import "PPPPDefine.h"
@interface PictrueDateViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation PictrueDateViewController

@synthesize m_pPicPathMgt;
@synthesize strDID;
@synthesize strName;
@synthesize navigationBar;
@synthesize tableView;
@synthesize imageBkDefault;
@synthesize NotifyReloadDataDelegate;
@synthesize picMgt;
@synthesize cameraListMgt;
@synthesize popovewCtr;
@synthesize menuTableCtr;
@synthesize menutableView;
@synthesize popList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    picDataArray = nil;
    picDataArray = [m_pPicPathMgt GetTotalPicDataArray:strDID] ;
    
    self.navigationItem.title = strName;
    UIImage* albumImg = [UIImage imageNamed:@"Camera"];
    UIImage* newalbumImg = [self fitImage:albumImg tofitHeight:35];
    UIButton* albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    albumBtn.backgroundColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    albumBtn.frame = CGRectMake(0, 0, newalbumImg.size.width, newalbumImg.size.height);
    albumBtn.layer.cornerRadius = 4.0f;
    albumBtn.layer.masksToBounds  =YES;
    [albumBtn setImage:newalbumImg forState:UIControlStateNormal];
    [albumBtn addTarget:self action:@selector(album:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithCustomView:albumBtn];
    self.navigationItem.rightBarButtonItem  = rightBar;
    [rightBar release];

    self.imageBkDefault = [UIImage imageNamed:@"picbk.png"];

    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height{
    CGSize imagesize = image.size;
    CGFloat scale;
    if (imagesize.height > height) {
        scale = imagesize.height / height;
    }
    imagesize = CGSizeMake(imagesize.width/scale, height);
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}


-(void)album:(id)sender
{
    int count = [cameraListMgt GetCount];
    AlbumTableViewController* albumTable = [[AlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    albumTable.cameraListMgt = self.cameraListMgt;
    albumTable.delegate =self;
    albumTable.mark = @"picture";
    FPPopoverController* fppView = [[FPPopoverController alloc] initWithViewController:albumTable];
    fppView.delegate = self;
    fppView.contentSize = CGSizeMake(190, 45*(count + 1.55));
    [fppView presentPopoverFromView:sender];
    
    _fPPopoverCtr = [fppView retain];
    [fppView release];
    fppView = nil;
    [albumTable release];
    albumTable = nil;
}


#pragma mark AlbumTableViewControllerDelegate
- (void)reloadData:(NSString*)strUID{
    if (self.fPPopoverCtr != nil) {
        [self.fPPopoverCtr dismissPopoverAnimated:YES];
    }
    self.strDID = strUID;
    picDataArray = [m_pPicPathMgt GetTotalPicDataArray:strDID] ;
    [self.tableView reloadData];
}

#pragma mark FPPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController{
    if (popoverController != nil) {
        [popoverController release];
        popoverController = nil;
    }
}

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController{
    
}

#pragma mark PopupListComponentDelegate
- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId{
    
}
- (void) popupListcompoentDidCancel:(PopupListComponent *)sender{
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    
    if (popovewCtr) {
        
        [popovewCtr release];
        popovewCtr = nil;
        if (menuTableCtr) {
            [menuTableCtr release];
            menuTableCtr = nil;
        }
    }
    
    if (_fPPopoverCtr != nil) {
        [_fPPopoverCtr release];
        _fPPopoverCtr = nil;
    }
    [self.menutableView release];
    self.menutableView = nil;

    
    self.m_pPicPathMgt = nil;
    self.strDID = nil;
    self.navigationBar = nil;
    self.strName = nil;
    self.tableView = nil;
    self.imageBkDefault = nil;
    self.cameraListMgt = nil;
    self.picMgt = nil;
    self.cameraListMgt = nil;
    self.m_pPicPathMgt = nil;

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection11111");
    if (aTableView == menutableView) {
        return [cameraListMgt GetCount];
    }
    
    if (picDataArray == nil || [picDataArray count] == 0) {
        return 0;
    }else{
        int i = 0;
        for (NSDictionary* dic in picDataArray){
            NSString* strDate = [[dic allKeys] objectAtIndex:0];
            int nPicCount = [m_pPicPathMgt GetTotalNumByIDAndDate:strDID Date:strDate];
            if (nPicCount == 0) {
                i++;
            }
        }
        return ([picDataArray count] - i);
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    if (aTableView == tableView) {
        
    NSDictionary *datePicDic = [picDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    NSString *cellIdentifier = @"PictureDateListCell";       
    //当状态为显示当前的设备列表信息时
    PicDirCell *cell =  (PicDirCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicDirCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    int nPicCount = [m_pPicPathMgt GetTotalNumByIDAndDate:strDID Date:strDate];
    if (nPicCount == 0) {
        return nil;
    }
        
    NSString *strShowName = [NSString stringWithFormat:@"%@(%d)", strDate, nPicCount];
    NSString *strPath = [m_pPicPathMgt GetFirstPathByIDAndDate:strDID Date:strDate];
    UIImage *image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
    
    cell.labelName.text = strShowName;
    cell.labelName.text = strShowName;
    if (image != nil) {
        cell.imageView.image = image;
    }else {
        cell.imageView.image = imageBkDefault;
    }
    
    float cellHeight = cell.frame.size.height;
    float cellWidth = cell.frame.size.width;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 2, cellWidth, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    [cellBgView addSubview:label];
    [label release];
    
    cell.backgroundView = cellBgView;
    return cell;
    }else{
        static NSString* celliden = @"cell";
        CameraListCell* cell = (CameraListCell*)[aTableView dequeueReusableCellWithIdentifier:celliden];
        
        if (cell == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CameraListCell" owner:self options:nil];
            
            cell = [nib objectAtIndex:0];
        }

        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if (tableview == menutableView) {
        return 75;
    }
    return 60;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *datePicDic = [picDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    PictureListViewController *picListViewController = [[PictureListViewController alloc] init];
    picListViewController.strDID = strDID;
    picListViewController.strDate = strDate;
    picListViewController.m_pPicPathMgt = m_pPicPathMgt;
    picListViewController.cameraListMgt = self.cameraListMgt;
    picListViewController.NotifyReloadDataDelegate=self;
    picListViewController.strName = self.strName;
    [self.navigationController pushViewController:picListViewController animated:YES];
    [picListViewController release];
    
}

#pragma mark perfortInMainThread
-(void)reloadTableViewData{
    [self.tableView reloadData];
}

#pragma mark NotifyReloadData
-(void)NotifyReloadData{
    if(self.NotifyReloadDataDelegate!=nil){
        [self.NotifyReloadDataDelegate NotifyReloadData];
    }
    
    picDataArray = [m_pPicPathMgt GetTotalPicDataArray:strDID] ;
    [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:NO];
}


#pragma mark uinavigationbardelegate
- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [popovewCtr dismissPopoverAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];

    return NO;
}

@end
