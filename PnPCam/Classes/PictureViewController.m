//
//  PictureViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import "PictureViewController.h"
#import "obj_common.h"
#import "PictrueDateViewController.h"
#import "PicDirCell.h"
#import "APICommon.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

@synthesize navigationBar;
@synthesize segmentedControl;
@synthesize m_pCameraListMgt;
@synthesize m_pPicPathMgt;
@synthesize m_tableView;
@synthesize imageBkDefault;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"picture30.png"];
        self.tabBarItem.title = NSLocalizedStringFromTable(@"Picture", @STR_LOCALIZED_FILE_NAME, nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil);

    self.imageBkDefault = [UIImage imageNamed:@"picbk.png"];
}

-(void)Back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    self.navigationBar = nil;
    self.segmentedControl = nil;
    self.m_pCameraListMgt = nil;
    self.m_pPicPathMgt = nil;
    self.m_tableView = nil;
    self.imageBkDefault = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark TableViewDelegate


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection");    
    int count = [m_pCameraListMgt GetCount];
    return count;  
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    
    NSInteger index = anIndexPath.row ;    
    
    //-----------------------------------------------------------------------------------
    NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:index];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
  
    NSString *cellIdentifier = @"CameraPictureListCell";
//    NSLog(@"1 %d",index);
    //当状态为显示当前的设备列表信息时
    PicDirCell *cell =  (PicDirCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicDirCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    int nPicCount = [m_pPicPathMgt GetTotalNumByID:did];
    NSString *strShowName = [NSString stringWithFormat:@"%@(%d)", name,nPicCount];
    
    NSString *strPath = [m_pPicPathMgt GetFirstPathByID:did];
    UIImage *image = [APICommon GetImageByNameFromImage:did filename:strPath];
  
    
    cell.labelName.text = strShowName;
    if (image != nil) {
        cell.imageView.image = image;
        
    }else {
        cell.imageView.image = imageBkDefault;
    }

    
    float cellHeight = cell.frame.size.height;
    float cellWidth = cell.frame.size.width;
    
    //NSLog(@"dddd cellHeight: %f, cellWidth: %f", cellHeight, cellWidth);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 2, cellWidth, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    [cellBgView addSubview:label];
    [label release];
    
    cell.backgroundView = cellBgView;
    
    return cell;
  
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 60;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:anIndexPath.row];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    
    PictrueDateViewController *pictureDateViewController = [[PictrueDateViewController alloc] init];
    pictureDateViewController.strName = name;
    pictureDateViewController.strDID = did;
    pictureDateViewController.NotifyReloadDataDelegate=self;
    pictureDateViewController.m_pPicPathMgt = m_pPicPathMgt;
    pictureDateViewController.cameraListMgt = m_pCameraListMgt;
    [self.navigationController pushViewController:pictureDateViewController animated:YES];
    [pictureDateViewController release];
   
}

#pragma mark performInMainThread
- (void) reloadTableView
{
    [m_tableView reloadData];
}

#pragma mark NotifyReloadDataDelegate
- (void) NotifyReloadData
{
    
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

#pragma mark UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}
@end
