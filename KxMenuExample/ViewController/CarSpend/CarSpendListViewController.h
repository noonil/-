//
//  CarSpendListViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/5/22.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDViewController.h"

@interface CarSpendListViewController :HUDViewController< UITableViewDelegate ,UITableViewDataSource, UIAlertViewDelegate,UIActionSheetDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIActionSheet *actionSheet;


@end
