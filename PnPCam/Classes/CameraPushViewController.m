

#import "CameraPushViewController.h"
#import "CameraViewController.h"
#import "CameraInfoCell.h"
#import "mytoast.h"
#import "CameraSearchViewController.h"
#import "iCloudLivePFZUIviewQR.h"
#import <VSNetAPI/VSNetAPI.h>

static const double PageViewControllerTextAnimationDuration = 0.33;

@interface CameraPushViewController()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation CameraPushViewController

@synthesize bAddCamera;
@synthesize editCameraDelegate;
@synthesize strCameraName;
@synthesize strCameraID;
@synthesize oemid;
@synthesize currentTextField;
@synthesize tableView;
@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.strCameraName = @STR_DEFAULT_CAMERA_NAME;
        self.strCameraID = @"";
        self.oemid = @"PUSH";
//        self.strCameraID = @"";
//        self.oemid = @"PUSH";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

#pragma mark -
#pragma mark system

-(id)init
{
    self = [super init];
    if (self != nil) {
        self.strCameraName = @STR_DEFAULT_CAMERA_NAME;
        self.strCameraID = @"";
    }
    return self ;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {   
    [super viewDidLoad];       
    
    NSString *strTitle;
   
    strTitle = NSLocalizedStringFromTable(@"TouchPushCamera", @STR_LOCALIZED_FILE_NAME, nil);
    self.winsize = [UIScreen mainScreen].applicationFrame.size;
    self.navigationItem.title = strTitle;
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)      
                                style:UIBarButtonItemStyleBordered     
                               target:self     
                               action:@selector(btnFinished:)];
    
 //   rightButton.tintColor = [UIColor colorWithRed:BTN_DONE_RED/255.0f green:BTN_DONE_GREEN/255.0f blue:BTN_DONE_BLUE/255.0f alpha:0.5];
    
    //item.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    

    
    self.tableView.allowsSelection = NO;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [self.view removeGestureRecognizer:_swipeGes];
    [_swipeGes release],_swipeGes = nil;
    
    self.editCameraDelegate = nil;
    self.strCameraName = nil;
    self.strCameraID = nil;
    self.currentTextField = nil;
    self.tableView = nil;
    self.navigationBar = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    ///if (NO == bAddCamera) {
    return 1;
    //}
//return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //if (section == 0) {
        return 2;
    //}else {
       // return 1;
    //}
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = [NSString stringWithFormat:@"CameraInfoCell%d%d", anIndexPath.section, anIndexPath.row];//= @"CameraInfoCell1";	
    
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = anIndexPath.row;
    
    if (row != 1) {
        if (cell1 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
            cell1 = [nib objectAtIndex:0];
        }
        
        //disable selected cell
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        CameraInfoCell * cell = (CameraInfoCell*)cell1;

        CGRect newFrame = cell.textField.frame;
        newFrame.size = CGSizeMake(self.winsize.width - 180, newFrame.size.height);
        cell.textField.frame = newFrame;
        switch (row)
        {
            case 0: 
                cell.keyLable.text = NSLocalizedStringFromTable(@"OEMID", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputOemID", @STR_LOCALIZED_FILE_NAME, nil);
                cell.keyLable.font = [UIFont fontWithName:@"System Bold" size:17.f];
                cell.textField.text = self.oemid;
                break;
        }
        
        cell.textField.delegate = self;
        cell.textField.tag = row; 
    }else  if (row == 1){// lan search
        if (cell1 == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CustomAddCameraCell" owner:nil options:nil];
            
            cell1 = [nib lastObject];
            
        }     
        UIImage* btnbackground = [UIImage imageNamed:@"BtnBackGround"];
        btnbackground = [btnbackground stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage* btnbackgroundselect = [UIImage imageNamed:@"BtnBackGroundSelect"];
        btnbackgroundselect = [btnbackgroundselect stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        CustomAddCameraCell* Customcell = (CustomAddCameraCell*)cell1;
    
        CGRect newFrame = Customcell.textField.frame;
        newFrame.size = CGSizeMake(self.winsize.width - 150, newFrame.size.height);
        Customcell.textField.frame = newFrame;
        
        Customcell.keyLabel.text = NSLocalizedStringFromTable(@"CameraID", @STR_LOCALIZED_FILE_NAME, nil);
        Customcell.keyLabel.font = [UIFont fontWithName:@"System Bold" size:17.f];
        Customcell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraID", @STR_LOCALIZED_FILE_NAME, nil);
        self.strCameraID = Customcell.textField.text;
        //Customcell.textField.text = self.strCameraID;
        Customcell.textField.delegate = self;
        Customcell.textField.tag = row;

        [Customcell.seachButton setTitle:NSLocalizedStringFromTable(@"bingdev", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        NSString* seachButtonText = NSLocalizedStringFromTable(@"Search11", @STR_LOCALIZED_FILE_NAME, nil);
        CGSize fontSize = [seachButtonText sizeWithFont:Customcell.seachButton.titleLabel.font constrainedToSize:Customcell.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        fontSize = CGSizeMake(fontSize.width + 20, fontSize.height + 10);
         CGRect newframe =  Customcell.seachButton.frame;
        newframe.size = fontSize;
        newframe.origin = CGPointMake(newframe.origin.x , newframe.origin.y + 10);
        Customcell.seachButton.frame = newframe;
        
        //Customcell.seachButton.layer.masksToBounds = YES;
        //Customcell.seachButton.layer.cornerRadius = 4.0;
        Customcell.seachButton.titleLabel.textColor = [UIColor whiteColor];
        //Customcell.seachButton.backgroundColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        [Customcell.seachButton setBackgroundImage:btnbackground forState:UIControlStateNormal];
        [Customcell.seachButton setBackgroundImage:btnbackgroundselect forState:UIControlStateSelected];
        [Customcell.seachButton addTarget:self action:@selector(bind:) forControlEvents:UIControlEventTouchUpInside];
                
        [Customcell.scanButton setTitle:NSLocalizedStringFromTable(@"unbingdev", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        NSString* scanstr = NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
        CGSize scanstrsize = [scanstr sizeWithFont:Customcell.scanButton.titleLabel.font constrainedToSize:Customcell.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        scanstrsize = CGSizeMake(scanstrsize.width + 20, scanstrsize.height + 10);
        CGRect scanNewFrame =Customcell.scanButton.frame;
        scanNewFrame.size = scanstrsize;
        scanNewFrame.origin = CGPointMake(scanNewFrame.origin.x , scanNewFrame.origin.y + 10);
        Customcell.scanButton.frame = scanNewFrame;

        [Customcell.scanButton addTarget:self action:@selector(unbind:) forControlEvents:UIControlEventTouchUpInside];
        Customcell.scanButton.titleLabel.textColor = [UIColor whiteColor];
        //Customcell.scanButton.layer.masksToBounds = YES;
        //Customcell.scanButton.layer.cornerRadius = 4.0f;
      
        [Customcell.scanButton setBackgroundImage:btnbackground forState:UIControlStateNormal];
         [Customcell.scanButton setBackgroundImage:btnbackgroundselect forState:UIControlStateSelected];
        //Customcell.scanButton.backgroundColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    }    
    
	return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 88;
    }
    return 44;
}

-(void)bind:(id)sender{
    NSLog(@"vst bind");
    if ([oemid length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"InputOemID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    if ([strCameraID length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCameraID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    NSLog(@"deviceToken %@",deviceToken);
    if (deviceToken.length == 0 || deviceToken == nil) {
        [mytoast showWithText:@"未获取到APNS token"];
        return;
    }
    UIActivityIndicatorView *activityIV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    activityIV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIV.color = [UIColor grayColor];
    [self.view addSubview:activityIV];
    [activityIV startAnimating];
    NSLog(@"deviceToken %@",deviceToken);
    NSLog(@"strCameraID %@",strCameraID);
    NSLog(@"oemid %@",oemid);
    [WebAPIManager BingdingDeviceUID:strCameraID Token:deviceToken Oemid:oemid Language:@"en" ResultBlockSuccess:^(id result) {
        [activityIV stopAnimating];
        [activityIV release];
        NSLog(@"注册摄像机成功 %@",result);
        [mytoast showWithText:NSLocalizedStringFromTable(@"推送绑定成功", @STR_LOCALIZED_FILE_NAME, nil)];
        [self.navigationController popViewControllerAnimated:YES];
    } Failure:^(NSError *error, NSInteger statusCode, NSString *resultMessage) {
        [activityIV stopAnimating];
        [activityIV release];
        if (statusCode == 401) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"注册摄像机失败: %ld %@", (long)statusCode, resultMessage);
    }];
}
-(void)unbind:(id)sender{
    NSLog(@"unbind");
    if ([strCameraID length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCameraID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    UIActivityIndicatorView *activityIV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    activityIV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIV.color = [UIColor grayColor];
    [self.view addSubview:activityIV];
    [activityIV startAnimating];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    [WebAPIManager UnbingdingDeviceUID:self.strCameraID Token:deviceToken Oemid:oemid ResultBlockSuccess:^(id result) {
        [activityIV stopAnimating];
        [activityIV release];
        NSDictionary *dic = result;
        NSLog(@"反注册摄像机成功 %@", result);
        NSString *msgStr = dic[@"msg"];
        if ([msgStr isEqualToString:@"unbind success"]) {
            NSLog(@"反注册摄像机成功 %@", result);
            [mytoast showWithText:NSLocalizedStringFromTable(@"推送解绑成功", @STR_LOCALIZED_FILE_NAME, nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
            [mytoast showWithText:msgStr];

    } Failure:^(NSError *error, NSInteger statusCode, NSString *resultMessage) {
        [activityIV stopAnimating];
        [activityIV release];
        NSLog(@"反注册摄像机失败：%@ %ld", resultMessage, (long)statusCode);
    }];
    
}

//反向传值
- (void)displayData:(NSString *)ScanString
{
    self.strCameraID = ScanString;
    UITextField *textField = (UITextField *)[self.view viewWithTag:1];
    textField.text = self.strCameraID;
    NSLog(@"回传后的字符串：%@",ScanString);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedStringFromTable(@"CameraInfo", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(section == 1){ //lan search
        //return NSLocalizedStringFromTable(@"LAN", @STR_LOCALIZED_FILE_NAME, nil);
        return nil;
    }else { //scan qr code
        ///return NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
        return nil;
    }
}

- (void) tableView:(UITableView *)anTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{ 
    [anTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
}


#pragma mark -
#pragma mark KeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
    //NSLog(@"keyboardWillShowNotification");
    
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

#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@"vst textFieldDidEndEditing");
    
    switch (textField.tag) {
        case TAG_CAMERA_NAME:
            self.oemid = textField.text;
            break;
        case TAG_CAMERA_ID:
            self.strCameraID = textField.text;
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
    NSLog(@"vst shouldChangeCharactersInRange %@",string);
    switch (textField.tag) {
        case TAG_CAMERA_ID:
            self.strCameraID = [textField.text stringByAppendingString:string];
            break;
        case TAG_PASSWORD:
            self.oemid = [textField.text stringByAppendingString:string];
            break;
    }
    if (range.location >= 32) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
      NSLog(@"vst textFieldDidBeginEditing %@",textField.text);
}


#pragma mark -
#pragma mark other


- (void) btnFinished:(id)sender
{
    NSLog(@"btnfinish------");
    [currentTextField resignFirstResponder];
    
    NSLog(@"CameraName: %@", strCameraName);
    NSLog(@"CameraID: %@", strCameraID);
    
    if ([strCameraName length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCamreraName", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    if ([strCameraID length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCameraID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    if (NO == bAddCamera) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)performResultAction {
    
}

#pragma mark SearchAddCameraInfoDelegate
- (void) AddCameraInfo:(NSString *)astrCameraName DID:(NSString *)strDID tmpdid:(NSString *)strTmpDID
{
    self.strCameraName = astrCameraName;
    self.strCameraID = strDID;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CameraInfoCell *cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];  
    if (cameraInfo == nil) {
        return;
    }
    
    cameraInfo.textField.text = strDID;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];  
    if (cameraInfo == nil) {
        return;
    }
    
    cameraInfo.textField.text = astrCameraName;
    
}

#pragma mark navigationbardelegate
- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

- (CGSize)scaleImage:(UIImage*)image{
    CGSize size = image.size;
    float scale = 44 / size.height;
    float width = size.width * scale;
    size = CGSizeMake(width, 44);
    return size;
    
}

@end
