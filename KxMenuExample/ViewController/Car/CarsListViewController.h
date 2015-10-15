//
//  CarsListViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/5/22.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDViewController.h"


@interface CarsListViewController : HUDViewController< UITableViewDelegate ,UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger tag;
//@property (nonatomic, strong) NSObject *carSpendEdit;

@end
