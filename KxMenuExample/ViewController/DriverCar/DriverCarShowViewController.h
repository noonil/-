//
//  DriverCarShowViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/6/3.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DriveCar;
#import "HUDViewController.h"

@interface DriverCarShowViewController : HUDViewController<UIGestureRecognizerDelegate>
@property (nonatomic, strong)DriveCar *driverCar;

@property (weak, nonatomic) IBOutlet UILabel *mailUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailDownLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upImgView;
@property (weak, nonatomic) IBOutlet UIImageView *downImgView;
@property (weak, nonatomic) IBOutlet UIButton *upLoadButton;
@property (strong, nonatomic) IBOutlet UIView *modifyView;
@property (weak, nonatomic) IBOutlet UITextField *modifyMilesTxt;
@property (weak, nonatomic) IBOutlet UIButton *modifyDownBtn;
@property (weak, nonatomic) IBOutlet UILabel *mileLabel;


- (IBAction)modifyUpCar_TouchUpInside:(id)sender;
- (IBAction)modifyDownCar_TouchUpInside:(id)sender;
- (IBAction)cancelModify_TouchUpInside:(id)sender;
- (IBAction)submitModify_TouchUpInside:(id)sender;
- (IBAction)modifyMilesTxt_DidEndOnExit:(id)sender;

- (IBAction)upLoad_TouchDown:(id)sender;




@end
