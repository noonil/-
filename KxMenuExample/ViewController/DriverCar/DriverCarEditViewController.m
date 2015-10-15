//
//  DriverCarEditViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//


#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#define kNavBarHeight64 64


#import "CCLocationManager.h"
#import "DriverCarEditViewController.h"
#import "CarsListViewController.h"
#import "DriverCarListViewController.h"
#import "DriveCar.h"
#import "Car.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ProgressHUD.h"
#import "IdentifierValidator.h"
#import "CarEditViewController.h"
#import "NSData+MD5.h"
#import "CarListAddViewController.h"



@interface DriverCarEditViewController ()
{
BOOL isFullScreen;
    CGFloat offset;
    CGFloat txtButtom;
    
    long long expectedLength;
    long long currentLength;
    MBProgressHUD *HUD;


}
@property (nonatomic,strong)NSString *licpn;
//@property (nonatomic,strong)NSString *upCarMails;
//@property (nonatomic,strong)NSString *downCarMails;
@property (nonatomic,strong)NSData  *pressImgData;
@property (nonatomic,strong)UIImage  *pressImg;
@property (nonatomic,strong)NSString *imgName;
@property (nonatomic,strong)NSString  *location;
@property (nonatomic,strong)DriveCar  *driverCar;

@end

@implementation DriverCarEditViewController

- (BOOL) shouldAutorotate

{
    
    return NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //添加隐藏按钮done http://blog.csdn.net/kylinbl/article/details/6694897
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, kTopBarHeight30)];
    [topView setBarStyle:UIBarStyleBlack];

    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard:)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [_memoTxtView setInputAccessoryView:topView];
    [_upCarMailsTxt setInputAccessoryView:topView];
    [_downCarMailsTxt setInputAccessoryView:topView];
    
    _upCarMailsTxt.keyboardType=UIKeyboardTypeDecimalPad;
    _downCarMailsTxt.keyboardType=UIKeyboardTypeDecimalPad;
    
    

   
    // 监听键盘的即将显示事件. UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    // 监听键盘即将消失的事件. UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    

    self.location=nil;
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        self.location =[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        
    }];
    
    
    
    NSString *idd=[[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    if (nil==idd) {
        self.driverCar=[[DriveCar alloc]init];
        self.memoTxtView.hidden=YES;
    }
    else{
        
        NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where rowid=%d and reporter='%@' ",[idd intValue],[Util getUserName] ] toClass:[DriveCar class]];
        
        //取得上车的那条记录的id
        self.driverCar=[dataArray objectAtIndex:0 ];
    }
    

   // _dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];


}

#pragma mark - 键盘隐藏

#pragma mark -textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    txtButtom = textView.frame.origin.y + textView.frame.size.height;
}

#pragma mark -textField delegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtButtom = textField.frame.origin.y + textField.frame.size.height;
    
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

////输入框编辑完成以后，将视图恢复到原始状态
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    //    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}

#pragma mark -消息通知
- (void) keyboardDidShow:(NSNotification *)notify {
    CGFloat kbHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;//获取键盘高度，在不同设备上，以及中英文下是不同的，很多网友的解决方案都把它定死了。
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat screenHeight = self.view.bounds.size.height;
    if (txtButtom + kbHeight < screenHeight) return;//若键盘没有遮挡住视图则不进行整个视图上移
    
    // 键盘会盖住输入框, 要移动整个view了
    offset = txtButtom + kbHeight - screenHeight+5 ;
    //NSLog(@"delta=%f",offset);
    
    if (offset>0) {
        
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    
    
}


- (void) keyboardWillHidden:(NSNotification *)notify {//键盘消失
    
    
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    txtButtom=0;
    
}

-(void)dismissKeyBoard:(id)sender
{
    if ([_upCarMailsTxt isFirstResponder]) {
        [_upCarMailsTxt resignFirstResponder];

    }
    else if([_downCarMailsTxt isFirstResponder]){
        [_downCarMailsTxt resignFirstResponder];
    }
    else if([_memoTxtView isFirstResponder]){
        [_memoTxtView resignFirstResponder];
    }
}

#pragma mark - show view
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _status = [userDefaults stringForKey:@"status"];
   // NSString *licpn=[userDefaults stringForKey:@"licpn"];
    
    UIImage *upCarImg;
    DriveCar * mm;
    
    if ([self getId]!=nil) {
        NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where rowid=%d",[[self getId] intValue] ]toClass:[DriveCar class]];
        
        //取得刚刚插入的那条记录的id
         mm=(DriveCar *)[dataArray objectAtIndex:0 ]  ;
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:mm.photoUp];
        NSData *imageData = [NSData dataWithContentsOfFile: fullPath];
        upCarImg = [UIImage imageWithData: imageData];
    }
    

    
    if (  [self getId] ==nil   ) {
        _downCarMailsTxt.enabled=NO;
        _downCarImgButton.enabled=NO;
        
        [_beginEndBtn setTitle:@"开始驾车" forState:UIControlStateNormal];

        
    }
    else {
        _upCarMailsTxt.enabled=NO;
        _upCarImgButton.enabled=NO;
        _licpnTxt.enabled=NO;
        _licpnTxt.text=mm.licpn;
        _upCarMailsTxt.text=mm.mileUp;
        _upCarImgView.image=upCarImg;
         [_beginEndBtn setTitle:@"结束驾车" forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Touch Event

- (IBAction)licpnTxt_TouchDown:(id)sender {
    [_licpnTxt becomeFirstResponder];
    [_licpnTxt resignFirstResponder];
    
    
    
    
    CarListAddViewController *carListAddVC=[[CarListAddViewController alloc]init];
    
    self.bkView.backgroundColor=KBackGroundColor;
    self.bkView.frame=self.navigationController.view.frame;
    CGRect r=self.navigationController.view.frame;
    r.origin.y=kHeight64;
    r.size.height=carListAddVC.view.frame.size.height;
    carListAddVC.view.frame=r;
    carListAddVC.view.backgroundColor=blueColor;
    carListAddVC.carListVC.tag=2;

    
    
    [self.bkView addSubview:carListAddVC.view];
    [self.navigationController.view addSubview:self.bkView];
    [self.navigationController addChildViewController:carListAddVC];
    [carListAddVC didMoveToParentViewController:self.navigationController];
    
//    CarsListViewController * carList;
//    UIView *carView;
//    
//    NSArray *arr= [[NSBundle mainBundle] loadNibNamed:@"CarSpendEcitViewController" owner:self options:nil] ;
//    carView=[arr objectAtIndex:2];
//    carList=[arr objectAtIndex:3];
//    carView.backgroundColor=blueColor;
//    
//
//   // self.carTableView.backgroundColor=blueColor;
//    
//    CGRect r=self.navigationController.view.frame;
//    r.origin.y=kHeight64;
//    r.size.height=carView.frame.size.height;
//    carView.frame=r;
//    
//    carList.tag=2;
//    
//    [self.bkView addSubview:carView];
//    
//    [self.navigationController. view addSubview:self.bkView];
//    [self addChildViewController:carList];
//    [carList didMoveToParentViewController:self];
    
    
// 2
//    NSMutableArray * array = [[Util getUsingLKDBHelper] searchWithSQL:@"select * from @t " toClass:[Car class]];
//    if ([array count]>0) {
//        CarsListViewController *carList;
//        carList=[[CarsListViewController alloc]init];
//        carList.view.frame=CGRectMake(0, kNavBarHeight64, self.view.bounds.size.width, self.view.bounds.size.height-kNavBarHeight64);
//        carList.tag=2;
//        
//        
//        [self addChildViewController:carList];
//        [self.view addSubview:carList.view];
//        
//
//
//    }
//    else{
//        CarEditViewController *carEdit;
//        carEdit=[[CarEditViewController alloc]init];
//        carEdit.view.frame=CGRectMake(0, kNavBarHeight64, self.view.bounds.size.width, self.view.bounds.size.height/2.5);
//        carEdit.tag=2;
//        [self.bkView addSubview:carEdit.view];
//        [self addChildViewController:carEdit];
//        [self.view addSubview:self.bkView];
//    }
//    

    

}



- (IBAction)upDownCarTxt_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}


#pragma mark - 点提交按钮
- (IBAction)beginEndBtn_TouchDown:(id)sender {
    
    _licpn=self.licpnTxt.text;
    NSString * upCarMails=self.upCarMailsTxt.text;
    NSString * downCarMails=self.downCarMailsTxt.text;
    
    if (_location==nil) {
        _location=@"32.086240,118.774530";
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                       message:@"经纬度没有获取到，请点击提交重试。"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
//        return;
    }



    if ([_licpn length] == 0 )
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择车辆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    
    if ([self getId]==nil) {

        
        
        if (![IdentifierValidator isFloat:upCarMails]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上车公里数应填数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
        if(![self isInsideTwo:upCarMails]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"公里数小数位最多两位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        
        };
        
        if([upCarMails floatValue]>100000){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"公里数应<=10万" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        };
        
        

        
        
        
        if (_upCarImgView.tag != 100) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请拍上车照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
        
        
    }else {

        
        if (![IdentifierValidator isFloat:downCarMails]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"下车公里数应填数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        
        

        
        if ([downCarMails floatValue]<[upCarMails floatValue]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"下车公里应>=上车公里数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }

        if(![self isInsideTwo:downCarMails]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"公里数小数位最多两位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        };
        
        if([downCarMails floatValue]>100000){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"公里数应<=10万" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        };

        if (_downCarImgView.tag != 200) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请拍下车照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
    }

    
    
    //显示提交界面
    _licpnLabel.text=_licpnTxt.text;
    _showPictureImgView.image=_pressImg;//_img;

    //if (     [@"s" isEqualToString:_status ]  || _status ==nil   ) {
    if ([self getId]==nil) {

        _mailTitleLabel.text=@"上车里程";
        _mailLabel.text=_upCarMailsTxt.text;
    }
    else {
        _mailTitleLabel.text=@"下车里程";
        _mailLabel.text=_downCarMailsTxt.text;
    }

  //  [self.view addSubview:_updateView];
    
    self.bkView.frame=self.navigationController.view.frame;
    [self.bkView addSubview:_updateView];
    
//    CGRect r=self.bkView.frame;
//    r.origin.y=(self.bkView.frame.size.height-self.updateView.frame.size.height)/2;
//    self.updateView.frame=r;
    
    [self.navigationController.view addSubview:self.bkView];
    
}

//是否小数位<=2
-(BOOL)isInsideTwo:(NSString *)miles{
    NSRange range;
    range = [miles rangeOfString:@"."];
    NSUInteger xiaoshuCount=[miles length]-range.location-1;
    if (range.location!=NSNotFound && xiaoshuCount>2) {
        return false;
    }
    else
        return true;
}

- (IBAction)cancelBtn_TouchDown:(id)sender {
    [_updateView removeFromSuperview];
    [self.bkView removeFromSuperview];
}

#pragma mark - 数据上传
- (IBAction)updateBtn_TouchDown:(id)sender {
    
    HUD = [MBProgressHUD  showHUDAddedTo:self.navigationController.view animated:YES] ;
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
   
    [HUD show:YES];
    

    
      dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

          [self preareUploadData];
      }
    );
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = @"Loading";
//    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // Do a taks in the background
//        [self myTask];
//        // Hide the HUD in the main tread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//        });
//    });
}


//-(void)preareUploadData:(NSString *)time
//{

-(void)preareUploadData
{
        [self saveImageData :_pressImgData withName:_imgName];
        NSString * md5=[_pressImgData MD5];


    NSLog(@"上车上传md5=%@\n",md5);
    
    
    
    NSString *id=[[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
  //  DriveCar *_driverCar;
    _driverCar=[[DriveCar alloc]init];

    NSString *timeStr=[self getTime];
    _driverCar.imis= [Util getUsingUDID];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] ];


    if (nil==id) {
        
        _driverCar.status=@"s";
        _driverCar.licpn=_licpnTxt.text;
        _driverCar.driver=_car.driver;
        _driverCar.driver_phone=_car.driverPhone;
        _driverCar.reporter=[Util getUserName];
        _driverCar.locationUp=self.location;
        _driverCar.photoUp=_imgName;
        _driverCar.memoUp=_memoTxtView.text;
         _driverCar.timeUp=timeStr;
        _driverCar.mileUp=_upCarMailsTxt.text;
        _driverCar.md5Up=md5;
        
        _driverCar.mile=_upCarMailsTxt.text;
         _driverCar.serverId=[NSString stringWithFormat:@"%@_%@",_driverCar.imis,timeSp];
        // _driverCar.serverId=timeSp;
        
        

        
        
    }
    else{
        
        NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where rowid=%d",[id intValue] ] toClass:[DriveCar class]];
        
        //取得上车的那条记录的id
        _driverCar=[dataArray objectAtIndex:0 ];
        _driverCar.status=@"e";//
        _driverCar.photoDown=_imgName;
        _driverCar.memoDown=_memoTxtView.text;
         _driverCar.timeDown=timeStr;
        _driverCar.mileDown=_downCarMailsTxt.text;
        _driverCar.md5Down=md5;
        _driverCar.locationDown=self.location;

        
        _driverCar.mile=_downCarMailsTxt.text;
        
    }
    
    

    _driverCar.photo=_imgName;
    _driverCar.memo=_memoTxtView.text;
    _driverCar.time=timeStr;
   // _driverCar.username=[Util getUserName];
    
    _driverCar.isLocalTime=@"N";

  
    

    //[ProgressHUD show:@"Please wait..."];
   

    
    
  //  if (IS_IOS8) {
 //   [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//CLLocationCoordinate2D locationCorrrdinate = (CLLocationCoordinate2D){0, 0};
//             NSLog(@"location=%@",[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]);




            LKDBHelper* ldbHelper = [Util getUsingLKDBHelper];
    
    
            if (nil==id) {//上车插入数据
               // _driverCar.locationUp=[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
                
                BOOL success =[ldbHelper insertToDB:_driverCar];
                
                if(!success){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"插入上车数据失败！"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];;
                }
                else{
                    //NSMutableArray * dataArray = [ldbHelper searchWithSQL:@"select * from @t order by rowid desc" toClass:[DriveCar class]];
                    NSMutableArray *dataArray = [ldbHelper searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];
                    
                    
                    //取得刚刚插入的那条记录的id
                    DriveCar * mm=(DriveCar *)[dataArray objectAtIndex:0 ]  ;
                    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)mm.rowid] forKey:@"id"];

                    [self uploadData:_pressImgData driverCar:mm ];
                    

                }

                
    
                
            }
            else  { //下车插入数据
                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"id"];
                

               // _driverCar.locationDown=[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
                
                BOOL success =[ldbHelper updateToDB:_driverCar where:nil];
                if(!success){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"插入下车数据失败！"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];

                }
                else{

                    [self uploadData:_pressImgData driverCar:_driverCar ];

                }

            }
    
    
    

            NSArray *viewControllers = self.navigationController.viewControllers;
            DriverCarListViewController *rootViewController = [viewControllers objectAtIndex:0];

            //rootViewController.dataArray=[[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t  order by rowid desc" ] toClass:[DriveCar class]];
            rootViewController.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];

            [rootViewController.tableVeiw reloadData];



            
            
//        }];
    
    
    
    
    
    
    }




#pragma mark -开始上传

//-(void)uploadData:(NSData *)imgData driverCar:(DriveCar *)driCar location:(NSString *)location {
-(void)uploadData:(NSData *)imgData driverCar:(DriveCar *)driCar  {

    
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/input.do"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];

    
   // [request setUseKeychainPersistence:YES];
    
  
    [request setPostValue:driCar.licpn forKey:@"licpn"];
    [request setPostValue:driCar.driver forKey:@"driver"];
    [request setPostValue:driCar.driver_phone forKey:@"driver_phone"];
    [request setPostValue:driCar.mile forKey:@"miles"];
    [request setPostValue:self.location forKey:@"location"];
    [request setPostValue:driCar.time forKey:@"time"];
    [request setPostValue:driCar.reporter forKey:@"reporter"];
    [request setPostValue:driCar.status forKey:@"status"];
    [request setPostValue:driCar.imis forKey:@"imis"];
    [request setPostValue:driCar.photo forKey:@"photo"];
    [request setPostValue:driCar.serverId forKey:@"id"];
    [request setPostValue:driCar.memo forKey:@"memo"];
    [request setPostValue:driCar.isLocalTime forKey:@"isLocalTime"];
    NSLog(@"上传数据=======\n licpn=%@\n driver=%@\n driver_phone=%@\n miles=%@\n location=%@\n time=%@\n reporter=%@\n status=%@\n imis=%@\n photo=%@\n serverid=%@\n memo=%@\n isLocalTime=%@\n ",driCar.licpn,driCar.driver,driCar.driver_phone,driCar.mile,self.location,driCar.time,driCar.reporter,driCar.status,driCar.imis,driCar.photo,driCar.serverId,driCar.memo,driCar.isLocalTime);
    

    [request setData:imgData withFileName:_imgName andContentType:@"image/png" forKey:@"file"];
    
    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
//    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
}






- (void)requestFinished:(ASIHTTPRequest *)request {
//[ProgressHUD dismiss];
    
    NSString * message=nil;
    
    
    if([@"Y" isEqualToString:[request responseString]] )
        
    {
        
        message=@"上传成功.";
        
        if ([_driverCar.status isEqualToString:@"s"]) {
            _driverCar.submitStatus_Up=@"true";
            [[Util getUsingLKDBHelper] insertToDB:_driverCar ];
            
        }
        else if([_driverCar.submitStatus_Up isEqualToString:@"true"]){
            _driverCar.submitStatus=@"true";
             //BOOL success=
            [[Util getUsingLKDBHelper] insertToDB:_driverCar ];
//             NSLog(@"下车提交时 success======%c",success);
//            
//            
//            //取得刚刚插入的那条记录的id
//            //NSString *id=[[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
//            NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where rowid=%ld",(long )_driverCar.rowid] toClass:[DriveCar class]];
//            
//            //取得上车的那条记录的id
//            DriveCar * driverCarmm=[dataArray objectAtIndex:0 ];
//            
//            NSLog(@"下车提交时 driverCarmm.submitStatus======%@",driverCarmm.submitStatus);
            
            
            NSArray *viewControllers = self.navigationController.viewControllers;
            DriverCarListViewController *rootViewController = [viewControllers objectAtIndex:0];
            
            //rootViewController.dataArray=[[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t  order by rowid desc" ] toClass:[DriveCar class]];
            rootViewController.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];
            
            [rootViewController.tableVeiw reloadData];
        
        }
        
        

  
        
        
    }
    else {
        if([@"N1" isEqualToString:[request responseString]] ){
            
            message =@"参数不完整";
        }
        else if([@"N2" isEqualToString:[request responseString]] ){
            
            message =@"request不是Multipart类型";
        }
        else if([@"N3" isEqualToString:[request responseString]] ){
            
            message =@"没有上车信息";
        }
        
        else if([@"N4" isEqualToString:[request responseString]] ){
            
            message =@"服务器端插入异常";
        }
        
    }
    

    HUD.labelText =message;
    
    [self hidHUD];

}


//- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
- (void)requestFailed:(ASIHTTPRequest *)request {


    HUD.labelText = @"上传失败";
    [self hidHUD];


}
-(void)hidHUD{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popToRootView) userInfo:nil repeats:NO];
}

-(void)popToRootView{
    
    [self.bkView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)removeHud {
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];

}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    //sleep(3);
}

#pragma mark -
#pragma mark  保存图片至沙盒
- (void) saveImageData:(NSData *)imgData withName:(NSString *)imageName
{
    

    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];

    // 将图片写入文件
    
    [imgData writeToFile:fullPath atomically:NO];
}


#pragma mark 拍照
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    CGSize size={780,1000};
    
    UIImage * orangeImg=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * orangeImg2=[self scaleToSize:orangeImg size:size];
    
    _pressImgData = UIImageJPEGRepresentation(orangeImg2, 0.1);
//    NSLog(@"1=%ld",pressImgData.length);
//
//    NSData *pressImgData2 = UIImageJPEGRepresentation(orangeImg, 1);
//    NSData *pressImgData3 = UIImagePNGRepresentation(orangeImg);
    
//    self.img = [UIImage imageWithData:_pressImgData];
    _pressImg = [UIImage imageWithData:_pressImgData];
//    NSData *imageData = UIImageJPEGRepresentation(_img, 0.0001);
//    NSLog(@"2=%ld",imageData.length);
    
    
    self.imgName=[NSString stringWithFormat:@"%@.jpg",[Util getTimeStamp]];
    
    
    isFullScreen = NO;
    
    if (    [self getId]==nil   ) {
        [self.upCarImgView setImage:[UIImage imageWithData:_pressImgData]];
        self.upCarImgView.tag = 100;
    }
    else  {
        [self.downCarImgView setImage:[UIImage imageWithData:_pressImgData]];
        self.downCarImgView.tag = 200;

    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}



#pragma mark - 拍照 actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
- (IBAction)upCarImg_TouchDown:(id)sender {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        //sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", nil];
    }
    else {
        
       //sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles: nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}


- (IBAction)downCarImg_TouchDown:(id)sender {
    [self upCarImg_TouchDown:sender];
}

- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
    
}



#pragma  mark - get/set
-(NSString *)getTime{
    // 1.将网址初始化成一个OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"http://222.45.43.97:9971/teamtmiles/gettime.do"];
    // 如果网址中存在中文,进行URLEncode
    //NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingMacChineseSimp )];
   // NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    //NSString *newUrlStr =LoginUrl(@"杨杰A",@"888888");
    
    
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data=nil;
    NSString* time;
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (nil==data) {

        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        //设置时间输出格式：
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        time  = [df stringFromDate:currentDate];
        
    }
    else{
        time = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    }
    
    
    return time;

}








-(NSString *)getId{
        NSString *id=[[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    
    return id;;
}







@end
