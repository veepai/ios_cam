//
//  WifiPwdViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-9.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import "WifiPwdViewController.h"
#import "WifiPwdCell.h"
#import "obj_common.h"

#include "CameraViewController.h"
#import "VSNet.h"

@interface WifiPwdViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation WifiPwdViewController

@synthesize m_strSSID;
@synthesize m_channel;
@synthesize m_security;
@synthesize m_strDID;
@synthesize m_strPwd;
@synthesize textPassword;
@synthesize navigationBar;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textPassword = nil;
    NSString *strTitle = NSLocalizedStringFromTable(@"EnterPwd", @STR_LOCALIZED_FILE_NAME, nil);
      self.navigationItem.title = strTitle;
    
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)      
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(btnSetWifi:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    [rightButton release];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    
    self.textPassword = nil;
    self.m_strSSID = nil;
    self.m_strDID = nil;
    self.m_strPwd = nil;
    self.navigationBar = nil;
    [super dealloc];
}

- (void) btnSetWifi:(id)sender
{
    if (textPassword != nil) {
        [textPassword resignFirstResponder];
    }
    
    char *pkey = NULL;
    char *pwpa_psk = NULL;
    switch (m_security) {
        case 0: //none
            pkey = (char*)"";
            pwpa_psk = (char*)"";
            break;
        case 1: //wep
            pkey = (char*)[m_strPwd UTF8String];
            pwpa_psk = (char*)"";
            break;
        case 2: //wpa-psk(AES)
        case 3://wpa-psk(TKIP)
        case 4://wpa2-psk(AES)
        case 5://wpa3-psk(TKIP)
            pkey = (char*)"";
            pwpa_psk = (char*)[m_strPwd UTF8String];
            break;
        default:
            break;
    }
    
    NSString *cmd = [NSString stringWithFormat:@"set_wifi.cgi?enable=1&ssid=%@&encrypt=0&defkey=0&key1=%s&key2=&key3=&key4=&authtype=%d&keyformat=0&key1_bits=0&key2_bits=0&key3_bits=0&key4_bits=0&channel=%d&mode=0&wpa_psk=%s&",m_strSSID,pkey,m_security,m_channel,pwpa_psk];
    
    NSString *sendSSID = [cmd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[VSNet shareinstance] sendCgiCommand:sendSSID withIdentity:m_strDID];
    [[VSNet shareinstance] setControlDelegate:m_strDID withDelegate:self];
    
    alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"WIFISetSucInfomation", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)rebootPrompt:(id)sender{
    if ((alertView != nil)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        [alertView release];
        alertView = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)anlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [alertView release];
    alertView = nil;
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"WifiPwdCell";	
    WifiPwdCell *cell =  (WifiPwdCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WifiPwdCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textPassword.delegate = self;
    cell.lablePassword.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
}

#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textPassword = textField;    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.m_strPwd = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 64) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark -  VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"WifiPwdViewController VSNet返回数据 UID:%@ comtype %ld",deviceIdentity,(long)comType);
}
@end
