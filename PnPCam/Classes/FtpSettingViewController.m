//
//  FtpSettingViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

static const double PageViewControllerTextAnimationDuration = 0.33;

#import "FtpSettingViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "CameraInfoCell.h"
#import "mytoast.h"

#import "VSNet.h"
#import "cmdhead.h"
#import "NSString+subValueFromRetString.h"
#import "CameraViewController.h"

@interface FtpSettingViewController ()

@end

@implementation FtpSettingViewController

@synthesize navigationBar;
@synthesize tableView;
@synthesize currentTextField;
@synthesize m_strFTPSvr;
@synthesize m_strPwd;
@synthesize m_strUser;
@synthesize m_strDID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnSetFTP:(id) sender
{
    [currentTextField resignFirstResponder];
    
    //set_ftp.cgi?svr=%s&port=%d&user=%s&pwd=%s&mode=%d&dir=%s&interval=%d&
    NSString* strCmd = [NSString stringWithFormat:@"set_ftp.cgi?svr=%s&port=%d&user=%s&pwd=%s&mode=0&dir=%s&interval=%d&",
                        [m_strFTPSvr UTF8String],
                        m_nFTPPort,
                        [m_strUser UTF8String],
                        [m_strPwd UTF8String],
                        "/",
                        m_nUploadInterval];
    
    
    [[VSNet shareinstance] sendCgiCommand:strCmd withIdentity:m_strDID];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.m_strFTPSvr = @"";
    self.m_strPwd = @"";
    self.m_strUser = @"";
    m_nFTPPort = 21;
    m_nUploadInterval = 0;
    
    //self.textPassword = nil;
    NSString *strTitle = NSLocalizedStringFromTable(@"FTPSetting", @STR_LOCALIZED_FILE_NAME, nil);

    self.navigationItem.title = strTitle;
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(btnSetFTP:)];
    
    //item.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];

    NSString *cmd1 = @"get_params.cgi?";
    [[VSNet shareinstance] setControlDelegate:m_strDID withDelegate:self];
    [[VSNet shareinstance] sendCgiCommand:cmd1 withIdentity:m_strDID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CameraViewController *camereView = [self.navigationController.viewControllers objectAtIndex:0];
    [[VSNet shareinstance] setControlDelegate:m_strDID withDelegate:camereView];
}

- (void) dealloc
{
    self.navigationBar = nil;
    self.tableView = nil;
    self.currentTextField = nil;
    self.m_strPwd = nil;
    self.m_strFTPSvr = nil;
    self.m_strUser = nil;
    self.m_strDID = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"FTPSettingCell1";
    
    CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell1 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    switch (anIndexPath.row) {
        case 0: //ftp server
        {            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPServer", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strFTPSvr;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputFtpServer", @STR_LOCALIZED_FILE_NAME, nil);
        }
            break;
        case 1: //ftp port
        {
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPPort", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nFTPPort];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
          
        }
            break;
        case 2: //ftp user
        {
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPUser", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strUser;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputFtpUser", @STR_LOCALIZED_FILE_NAME, nil);
            
        }
            break;
        case 3: //ftp pwd
        {
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPPwd", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strPwd;
            cell1.textField.secureTextEntry = YES;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputFtpPwd", @STR_LOCALIZED_FILE_NAME, nil);
            
        }
            break;
        case 4: //upload interval
        {
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPUploadInterval", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nUploadInterval];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
          
        }
            break;
            
        default:
            break;
    }    
    
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.textField.delegate = self;
    cell1.textField.tag = anIndexPath.row;
    
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
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
	CGRect textFieldRect =[self.tableView convertRect:currentTextField.bounds fromView:currentTextField];
    
    NSArray *rectarray = [self.tableView indexPathsForRowsInRect:textFieldRect];
    if (rectarray.count <= 0) {
        return;
    }
    
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	[self.tableView scrollRectToVisible:textFieldRect animated:NO];
    
}

- (void)keyboardWillHideNotification:(NSNotification* )aNotification
{
    if (textFieldAnimatedDistance == 0)
	{
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


#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0: // ftp server
            self.m_strFTPSvr = textField.text;
            break;
        case 1: //ftp port
            m_nFTPPort = atoi([textField.text UTF8String]);
            if (m_nFTPPort <= 0) {
                m_nFTPPort = 21;
            }
            break;
        case 2: //ftp user
            self.m_strUser = textField.text;
            break;
        case 3://ftp pwd
            self.m_strPwd = textField.text;
            break;
        case 4: //upload interval
            m_nUploadInterval = atoi([textField.text UTF8String]);
            if (m_nUploadInterval < 0) {
                m_nUploadInterval = 0;
            }
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
    return YES;
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark -
#pragma mark performOnMainThread
- (void) reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark - VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"FtpSettingViewController:返回数据 UID:%@,comType:%ld",deviceIdentity,(long)comType);
    if ([deviceIdentity isEqualToString:m_strDID] && comType == CGI_IEGET_PARAM)
    {
        NSInteger result = [[NSString subValueByKeyString:@"result=" fromRetString:retString] integerValue];
        if (result != 0) {
            NSLog(@"数据异常!");
            return;
        }
        
        m_strFTPSvr = [NSString subValueByKeyString:@"ftp_svr=" fromRetString:retString];
        m_nFTPPort = [[NSString subValueByKeyString:@"ftp_port=" fromRetString:retString] integerValue];
        m_strUser = [NSString subValueByKeyString:@"ftp_user=" fromRetString:retString];
        m_strPwd = [NSString subValueByKeyString:@"ftp_pwd=" fromRetString:retString];
        m_nUploadInterval = [[NSString subValueByKeyString:@"ftp_upload_interval=" fromRetString:retString] integerValue];
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
    }
}
@end
