//
//  DriverCarListTableViewCell.h
//  KxMenuExample
//
//  Created by xuming on 15/5/29.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverCarListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *driveInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *submitStatusLabel;

@end
