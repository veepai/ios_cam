//
//  PlanManagement.m
//  P2PCamera
//
//  Created by 黄甜 on 17/2/8.
//
//

#import "PlanManagement.h"
#import "PlanModel.h"
#import "NSString+subValueFromRetString.h"

static PlanManagement *shareDatabase = nil;
@implementation PlanManagement
-(id) init
{
    if (self == [super init])
    {
        _RecordPlanArray = [[NSMutableArray alloc] init];
        _MotionRecordPlanArray = [[NSMutableArray alloc] init];
        _MotiondPushRecordPlanArray = [[NSMutableArray alloc] init];
        _AlarmPlanArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+(PlanManagement *)shareManagement
{
    if (shareDatabase == nil)
    {
        shareDatabase = [[PlanManagement alloc] init];
    }
    return shareDatabase;
}

+ (void)detailMotionPushPlanData:(NSString *)DataStr{
    NSLog(@"detailMotionPushPlanData %@", DataStr);
    [[PlanManagement shareManagement].MotiondPushRecordPlanArray removeAllObjects];
    for (int i = 1; i <= 21 ; i++) {
        NSString *motion_push_planStr = [NSString stringWithFormat:@"motion_push_plan%d=", i];
        int motion_push_plan_num = [[NSString subValueByKeyString:motion_push_planStr fromRetString:DataStr] intValue];
        PlanModel *planM = [self planModel:motion_push_plan_num];
        if (planM != nil) {
            [[PlanManagement shareManagement].MotiondPushRecordPlanArray addObject:planM];
        }
    }
}

+ (void)detailRecordPlanData:(NSString *)DataStr{
    NSLog(@"detailRecordPlanData %@", DataStr);
    [[PlanManagement shareManagement].RecordPlanArray removeAllObjects];
    for (int i = 1; i <= 21 ; i++) {
        NSString *record_planStr = [NSString stringWithFormat:@"record_plan%d=", i];
        int record_plan_num = [[NSString subValueByKeyString:record_planStr fromRetString:DataStr] intValue];
        PlanModel *planM = [self planModel:record_plan_num];
        if (planM != nil) {
            [[PlanManagement shareManagement].RecordPlanArray addObject:planM];
        }
    }
}

+ (void)detailMotionRecordPlanData:(NSString *)DataStr{
    NSLog(@"detailMotionRecordPlanData %@", DataStr);
    [[PlanManagement shareManagement].MotionRecordPlanArray removeAllObjects];
    for (int i = 1; i <= 21 ; i++) {
        NSString *motion_record_planStr = [NSString stringWithFormat:@"motion_record_plan%d=", i];
        int motion_record_plan_num = [[NSString subValueByKeyString:motion_record_planStr fromRetString:DataStr] intValue];
        PlanModel *planM = [self planModel:motion_record_plan_num];
        if (planM != nil) {
            [[PlanManagement shareManagement].MotionRecordPlanArray addObject:planM];
        }
    }
}


+ (PlanModel *) planModel:(int) num{
    if (num == 0 || num == -1 || num == 1) {
        return nil;
    }
    
    int i = 0;
    int j;
    if (num < 0) {
        j = ABS(num);
    }else{
        j = num;
    }
    int tmp[32];
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
    BOOL sunday = NO;
    for (int m = 24,n=0; m<31; m++,n++) {
        if (tmp[m] != 0) {
            if (n == 0) {
                sunday = YES;
            }
            else if(m == 30)
            {
                [week appendFormat:@"%d",n];
            }
            else
            {
                [week appendFormat:@"%d,",n];
            }
        }
    }
    if (sunday)
    {
        [week appendFormat:@",7"];
    }
    
    PlanModel *par = [[PlanModel alloc] init];
    par.startTimer = [self MinutesTurnHourPush:start];
    par.endTimer = [self MinutesTurnHourPush:end];
    par.week = week;
    par.sum = num;
    return par;
}

+(NSString *) MinutesTurnHourPush:(int) MTH{
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
@end
