//
//  AlbumTableViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-1-23.
//
//

#import "AlbumTableViewController.h"

@interface AlbumTableViewController ()

@end

@implementation AlbumTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if ([_mark isEqualToString:@"picture"]) {
            self.title = [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Picture", @STR_LOCALIZED_FILE_NAME, nil)];
        }else if ([_mark isEqualToString:@"record"]){
            self.title = [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _cameraListMgt = nil;
    _m_strDID = nil;
    _delegate  = nil;
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_cameraListMgt GetCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.imageView.image = ([[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_IMG] == nil) ? ([UIImage imageNamed:@"back"]) : ([[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_IMG]);
    cell.textLabel.text = [[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_NAME];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_delegate reloadData:[[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_DID]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

@end
