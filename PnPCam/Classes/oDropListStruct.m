#import "oDropListStruct.h"
#import "obj_common.h"

static data_param_value *gData_param_value = nil;
@implementation param_value_t
-(void) InitValue:(int)_index Name:(NSString*)_strName Title:(NSString*)_strTitle Value:(NSString*)_strValue pm1:(int)_param1 pm2:(int)param2
{
    self.index    = _index;
    self.strName  = _strName;
    self.strTitle = _strTitle;
    self.strValue = _strValue;
    self.param1   = _param1;
    self.param2   = param2;
}

@end


@interface data_param_value()
{
 
}
@end


@implementation data_param_value
+(id)sharedInstance{
    @synchronized(self){
        if (gData_param_value == nil){
            gData_param_value = [[super alloc] init];
            [gData_param_value InitData];
        }
    }
    return gData_param_value;
}

- (id) init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) InitData{
    //extern_level
    param_value_t* value = [[param_value_t alloc] init];
    [value InitValue:0 Name:@"" Title:NSLocalizedStringFromTable(@"alarm_text_a2", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* value1 = [[param_value_t alloc] init];
    [value1 InitValue:1 Name:@"" Title:NSLocalizedStringFromTable(@"alarm_text_a1", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    self.extern_level = [NSArray arrayWithObjects:value,value1,nil];
    //extern_mode
    param_value_t* extern_mode_value1 = [[param_value_t alloc] init];
    [extern_mode_value1 InitValue:0 Name:@"" Title:NSLocalizedStringFromTable(@"Disconnect", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* extern_mode_value2 = [[param_value_t alloc] init];
    [extern_mode_value2 InitValue:1 Name:@"" Title:NSLocalizedStringFromTable(@"Close", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    self.extern_mode = [NSArray arrayWithObjects:extern_mode_value1,extern_mode_value2, nil];
    //motion_level
    param_value_t* motion_level_value1 = [[param_value_t alloc] init];
    [motion_level_value1 InitValue:1 Name:@"" Title:NSLocalizedStringFromTable(@"MotionLevelHigh", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* motion_level_value2 = [[param_value_t alloc] init];
    [motion_level_value2 InitValue:5 Name:@"" Title:NSLocalizedStringFromTable(@"MotionLevelMiddle", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* motion_level_value3 = [[param_value_t alloc] init];
    [motion_level_value3 InitValue:10 Name:@"" Title:NSLocalizedStringFromTable(@"MotionLevelLow", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    self.motion_level = [NSArray arrayWithObjects:motion_level_value1,motion_level_value2, motion_level_value3,nil];
    //motion_preset
    param_value_t* motion_preset_value1 = [[param_value_t alloc] init];
    [motion_preset_value1 InitValue:0 Name:@"No" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value2 = [[param_value_t alloc] init];
    [motion_preset_value2 InitValue:1 Name:@"1" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value3 = [[param_value_t alloc] init];
    [motion_preset_value3 InitValue:3 Name:@"3" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value4 = [[param_value_t alloc] init];
    [motion_preset_value4 InitValue:4 Name:@"4" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value5 = [[param_value_t alloc] init];
    [motion_preset_value5 InitValue:5 Name:@"5" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value6 = [[param_value_t alloc] init];
    [motion_preset_value6 InitValue:6 Name:@"6" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value7 = [[param_value_t alloc] init];
    [motion_preset_value7 InitValue:7 Name:@"7" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value8 = [[param_value_t alloc] init];
    [motion_preset_value8 InitValue:8 Name:@"8" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value9 = [[param_value_t alloc] init];
    [motion_preset_value9 InitValue:9 Name:@"9" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value10 = [[param_value_t alloc] init];
    [motion_preset_value10 InitValue:10 Name:@"10" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value11 = [[param_value_t alloc] init];
    [motion_preset_value11 InitValue:11 Name:@"11" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value12 = [[param_value_t alloc] init];
    [motion_preset_value12 InitValue:12 Name:@"12" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value13 = [[param_value_t alloc] init];
    [motion_preset_value13 InitValue:13 Name:@"13" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value14 = [[param_value_t alloc] init];
    [motion_preset_value14 InitValue:14 Name:@"14" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value15 = [[param_value_t alloc] init];
    [motion_preset_value15 InitValue:15 Name:@"15" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* motion_preset_value16 = [[param_value_t alloc] init];
    [motion_preset_value16 InitValue:16 Name:@"16" Title:@"" Value:nil pm1:0 pm2:0];
    self.motion_preset = [NSArray arrayWithObjects:motion_preset_value1,
                     motion_preset_value2,
                     motion_preset_value3,
                     motion_preset_value4,
                     motion_preset_value5,
                     motion_preset_value6,
                     motion_preset_value7,
                     motion_preset_value8,
                     motion_preset_value9,
                     motion_preset_value10,
                     motion_preset_value11,
                     motion_preset_value12,
                     motion_preset_value13,
                     motion_preset_value14,
                     motion_preset_value15,
                     motion_preset_value16,nil];
    
    //pic_timer
    param_value_t* pic_timer_value1 = [[param_value_t alloc] init];
    [pic_timer_value1 InitValue:0 Name:@"0" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value2 = [[param_value_t alloc] init];
    [pic_timer_value2 InitValue:1 Name:@"1" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value3 = [[param_value_t alloc] init];
    [pic_timer_value3 InitValue:3 Name:@"3" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value4 = [[param_value_t alloc] init];
    [pic_timer_value4 InitValue:4 Name:@"4" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value5 = [[param_value_t alloc] init];
    [pic_timer_value5 InitValue:5 Name:@"5" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value6 = [[param_value_t alloc] init];
    [pic_timer_value6 InitValue:6 Name:@"6" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value7 = [[param_value_t alloc] init];
    [pic_timer_value7 InitValue:7 Name:@"7" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value8 = [[param_value_t alloc] init];
    [pic_timer_value8 InitValue:8 Name:@"8" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value9 = [[param_value_t alloc] init];
    [pic_timer_value9 InitValue:9 Name:@"9" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value10 = [[param_value_t alloc] init];
    [pic_timer_value10 InitValue:10 Name:@"10" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value11 = [[param_value_t alloc] init];
    [pic_timer_value11 InitValue:15 Name:@"15" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value12 = [[param_value_t alloc] init];
    [pic_timer_value12 InitValue:20 Name:@"20" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value13 = [[param_value_t alloc] init];
    [pic_timer_value13 InitValue:25 Name:@"25" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value14 = [[param_value_t alloc] init];
    [pic_timer_value14 InitValue:30 Name:@"30" Title:@"" Value:nil pm1:0 pm2:0];
    param_value_t* pic_timer_value15 = [[param_value_t alloc] init];
    [pic_timer_value15 InitValue:60 Name:@"60" Title:@"" Value:nil pm1:0 pm2:0];
    self.pic_timer = [NSArray arrayWithObjects:pic_timer_value1,
                 pic_timer_value2,
                 pic_timer_value3,
                 pic_timer_value4,
                 pic_timer_value5,
                 pic_timer_value6,
                 pic_timer_value7,
                 pic_timer_value8,
                 pic_timer_value9,
                 pic_timer_value10,
                 pic_timer_value11,
                 pic_timer_value12,
                 pic_timer_value13,
                 pic_timer_value14,
                 pic_timer_value15,
                 nil];
    
    //ntp_server
    param_value_t* ntp_server_value1 = [[param_value_t alloc] init];
    [ntp_server_value1 InitValue:0 Name:@"1" Title:@"time.nist.gov" Value:@"time.nist.gov" pm1:0 pm2:0];
    param_value_t* ntp_server_value2 = [[param_value_t alloc] init];
    [ntp_server_value2 InitValue:1 Name:@"2" Title:@"time.kriss.re.kr" Value:@"time.kriss.re.kr" pm1:0 pm2:0];
    param_value_t* ntp_server_value3 = [[param_value_t alloc] init];
    [ntp_server_value3 InitValue:2 Name:@"3" Title:@"time.windows.com" Value:@"time.windows.com" pm1:0 pm2:0];
    param_value_t* ntp_server_value4 = [[param_value_t alloc] init];
    [ntp_server_value4 InitValue:3 Name:@"4" Title:@"time.nuri.net" Value:@"time.nuri.net" pm1:0 pm2:0];
    self.ntp_server =[NSArray arrayWithObjects:ntp_server_value1,ntp_server_value2,ntp_server_value3,ntp_server_value4,nil];
    
     //time_zone
     param_value_t* time_zone_value1 = [[param_value_t alloc] init];
     [time_zone_value1 InitValue:39600 Name:@"" Title:
      NSLocalizedStringFromTable(@"datetimeZone0", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
     param_value_t* time_zone_value2 = [[param_value_t alloc] init];
     [time_zone_value2 InitValue:36000 Name:@"" Title:
      NSLocalizedStringFromTable(@"datetimeZone1", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
     param_value_t* time_zone_value3 = [[param_value_t alloc] init];
     [time_zone_value3 InitValue:32400 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone2", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
     param_value_t* time_zone_value4 = [[param_value_t alloc] init];
     [time_zone_value4 InitValue:28800 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone3", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value5 = [[param_value_t alloc] init];
    [time_zone_value5 InitValue:25200 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone4", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value6 = [[param_value_t alloc] init];
    [time_zone_value6 InitValue:21600 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone5", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value7 = [[param_value_t alloc] init];
    [time_zone_value7 InitValue:18000 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone6", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value8 = [[param_value_t alloc] init];
    [time_zone_value8 InitValue:14400 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone7", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value9 = [[param_value_t alloc] init];
    [time_zone_value9 InitValue:12600 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone8", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value10 = [[param_value_t alloc] init];
    [time_zone_value10 InitValue:10800 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone9", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value11 = [[param_value_t alloc] init];
    [time_zone_value11 InitValue:7200 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone10", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value12 = [[param_value_t alloc] init];
    [time_zone_value12 InitValue:3600 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone11", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value13 = [[param_value_t alloc] init];
    [time_zone_value13 InitValue:0 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone12", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value14 = [[param_value_t alloc] init];
    [time_zone_value14 InitValue:-3600 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone13", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value15 = [[param_value_t alloc] init];
    [time_zone_value15 InitValue:-7200 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone14", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value16 = [[param_value_t alloc] init];
    [time_zone_value16 InitValue:-10800 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone15", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value17 = [[param_value_t alloc] init];
    [time_zone_value17 InitValue:-12600 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone16", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value18 = [[param_value_t alloc] init];
    [time_zone_value18 InitValue:-14400 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone17", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value19 = [[param_value_t alloc] init];
    [time_zone_value19 InitValue:-16200 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone18", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value20 = [[param_value_t alloc] init];
    [time_zone_value20 InitValue:-18000 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone19", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value21 = [[param_value_t alloc] init];
    [time_zone_value21 InitValue:-19800 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone20", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value22 = [[param_value_t alloc] init];
    [time_zone_value22 InitValue:-21600 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone21", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value23 = [[param_value_t alloc] init];
    [time_zone_value23 InitValue:-25200 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone22", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value24 = [[param_value_t alloc] init];
    [time_zone_value24 InitValue:-28800 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone23", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value25 = [[param_value_t alloc] init];
    [time_zone_value25 InitValue:-32400 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone24", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value26 = [[param_value_t alloc] init];
    [time_zone_value26 InitValue:-34200 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone25", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value27 = [[param_value_t alloc] init];
    [time_zone_value27 InitValue:-36000 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone26", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value28 = [[param_value_t alloc] init];
    [time_zone_value28 InitValue:-39600 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone27", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    param_value_t* time_zone_value29 = [[param_value_t alloc] init];
    [time_zone_value29 InitValue:-43200 Name:@"" Title:
     NSLocalizedStringFromTable(@"datetimeZone28", @STR_LOCALIZED_FILE_NAME, nil) Value:nil pm1:0 pm2:0];
    self.time_zone = [NSArray arrayWithObjects:time_zone_value1,
                 time_zone_value2,
                 time_zone_value3,
                 time_zone_value4,
                 time_zone_value5,
                 time_zone_value6,
                 time_zone_value7,
                 time_zone_value8,
                 time_zone_value9,
                 time_zone_value10,
                 time_zone_value11,
                 time_zone_value12,
                 time_zone_value13,
                 time_zone_value14,
                 time_zone_value15,
                 time_zone_value16,
                 time_zone_value17,
                 time_zone_value18,
                 time_zone_value19,
                 time_zone_value20,
                 time_zone_value21,
                 time_zone_value22,
                 time_zone_value23,
                 time_zone_value24,
                 time_zone_value25,
                 time_zone_value26,
                 time_zone_value27,
                 time_zone_value28,
                 time_zone_value29,
                 nil];
    
    param_value_t* ssl_value1 = [[param_value_t alloc] init];
    [ssl_value1 InitValue:0 Name:@"NONE" Title:nil Value:nil pm1:0 pm2:0];
    param_value_t* ssl_value2 = [[param_value_t alloc] init];
    [ssl_value2 InitValue:1 Name:@"SSL" Title:nil Value:nil pm1:0 pm2:0];
    param_value_t* ssl_value3 = [[param_value_t alloc] init];
    [ssl_value3 InitValue:2 Name:@"TLS" Title:nil Value:nil pm1:0 pm2:0];
    self.ssl =[NSArray arrayWithObjects:ssl_value1,ssl_value2,ssl_value3,nil];
    
    //smtp_svr
    param_value_t* smtp_svr_value1 = [[param_value_t alloc] init];
    [smtp_svr_value1 InitValue:0 Name:@"smtp.gmail.com" Title:@"" Value:@"" pm1:465 pm2:2];
    param_value_t* smtp_svr_value2 = [[param_value_t alloc] init];
    [smtp_svr_value2 InitValue:1 Name:@"smtp.mail.yahoo.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value3 = [[param_value_t alloc] init];
    [smtp_svr_value3 InitValue:2 Name:@"smtp.sina.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value4 = [[param_value_t alloc] init];
    [smtp_svr_value4 InitValue:3 Name:@"smtp.qq.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value5 = [[param_value_t alloc] init];
    [smtp_svr_value5 InitValue:4 Name:@"smtp.sohu.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value6 = [[param_value_t alloc] init];
    [smtp_svr_value6 InitValue:5 Name:@"smtp.yeah.net" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value7 = [[param_value_t alloc] init];
    [smtp_svr_value7 InitValue:6 Name:@"smtp.126.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value8 = [[param_value_t alloc] init];
    [smtp_svr_value8 InitValue:7 Name:@"smtp.163.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value9 = [[param_value_t alloc] init];
    [smtp_svr_value9 InitValue:8 Name:@"smtp.tom.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value10 = [[param_value_t alloc] init];
    [smtp_svr_value10 InitValue:9 Name:@"smtp.264.net" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value11 = [[param_value_t alloc] init];
    [smtp_svr_value11 InitValue:10 Name:@"smtp.21cn.com" Title:@"" Value:@"" pm1:25 pm2:0];
    param_value_t* smtp_svr_value12 = [[param_value_t alloc] init];
    [smtp_svr_value12 InitValue:11 Name:@"mx.eyou.com" Title:@"" Value:@"" pm1:25 pm2:0];
    self.smtp_svr = [NSArray arrayWithObjects:smtp_svr_value1,
                smtp_svr_value2,
                smtp_svr_value3,
                smtp_svr_value4,
                smtp_svr_value5,
                smtp_svr_value6,
                smtp_svr_value7,
                smtp_svr_value8,
                smtp_svr_value9,
                smtp_svr_value10,
                smtp_svr_value11,
                smtp_svr_value12,
                nil];
}

@end
