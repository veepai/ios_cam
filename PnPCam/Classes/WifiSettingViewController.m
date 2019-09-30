//
//  WifiSettingViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-8.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import "WifiSettingViewController.h"
#import "WifiPwdViewController.h"
#import "obj_common.h"
#import "CameraViewController.h"

#import "VSNet.h"
#import "cmdhead.h"
#import "APICommon.h"
#import "NSString+subValueFromRetString.h"

@interface WifiSettingViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation WifiSettingViewController

@synthesize m_strSSID;
@synthesize m_strWEPKey;
@synthesize m_strWPA_PSK;
@synthesize m_strDID;
@synthesize navigationBar;

@synthesize wifiTableView;

#pragma mark -
#pragma mark system

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handleTimer:(id)param
{    
    [self StopTimer];
    [self hideLoadingIndicator];  
    m_bFinished = YES;
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

- (void) StopTimer
{
    [m_timerLock lock];
    if (m_timer != nil) {
        [m_timer invalidate];
        m_timer = nil;
    }
    [m_timerLock unlock];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    m_timerLock = [[NSCondition alloc] init];
   
    m_bFinished = NO;
    m_wifiScanResult = [[NSMutableArray alloc] init];
    
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    NSString *cmd1 = @"get_params.cgi?";
    NSString *cmd2 = @"wifi_scan.cgi?";
    [[VSNet shareinstance] sendCgiCommand:cmd1 withIdentity:self.m_strDID];
    [[VSNet shareinstance] sendCgiCommand:cmd2 withIdentity:self.m_strDID];
    [[VSNet shareinstance] setControlDelegate:self.m_strDID withDelegate:self];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    if (m_wifiScanResult != nil) {
        [m_wifiScanResult release];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self StopTimer];
}

- (void)dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    wifiTableView = nil;
    if (m_wifiScanResult != nil) {
        [m_wifiScanResult release];
    }    
    m_strDID = nil;
    m_strWEPKey = nil;
    m_strWPA_PSK = nil;
    m_strSSID = nil;
    self.navigationBar = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) refresh:(id)param
{
    [m_wifiScanResult removeAllObjects];
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];

    NSString *cmd1 = @"get_params.cgi?";
    NSString *cmd2 = @"wifi_scan.cgi?";
    
    [[VSNet shareinstance] sendCgiCommand:cmd1 withIdentity:self.m_strDID];
    [[VSNet shareinstance] sendCgiCommand:cmd2 withIdentity:self.m_strDID];
    
    m_bFinished = NO;
    [self reloadTableView:nil];
}

- (void)showLoadingIndicator
{
    NSString *strTitle = NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);
    self.navigationItem.title = strTitle;
    //创建一个右边按钮  
    UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];
    self.navigationItem.rightBarButtonItem = progress;
}

- (void)hideLoadingIndicator
{
    //创建一个右边按钮
	UIBarButtonItem *refreshButton =
    [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
      target:self
      action:@selector(refresh:)];

    self.navigationItem.rightBarButtonItem = refreshButton;
    return;
}


#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    if (m_bFinished == NO) {
        return 1;
    }
    
    if ([m_wifiScanResult count] > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return [m_wifiScanResult count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = @"SettingCell";	
    UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }    
    
    int section = [anIndexPath section];
    if (section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (m_bFinished == FALSE) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"Loading", @STR_LOCALIZED_FILE_NAME, nil);
            cell.detailTextLabel.text = @"";
        }else {
            if (m_strSSID.length == 0) {
                cell.textLabel.text = NSLocalizedStringFromTable(@"NotSetting", @STR_LOCALIZED_FILE_NAME, nil);
                cell.detailTextLabel.text = @"";
            }else {
                cell.textLabel.text = m_strSSID;
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = NSLocalizedStringFromTable(@"ADD_WIFISETTING_CONE_ADD", @STR_LOCALIZED_FILE_NAME, nil);
                
            }        
        }   
    }
    
    if (section == 1) {
        int index = anIndexPath.row;
        
        NSDictionary *wifiResult = [m_wifiScanResult objectAtIndex:index];
        NSString *strSSID = [wifiResult objectForKey:@STR_SSID];
        cell.textLabel.text = strSSID;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"SSID";
    }else {
        return NSLocalizedStringFromTable(@"WifiList", @STR_LOCALIZED_FILE_NAME, nil);
    }    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    if (anIndexPath.section == 0) {
        return;
    }
    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];

    int index = anIndexPath.row;
    m_currentIndex = index;
    NSDictionary *wifiInfor = [m_wifiScanResult objectAtIndex:index];    
    int security = [[wifiInfor objectForKey:@STR_SECURITY] intValue];
    NSString *strSSID = [wifiInfor objectForKey:@STR_SSID];
    if (security == 0) {
        NSString *strMessage = [NSString stringWithFormat:@"%@%@ ?",NSLocalizedStringFromTable(@"WillSet", @STR_LOCALIZED_FILE_NAME, nil),strSSID];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:strMessage delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
        [alertView show];
        [alertView release];
        return;
    }
    WifiPwdViewController *wifipwdView = [[WifiPwdViewController alloc] init];
    wifipwdView.m_strDID = m_strDID;
    wifipwdView.m_strSSID = strSSID;
    wifipwdView.m_channel = [[wifiInfor objectForKey:@STR_CHANNEL] intValue];
    wifipwdView.m_security = security;
    [self.navigationController pushViewController:wifipwdView animated:YES];
    [wifipwdView release];
}

#pragma mark PerformInMainThread
- (void) reloadTableView:(id) param
{
    [wifiTableView reloadData];
}

#pragma mark UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1) {
        return;
    }
    
    NSDictionary *wifiInfor = [m_wifiScanResult objectAtIndex:m_currentIndex];    
    int security = [[wifiInfor objectForKey:@STR_SECURITY] intValue];
    NSString *strSSID = [wifiInfor objectForKey:@STR_SSID];
    int channel = [[wifiInfor objectForKey:@STR_CHANNEL] intValue];
    
    NSString *cmd = [NSString stringWithFormat:@"set_wifi.cgi?enable=1&ssid=%@&encrypt=0&defkey=0&key1=&key2=&key3=&key4=&authtype=%d&keyformat=0&key1_bits=0&key2_bits=0&key3_bits=0&key4_bits=0&channel=%d&mode=0&wpa_psk=&",strSSID,security,channel];
    [[VSNet shareinstance] sendCgiCommand:cmd withIdentity:m_strDID];
    
    CameraViewController *camereView = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToViewController:camereView animated:YES];
}

#pragma mark - VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"WifiSettingViewController：VSNet返回数据 UID:%@,comType:%ld",deviceIdentity,(long)comType);
    NSString *string = [[NSString alloc] initWithCString:buffer encoding:NSUTF8StringEncoding];
    if ([deviceIdentity isEqualToString:m_strDID] && comType == CGI_IEGET_PARAM)
    {
        NSInteger result = [[NSString subValueByKeyString:@"result=" fromRetString:string] integerValue];
        if (result != 0) {
            NSLog(@"数据异常!");
            return;
        }
        
        m_strSSID = [NSString subValueByKeyString:@"wifi_ssid=" fromRetString:string];
        m_channel = [[NSString subValueByKeyString:@"wifi_channel=" fromRetString:string] intValue];
        m_authtype = [[NSString subValueByKeyString:@"wifi_authtype=" fromRetString:string] intValue];
        m_strWEPKey = [NSString subValueByKeyString:@"wifi_key1=" fromRetString:string];
        m_strWPA_PSK = [NSString subValueByKeyString:@"wifi_wpa_psk=" fromRetString:string];
    }
    else if ([deviceIdentity isEqualToString:m_strDID] && comType == CGI_IESET_WIFISCAN) {
        if (string == nil) {
            if (retString != nil) {
                string = retString;
            } else {
                string = [NSString stringWithFormat:@"%s",buffer];
            }
        }
        NSLog(@"无线wifi返回数据：\nUID = %@,类型 = %ld,buff = %@",deviceIdentity,(long)comType,string);
        NSInteger result = [[NSString subValueByKeyString:@"result=" fromRetString:string] integerValue];
        if (result != 0) {
            NSLog(@"数据异常!");
            return;
        }
        
        if (m_bFinished == YES) {
            return;
        }
        
        for (NSInteger i = 0; i < retString.length; i ++) {
            NSString *strSSID = [APICommon stringAnalysisWithFormatStr:[NSString stringWithFormat:@"ap_ssid[%ld] =",(long)i] AndRetString:string];
            NSInteger nSecurity = [[APICommon stringAnalysisWithFormatStr:[NSString stringWithFormat:@"ap_security[%ld]=",(long)i] AndRetString:string] integerValue];
            NSInteger nChannel = [[APICommon stringAnalysisWithFormatStr:[NSString stringWithFormat:@"ap_channel[%ld]=",i] AndRetString:string] integerValue];
            NSInteger nDB0 = [[APICommon stringAnalysisWithFormatStr:[NSString stringWithFormat:@"ap_dbm0[%ld]=",i] AndRetString:string] integerValue];
            
            NSLog(@"搜索到的第%ld个WiFi",i);
            NSMutableDictionary *wifiscan = [NSMutableDictionary dictionaryWithObjectsAndKeys:strSSID, @STR_SSID, [NSNumber numberWithInteger:nSecurity], @STR_SECURITY,[NSNumber numberWithInteger:nDB0], @STR_DB0, [NSNumber numberWithInteger:nChannel], @STR_CHANNEL, nil];
            
            [m_wifiScanResult addObject:wifiscan];
            if (strSSID.length == 0) {
                [m_wifiScanResult removeLastObject];
                break;
            }
        }
        
        m_bFinished = YES;
        [self performSelectorOnMainThread:@selector(StopTimer) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
        
    }else{
        //        NSLog(@"获取WiFi数据失败!");
    }
}



#pragma mark navigationBarDelegate
- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

@end
