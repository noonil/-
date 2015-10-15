//
//  CarSpendListViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/5/22.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "CarSpendListViewController.h"
#import "CarSpendEcitViewController.h"
#import "CarSpend.h"
#import "Car.h"





//#define blueColor [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7]
//#define kHeight44 44


@interface CarSpendListViewController ()
@property(nonatomic, strong) CarSpendEcitViewController *carSpendEditView;
@property(nonatomic, strong) CarSpend *carSpend;
//@property(nonatomic, strong) UIView *backGroundView;

@end

@implementation CarSpendListViewController

@synthesize carSpendEditView=_carSpendEditView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(pressAddSpendButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor=blueColor;
    [self.view addSubview:self.tableView];
    
    
    ;
    //_dataArray = [[Util getUsingLKDBHelper] searchWithSQL:@"select * from @t" toClass:[CarSpend class]];
    _dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' order by rowid desc", [Util getUserName]] toClass:[CarSpend class]];
    
    
    
    
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
-(void)pressAddSpendButton{
    self.carSpendEditView.licpnTxt.text=nil;
    self.carSpendEditView.timeTxt.text=nil;
    self.carSpendEditView.spendTxt.text=nil;
    
//    [self.backGroundView addSubview:self.carSpendEditView.view];
//
//    
//    [self addChildViewController:self.carSpendEditView];
//    [self.view addSubview:self.backGroundView];
    
    
//    [self.navigationController addChildViewController:self.carSpendEditView];
//    
//    self.bkGroundView=[[BackGroundView alloc]initWithView:self.navigationController.view];
//    self.bkGroundView.dimBackground=YES;
//    [self.bkGroundView addSubview:self.carSpendEditView.view];
//    [self.navigationController.view addSubview:self.bkGroundView];
//    [self.carSpendEditView didMoveToParentViewController:self.navigationController];
//    
//
    
  

    

    [self.bkView addSubview:self.carSpendEditView.view];
    self.carSpendEditView.view.backgroundColor=blueColor;
    
    [self.navigationController.view addSubview:self.bkView];
    [self.navigationController addChildViewController:self.carSpendEditView];
    [self.carSpendEditView didMoveToParentViewController:self.navigationController];
    
    
    
}



#pragma mark - table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    
    
    
    double x=self.tableView.bounds.size.width/3;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, x, kHeight44)];
    label.backgroundColor = [UIColor whiteColor];
    label.text= @"车牌号";
    label.textColor=blueColor;
    label.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, x, kHeight44)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.text= @"时间";
    label1.textColor=blueColor;
    label1.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(2*x, 0, x, kHeight44)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.text= @"过停费用";
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
    
    
    CarSpend *carSpend=self.dataArray[indexPath.row];
//    cell.textLabel.text =carSpend.spend ;
//        cell.textLabel.text =[NSString stringWithFormat:@"%@    %@    %@",carSpend.licpn,carSpend.time,carSpend.spend] ;
    
    
    double x=self.view.bounds.size.width/3;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, x+1, cell.bounds.size.height)];
    label.backgroundColor = blueColor;
    label.text= carSpend.licpn;
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, x+1, cell.bounds.size.height)];
    label1.backgroundColor = blueColor;
    label1.text= carSpend.time;
    label1.font=[UIFont systemFontOfSize:15];
    label1.textAlignment=NSTextAlignmentCenter;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(2*x, 0, x, cell.bounds.size.height)];
    label2.backgroundColor = blueColor;
    label2.text= carSpend.spend;
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
    
    _carSpend=self.dataArray[indexPath.row];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
    
    [alert show];
    
}

#pragma mark -UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [[Util getUsingLKDBHelper] deleteToDB:_carSpend];
            //_dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:@"select * from @t" toClass:[CarSpend class]];
            _dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' order by rowid desc", [Util getUserName]] toClass:[CarSpend class]];
            [self.tableView reloadData];
            break;
        case 1:
            //NSLog(@"Button 1 Pressed");
            break;
        default:
            break;
    }
    
}


#pragma mark - Getter Methods
-(CarSpendEcitViewController *)carSpendEditView{
    if (nil==_carSpendEditView) {
        _carSpendEditView=[[CarSpendEcitViewController alloc]init];
        _carSpendEditView.view.frame =CGRectMake(0, kHeight64, _carSpendEditView.view.bounds.size.width, _carSpendEditView.view.bounds.size.height);
    }
    return _carSpendEditView;
}

//-(UIView *)backGroundView{
//    if (nil==_backGroundView) {
//        _backGroundView= [[UIView alloc] init];
//        _backGroundView.frame = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height);
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
