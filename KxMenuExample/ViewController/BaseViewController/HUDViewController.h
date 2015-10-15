//
//  HUDViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/6/10.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface HUDViewController : UIViewController<MBProgressHUDDelegate>

{
    MBProgressHUD *HUD;
}
//@property (nonatomic,strong)UIView *backGroundView;
@property (nonatomic,strong)UIView *bkView;//遮罩层

@end
