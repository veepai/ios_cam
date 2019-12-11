//
//  UserPwdSetViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-24.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import "UserPwdSetViewController.h"
#import "obj_common.h"
#import "CameraInfoCell.h"
#import "MBProgressHUD.h"

#import "VSNet.h"
#import "cmdhead.h"
#import "APICommon.h"
#import "CameraViewController.h"

static const double PageViewControllerTextAnimationDuration = 0.33;

@interface UserPwdSetViewController ()
{
    MBProgressHUD *loadHUD;
}
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation UserPwdSetViewController

@synthesize m_strUser;
@synthesize m_strPwd;
@synthesize textUser;
@synthesize textPassword;
@synthesize tableView;
@synthesize navigationBar;
@synthesize currentTextField;

@synthesize m_user1;
@synthesize m_pwd1;
@synthesize m_user2;
@synthesize m_pwd2;

@synthesize m_strDID;
@synthesize alertView;
@synthesize timer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_strUser = @"admin";
    }
    return self;
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnSetUserPwd:(id)sender
{
    if (textUser!= nil) {
        [textUser resignFirstResponder];
    }
    if (textPassword != nil) {
        [textPassword resignFirstResponder];
    }    
    [textPassword endEditing:YES];
    
    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"PwdChangedSuc", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil];
    
    [alertView show];

}


- (BOOL) EditP2PCameraInfo:(BOOL)bAdd Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid
{
    NSLog(@"EditP2PCameraInfo  bAdd: %d, name: %@, did: %@, user: %@, pwd: %@, olddid: %@", bAdd, name, did, user, pwd, olddid);
    
    BOOL bRet;
    
    if (bAdd == YES) {
        bRet = [_cameraListMgt AddCamera:name DID:did User:user Pwd:pwd Snapshot:nil];
    }else {
        bRet = [_cameraListMgt EditCamera:olddid Name:name DID:did User:user Pwd:pwd];
    }
    
    if (bRet == YES) {
        
        //修改成功，重新启动P2P连接
        sleep(3.0f);
        CameraViewController *camereView = [self.navigationController.viewControllers objectAtIndex:0];
        [[VSNet shareinstance] stop:did];
        if([[VSNet shareinstance] IsVUID:did])
           [[VSNet shareinstance] StartVUID:nil withPassWord:pwd initializeStr:nil LanSearch:1 ID:nil ADD:NO VUID:did LastonlineTimestamp:0 withDelegate:camereView];
        else
            [[VSNet shareinstance] start:did withUser:user withPassWord:pwd initializeStr:nil LanSearch:1];
        
        [[VSNet shareinstance] setStatusDelegate:did withDelegate:camereView];
        [[VSNet shareinstance] setControlDelegate:did withDelegate:camereView];
        
        [loadHUD hide:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
        
    }else{
        NSLog(@"操作失败!");
        [loadHUD hide:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
    
    NSLog(@"bRet: %d", bRet);
    
    return bRet;
}


- (void)rebootPrompt:(id)sender{
    if (alertView != nil) {
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
    
    [alertView release];
    alertView = nil;
    
    loadHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:loadHUD];
    loadHUD.dimBackground = YES;
    
    loadHUD.labelText = NSLocalizedStringFromTable(@"PleaseWait", @STR_LOCALIZED_FILE_NAME, Nil);
    [loadHUD show:YES];
    
    [[VSNet shareinstance] setControlDelegate:m_strDID withDelegate:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sendCGI];
    });
}

- (void)sendCGI
{

    NSString *cmdStr = [NSString stringWithFormat:@"set_users.cgi?&user1=%@&user2=%@&user3=%@&pwd1=%@&pwd2=%@&pwd3=%@&", @"", @"", @"admin", @"", @"", m_strPwd];
    [[VSNet shareinstance] sendCgiCommand:cmdStr withIdentity:m_strDID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textPassword = nil;
    NSString *strTitle = NSLocalizedStringFromTable(@"UserSetting", @STR_LOCALIZED_FILE_NAME, nil);
    self.navigationItem.title = strTitle;
    
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)      
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(btnSetUserPwd:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;

    [rightButton release];
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc{
    
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
   
    self.m_strUser = nil;
    self.m_strPwd = nil;
    self.textPassword = nil;
    self.textUser = nil;
    self.navigationBar = nil;
    self.m_strDID = nil;
    self.m_user1 = nil;
    self.m_pwd1 = nil;
    self.m_user2 = nil;
    self.m_pwd2 = nil;
    self.tableView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark KeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
    CGRect keyboardRect = CGRectZero;
	if (UIKeyboardFrameEndUserInfoKey != nil)
	{
		keyboardRect = [self.view.superview
                        convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                        fromView:nil];
	}
	else
	{
		NSArray *topLevelViews = [self.view.window subviews];
		if ([topLevelViews count] == 0)
		{
			return;
		}
		
		UIView *topLevelView = [[self.view.window subviews] objectAtIndex:0];
		keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
		keyboardRect.origin.y = topLevelView.bounds.size.height - keyboardRect.size.height;
		keyboardRect = [self.view.superview
                        convertRect:keyboardRect
                        fromView:topLevelView];
	}
	
	CGRect viewFrame = self.tableView.frame;
    
	textFieldAnimatedDistance = 0;
	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
	{
		textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
		viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
		[self.tableView setFrame:viewFrame];
		[UIView commitAnimations];
	}
    
	const CGFloat PageViewControllerTextFieldScrollSpacing = 10;
	CGRect textFieldRect =
    [self.tableView convertRect:currentTextField.bounds fromView:currentTextField];
    
    NSArray *rectarray = [self.tableView indexPathsForRowsInRect:textFieldRect];
    if (rectarray.count <= 0) {
        return;
    }
    
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	[self.tableView scrollRectToVisible:textFieldRect animated:NO];     
    
}

- (void)keyboardWillHideNotification:(NSNotification* )aNotification
{
    if (textFieldAnimatedDistance == 0){
		return;
	}
	
	CGRect viewFrame = self.tableView.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
	[self.tableView setFrame:viewFrame];
	[UIView commitAnimations];
	textFieldAnimatedDistance = 0;
}


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
    
    NSString *cellIdentifier = @"UserPwdCell";	
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
 
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        
        //disable selected cell
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CameraInfoCell * cell = (CameraInfoCell*)cell1;
        
        NSInteger row = anIndexPath.row;
        switch (row) {
            case 0:
                cell.keyLable.text = NSLocalizedStringFromTable(@"NewPwd", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.secureTextEntry = YES;
                cell.textField.text = self.m_strPwd;            
                break;
                
            default:
                break;
        }
        
        cell.textField.delegate = self;
        cell.textField.tag = row; 
    
	
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
}

#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            self.textPassword = textField; 
            break;        
        default:
            break;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            self.m_strPwd = textField.text;
            break;        
        default:
            break;
    }    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 16) {
        return NO;
    }
    
    return YES;
}


#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    [tableView reloadData];
}

#pragma mark -
#pragma mark navigationBarDelegate
- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark - VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"UserPwdSetViewController VSNet返回数据 UID:%@ comtype %ld",deviceIdentity,(long)comType);
    if (comType == CGI_IESET_USER && [deviceIdentity isEqualToString:m_strDID]) {
        NSInteger result = [[APICommon stringAnalysisWithFormatStr:@"result=" AndRetString:retString] integerValue];
        if (result == 0){
            [[VSNet shareinstance] sendCgiCommand:@"reboot.cgi?" withIdentity:m_strDID];
            [self EditP2PCameraInfo:NO Name:self.cameraName DID:self.m_strDID User:@"admin" Pwd:self.m_strPwd OldDID:self.m_strDID];
        }
        else{
            NSLog(@"修改密码失败");
        }
    }
}

@end
