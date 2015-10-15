//
//  DriverCarEditViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDViewController.h"
@class DriveCar;
@class Car;

@interface DriverCarEditViewController : HUDViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate, MBProgressHUDDelegate>

@property (nonatomic,strong) Car *car;
@property (weak, nonatomic) IBOutlet UITextField *licpnTxt;
@property (weak, nonatomic) IBOutlet UITextField *upCarMailsTxt;
@property (weak, nonatomic) IBOutlet UITextField *downCarMailsTxt;
@property (weak, nonatomic) IBOutlet UILabel *licpnLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginEndBtn;
@property (strong, nonatomic) IBOutlet UIView *updateView;
@property (weak, nonatomic) IBOutlet UIImageView *upCarImgView;
@property (weak, nonatomic) IBOutlet UIImageView *downCarImgView;
@property (weak, nonatomic) IBOutlet UIButton *upCarImgButton;
@property (weak, nonatomic) IBOutlet UIButton *downCarImgButton;
@property (weak, nonatomic) IBOutlet UIImageView *showPictureImgView;
@property (weak, nonatomic) IBOutlet UITextView *memoTxtView;


@property (strong, nonatomic)NSString *status;//(S:上车上传，E:下车上传）
@property (strong, nonatomic)MBProgressHUD *HUD;
//@property (nonatomic,strong)DriveCar *driverCar;

- (IBAction)licpnTxt_TouchDown:(id)sender;
- (IBAction)upDownCarTxt_DidEndOnExit:(id)sender;
- (IBAction)beginEndBtn_TouchDown:(id)sender;
- (IBAction)cancelBtn_TouchDown:(id)sender;
- (IBAction)updateBtn_TouchDown:(id)sender;
- (IBAction)upCarImg_TouchDown:(id)sender;
- (IBAction)downCarImg_TouchDown:(id)sender;




@end
