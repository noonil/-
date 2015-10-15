//
//  BViewController.h
//  TrafficCommunication
//
//  Created by xbk on 13-12-23.
//  Copyright (c) 2013年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface BViewController : UIViewController<MBProgressHUDDelegate>
@property (nonatomic,strong)MBProgressHUD *progressHUD;
@property (nonatomic,strong)MBProgressHUD *notePressHUD;
@property (nonatomic,strong)UIImage       *leftImg;
@property (nonatomic,strong)UIImage       *midImg;
@property (nonatomic,strong)UIImage       *rightImg;
- (void)setupNavigation;
- (void)setupToolBar;
- (void)setupMenuBarButtonItems;

- (void)showProgressHUDInfo:(NSString *)info;

@end
