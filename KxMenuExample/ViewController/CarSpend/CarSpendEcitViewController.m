//
//  CarSpendEcitViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "CarSpendEcitViewController.h"
#import "CarSpendListViewController.h"
#import "CarsListViewController.h"
#import "CarSpend.h"
#import "CCLocationManager.h"
#import "ASIHTTPRequest.h"
#import  "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "IdentifierValidator.h"
#import "CarEditViewController.h"





@interface CarSpendEcitViewController ()
@property(nonatomic,strong) CarsListViewController *carList;//为什么


@end

@implementation CarSpendEcitViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_licpnTxt setDelegate:self];
    
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, kTopBarHeight30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard:)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [self.spendTxt setInputAccessoryView:topView];
    self.spendTxt.keyboardType=UIKeyboardTypeDecimalPad;
    
    
    NSArray *arr= [[NSBundle mainBundle] loadNibNamed:@"CarSpendEcitViewController" owner:self options:nil] ;
    self.view=[arr objectAtIndex:0];
    
 

    
}

-(void)dismissKeyBoard:(id)sender
{
        [_spendTxt resignFirstResponder];
        

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////初始化位置变量
//-(void)initLocationVar{
//
//// 实例化一个位置管理器
//self.locationManager = [[CLLocationManager alloc] init];
//
//self.locationManager.delegate = self;
//
//// 设置定位精度
//// kCLLocationAccuracyNearestTenMeters:精度10米
//// kCLLocationAccuracyHundredMeters:精度100 米
//// kCLLocationAccuracyKilometer:精度1000 米
//// kCLLocationAccuracyThreeKilometers:精度3000米
//// kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
//// kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
//self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//
//// distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
//// 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
//self.locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
//}

#pragma mark - touch event
- (IBAction)textField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];

}

- (IBAction)timeTxt_TouchDown:(id)sender {

    
    UIDatePicker* datePicker=[[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSString *title = NSLocalizedString(@"\n\n\n\n\n\n\n\n\n\n\n", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    
    UIAlertController* alertController=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:otherButtonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        NSDate* date=[datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* curentDate=[formatter stringFromDate:date];
        self.timeTxt.text=curentDate;
        
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:cancelButtonTitle style:(UIAlertActionStyleDefault) handler:nil];
    
    
    [alertController addAction:ok];
    [alertController addAction:no];
    
    [alertController.view addSubview:datePicker];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma marks - 添加汽车，取消添加
- (IBAction)addCar_TouchDown:(id)sender {
    
    CarEditViewController * carEdit=[[CarEditViewController alloc]init];
    carEdit.tag=3;
    carEdit.view.backgroundColor=blueColor;
    
    CGRect r=self.view.frame;
    r.origin.y=0;
    r.size.height+=3;
    carEdit.view.frame=r;
    

    UIView *bkGView=[[UIView alloc]initWithFrame:self.navigationController.view.frame];
    bkGView.backgroundColor=KBackGroundColor;
    [bkGView addSubview:carEdit.view];
    
    [self.view addSubview:bkGView];
    [self addChildViewController:carEdit];
    [carEdit didMoveToParentViewController:self];
    

    
}

- (IBAction)cancelAddCar_TouchDown:(id)sender {
    
    
    [self.carsListView willMoveToParentViewController:nil];
    [self.carView removeFromSuperview];
    [self.carsListView removeFromParentViewController];
    self.view.backgroundColor=blueColor;
    
    //[oldVC didMoveToParentViewController:nil
}

#pragma marks -



- (IBAction)licpnTxt_TouchDown:(id)sender {

    [_licpnTxt becomeFirstResponder];
    [_licpnTxt resignFirstResponder];
    
    
    
    NSArray *arr= [[NSBundle mainBundle] loadNibNamed:@"CarSpendEcitViewController" owner:self options:nil] ;
    self.carView=[arr objectAtIndex:2];
    self.carView.backgroundColor=blueColor;
    self.carTableView.backgroundColor=blueColor;

    CGRect r=self.view.frame;
    r.origin.y=0;
    self.carView.frame=r;
    
    self.carsListView.tag=1;

    [self.view addSubview:self.carView];
    [self addChildViewController:self.carsListView];
    [self.carsListView didMoveToParentViewController:self];

    
}


- (IBAction)pressCancelButton:(id)sender {
    
    
    [self willMoveToParentViewController:nil];
    [self.view.superview removeFromSuperview];//移除遮罩层
    [self removeFromParentViewController];
    //[oldVC didMoveToParentViewController:nil
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=0; break;
            //date02=date01
        case NSOrderedSame: ci=1; break;
        
    }
    return ci;
}
    
    




- (IBAction)pressSubmitButton:(id)sender {
    
   // [self checkInput];
    if ([_licpnTxt.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"车辆没有选" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_timeTxt.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"日期没有选" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    
    if ([self compareDate:_timeTxt.text withDate:curTime]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"选择日期不能大于当前日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if ([_spendTxt.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"过停费为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if (![IdentifierValidator isFloat:_spendTxt.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"过停费应填数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    if(![IdentifierValidator isInsideTwo:_spendTxt.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"过停费小数位最多两位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    };



    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        

        NSLog(@"driverCar.location=%@",[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]);


    CarSpend *carSpend=[[CarSpend alloc]init];
    carSpend.username=[[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    carSpend.spend=_spendTxt.text;
    carSpend.licpn=_licpnTxt.text;
    carSpend.time=_timeTxt.text;
    carSpend.latitude=[NSString stringWithFormat:@"%lf",locationCorrrdinate.latitude];
    carSpend.longitude=[NSString stringWithFormat:@"%lf",locationCorrrdinate.longitude];
    carSpend.imsi=[Util getUsingUDID];
    carSpend.username=[Util getUserName];
  
    

    LKDBHelper* ldbHelper = [Util getUsingLKDBHelper];
    BOOL success =[ldbHelper insertToDB:carSpend];
    if(!success){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"插入数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else{
        LKDBHelper *lkdHelper=[Util getUsingLKDBHelper];
        //NSMutableArray * dataArray = [lkdHelper searchWithSQL:@"select * from @t" toClass:[CarSpend class]];
        NSMutableArray * dataArray = [lkdHelper searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' order by rowid desc",[Util getUserName] ]toClass:[CarSpend class]];
        
        UINavigationController *nav=(UINavigationController *)self.parentViewController;
        CarSpendListViewController *spendList=[nav.viewControllers objectAtIndex:1];

        spendList.dataArray=dataArray;
        [spendList.tableView reloadData];
    }
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        HUD.delegate = self;
         [HUD show:YES];
        
        [self upLoadData:carSpend];
        
  //  [self pressCancelButton:sender];
        
        
        
         }];
}

#pragma mark - 数据上传
-(void)upLoadData:(CarSpend *)carSpend{
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/miscExpense.do"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    

    [request setUseKeychainPersistence:YES];
    //if you have your site secured by .htaccess
    [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];

    

    
    [request setPostValue:carSpend.username forKey:@"username"];
    [request setPostValue:carSpend.spend forKey:@"expense"];
    [request setPostValue:carSpend.licpn forKey:@"licpn"];
    [request setPostValue:carSpend.time forKey:@"time"];
    [request setPostValue:carSpend.longitude forKey:@"longitude"];
    [request setPostValue:carSpend.latitude forKey:@"latitude"];
    [request setPostValue:carSpend.imsi forKey:@"imei"];

    
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{
   // NSString *responseString = [request responseString];


    if([@"true" isEqualToString:[request responseString]] )
        
    {
        HUD.labelText =@"上传数据成功";
        [self hidHUD];

    }
    else
    {
        HUD.labelText =@"上传数据失败";
        [self hidHUD];

    }
  
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
   

    //HUD.labelText =[NSString stringWithFormat:@"%@",[[request error] localizedDescription]];
    HUD.labelText =@"上传数据失败";

    [self hidHUD];

    
}

-(void)hidHUD{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(pressCancelButton:) userInfo:nil repeats:NO];
    
    
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
