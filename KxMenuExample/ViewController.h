//
//  ViewController.h
//  kxmenu
//
//  Created by Kolyvan on 17.05.13.
//  Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController< UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;


@end
