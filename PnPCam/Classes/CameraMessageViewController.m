
#import "CameraMessageViewController.h"
#import "CameraViewController.h"
#import "CameraInfoCell.h"
#import "mytoast.h"
#import "CameraSearchViewController.h"
#import "iCloudLivePFZUIviewQR.h"
#import <VSNetAPI/VSNetAPI.h>

static const double PageViewControllerTextAnimationDuration = 0.33;

@interface CameraMessageViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation CameraMessageViewController
@synthesize bAddCamera;
@synthesize editCameraDelegate;
@synthesize strCameraName;
@synthesize strCameraID;
@synthesize time;
@synthesize currentTextField;
@synthesize tableView;
@synthesize navigationBar;
@synthesize messageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.strCameraName = @STR_DEFAULT_CAMERA_NAME;
        self.strCameraID = @"";
        self.time = @"";
        //self.strCameraID = @"VSTH000012BWZBR";
        //self.time = @"2018-10-24";
    }
    return self;
}

#pragma mark -
#pragma mark system

-(id)init
{
    self = [super init];
    if (self != nil) {
        self.strCameraName = @STR_DEFAULT_CAMERA_NAME;
        self.strCameraID = @"";
        self.time = @"";
    }
    
    return self ;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {   
    [super viewDidLoad];       
    
    NSString *strTitle;
   
    strTitle = NSLocalizedStringFromTable(@"TouchMessageCamera", @STR_LOCALIZED_FILE_NAME, nil);
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
    messageView = [[UITextView alloc] initWithFrame:CGRectMake(10, 280, 400, 300)];
    [messageView setText:@"message record"];
    
    [self.view addSubview:messageView];
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
    self.time = nil;
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
                cell.keyLable.text = NSLocalizedStringFromTable(@"time", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.placeholder = NSLocalizedStringFromTable(@"timetip", @STR_LOCALIZED_FILE_NAME, nil);
                cell.keyLable.font = [UIFont fontWithName:@"System Bold" size:17.f];
                //cell.textField.text = NSLocalizedStringFromTable(@"timetip", @STR_LOCALIZED_FILE_NAME, nil);
                break;
        }
        
        cell.textField.delegate = self;
        cell.textField.tag = row; 
    }else  if (row == 1){// lan search
        if (cell1 == nil) {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CustomMessageCameraCell" owner:nil options:nil];
            
            cell1 = [nib lastObject];
            
        }     
        UIImage* btnbackground = [UIImage imageNamed:@"BtnBackGround"];
        btnbackground = [btnbackground stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage* btnbackgroundselect = [UIImage imageNamed:@"BtnBackGroundSelect"];
        btnbackgroundselect = [btnbackgroundselect stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        CustomMessageCameraCell* Customcell = (CustomMessageCameraCell*)cell1;
    
        CGRect newFrame = Customcell.textField.frame;
        newFrame.size = CGSizeMake(self.winsize.width - 150, newFrame.size.height);
        Customcell.textField.frame = newFrame;
        
        Customcell.keyLabel.text = NSLocalizedStringFromTable(@"CameraID", @STR_LOCALIZED_FILE_NAME, nil);
        Customcell.keyLabel.font = [UIFont fontWithName:@"System Bold" size:17.f];
        Customcell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraID", @STR_LOCALIZED_FILE_NAME, nil);
        Customcell.textField.delegate = self;
        Customcell.textField.tag = row;
      
        
        [Customcell.scanButton setTitle:NSLocalizedStringFromTable(@"GET", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        NSString* scanstr = NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
        CGSize scanstrsize = [scanstr sizeWithFont:Customcell.scanButton.titleLabel.font constrainedToSize:Customcell.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        scanstrsize = CGSizeMake(scanstrsize.width + 20, scanstrsize.height + 10);
        CGRect scanNewFrame =Customcell.scanButton.frame;
        scanNewFrame.size = scanstrsize;
        scanNewFrame.origin = CGPointMake(scanNewFrame.origin.x , scanNewFrame.origin.y + 10);
        Customcell.scanButton.frame = scanNewFrame;

        [Customcell.scanButton addTarget:self action:@selector(btnGetMessage:) forControlEvents:UIControlEventTouchUpInside];
        Customcell.scanButton.titleLabel.textColor = [UIColor whiteColor];
      
        [Customcell.scanButton setBackgroundImage:btnbackground forState:UIControlStateNormal];
        [Customcell.scanButton setBackgroundImage:btnbackgroundselect forState:UIControlStateSelected];
 
    }    
    
	return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 88;
    }
    return 44;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}


-(void)btnGetMessage:(id)sender{
    NSLog(@"messageinf");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ([time length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputTime", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    if ([strCameraID length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCameraID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    UIActivityIndicatorView *activityIV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    activityIV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIV.color = [UIColor grayColor];
    [self.view addSubview:activityIV];
    [activityIV startAnimating];
    
    NSLog(@"strCameraID %@",strCameraID);
    NSLog(@"time %@",time);
    [WebAPIManager GetMessageDevice:self.strCameraID Time:self.time  ResultBlockSuccess:^(id result) {
        [activityIV stopAnimating];
        [activityIV release];
        NSDictionary *dic = result;
        NSString *json = nil;
        NSError *error ;
        NSData *jsondate = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&error];
        if(!jsondate)
        {
            NSLog(@"api记录 json error");
        }else{
            json = [[NSString alloc] initWithData:jsondate encoding:NSUTF8StringEncoding];
        }
        NSLog(@"api记录成功 json%@", json);
        //NSString *content = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"api记录成功 %@", content);
        
        [messageView setText: json];
         //[mytoast showWithText:result];
//        NSString *msgStr = dic[@"msg"];
//        if ([msgStr isEqualToString:@"unbind success"]) {
//            NSLog(@"api记录成功 %@", result);
//            [mytoast showWithText:NSLocalizedStringFromTable(@"api记录", @STR_LOCALIZED_FILE_NAME, nil)];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else
//            [mytoast showWithText:msgStr];
        
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
	NSLog(@"textFieldDidEndEditing");
    
    switch (textField.tag) {
        case TAG_CAMERA_NAME:
            self.time = textField.text;
            break;
        case TAG_CAMERA_ID:
            self.strCameraID = textField.text;
            break;
        case TAG_PASSWORD:
            self.time = textField.text;
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
    NSLog(@"textField %@ ,%d",textField.text,textField.tag);
    switch (textField.tag) {
        case TAG_CAMERA_NAME:
            self.time = [textField.text stringByAppendingString:string];
            break;
        case TAG_CAMERA_ID:
            self.strCameraID =  [textField.text stringByAppendingString:string];
            break;
        case TAG_PASSWORD:
            self.time = textField.text;
            break;
        default:
            break;
    }
    if (range.location >= 32) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark other


- (void) btnFinished:(id)sender
{
    [currentTextField resignFirstResponder];
    
    NSLog(@"CameraName: %@", strCameraName);
    NSLog(@"CameraID: %@", strCameraID);
    NSLog(@"Password: %@", time);
    
    if ([time length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCamreraName", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    if ([strCameraID length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCameraID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
   [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)performResultAction {
    
}

#pragma mark SearchAddCameraInfoDelegate
- (void) AddCameraInfo:(NSString *)astrCameraName DID:(NSString *)strDID
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
