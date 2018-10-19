//
//  RecordScheduleSettingViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import "RecordScheduleSettingViewController.h"
#import "cmdhead.h"
#import "PPPPDefine.h"
#import "SDCardCell.h"
#import "SDStatusCell.h"
#import "obj_common.h"
#import "SetRecordTimeCell.h"
#import "RecordScheduleCell.h"
#import "SetRecordScheduleCell.h"
#import "SetRecordTimeViewController.h"
#import "AddPlanViewController.h"
#import "AddScheduleTimeCell.h"
#import "SetScheduleTimeCell.h"
#import "LookCurrentRecordScheduleViewController.h"
#import "PlanManagement.h"
#import "PlanModel.h"

#import "VSNet.h"
#import "APICommon.h"
#import "CameraViewController.h"

#define KEYSTRATTIME @"STRATTIME"
#define KEYENDTIME @"ENDTIME"
#define KEYOPENRECORD @"OPENRECORD"
#define KEYREPEATDAY @"REPEATDAY"
#define KEYREPEATWEEK @"REPEATWEEK"
#define KEYSTRATDATE @"STARTDATE"
#define KEYENDDATE @"ENDDATE"
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey :@"UIKeyboardBoundsUserInfoKey")

@interface RecordScheduleSettingViewController ()
@property (nonatomic) int SDCardTotal;
@property (nonatomic) int SDCardFree;
@property (nonatomic) int SDCardStatus;
@property (nonatomic) int timeLength;
@property (nonatomic) int coverEnable;
@property (nonatomic) int recordSize;//返回值一直为0，所以暂时不显示
@property (nonatomic) int ScheduleRecordEnable;
@property (nonatomic) BOOL SetRecordSchedule;//显示实时录像的时间表
@property (nonatomic) BOOL SetRecordTime;//设置实时录像时间
@property (nonatomic) int fixed_enable;
@property (nonatomic) BOOL is_LookRecSchedule;
@property (nonatomic, retain) UITapGestureRecognizer* resignKeyBoard;
@property (nonatomic, retain) UITextField* timeLengthTf;
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@property (nonatomic, retain) NSMutableArray* RecSchedule;
@property (nonatomic, retain) NSMutableArray* MotionRecSchedule;
@end

@implementation RecordScheduleSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _SDCardFree = 0;
        _SDCardStatus = 0;
        _SDCardTotal = 0;
        _timeLength = 0;
        _coverEnable = 0;
        _recordSize = 0;
        _ScheduleRecordEnable = 0;
        _SetRecordSchedule = NO;
        _SetRecordTime = NO;
        _is_LookRecSchedule = NO;
        _RecSchedule = [[NSMutableArray alloc] init];
        _MotionRecSchedule = [[NSMutableArray alloc] init];
        memset(&tmp, 0, sizeof(tmp));
        Schedule = [[NSMutableArray alloc] initWithCapacity:672];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
        }
        self.resignKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
        self.resignKeyBoard.numberOfTapsRequired = 1;
    }
    return self;
}

- (void) resignKeyboard:(UITapGestureRecognizer*) tapGes{
    [self.timeLengthTf resignFirstResponder];
}

#pragma mark -
#pragma mark KeyBoardNotifycation
- (void) keyBoardShow:(NSNotification*) notification{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    NSValue* keyboardValue = [[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyboardValue CGRectValue].size;
    
    NSIndexPath* patn = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell* cell = [self.aTableView cellForRowAtIndexPath:patn];
    CGRect rect = [self.aTableView convertRect:cell.frame toView:self.view];
    NSLog(@"rect  %@",NSStringFromCGRect(rect));
    CGFloat height = keyboardSize.height - (winsize.height - rect.size.height - rect.origin.y - 20.f - 44.f);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0.f, (height * (-1)), winsize.width, winsize.height);
        }];
    }
    [self.view addGestureRecognizer:_resignKeyBoard];
}

- (void) keyBoardHide:(NSNotification*) notification{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0.f, 0.f, winsize.width, winsize.height);
        }];
    }
    [self.view removeGestureRecognizer:_resignKeyBoard];
}

- (void) saveSDSetting:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) SetSDRecordParam:(id) sender{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSDSetting:)];
    self.navigationItem.rightBarButtonItem = item;
    [item release],item = nil;
    
    _aTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _aTableView.delegate = self;
    _aTableView.dataSource = self;
    [self.view addSubview:_aTableView];
    self.aTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    [[PlanManagement shareManagement].RecordPlanArray removeAllObjects];
    [[PlanManagement shareManagement].MotionRecordPlanArray removeAllObjects];
    
    [[VSNet shareinstance] setControlDelegate:self.m_strDID withDelegate:self];
    [self getPlanStatus];
}

- (void)getPlanStatus
{
    //获取录像计划指令
    NSString *commandRecordPlanStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=11&mark=212&type=3&"];
    [[VSNet shareinstance] sendCgiCommand:commandRecordPlanStr withIdentity:self.m_strDID];
    
    //获取移动侦测录像计划指令
    NSString *commandMotionPlanStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=11&mark=212&type=1&"];
    [[VSNet shareinstance] sendCgiCommand:commandMotionPlanStr withIdentity:self.m_strDID];
    
    //移动侦测录像计划指令生效需把移动侦测功能打开
    //获取移动侦测状态
    [[VSNet shareinstance] sendCgiCommand:@"get_record.cgi?" withIdentity:self.m_strDID];
}

//获取到的移动侦测状态结果
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
    //默认打开移动侦测功能
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_is_LookRecSchedule) {
        _is_LookRecSchedule = !_is_LookRecSchedule;
        [self SetSDRecordParam:nil];
    }
    
    [[VSNet shareinstance] setControlDelegate:_m_strDID withDelegate:self];
    [_RecSchedule removeAllObjects];
    [_MotionRecSchedule removeAllObjects];
    [_RecSchedule addObjectsFromArray:[PlanManagement shareManagement].RecordPlanArray];
    [_MotionRecSchedule addObjectsFromArray:[PlanManagement shareManagement].MotionRecordPlanArray];
    if (_SetRecordSchedule) {
        [self.aTableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    CameraViewController *camereView = [self.navigationController.viewControllers objectAtIndex:0];
    [[VSNet shareinstance] setControlDelegate:_m_strDID withDelegate:camereView];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)weekStr:(NSString *)weekStr
{
    NSArray *array = [weekStr componentsSeparatedByString:@","];
    NSMutableString *weeksStr = [[NSMutableString alloc] init];
    NSString *weekStr02;
    for (int i = 0; i < array.count; i++)
    {
        switch ([array[i] integerValue])
        {
            case 6:
                weekStr02 = NSLocalizedStringFromTable(@"Saturday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 5:
                weekStr02 = NSLocalizedStringFromTable(@"Friday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 4:
                weekStr02 = NSLocalizedStringFromTable(@"Thursday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 3:
                weekStr02 = NSLocalizedStringFromTable(@"Wednesday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 2:
                weekStr02 = NSLocalizedStringFromTable(@"Tuesday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 1:
                weekStr02 = NSLocalizedStringFromTable(@"Monday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            default:
                weekStr02 = NSLocalizedStringFromTable(@"Sunday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
        }
        NSString *str = [NSString stringWithFormat:@" %@", weekStr02];
        [weeksStr appendString:str];
    }
    return weeksStr;
}

#pragma mark -
#pragma mark UITableView Dalegate  Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_SetRecordSchedule) {
        return 4;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_SDCardStatus == PPPP_SDCARD_STATUS_NON) {
            return 3;
        }else{
            return 4;
        }
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return [_RecSchedule count] + 1;
    }else {
        return [_MotionRecSchedule count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            static NSString* statusCell = @"StatusCell";
            SDStatusCell* cell = (SDStatusCell*)[tableView dequeueReusableCellWithIdentifier:statusCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SDStatusCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.keyLabel.text = NSLocalizedStringFromTable(@"SDStatus", @STR_LOCALIZED_FILE_NAME, nil);
            cell.keyLabel.autoresizingMask = UIViewAutoresizingNone;
            cell.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
            if (_SDCardStatus == PPPP_SDCARD_STATUS_NON) {
                cell.contentLabel.text = NSLocalizedStringFromTable(@"SDNON", @STR_LOCALIZED_FILE_NAME, nil);
            }else if (_SDCardStatus == PPPP_SDCARD_STATUS_RECORDING){
                cell.contentLabel.text = NSLocalizedStringFromTable(@"SDRecording", @STR_LOCALIZED_FILE_NAME, nil);
            }else if (_SDCardStatus == PPPP_SDCARD_STATUS_STOP_RECORD){
                cell.contentLabel.text = NSLocalizedStringFromTable(@"SDStopRecord", @STR_LOCALIZED_FILE_NAME, nil);
            }
            return cell;
        }else if (indexPath.row == 3){
            static NSString* formatterCell = @"FormatterCellIden";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:formatterCell];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:formatterCell] autorelease];
            }
            cell.textLabel.text = NSLocalizedStringFromTable(@"SDFormat", @STR_LOCALIZED_FILE_NAME, nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            static NSString* SDcell = @"SDCell";
            SDCardCell* cell = (SDCardCell*)[tableView dequeueReusableCellWithIdentifier:SDcell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SDCardCell" owner:self options:nil] lastObject];
            }
            switch (indexPath.row) {
                case 0:
                    cell.keyLabel.text = NSLocalizedStringFromTable(@"SDTotal", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.contentLabel.text = [NSString stringWithFormat:@"%d",_SDCardTotal];
                    break;
                case 1:
                    cell.keyLabel.text = NSLocalizedStringFromTable(@"SDFree", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.contentLabel.text = [NSString stringWithFormat:@"%d",_SDCardFree];
                    break;
                    
                default:
                    break;
            }
            cell.keyLabel.autoresizingMask = UIViewAutoresizingNone;
            cell.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
            cell.unitLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            static NSString* recordTimecell = @"RecordCellTime";
            SetRecordTimeCell* cell = (SetRecordTimeCell*)[tableView dequeueReusableCellWithIdentifier:recordTimecell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SetRecordTimeCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.keyLabel.text = NSLocalizedStringFromTable(@"RecordTime", @STR_LOCALIZED_FILE_NAME, nil);
            cell.keyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            cell.timeRangeLabel.text = NSLocalizedStringFromTable(@"TimeRange", @STR_LOCALIZED_FILE_NAME, nil);
            cell.timeRangeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.timeRangeLabel.numberOfLines = 0;
            [cell.timeRangeLabel setAdjustsFontSizeToFitWidth:YES];
            cell.recordTime.text = [NSString stringWithFormat:@"%d",_timeLength];
            cell.recordTime.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.recordTime.keyboardType = UIKeyboardTypeNumberPad;
            cell.recordTime.delegate = self;
            self.timeLengthTf = cell.recordTime;
            return cell;
        }
        
        if (indexPath.row == 3) {
            static NSString* cellIden = @"cellIdenIcon";
            RecordScheduleCell* cell = (RecordScheduleCell*)[tableView dequeueReusableCellWithIdentifier:cellIden];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordScheduleCell" owner:self options:nil] lastObject];
            }
            cell.iconImg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.iconImg.contentMode = UIViewContentModeScaleAspectFit;
            cell.keyLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            cell.keyLabel.text = NSLocalizedStringFromTable(@"RecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
            if (_SetRecordSchedule) {
                cell.iconImg.image = [UIImage imageNamed:@"common_stretch_arrow_downward"];
            }else{
                cell.iconImg.image = [UIImage imageNamed:@"common_stretch_arrow_upward"];
            }
            return cell;
        }
        
        
        static NSString* recordInfo = @"ReocrdInfomation";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:recordInfo];
        if (cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordInfo] autorelease];
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedStringFromTable(@"Looprewrite", @STR_LOCALIZED_FILE_NAME, nil);
                if (_coverEnable == 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            case 2:
                cell.textLabel.text = NSLocalizedStringFromTable(@"Schedulerecording", @STR_LOCALIZED_FILE_NAME, nil);
                if (_ScheduleRecordEnable == 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            default:
                break;
        }
        return cell;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            if (_RecSchedule.count == 0)
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
            else
            {
                static NSString *recordPlanCell = @"recordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _RecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
        else
        {
            if (indexPath.row < _RecSchedule.count)
            {
                static NSString *recordPlanCell = @"recordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _RecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
        }
    }
    else{
        if (indexPath.row == 0)
        {
            if (_MotionRecSchedule.count == 0)
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
            else
            {
                static NSString *recordPlanCell = @"motionRecordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _MotionRecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
        else
        {
            if (indexPath.row < _MotionRecSchedule.count)
            {
                static NSString *recordPlanCell = @"motionRecordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _MotionRecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"SDFormatTitle", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"SDFormatDescription", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
            alert.tag = 101;
            [alert show];
            [alert release];
        }
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                if (_coverEnable == 0) {
                    _coverEnable = 1;
                }else{
                    _coverEnable = 0;
                }
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
            }
                break;
            case 2:
            {
                if (0 == _ScheduleRecordEnable) {
                    _ScheduleRecordEnable = 1;
                }else{
                    _ScheduleRecordEnable = 0;
                }
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
                
                
                NSString *cmd;
                if (_ScheduleRecordEnable)
                {
                    cmd = [NSString stringWithFormat:@"set_recordsch.cgi?record_cover=%d&record_timer=%d&time_schedule_enable=%d&schedule_sun_0=%d&schedule_sun_1=%d&schedule_sun_2=%d&schedule_mon_0=%d&schedule_mon_1=%d&schedule_mon_2=%d&schedule_tue_0=%d&schedule_tue_1=%d&schedule_tue_2=%d&schedule_wed_0=%d&schedule_wed_1=%d&schedule_wed_2=%d&schedule_thu_0=%d&schedule_thu_1=%d&schedule_thu_2=%d&schedule_fri_0=%d&schedule_fri_1=%d&schedule_fri_2=%d&schedule_sat_0=%d&schedule_sat_1=%d&schedule_sat_2=%d&",1,_timeLength,_ScheduleRecordEnable,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
                }
                else{
                    cmd = [NSString stringWithFormat:@"set_recordsch.cgi?record_cover=%d&record_timer=%d&time_schedule_enable=%d&schedule_sun_0=%d&schedule_sun_1=%d&schedule_sun_2=%d&schedule_mon_0=%d&schedule_mon_1=%d&schedule_mon_2=%d&schedule_tue_0=%d&schedule_tue_1=%d&schedule_tue_2=%d&schedule_wed_0=%d&schedule_wed_1=%d&schedule_wed_2=%d&schedule_thu_0=%d&schedule_thu_1=%d&schedule_thu_2=%d&schedule_fri_0=%d&schedule_fri_1=%d&schedule_fri_2=%d&schedule_sat_0=%d&schedule_sat_1=%d&schedule_sat_2=%d&",1,_timeLength,_ScheduleRecordEnable,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
                }
                [[VSNet shareinstance] sendCgiCommand:cmd withIdentity:self.m_strDID];
            }
                break;
            case 3:
            {
                _SetRecordSchedule = !_SetRecordSchedule;
                [tableView beginUpdates];
                if (!_SetRecordSchedule) {
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    [tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView insertSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [tableView endUpdates];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0)
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (_RecSchedule.count == 0)
            {
                addPlanVC.isEdit = NO;
            }
            else
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Schedule_Recording";
            addPlanVC.str_DID = self.m_strDID;
            
            [self.navigationController pushViewController:addPlanVC animated:YES];
            [addPlanVC release], addPlanVC = nil;
        }
        else
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (indexPath.row < _RecSchedule.count)
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            else
            {
                addPlanVC.isEdit = NO;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Schedule_Recording";
            addPlanVC.str_DID = self.m_strDID;
            
            [self.navigationController pushViewController:addPlanVC animated:YES];
            [addPlanVC release], addPlanVC = nil;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (_MotionRecSchedule.count == 0)
            {
                addPlanVC.isEdit = NO;
            }
            else
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"移动侦测录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Motion_Recording_Schedule";
            addPlanVC.str_DID = self.m_strDID;
            [self.navigationController pushViewController:addPlanVC animated:YES];
            [addPlanVC release], addPlanVC = nil;
        }
        else
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (indexPath.row < _MotionRecSchedule.count)
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            else
            {
                addPlanVC.isEdit = NO;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"移动侦测录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Motion_Recording_Schedule";
            addPlanVC.str_DID = self.m_strDID;
            [self.navigationController pushViewController:addPlanVC animated:YES];
            [addPlanVC release], addPlanVC = nil;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return NSLocalizedStringFromTable(@"SDInfomation", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(section == 1){
        return NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(section == 2){
        return NSLocalizedStringFromTable(@"RecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
    }else
        return @"移动侦测录像";
}
#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"BOOL textField  %@",textField.text);
    _timeLength = [textField.text intValue];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField  %@",textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1) {
        return YES;
    }
    NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange timelength = [string rangeOfCharacterFromSet:characterSet];
    NSLog(@"textField  %@   string  %@  Range  %d  %d",textField.text,string,range.location,range.length);
    
    if (timelength.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDalegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            NSString *cmd = @"set_formatsd.cgi?";
            [[VSNet shareinstance] sendCgiCommand:cmd withIdentity:self.m_strDID];
        }
    }else if (alertView.tag == 100){
        if (buttonIndex == 1) {
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark CellIconImage TapGestureRecognizer
- (void) clickIconImg:(UITapGestureRecognizer*) tapges{
    RecordTimeMode* view = (RecordTimeMode*)[tapges view];
    view.is_Selected_Icon = !view.is_Selected_Icon;
    NSMutableDictionary* dic = [self.RecSchedule objectAtIndex:(view.tag - 2)];
    NSLog(@"dic  %@",dic);
    NSMutableArray* weeks = [dic objectForKey:KEYREPEATWEEK];
    NSString* startStr = [dic objectForKey:KEYSTRATTIME];
    NSString* endStr = [dic objectForKey:KEYENDTIME];
    int starthour = [[startStr substringWithRange:NSMakeRange(0, 2)] intValue];
    int startmin = [[startStr substringWithRange:NSMakeRange(5, 2)] intValue];
    int endhour = [[endStr substringWithRange:NSMakeRange(0, 2)] intValue];
    int endmin = [[endStr substringWithRange:NSMakeRange(5, 2)] intValue];
    int startIndex = starthour*4 + startmin/15 + (startmin%15 ? 1 : 0);
    int endIndex = endhour*4 + endmin/15 + (endmin%15 ? 1 : 0);
    
    if (view.is_Selected_Icon) {
        for (int i = 0; i < 7; i++) {
            if ([(NSNumber*)[weeks objectAtIndex:i] isEqualToNumber:@1]) {
                for (int j = startIndex + 96 * i; j < endIndex + 96 * i; j ++) {
                    Schedule[j] = @1;
                }
            }
        }
        [dic setObject:[NSNumber numberWithBool:YES] forKey:KEYOPENRECORD];
    }else{
        for (int i = 0; i < 7; i++) {
            if ([(NSNumber*)[weeks objectAtIndex:i] isEqualToNumber:@1]) {
                for (int j = startIndex + 96 * i; j < endIndex + 96 * i; j ++) {
                    Schedule[j] = @0;
                }
            }
        }
        [dic setObject:[NSNumber numberWithBool:NO] forKey:KEYOPENRECORD];
    }
    [self.RecSchedule replaceObjectAtIndex:(view.tag - 2) withObject:dic];
}


#pragma mark -
#pragma mark SetRecordTimeViewControllerDelegate
- (void) SetRecordTimeViewController:(SetRecordTimeViewController*) recordTime withStarTimes:(NSArray*) startDates EndDateTimes:(NSArray*) endDates andRepeatDay:(int*) weeks OpenRecord:(BOOL) openRecord{
    for (int i = 0; i < [startDates count]; i ++) {
        
        NSMutableArray* ws = [NSMutableArray array];
        NSString* startStr = [startDates objectAtIndex:i];
        NSString* endstr = [endDates objectAtIndex:i];
        int starthour = [[startStr substringWithRange:NSMakeRange(0, 2)] intValue];
        int startmin = [[startStr substringWithRange:NSMakeRange(5,2)] intValue];
        int endhour = [[endstr substringWithRange:NSMakeRange(0, 2)] intValue];
        int endmin = [[endstr substringWithRange:NSMakeRange(5,2)] intValue];
        int startIndex = starthour*4 + startmin/15 + (startmin%15 ? 1 : 0);
        int endIndex = endhour*4 + endmin/15 + (endmin%15 ? 1 : 0);
        
        for (int j = 0; j < 7; j++) {
            [ws addObject:[NSNumber numberWithInt:weeks[j]]];
            if (weeks[j] == 1) {
                for (int i = startIndex + (j*96); i < endIndex + (j*96); i++) {
                    Schedule[i] = @1;
                }
            }
        }
        
        if (endhour == 24) {
            endhour = 0;
            endmin = 0;
        }
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        df.dateFormat =  @"yyyy-MM-dd HH:mm:ss";
        NSString* dateStr = [[df stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
        NSString* startDateStr = [NSString stringWithFormat:@"%@ %d:%d:00",dateStr,starthour,startmin];
        NSString* endDateStr = [NSString stringWithFormat:@"%@ %d:%d:00",dateStr,endhour,endmin];
        
        NSDate* startDate = [df dateFromString:startDateStr];
        NSDate* endDate = [df dateFromString:endDateStr];
        // NSLog(@"endDateStr  %@  endDate  %@",endDateStr,endDate);
        [df release];
        NSArray* objs = [NSArray arrayWithObjects:[startDates objectAtIndex:i], [endDates objectAtIndex:i], recordTime.weekStr, [NSNumber numberWithBool:openRecord], ws, startDate, endDate,nil];
        NSArray* keys = [NSArray arrayWithObjects:KEYSTRATTIME, KEYENDTIME, KEYREPEATDAY, KEYOPENRECORD, KEYREPEATWEEK, KEYSTRATDATE, KEYENDDATE,nil];
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjects:objs forKeys:keys];
        if (recordTime.bAddRecordTime) {
            [self.RecSchedule addObject:dic];
        }else{
            if (i == 0) {
                [self.RecSchedule replaceObjectAtIndex:recordTime.replaceIndex withObject:dic];
            }else{
                [self.RecSchedule addObject:dic];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.aTableView reloadData];
    });
    
    [self SetSDRecordParam:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    //UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


- (void) dealloc{
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    
    [super dealloc];
    [Schedule release],Schedule = nil;
    [_RecSchedule release],_RecSchedule = nil;
    [_MotionRecSchedule release], _MotionRecSchedule = nil;
    [_aTableView release],_aTableView = nil;
    [_resignKeyBoard release],_resignKeyBoard = nil;
    
}

#pragma mark - VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"RecordScheduleSettingViewController VSNet返回数据 UID:%@ comtype %ld",deviceIdentity,(long)comType);
    if ([deviceIdentity isEqualToString:self.m_strDID])
    {
        if (comType == CGI_IEGET_RECORD)
        {
            self.SDCardTotal = [[APICommon stringAnalysisWithFormatStr:@"total=" AndRetString:retString] intValue];
            self.SDCardFree = [[APICommon stringAnalysisWithFormatStr:@"free=" AndRetString:retString] intValue];
            int status = [[APICommon stringAnalysisWithFormatStr:@"record_sd_status=" AndRetString:retString] intValue];
            self.timeLength =[[APICommon stringAnalysisWithFormatStr:@"record_timer=" AndRetString:retString] intValue];
            self.ScheduleRecordEnable=[[APICommon stringAnalysisWithFormatStr:@"record_time_enable=" AndRetString:retString] intValue];
            if (status == 0) {
                _SDCardStatus = PPPP_SDCARD_STATUS_NON;
            }else if (status == 2){
                _SDCardStatus = PPPP_SDCARD_STATUS_RECORDING;
            }else if (status == 1){
                _SDCardStatus = PPPP_SDCARD_STATUS_STOP_RECORD;
            }
            
            if (_SDCardStatus != 0 && self.SDCardTotal > 0){
                _coverEnable = 1;
            }
            dispatch_async(dispatch_get_main_queue(),^{
                [_aTableView reloadData];
            });
        }
        else if(comType == CGI_MUSIC_OPERATION )
        {
            if ([retString rangeOfString:@"cmd"].location != NSNotFound && [[APICommon stringAnalysisWithFormatStr:@"cmd=" AndRetString:retString] isEqualToString:@"2017"]){
                if ([retString rangeOfString:@"motion_record_plan"].location != NSNotFound)
                {
                    [[PlanManagement shareManagement].MotionRecordPlanArray removeAllObjects];
                    [PlanManagement detailMotionRecordPlanData:retString];
                    [_MotionRecSchedule removeAllObjects];
                    [_MotionRecSchedule addObjectsFromArray:[PlanManagement shareManagement].MotionRecordPlanArray];
                }
                else if ([retString rangeOfString:@"record_plan"].location != NSNotFound)
                {
                    [[PlanManagement shareManagement].RecordPlanArray removeAllObjects];
                    [PlanManagement detailRecordPlanData:retString];
                    [_RecSchedule removeAllObjects];
                    [_RecSchedule addObjectsFromArray:[PlanManagement shareManagement].RecordPlanArray];
                }
            }
        }
    }
}
@end
