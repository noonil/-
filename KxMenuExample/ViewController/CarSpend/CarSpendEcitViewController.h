//
//  CarSpendEcitViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"
#import "HUDViewController.h"
#import "CarsListViewController.h"


@interface CarSpendEcitViewController : HUDViewController<UIActionSheetDelegate,UITextFieldDelegate>

@property (strong, nonatomic)Car *car;

@property (weak, nonatomic) IBOutlet UITextField *licpnTxt;
@property (weak, nonatomic) IBOutlet UITextField *timeTxt;
@property (weak, nonatomic) IBOutlet UITextField *spendTxt;


@property (weak, nonatomic) IBOutlet UIView *carView;

@property (strong, nonatomic) IBOutlet UITableView *carTableView;
@property (strong, nonatomic) IBOutlet CarsListViewController *carsListView;


- (IBAction)textField_DidEndOnExit:(id)sender;
- (IBAction)licpnTxt_TouchDown:(id)sender;
- (IBAction)timeTxt_TouchDown:(id)sender;
- (IBAction)addCar_TouchDown:(id)sender;
- (IBAction)cancelAddCar_TouchDown:(id)sender;



- (IBAction)pressCancelButton:(id)sender;
- (IBAction)pressSubmitButton:(id)sender;




@end
