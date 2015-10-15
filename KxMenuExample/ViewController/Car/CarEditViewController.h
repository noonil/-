//
//  CarEditViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/5/22.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDViewController.h"
#import "Car.h"

@interface CarEditViewController : HUDViewController<UITextFieldDelegate>
{
    
    UITextField *licpn;//车牌号
    UITextField *driver;
    UITextField *driverPhone;//驾车师傅电话
    
    UIButton *cancel;
    UIButton *submit;


    
}
@property(nonatomic, assign)NSInteger tag;
@property(nonatomic, retain)IBOutlet UITextField *licpnTxt;
@property(nonatomic, retain)IBOutlet UITextField *driverTxt;
@property(nonatomic, retain)IBOutlet UITextField *driverPhoneTxt;
@property(nonatomic, retain)Car *car;

@property(nonatomic, retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic, retain)IBOutlet UIButton *submitBtn;

- (IBAction)textFiledReturnEditing:(id)sender;
- (IBAction)canelBunPressed:(id)sender;
- (IBAction)submitBunPressed:(id)sender;




@end
