//
//  HUDViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/6/10.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "HUDViewController.h"
#import "MBProgressHUD.h"
#import "BackGroundView.h"

@interface HUDViewController ()

@end

@implementation HUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
   // [HUD release];
    HUD = nil;
}

-(UIView *)bkView{
    if (nil==_bkView) {
        _bkView= [[UIView alloc] init];
        _bkView.frame = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height);
        _bkView.backgroundColor =KBackGroundColor;

    }
    return _bkView;
}

@end
