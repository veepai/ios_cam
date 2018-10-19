    //
//  StartViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"
#import "obj_common.h"

@implementation StartViewController

@synthesize versionLabel;
@synthesize imgView;

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    CGRect winsize = [[UIScreen mainScreen] bounds];

    imgView.frame =winsize;
    NSString *strVersion = [NSString stringWithFormat:@"Ver %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    versionLabel.text = strVersion;
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.shadowColor = [UIColor blackColor];
    versionLabel.shadowOffset = CGSizeMake(1,1);
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
    [imgView  release];
    [versionLabel release];
    [super dealloc];
}

@end
