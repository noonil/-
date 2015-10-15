//
//  DriverCarListViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDViewController.h"

@interface DriverCarListViewController : HUDViewController< UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;//上车记录
@property (weak, nonatomic) IBOutlet UIButton *upDown_Car_Button;

- (IBAction)showDriveCar_TouchDown:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;

@property (nonatomic, strong) NSMutableDictionary *dataMap;
//@property (nonatomic, strong) UITableView *tableView;
@end
