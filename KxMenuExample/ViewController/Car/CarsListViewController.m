//
//  CarsListViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/5/22.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "CarsListViewController.h"
#import "CarEditViewController.h"
#import "CarSpendEcitViewController.h"
#import "DriverCarEditViewController.h"
#import "Car.h"
#import "DriveCar.h"
#import "CarListAddViewController.h"





@interface CarsListViewController ()
@property(nonatomic, strong) CarEditViewController *carEditView;
@property(nonatomic, strong) Car *car;
//@property(nonatomic, strong) UIView *backGroundView;
@end

@implementation CarsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(pressAddCarButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor=blueColor;
    [self.view addSubview:self.tableView];
    
    self.title=@"华苏车辆管理";
    self.navigationController.navigationBar.backgroundColor=blueColor;
    //self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:@"select * from @t order by rowid" toClass:[Car class]];
    self.dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' order by rowid desc",[[NSUserDefaults standardUserDefaults]stringForKey:@"username"] ]toClass:[Car class]];

}

-(void)viewWillLayoutSubviews:(BOOL)animated{

}

-(void)viewWillAppear:(BOOL)animated{
  //  self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:@"select * from @t order by rowid" toClass:[Car class]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch event
-(void)pressAddCarButton{

    self.carEditView.tag=1;
    self.carEditView.licpnTxt.text=nil;
    self.carEditView.driverTxt.text=nil;
    self.carEditView.driverPhoneTxt.text=nil;
    
    
//    
//    [self.backGroundView addSubview:self.carEditView.view];
//
//    [self addChildViewController:self.carEditView];
//    [self.view addSubview:self.backGroundView];
//    
//    
    

    self.bkView.frame=self.navigationController.view.frame;
    [self.bkView addSubview:self.carEditView.view];
    
    [self.navigationController.view addSubview:self.bkView];
    [self.navigationController addChildViewController:self.carEditView];
    [self.carEditView didMoveToParentViewController:self.navigationController];
    

  

}



#pragma mark - table

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"车牌号             时间              过停费用";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];

    
    
    double x=self.tableView.bounds.size.width/3;
  
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, x+1, kHeight44)];
    label.backgroundColor = [UIColor whiteColor];
    label.text= @"车牌号";
    label.textColor=blueColor;
    label.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, x+1, kHeight44)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.text= @"师傅";
    label1.textColor=blueColor;
    label1.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(2*x, 0, x, kHeight44)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.text= @"手机号";
    label2.textColor=blueColor;
    label2.textAlignment=NSTextAlignmentCenter;
    
    
    [headerView addSubview:label];
    [headerView addSubview:label1];
    [headerView addSubview:label2];
    
    
    return headerView;
}

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
    

    Car *car=self.dataArray[indexPath.row];

    
    double x=self.view.bounds.size.width/3;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, x+1, cell.bounds.size.height)];
    //label.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.7];
    label.text= car.licpn;
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, x+1, cell.bounds.size.height)];
    //label1.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.7];
    label1.text= car.driver;
    label1.font=[UIFont systemFontOfSize:15];
    label1.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(2*x, 0, x, cell.bounds.size.height)];
    //label2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0.7];
    label2.text= car.driverPhone;
    label2.font=[UIFont systemFontOfSize:15];
    label2.textAlignment=NSTextAlignmentCenter;
    
    
    for(UIView *mylabelview in [cell subviews])
    {
        if ([mylabelview isKindOfClass:[UILabel class]]) {
            [mylabelview removeFromSuperview];
        }
    }
    [cell addSubview:label];
    [cell addSubview:label1];
    [cell addSubview:label2];
    
    cell.backgroundColor=blueColor;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 //self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:@"select * from @t" toClass:[Car class]];
 self.dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' order by rowid desc",[[NSUserDefaults standardUserDefaults]stringForKey:@"username"] ]toClass:[Car class]];
    _car=self.dataArray[indexPath.row];

    if (_tag==1) { //如果是从车停费页面跳转过来

        CarSpendEcitViewController *carSpendEditVC=(CarSpendEcitViewController *)self.parentViewController;

        
        for (UIView *view  in carSpendEditVC.view.subviews){
        
            [view removeFromSuperview];
        }
        
        
        
        
        NSArray *arr= [[NSBundle mainBundle] loadNibNamed:@"CarSpendEcitViewController" owner:carSpendEditVC options:nil] ;
        carSpendEditVC.view=[arr objectAtIndex:0];
        carSpendEditVC.view.backgroundColor=blueColor;
        carSpendEditVC.licpnTxt.text=_car.licpn;
        carSpendEditVC.car=_car;
        
        
        
        
    }
    else if (_tag==2) {//如果是从上车，下车页面跳转过来
        DriverCarEditViewController *driverCarEdit;
        UINavigationController *nav=(UINavigationController *)self.navigationController;
        driverCarEdit =nav.childViewControllers[1];
        

        CarListAddViewController * carListAddVC=(CarListAddViewController *)self.parentViewController;
        [carListAddVC willMoveToParentViewController:nil];
        [carListAddVC.view.superview removeFromSuperview];
        [carListAddVC.view removeFromSuperview];
        [carListAddVC removeFromParentViewController];
        
        driverCarEdit.licpnTxt.text=_car.licpn;
        driverCarEdit.car=_car;
      //  NSLog(@"司机=%@司机电话=%@",_car.driver,_car.driverPhone);
    }
    


    
    else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择操作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",@"编辑", nil];

        alert.delegate=self;
    [alert show];
    }
 
}

#pragma mark -UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 1:
            [[Util getUsingLKDBHelper] deleteToDB:_car];
            //_dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:@"select * from @t" toClass:[Car class]];
            _dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' order by rowid desc",[[NSUserDefaults standardUserDefaults]stringForKey:@"username"] ]toClass:[Car class]];
            [self.tableView reloadData];
            break;
        case 0:
     
            break;
        case 2://编辑
        {
            CarEditViewController *carEdit=[[CarEditViewController alloc]init];
             carEdit.view.frame =CGRectMake(0, kHeight64, carEdit.view.bounds.size.width, carEdit.view.bounds.size.height);
            carEdit.car=_car;
            carEdit.licpnTxt.text=_car.licpn;
            carEdit.driverTxt.text=_car.driver;
            carEdit.driverPhoneTxt.text=_car.driverPhone;
            carEdit.tag=1;
            
            

//                [self.bkView addSubview:carEdit.view];
//                
//            [self addChildViewController:carEdit];
//                [self.view addSubview:self.bkView];
            
            
            self.bkView.frame=self.navigationController.view.frame;
            [self.bkView addSubview:carEdit.view];
            
            [self.navigationController.view addSubview:self.bkView];
            [self.navigationController addChildViewController:carEdit];
            [carEdit didMoveToParentViewController:self.navigationController];
            
       
        }
            break;
        default:
            break;
    }
    

}


#pragma mark - Getter Methods
-(CarEditViewController *)carEditView{
    if (nil==_carEditView) {
        _carEditView=[[CarEditViewController alloc]init];
        _carEditView.view.frame =CGRectMake(0, kHeight64, _carEditView.view.bounds.size.width, _carEditView.view.bounds.size.height);
    }
    return _carEditView;
}

//-(UIView *)backGroundView{
//    if (nil==_backGroundView) {
//        _backGroundView= [[UIView alloc] init];
//        _backGroundView.frame = CGRectMake(0, 70,self.view.frame.size.width,self.view.frame.size.height);
//        _backGroundView.backgroundColor = [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:1.0f];
//        _backGroundView.alpha = 1;
//    }
//    return _backGroundView;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
