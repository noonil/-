//
//  ViewController.m
//  kxmenu
//
//  Created by Kolyvan on 17.05.13.
//  Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
//

#import "ViewController.h"
#import "KxMenu.h"
#import "CarsListViewController.h"
#import "DriverCarEditViewController.h"
#import "CarSpendListViewController.h"
#import "DriveCar.h"

@interface ViewController ()
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong)UIButton * button;
@property (nonatomic,strong) DriveCar *driverCar;
@end

@implementation ViewController {
    

    UIButton *_btn3;

}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    return self;
}

- (void) loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    const CGFloat W = self.view.bounds.size.width;
    

    
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3.frame = CGRectMake(W - 105, 5, 100, 50);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showMenu:) ];
    self.navigationItem.rightBarButtonItem=menuButton;
    
    
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = CGRectMake(W - 155, 120, 100, 50);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _status = [userDefaults stringForKey:@"status"];
    

    
    [_button addTarget:self action:@selector(showDriveCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];

    

    //[KxMenu setTintColor: [UIColor colorWithRed:15/255.0f green:97/255.0f blue:33/255.0f alpha:1.0]];
    //[KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
    
    

    
    

    _dataArray = [[Util getUsingLKDBHelper] searchWithSQL:@"select * from @t" toClass:[DriveCar class]];
    
    for (int i=0; i<[_dataArray count]; i++) {
        DriveCar *mm=[_dataArray objectAtIndex:i ];
        NSLog(@"rowid=%ld   downCarId=%@",mm.rowid,mm.downCarRowId);
    }
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _status = [userDefaults stringForKey:@"status"];
    
    if (     [@"S" isEqualToString:_status ]  || _status ==nil   ) {
        [_button setTitle:@"上车" forState:UIControlStateNormal];
        
    }
    else if ([@"E" isEqualToString:_status]) {
        
        [_button setTitle:@"下车" forState:UIControlStateNormal];
        
    }


}


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    const CGFloat W = self.view.bounds.size.width;
    _btn3.frame = CGRectMake(W - 105, 12, 100, 50);
    
    
    
    CGRect tableFrame=self.view.frame;// CGRectMake(0, 400, 300, 100);
    //CGRect tableBound=self.view.bounds;
    tableFrame.origin.y=300;
    tableFrame.size.height=250;
    //tableBound.size.height=200;
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
   // self.tableView.bounds=tableBound;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor redColor];
    self.tableView.backgroundColor=[UIColor greenColor];

    
   // [[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"username"];

}



#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    DriveCar *driverCar=self.dataArray[indexPath.row];
    cell.textLabel.text =driverCar.licpn ;
    cell.detailTextLabel.text=driverCar.status;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _driverCar=self.dataArray[indexPath.row];
    

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"确定删除吗" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
        
        [alert show];
 
    
}

#pragma mark -UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [[Util getUsingLKDBHelper] deleteToDB:_driverCar];
            _dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:@"select * from @t" toClass:[DriveCar class]];
            [self.tableView reloadData];
            break;
        case 1:
            break;
        default:
            break;
    }
    
    
}

#pragma mark -showMenu

- (void)showMenu:(UIBarButtonItem *)sender
{
    NSArray *menuItems =
    @[
      
//      [KxMenuItem menuItem:@"ACTION MENU 1234456"
//                     image:nil
//                    target:nil
//                    action:NULL],
//            
//      [KxMenuItem menuItem:@"Share this"
//                     image:[UIImage imageNamed:@"action_icon"]
//                    target:self
//                    action:@selector(pushMenuItem:)],
//      
//      [KxMenuItem menuItem:@"Check this menu"
//                     image:nil
//                    target:self
//                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"车辆管理"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(showCarsList:)],
      
      [KxMenuItem menuItem:@"过路桥费管理"
                     image:[UIImage imageNamed:@"search_icon"]
                    target:self
                    action:@selector(showCarSpendList:)],
      
//      [KxMenuItem menuItem:@"Go home"
//                     image:[UIImage imageNamed:@"home_icon"]
//                    target:self
//                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:_btn3.frame
                 menuItems:menuItems];
}

- (void) showCarsList:(id)sender
{
    
    //NSLog(@"%@", sender);
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:[[CarsListViewController alloc]init] animated:YES];
}

- (void) showCarSpendList:(id)sender
{
    //NSLog(@"%@", sender);
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:[[CarSpendListViewController alloc]init] animated:YES];
}

- (void) showDriveCar:(id)sender
{
    //NSLog(@"%@", sender);
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:[[DriverCarEditViewController alloc]init] animated:YES];
    
}



@end
