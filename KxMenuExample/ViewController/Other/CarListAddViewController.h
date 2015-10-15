//
//  CarListAddViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/7/13.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDViewController.h"
#import "CarsListViewController.h"

@interface CarListAddViewController : HUDViewController
- (IBAction)cancelButton_TouchDown:(UIButton *)sender;
- (IBAction)addButton_TouchDown:(id)sender;
@property (strong, nonatomic) IBOutlet CarsListViewController *carListVC;

@end
