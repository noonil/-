//
//  BViewController.m
//  TrafficCommunication
//
//  Created by xbk on 13-12-23.
//  Copyright (c) 2013年 com. All rights reserved.
//

#import "BViewController.h"


@interface BViewController () <UIGestureRecognizerDelegate>

@end

@implementation BViewController
@synthesize progressHUD = _progressHUD;
@synthesize notePressHUD = _notePressHUD;
@synthesize leftImg = _leftImg;
@synthesize midImg = _midImg;
@synthesize rightImg = _rightImg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    if(![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance=NO;
      //  self.navigationController.navigationBar.translucent = NO;
       // self.tabBarController.tabBar.translucent = NO;
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f5" andAlpha:1.0];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleSwipe:)];
    gesture.delegate = self;
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gesture];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    [self setupMenuBarButtonItems];
    
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self] &&
       ![self isKindOfClass:[MenuViewController class]])
    {
        self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
    }
    else
    {
        self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    }
}

- (void)setupMenuBarButtonItems
{
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self])
    {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (UIBarButtonItem *)leftMenuBarButtonItem
{
    
    return [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(leftSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)backBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
}

- (void)setupNavigation
{
    UIButton *btn = nil;
    UIBarButtonItem *rItems = nil;
    if (self.leftImg) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 25, 25)];
//        [btn setTitle:@"左边" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:self.leftImg forState:UIControlStateNormal];
  //      [btn setBackgroundImage:self.leftImg forState:UIControlStateHighlighted];
        rItems = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = rItems;
    }
    NSMutableArray *array = [NSMutableArray array];
   
    if (self.rightImg) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 25, 25)];
         [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:self.rightImg forState:UIControlStateNormal];
      //  [btn setBackgroundImage:self.rightImg forState:UIControlStateHighlighted];

        rItems = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [array addObject:rItems];
    }
    if (self.midImg) {
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setFrame:CGRectMake(0, 0, 25, 25)];
         [btn addTarget:self action:@selector(midBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:self.midImg forState:UIControlStateNormal];
     //   [btn setBackgroundImage:self.midImg forState:UIControlStateHighlighted];
        rItems = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [array addObject:rItems];
    }
    self.navigationItem.rightBarButtonItems = array;
}
- (void)setupToolBar
{
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(leftToolBarItemClicked)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(RightToolBarItemClicked)];
    NSArray *array = [[NSArray alloc] initWithObjects:btnItem,spaceItem,btnItem1,nil];

    [self setToolbarItems:array];
}
- (void)leftBtnClick:(UIButton *)btn
{
    
}
- (void)rightBtnClick:(UIButton *)btn
{
    
}
- (void)midBtnClick:(UIButton *)btn
{
    
}
- (void)leftToolBarItemClicked
{
    
}
- (void)RightToolBarItemClicked
{
    
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.mode = MBProgressHUDModeIndeterminate;
    }
    return _progressHUD;
}

- (void)showProgressHUDInfo:(NSString *)info
{
    [self.notePressHUD setLabelText:info];
    [self.notePressHUD show:YES];
    [self.notePressHUD hide:YES afterDelay:1.5];
}

- (MBProgressHUD *)notePressHUD
{
    if (!_notePressHUD) {
        _notePressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _notePressHUD.mode = MBProgressHUDModeText;
    }
    return _notePressHUD;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
