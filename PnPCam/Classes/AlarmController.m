//
//  AlarmController.m
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import "AlarmController.h"
#import "obj_common.h"

#import "oSwitchCell.h"
#import "oLableCell.h"
#import "oTextCell.h"

#import "oDropController.h"
#import "oDropListStruct.h"

#import "VSNet.h"
#import "cmdhead.h"
#import "CameraViewController.h"
#import "APICommon.h"
#import "NSString+subValueFromRetString.h"

@interface AlarmController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation AlarmController

@synthesize tableView;
@synthesize navigationBar;

@synthesize m_strDID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) btnSetAlarm:(id)sender
{
    NSString *cmd = [NSString stringWithFormat:@"set_alarm.cgi?enable_alarm_audio=%d&motion_armed=%d&motion_sensitivity=%d&input_armed=%d&ioin_level=%d&preset=%d&iolinkage=%d&ioout_level=%d&mail=%d&record=%d&upload_interval=%d&schedule_enable=1&schedule_sun_0=-1&schedule_sun_1=-1&schedule_sun_2=-1&schedule_mon_0=-1&schedule_mon_1=-1&schedule_mon_2=-1&schedule_tue_0=-1&schedule_tue_1=-1&schedule_tue_2=-1&schedule_wed_0=-1&schedule_wed_1=-1&schedule_wed_2=-1&schedule_thu_0=-1&schedule_thu_1=-1&schedule_thu_2=-1&schedule_fri_0=-1&schedule_fri_1=-1&schedule_fri_2=-1&schedule_sat_0=-1&schedule_sat_1=-1&schedule_sat_2=-1&",0,m_motion_armed,m_motion_sensitivity,m_input_armed,m_ioin_level,m_alarmpresetsit,m_iolinkage,m_ioout_level,m_mail,1,m_upload_interval];
    [[VSNet shareinstance] sendCgiCommand:cmd withIdentity:self.m_strDID];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *strTitle = NSLocalizedStringFromTable(@"AlarmSetting", @STR_LOCALIZED_FILE_NAME, nil);
    self.navigationItem.title = strTitle;
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(btnSetAlarm:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    //UISwipeGestureRecognizer
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    [[VSNet shareinstance] setControlDelegate:m_strDID withDelegate:self];
    [[VSNet shareinstance] sendCgiCommand:@"get_params.cgi?" withIdentity:m_strDID];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    CameraViewController *camereView = [self.navigationController.viewControllers objectAtIndex:0];
    [[VSNet shareinstance] setControlDelegate:m_strDID withDelegate:camereView];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.view removeGestureRecognizer:_swipeGes];
}

- (void)dealloc
{
    self.m_strDID = nil;
    [_swipeGes release],_swipeGes = nil;
    self.tableView = nil;
    self.navigationBar = nil;
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"alarmcell%d",anIndexPath.row];
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = anIndexPath.row;
    switch (row) {
        case 0:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionEnable", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_motion_armed>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionMotion_armed:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        }
            break;
        case 1:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionLevel", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            if (m_motion_sensitivity >= 1 && m_motion_sensitivity <= 3) {
                cell.DescriptionLable.text = NSLocalizedStringFromTable(@"MotionLevelHigh", @STR_LOCALIZED_FILE_NAME, nil);
            }else if(m_motion_sensitivity >= 4 && m_motion_sensitivity <= 6){
                cell.DescriptionLable.text = NSLocalizedStringFromTable(@"MotionLevelMiddle", @STR_LOCALIZED_FILE_NAME, nil);
            }else {
                cell.DescriptionLable.text = NSLocalizedStringFromTable(@"MotionLevelLow", @STR_LOCALIZED_FILE_NAME, nil);
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 2:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmExtern", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_input_armed>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionInput_armed:) forControlEvents:UIControlEventValueChanged];
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 3:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmExternMode", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell.DescriptionLable.text = [[[[data_param_value sharedInstance] extern_mode] objectAtIndex:m_ioin_level] strTitle];
            //[NSString stringWithFormat:@"%d", m_ioin_level];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 4:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionPreset", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell.DescriptionLable.text = [[[[data_param_value sharedInstance] motion_preset] objectAtIndex:m_alarmpresetsit] strName];
            //(m_alarmpresetsit == 0)?@"No":[NSString stringWithFormat:@"%d", m_alarmpresetsit];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 5:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionIO", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_iolinkage>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionIolinkage:) forControlEvents:UIControlEventValueChanged];
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 6:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionIOLevel", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell.DescriptionLable.text = [[[[data_param_value sharedInstance] extern_level] objectAtIndex:m_ioout_level] strTitle];
            //NSString stringWithUTF8String:motion_preset[m_alarmpresetsit].szName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 7://alarm record
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmRecord", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_record>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionRecord:) forControlEvents:UIControlEventValueChanged];
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    
	
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    switch (anIndexPath.row) {
        case 1:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 1;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
            [dpView release];
        }
            break;
        case 3:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 3;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
            [dpView release];
        }
            break;
        case 4:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 4;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
            [dpView release];
        }
            break;
        case 6:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 6;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
            [dpView release];
        }
            break;
        case 8:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 9;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
            [dpView release];
        }
            break;
        default:
            break;
    }
}

- (void) DropListResult:(NSString*)strDescription nID:(int)nID nType:(int)nType param1:(int)param1 param2:(int)param2
{
    if (nType == 1) {
        m_motion_sensitivity = nID;
    }
    if (nType == 3) {
        m_ioin_level = nID;
    }
    if (nType == 4) {
        m_alarmpresetsit = nID;
    }
    if (nType == 6) {
        m_ioout_level = nID;
    }
    if (nType == 9) {
        m_upload_interval = nID;
    }
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

#pragma mark PerformInMainThread
- (void) reloadTableView:(id) param
{
    [tableView reloadData];
}

- (void) AlarmProtocolResult:(int)motion_armed
          motion_sensitivity:(int)motion_sensitivity
                 input_armed:(int)input_armed
                  ioin_level:(int)ioin_level
              alarmpresetsit:(int)alarmpresetsit
                   iolinkage:(int)iolinkage
                 ioout_level:(int)ioout_level
                        mail:(int)mail
                    snapshot:(int)snapshot
             upload_interval:(int)upload_interval
                      record:(int)record
{
    m_motion_armed = motion_armed;
    m_motion_sensitivity = motion_sensitivity;
    
    m_input_armed = input_armed;
    m_ioin_level = ioout_level;
    
    m_alarmpresetsit = alarmpresetsit;
    m_iolinkage = iolinkage;
    m_ioout_level = ioout_level;
    
    m_mail = mail;
    m_snapshot = snapshot;
    m_upload_interval = upload_interval;
    
    m_record = record;
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
    
}

- (void)switchActionMotion_armed:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_motion_armed = 1;   }else {     m_motion_armed = 0;       }
}
- (void)switchActionInput_armed:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_input_armed = 1;   }else {     m_input_armed = 0;       }
}
- (void)switchActionIolinkage:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_iolinkage = 1;   }else {     m_iolinkage = 0;       }
}
- (void)switchActionMail:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_mail = 1;   }else {     m_mail = 0;       }
}
- (void)switchActionSnapshot:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_snapshot = 1;   }else {     m_snapshot = 0;       }
}

- (void)switchActionRecord:(id) sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_record = 1;   }else {     m_record = 0;       }
    
}

#pragma mark navigationBarDelegate
- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark - VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"AlarmController VSNet返回数据 UID:%@ comtype %ld",deviceIdentity,(long)comType);
    if ( [deviceIdentity isEqualToString:m_strDID] && comType == CGI_IEGET_PARAM)
    {
        m_motion_armed = [[NSString subValueByKeyString:@"alarm_motion_armed=" fromRetString:retString] intValue];
        m_motion_sensitivity = [[NSString subValueByKeyString:@"alarm_motion_sensitivity=" fromRetString:retString] intValue];
        m_input_armed = [[NSString subValueByKeyString:@"alarm_input_armed=" fromRetString:retString] intValue];
        m_ioin_level = [[NSString subValueByKeyString:@"alarm_ioin_level=" fromRetString:retString] intValue];
        m_alarmpresetsit= [[NSString subValueByKeyString:@"alarm_presetsit=" fromRetString:retString] intValue];
        m_iolinkage= [[NSString subValueByKeyString:@"alarm_iolinkage=" fromRetString:retString] intValue];
        m_ioout_level= [[NSString subValueByKeyString:@"alarm_ioout_level=" fromRetString:retString] intValue];
        m_mail = [[NSString subValueByKeyString:@"alarm_mail=" fromRetString:retString] intValue];
        m_snapshot = [[NSString subValueByKeyString:@"alarm_snapshot=" fromRetString:retString] intValue];
        m_upload_interval = [[NSString subValueByKeyString:@"alarm_upload_interval=" fromRetString:retString] intValue];
        m_record = [[NSString subValueByKeyString:@"alarm_record=" fromRetString:retString] intValue];
        m_enable_alarm_audio = [[NSString subValueByKeyString:@"enable_alarm_audio=" fromRetString:retString] intValue];
        [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
    }
}


@end
