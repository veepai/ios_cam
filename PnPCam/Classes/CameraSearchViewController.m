//
//  CameraSearchViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CameraSearchViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "CameraEditViewController.h"

@interface CameraSearchViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation CameraSearchViewController

@synthesize SearchListView;
@synthesize navigationBar;
@synthesize cameraViewController;
@synthesize SearchAddCameraDelegate;

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

    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    bSearchFinished = NO;    
    
    [self showLoadingIndicator];    
    searchListMgt = [[SearchListMgt alloc] init];    

    [self startSearch];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self stopSearch];
    self.SearchListView = nil;
    [searchListMgt release];
    self.searchListView = nil;
    self.navigationBar = nil;
    self.SearchAddCameraDelegate = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleTimer:(NSTimer *)timer
{
    NSLog(@"handleTimer");
    //time is up, invalidate the timer
    [searchTimer invalidate];  
    
    [self stopSearch];    
    
    bSearchFinished = YES;
    [self hideLoadingIndicator];
    
    [SearchListView reloadData];    
    
}

- (void) startSearch
{
    [[VSNet shareinstance] StartSearchDVS:self];
    //create the start timer
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];    
}

- (void) stopSearch
{    
    [[VSNet shareinstance] StopSearchDVS];
}


- (void) btnRefresh: (id) sender
{
    //NSLog(@"btnRefresh");
    [self showLoadingIndicator];
    [searchListMgt ClearList];
    [SearchListView reloadData];
    [self startSearch];
}

- (void)showLoadingIndicator
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"SearchCamera", @STR_LOCALIZED_FILE_NAME, nil);
	UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = progress;
    [progress release];
}

- (void)hideLoadingIndicator
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"SearchCamera", @STR_LOCALIZED_FILE_NAME, nil);
	UIBarButtonItem *refreshButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
     target:self
     action:@selector(btnRefresh:)];
	//[self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (bSearchFinished == NO) {
        return 0;
    }
    
    return [searchListMgt GetCount];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{

    NSDictionary *cameraDic = [searchListMgt GetCameraAtIndex:anIndexPath.row];
    
    NSString *cellIdentifier = @"SearchListCell";	       
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        [cell autorelease];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    //NSLog(@"name: %@, addr: %@", name, addr);
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = did;
	
	return cell;
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 50.0;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *cameraDic = [searchListMgt GetCameraAtIndex:anIndexPath.row];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    [SearchAddCameraDelegate AddCameraInfo:name DID:did];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark SearchCamereResultDelegate
- (void) VSNetSearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did
{
    if ([did length] == 0) {
        return;
    }
    [searchListMgt AddCamera:mac Name:name Addr:addr Port:port DID:did];
}


#pragma mark navigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}


@end
