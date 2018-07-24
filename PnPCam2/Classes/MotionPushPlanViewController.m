//
//  MotionPushPlanViewController.m
//  P2PCamera
//
//  Created by 黄甜 on 17/2/9.
//
//

#import "MotionPushPlanViewController.h"
#import "obj_common.h"
#import "AddPlanViewController.h"
#import "PlanManagement.h"
#import "PlanModel.h"
#import "AddScheduleTimeCell.h"

#import "VSNet.h"
#import "VSNetProtocol.h"
#import "cmdhead.h"
#import "APICommon.h"
#import "CameraViewController.h"

@interface MotionPushPlanViewController ()<UITableViewDelegate, UITableViewDataSource,VSNetControlProtocol>
@property (nonatomic, retain) NSMutableArray *MotionPushPlan;
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation MotionPushPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    [[PlanManagement shareManagement].MotiondPushRecordPlanArray removeAllObjects];
    self.MotionPushPlan = [[NSMutableArray alloc] init];
    [self getPlanStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.MotionPushPlan removeAllObjects];
    [self.MotionPushPlan addObjectsFromArray:[PlanManagement shareManagement].MotiondPushRecordPlanArray];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    CameraViewController *camereView = [self.navigationController.viewControllers objectAtIndex:0];
    [[VSNet shareinstance] setControlDelegate:_m_strDID withDelegate:camereView];
}

- (void)getPlanStatus
{
    /*NSString *commandStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=11&mark=212&type=2&"];
    _m_PPPPChannelMgt->GetJsonCGI((char*) [self.m_strDID UTF8String], 2017, (char *)[commandStr UTF8String]);
    _m_PPPPChannelMgt->SetSDcardScheduleDelegate((char*)[self.m_strDID UTF8String], self);
    
    //移动侦测报警通知计划指令生效需把移动侦测功能打开
    //获取移动侦测状态
    _m_PPPPChannelMgt->SetAlarmDelegate((char*)[self.m_strDID UTF8String], self);
    _m_PPPPChannelMgt->PPPPSetSystemParams((char*)[self.m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);*/
    
    [[VSNet shareinstance] setControlDelegate:self.m_strDID withDelegate:self];
    NSString *commandStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=11&mark=212&type=2&"];
    [[VSNet shareinstance] sendCgiCommand:commandStr withIdentity:self.m_strDID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) TenAndTwoPush:(int) num atIndex:(int)index{
    if (num == 0 || num == -1 || num == 1) {
        return ;
    }
    //    notesLabel.hidden = YES;
    int tmp[32];
    int i = 0;
    int j;
    if (num < 0) {
        j = ABS(num);
    }else{
        j = num;
    }
    
    while (j) {
        tmp[i] = j%2;
        i++;
        j = j/2;
    }
    
    for (; i<31; i++) {
        tmp[i] = 0;
    }
    
    if (num < 0) {
        tmp[31] = 1;
    }else{
        tmp[31] = 0;
    }
    
    int start = 0;
    int end = 0;
    NSMutableString *week = [[NSMutableString alloc] init];
    int ll = 0;
    for (int m = 0; m < 12; m++)
    {
        ll = tmp[m] * pow(2, m);
        start += ll;
    }
    
    for (int m = 12,n = 0; m<24; m++,n++) {
        
        ll = tmp[m] * pow(2, n);
        end += ll;
    }
    
    for (int m = 24,n=0; m<31; m++,n++) {
        if (tmp[m] != 0) {
            [week appendFormat:@"%d,",n];
        }
    }
    [week deleteCharactersInRange:NSMakeRange(week.length - 1, 1)];
    NSLog(@"week : %@", week);
    [self saveDatabasePush:[self MinutesTurnHourPush:start] endT:[self MinutesTurnHourPush:end] week:week isOn:tmp[31] Sum:num];
    
}

-(void) saveDatabasePush:(NSString *)startT endT:(NSString *)endT week:(NSString *)week isOn:(int )isOn Sum:(int)sum{
    
    PlanModel *par = [[PlanModel alloc] init];
    par.devicedID = self.m_strDID;
    par.startTimer = startT;
    par.endTimer = endT;
    par.week = week;
    par.isOn = [NSString stringWithFormat:@"%d",isOn];
    par.sum = sum;
    [[PlanManagement shareManagement].MotiondPushRecordPlanArray addObject:par];
    
}

-(NSString *) MinutesTurnHourPush:(int) MTH{
    NSString *starts;
    int mm = MTH;
    int rem = 0;
    if (mm<10) {
        starts = [NSString stringWithFormat:@"00:0%d",mm];
    }else if (mm >= 10 && mm < 60){
        starts = [NSString stringWithFormat:@"00:%d",mm];
    }else{
        mm = mm / 60;
        if (mm * 60 == MTH) {
            rem = 0;
        }else{
            rem = MTH % 60;
        }
        
        if (mm < 10) {
            if (rem < 10) {
                starts = [NSString stringWithFormat:@"0%d:0%d",mm,rem];
            }else{
                starts = [NSString stringWithFormat:@"0%d:%d",mm,rem];
            }
        }else{
            if (rem < 10) {
                starts = [NSString stringWithFormat:@"%d:0%d",mm,rem];
            }else{
                starts = [NSString stringWithFormat:@"%d:%d",mm,rem];
            }
        }
    }
    return starts;
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

#pragma mark --UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _MotionPushPlan.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (_MotionPushPlan.count > 0)
        {
            static NSString *recordPlanCell = @"pushPlanCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
            }
            PlanModel *model = [[PlanModel alloc] init];
            model = _MotionPushPlan[indexPath.row];
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
    else
    {
        if (indexPath.row < _MotionPushPlan.count)
        {
            static NSString *recordPlanCell = @"pushPlanCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
            }
            PlanModel *model = [[PlanModel alloc] init];
            model = _MotionPushPlan[indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"移动侦测报警计划";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
        if (_MotionPushPlan.count == 0)
        {
            addPlanVC.isEdit = NO;
        }
        else
        {
            addPlanVC.rowIndex = indexPath.row;
            addPlanVC.isEdit = YES;
        }
        addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"移动侦测报警计划", @STR_LOCALIZED_FILE_NAME, nil);
        addPlanVC.addPlanTyep = @"AddMotionPushPlan";
        addPlanVC.str_DID = self.m_strDID;
        //addPlanVC.m_PPPPChannelMgt = _m_PPPPChannelMgt;
        [self.navigationController pushViewController:addPlanVC animated:YES];
        [addPlanVC release], addPlanVC = nil;
    }
    else
    {
        AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
        if (indexPath.row < _MotionPushPlan.count)
        {
            addPlanVC.rowIndex = indexPath.row;
            addPlanVC.isEdit = YES;
        }
        else
        {
            addPlanVC.isEdit = NO;
        }
        addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"移动侦测报警计划", @STR_LOCALIZED_FILE_NAME, nil);
        addPlanVC.addPlanTyep = @"AddMotionPushPlan";
        addPlanVC.str_DID = self.m_strDID;
        //addPlanVC.m_PPPPChannelMgt = _m_PPPPChannelMgt;
        [self.navigationController pushViewController:addPlanVC animated:YES];
        [addPlanVC release], addPlanVC = nil;
    }
}

#pragma mark - VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"RecordScheduleSettingViewController VSNet返回数据 UID:%@ comtype %ld",deviceIdentity,(long)comType);
    if ([deviceIdentity isEqualToString:self.m_strDID])
    {
        if(comType == CGI_MUSIC_OPERATION )
        {
            if ([retString rangeOfString:@"cmd"].location != NSNotFound && [[APICommon stringAnalysisWithFormatStr:@"cmd=" AndRetString:retString] isEqualToString:@"2017"]){
                
                if ([retString rangeOfString:@"motion_push_plan"].location != NSNotFound)
                {
                    [[PlanManagement shareManagement].MotiondPushRecordPlanArray removeAllObjects];
                    [PlanManagement detailMotionPushPlanData:retString];
                    [_MotionPushPlan removeAllObjects];
                    [_MotionPushPlan addObjectsFromArray:[PlanManagement shareManagement].MotiondPushRecordPlanArray];
                    __unsafe_unretained typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }
        }
    }
}

@end
