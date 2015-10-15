//
//  DriverCarListViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/5/26.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//
//
//#import "DriverCarListViewController.h"
//
//@interface DriverCarListViewController ()
//
//@end
//
//@implementation DriverCarListViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end


#import "DriverCarListViewController.h"
#import "KxMenu.h"
#import "CarsListViewController.h"
#import "DriverCarEditViewController.h"
#import "CarSpendListViewController.h"
#import "DriveCar.h"
#import "DriverCarListTableViewCell.h"
#import "DriverCarShowViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AboutViewController.h"
#import "NSData+MD5.h"
#import "Reachability.h"
#import "CCLocationManager.h"


//#define blueColor [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7]

@interface DriverCarListViewController ()
{
    NSString * upMessage;
    NSString * downMessage;
    NSString * message;
    BOOL isLastNo; //自动上传是否到最后一条。
    BOOL singleUpFalse;//单条上传失败。
    int ii;
    

}
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong)UIButton * button;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic,strong) DriveCar *driveCar;
@property (nonatomic,strong) NSMutableArray *youwangArray;

@end

@implementation DriverCarListViewController {
    
    
    UIButton *_btn3;
    
}

#pragma mark - show

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _status = [userDefaults stringForKey:@"status"];
    
    
    NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where reporter='%@' order by rowid desc",[Util getUserName] ] toClass:[DriveCar class]];
    
    if ([dataArray count]>0) {
        DriveCar *driveCar=[dataArray objectAtIndex:0];
        if ([driveCar.status isEqualToString:@"s"]) {
            [_button setTitle:@"下车" forState:UIControlStateNormal];
        }
        else
            [_button setTitle:@"上车" forState:UIControlStateNormal];
            

    }
    else{
    
        [_button setTitle:@"上车" forState:UIControlStateNormal];
    }
    
    

    
    
    
    
}


-(void)viewDidLoad{
    const CGFloat W = self.view.bounds.size.width;
    
        _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btn3.frame = CGRectMake(W - 105, 5, 100, 50);
    
    
    // UIImage *mm=[self scaleToSize:[UIImage imageNamed:@"menu_button_pressed.png"] size:CGSizeMake(30, 30)];
    
    
    UIImage *mm=[UIImage imageNamed:@"menu_button_pressed.png"];
    
    UIImage *nn=[UIImage imageWithCGImage:[mm CGImage]
                        scale:(mm.scale *3)
                  orientation:(mm.imageOrientation)];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:nn style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];


        self.navigationItem.rightBarButtonItem=menuButton;
    
    
    
//        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _button.frame = CGRectMake(W - 155, 120, 100, 50);
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _status = [userDefaults stringForKey:@"status"];
    
    

    
        //[KxMenu setTintColor: [UIColor colorWithRed:15/255.0f green:97/255.0f blue:33/255.0f alpha:1.0]];
        //[KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
    
    
    
    
    
     //   _dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t  order by rowid desc" ] toClass:[DriveCar class]];
          _dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];

        
    
    self.tableVeiw.backgroundColor=blueColor;
        [self.tableVeiw reloadData];
    
    
    
    

    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"http://222.45.43.97:9971/teamtmiles/login.do";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];

    
    isLastNo=false;
    singleUpFalse=false;
    
    //[self updateData];




}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        NSLog(@"NotReachable\n");
        
    }
    else{
        [self updateData];
    }
    
//    if (status == ReachableViaWiFi) {
//        NSLog(@"ReachableViaWiFi\n");
//        
//    }
//    if (status == ReachableViaWWAN) {
//        NSLog(@"ReachableViaWWAN\n");
//        
//    }
    

    
}


#pragma  mark - 上传没有提交的数据
-(void)updateData{


    
    self.youwangArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' and submitStatus!='true' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];
    
    NSLog(@"array count=%ld\n",[_youwangArray count]);
    
    
    if ([_youwangArray count]>0) {
        HUD = [MBProgressHUD  showHUDAddedTo:self.navigationController.view animated:YES] ;
        HUD.dimBackground = YES;
        HUD.labelText=@"正在自动提交数据";
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
        
           
               ii=(int )[_youwangArray count]-1;
            
                self.driveCar=[_youwangArray objectAtIndex:ii];
            

            
                [self updata_Up];
                

            self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[_driveCar class]];
            
            [self.tableVeiw reloadData];
            
            
            


            
        }
        );
    
    }

    

}


//
//-(void)updata_Up1{
//    NSLog(@"mmmm\n");
//    return;
//    
//    NSLog(@"nn\n");
//
//
//}

-(void)updata_Up{
    //如果是第二个手机，数据同步下来得数据，是没有经纬度的。那么再获取一次经纬度。

//    if (_driveCar.locationUp==nil ) {
//        
//        
//            [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//                NSString *location =[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
//                _driveCar.locationUp=location;
//                _driveCar.locationDown=location;
//                
//            }];
//      
//        
//    }
//    


    
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_driveCar.photoUp];
    NSData * imageData = [NSData dataWithContentsOfFile: fullPath];
    
    NSString *md5_o=[imageData MD5];
    if (![md5_o isEqualToString:_driveCar.md5Up]) {
        NSLog(@"\n%@\n%@",md5_o,_driveCar.md5Up);
        
        
    
            
            [self upMiddle];
          
  
        
        singleUpFalse=true;
   
        
        
        
        
    }
    else{
        
        
        
        NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/input.do"];
        
        // [ASIHTTPRequest setDefaultTimeOutSeconds:30];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request setUseKeychainPersistence:YES];
        [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        
        
        
        
        [request setPostValue:_driveCar.licpn forKey:@"licpn"];
        [request setPostValue:_driveCar.driver forKey:@"driver"];
        [request setPostValue:_driveCar.driver_phone forKey:@"driver_phone"];
        [request setPostValue:_driveCar.mileUp forKey:@"miles"];
        [request setPostValue:_driveCar.locationUp forKey:@"location"];
        [request setPostValue:_driveCar.timeUp forKey:@"time"];
        [request setPostValue:_driveCar.reporter forKey:@"reporter"];
        [request setPostValue:@"s" forKey:@"status"];
        [request setPostValue:_driveCar.imis forKey:@"imis"];
        [request setPostValue:_driveCar.photoUp forKey:@"photo"];
        [request setPostValue:_driveCar.serverId forKey:@"id"];
        [request setPostValue:_driveCar.memo forKey:@"memo"];
        [request setPostValue:@"N" forKey:@"isLocalTime"];
        
        
        
        [request setData:imageData withFileName:_driveCar.photoUp andContentType:@"image/png" forKey:@"file"];
        
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(uploadRequestFinished_Up:)];
        [request setDidFailSelector:@selector(uploadRequestFailed_Up:)];
        
        NSLog(@"\n\n上传的上车数据 ===\n licpn=%@\n driver=%@\n driver_phone=%@\n miles=%@\n location=%@\n time=%@\n reporter=%@\n status=%@\n imis=%@\n photo=%@\n serverId=%@\n memo=%@\n isLocalTime=%@ ",_driveCar.licpn,_driveCar.driver,_driveCar.driver_phone,_driveCar.mileUp,_driveCar.locationUp,_driveCar.timeUp,_driveCar.reporter,_driveCar.status,_driveCar.imis,_driveCar.photoUp,_driveCar.serverId,_driveCar.memoUp,_driveCar.isLocalTime);
        
        
        NSLog(@"上车开始上传 ii=%d,time=%@",ii,[self getTime]);
        [request startSynchronous];
        
    }
    
}

-(NSString *)getTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss "];
   // NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];

}

-(BOOL)isImgChanged:(NSData *)imgData md5:(NSString *)md5{
    
    
    NSString *md5_o=[imgData MD5];

    
    if ([md5_o isEqualToString:md5]) {
        return true;
    }
    else
        return false;
    
}

-(void)updata_Down{
    
    
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_driveCar.photoDown];
    NSData * imageData = [NSData dataWithContentsOfFile: fullPath];
    
    if (![self isImgChanged:imageData md5:_driveCar.md5Down]) {
        
        
        [self downMiddle];
        


    }
    else{
        
        
        
        NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/input.do"];
        
        // [ASIHTTPRequest setDefaultTimeOutSeconds:30];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        
        
        [request setUseKeychainPersistence:YES];
        //上传下车数据
        [request setPostValue:_driveCar.licpn forKey:@"licpn"];
        [request setPostValue:_driveCar.driver forKey:@"driver"];
        [request setPostValue:_driveCar.driver_phone forKey:@"driver_phone"];
        [request setPostValue:_driveCar.mileDown forKey:@"miles"];
        [request setPostValue:_driveCar.locationDown forKey:@"location"];
        [request setPostValue:_driveCar.timeDown forKey:@"time"];
        [request setPostValue:_driveCar.reporter forKey:@"reporter"];
        [request setPostValue:@"e" forKey:@"status"];
        [request setPostValue:_driveCar.imis forKey:@"imis"];
        [request setPostValue:_driveCar.photoDown forKey:@"photo"];
        [request setPostValue:_driveCar.serverId forKey:@"id"];
        [request setPostValue:_driveCar.memoDown forKey:@"memo"];
        [request setPostValue:@"N" forKey:@"isLocalTime"];
        
        
        [request setData:imageData withFileName:_driveCar.photoDown andContentType:@"image/png" forKey:@"file"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(uploadRequestFinished_Down:)];
        [request setDidFailSelector:@selector(uploadRequestFailed_Down:)];
        
        NSLog(@"上传的下车数据===\n licpn=%@\n driver=%@\n driver_phone=%@\n miles=%@\n location=%@\n time=%@\n reporter=%@\n status=%@\n imis=%@\n photo=%@\n serverId=%@\n memo=%@\n isLocalTime=%@\n ",_driveCar.licpn,_driveCar.driver,_driveCar.driver_phone,_driveCar.mileDown,_driveCar.locationDown,_driveCar.timeDown,_driveCar.reporter,_driveCar.status,_driveCar.imis,_driveCar.photoDown,_driveCar.serverId,_driveCar.memoDown,_driveCar.isLocalTime);
        
        NSLog(@"下车开始上传 ii=%d,time=%@",ii,[self getTime]);
        [request startSynchronous];
    }
    
    
}


#pragma mark - up down 上传结果
-(void)showAlert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



-(void)hidHUD{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(jumpToView) userInfo:nil repeats:NO];

}



-(void)jumpToView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)uploadRequestFinished_Up:(ASIHTTPRequest *)request{
    
    
    NSLog(@"上车结束 ii=%d,time=%@",ii,[self getTime]);
    
    if([@"Y" isEqualToString:[request responseString]] )
        
    {
        
        upMessage =@"上车上传成功";
        
        
        
        [self up];

        
        
    }
    else if([@"N4" isEqualToString:[request responseString]] ){
        
        upMessage =@"上车上传成功";
        

        [self up];
    }
    
    else{
        if([@"N1" isEqualToString:[request responseString]] ){
            
            upMessage =@"参数不完整";
        }
        else if([@"N2" isEqualToString:[request responseString]] ){
            
            upMessage =@"request不是Multipart类型";
        }
        
        NSLog(@"上车上传出错%@",[NSString stringWithFormat:@"ii=%d ,%@",ii,upMessage]);

        [self upFail];
        
    }
    
    
    
}



//如果图片被篡改，
-(void)upMiddle{
    
    
    if (![_driveCar.status isEqualToString:@"s"]) {
        //如果还有下车记录，是否结束，由下车记录去处理
        [self updata_Down];
    }
    else if(ii==0){//如果是最后一条记录，并且没有下车记录
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[_driveCar class]];
            
            [self.tableVeiw reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"自动上传结束-图片"];
        });
    }
    else{// 如果没有下车记录，但不是最后一条
        ii--;
        self.driveCar=[_youwangArray objectAtIndex:ii];
        [self updata_Up];
        
    }
}

-(void)up{
    
    
    if (![_driveCar.status isEqualToString:@"s"]) {
        //如果还有下车记录，是否结束，由下车记录去处理
        [self updata_Down];
    }
    else if(ii==0){//如果是最后一条记录，并且没有下车记录
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[_driveCar class]];
            
            [self.tableVeiw reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"自动上传成功"];
        });
    }
    else{// 如果没有下车记录，但不是最后一条
        ii--;
        self.driveCar=[_youwangArray objectAtIndex:ii];
        [self updata_Up];
        
    }
}


-(void)upFail{
    
    
  if(ii==0){//如果是最后一条记录
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[_driveCar class]];
            
            [self.tableVeiw reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"自动上传完成"];
        });
    }
    else{// 如果不是最后一条
        ii--;
        self.driveCar=[_youwangArray objectAtIndex:ii];
        [self updata_Up];
        
    }
}





- (void)uploadRequestFailed_Up:(ASIHTTPRequest *)request{
    
    
    upMessage=@"上车上传失败";
    
    NSLog(@"上车上传失败,time=%@\n",[self getTime]);
    

    
    singleUpFalse=true;
    
    [self upFail];

    
}



- (void)uploadRequestFinished_Down:(ASIHTTPRequest *)request{
    
    NSLog(@"下车结束 ii=%d,time=%@",ii,[self getTime]);
    
    if([@"Y" isEqualToString:[request responseString]] )
        
    {
        
        downMessage=@"下车上传成功.";

        [self down];

        
        
        
    }
    else {
        if([@"N1" isEqualToString:[request responseString]] ){
            
            downMessage =@"参数不完整";
        }
        else if([@"N2" isEqualToString:[request responseString]] ){
            
            downMessage =@"request不是Multipart类型";
        }
        else if([@"N3" isEqualToString:[request responseString]] ){
            
            downMessage =@"没有上车信息";
        }
        else if([@"N4" isEqualToString:[request responseString]] ){
            
            downMessage =@"下车上传成功";

            [self down];


            
        }
        

        singleUpFalse=true;
        
        NSLog(@"下车上传出错%@",[NSString stringWithFormat:@"ii=%d ,%@",ii,downMessage]);

        
         [self downFail];
        
        
    }
    

    
}


//下车图片发生篡改

-(void)downMiddle{
    
    
    if(ii==0){//如果是最后一条记录
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[_driveCar class]];
            [self.tableVeiw reloadData];
            
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"自动上传结束-图片"];
        });
    }
    else{// 不是最后一条
        ii--;
        self.driveCar=[_youwangArray objectAtIndex:ii];
        [self updata_Up];
        
    }
}

-(void)down{
    
    _driveCar.submitStatus=@"true";
    [[Util getUsingLKDBHelper] insertToDB:_driveCar ];
    
    if(ii==0){//如果是最后一条记录
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[_driveCar class]];
            
            [self.tableVeiw reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"自动上传成功"];
        });
    }
    else{// 不是最后一条
        ii--;
        self.driveCar=[_youwangArray objectAtIndex:ii];
        [self updata_Up];
        
    }
}


-(void)downFail{
    
    if(ii==0){//如果是最后一条记录
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[_driveCar class]];
            
            [self.tableVeiw reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"自动上传完成"];
        });
    }
    else{// 不是最后一条
        ii--;
        self.driveCar=[_youwangArray objectAtIndex:ii];
        [self updata_Up];
        
    }
}


- (void)uploadRequestFailed_Down:(ASIHTTPRequest *)request{
    
    
    

    
    
    
    downMessage=@"下车上传失败";
    
    singleUpFalse=true;
    NSLog(@"下车上传失败，time=%@\n",[self getTime]);
    
    [self downFail];

    
    
    
}






- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    const CGFloat W = self.view.bounds.size.width;
    _btn3.frame = CGRectMake(W - 105, 12, 100, 50);
    
    
    
    CGRect tableFrame=self.view.frame;
    tableFrame.origin.y=250;
    tableFrame.size.height=250;
//    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    [self.view addSubview:self.tableView];
//    self.tableView.backgroundColor=[UIColor greenColor];
//    
    
    
}

#pragma mark - private

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    // 设置成为当前正在使用的context
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


#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[GlobalCounter getInstance] add:@"get height"];
//    
//    //只创建一个cell用作测量高度
//    static MyCell *cell = nil;
//    
//    if (!cell)
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyCell"];
//    
//    [self loadCellContent:cell indexPath:indexPath];
//    return [self getCellHeight:cell];
    return 65;
    
}

- (CGFloat)getCellHeight:(UITableViewCell*)cell
{
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (DriverCarListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"DriverCarListTableViewCell";
    DriverCarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
  //      cell = [[DriverCarListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DriverCarListTableViewCell" owner:self options:nil];
        cell =  [nib objectAtIndex:0];
        cell.backgroundColor=blueColor;
        
        

    }
    
    DriveCar *driverCar=self.dataArray[indexPath.row];


    
    if ([@"s" isEqualToString:driverCar.status]) {
        cell.driveInfoLabel.text =[NSString stringWithFormat:@"从%@\n驾驶%@\n正在行驶",driverCar.timeUp,driverCar.licpn];
    }
    else{

        NSString *gongli=[NSString stringWithFormat:@"%.2f", [driverCar.mileDown floatValue]-[driverCar.mileUp floatValue]];
 
        cell.driveInfoLabel.text =[NSString stringWithFormat:@"从%@\n至%@\n驾驶%@\n已经行驶%@公里",driverCar.timeUp,driverCar.timeDown,driverCar.licpn, gongli];
        
    }
    
    cell.submitStatusLabel.text=@"已结束";
    
    //NSLog(@"列表显示时 driverCar.submitStatus======%@",driverCar.submitStatus);

    if (![driverCar.submitStatus isEqualToString:@"true"]) {
        cell.submitStatusLabel.text=@"提交";
    }
 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    DriverCarShowViewController *driverCarShow=[[DriverCarShowViewController alloc]init];
    driverCarShow.driverCar=self.dataArray[indexPath.row];
    [self.navigationController pushViewController:driverCarShow animated:YES];
    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"确定删除吗" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
//    
//    [alert show];
    
    
}

//#pragma mark - UIAlertViewDelegate
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    switch (buttonIndex) {
//        case 0:
//            [[Util getUsingLKDBHelper] deleteToDB:_driverCar];
//            _dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:@"select * from @t" toClass:[DriveCar class]];
//            [self.tableVeiw reloadData];
//            break;
//        case 1:
//            break;
//        default:
//            break;
//    }
//    
//    
//}

#pragma  mark -touch down
- (IBAction)showDriveCar_TouchDown:(id)sender {
    //NSLog(@"%@", sender);
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:[[DriverCarEditViewController alloc]init] animated:YES];
}

#pragma mark - showMenu

- (void)showMenu:(UIBarButtonItem *)sender
{
    
    UIImage *originalImage= [UIImage imageNamed:@"menu_item_mgr_icon"];
    UIImage *originalImage1= [UIImage imageNamed:@"menu_item_cost_icon"];
    UIImage *originalImage2= [UIImage imageNamed:@"menu_item_sync_icon"];
    UIImage *originalImage3= [UIImage imageNamed:@"menu_item_about_icon"];
    
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
                     image: [UIImage imageWithCGImage:[originalImage CGImage]
                                                scale:(originalImage.scale *3)
                                          orientation:(originalImage.imageOrientation)]
       
                    target:self
                    action:@selector(showCarsList:)],
      
      [KxMenuItem menuItem:@"过停费管理"
                     image:[UIImage imageWithCGImage:[originalImage1 CGImage]
                                               scale:(originalImage1.scale *3)
                                         orientation:(originalImage1.imageOrientation)]
                    target:self
                    action:@selector(showCarSpendList:)],
      
      [KxMenuItem menuItem:@"数据同步"
                     image:[UIImage imageWithCGImage:[originalImage2 CGImage]
                                               scale:(originalImage2.scale *3)
                                         orientation:(originalImage2.imageOrientation)]
                    target:self
                    action:@selector(syncronize:)],
      
      [KxMenuItem menuItem:@"关于软件"
                     image:[UIImage imageWithCGImage:[originalImage3 CGImage]
                                               scale:(originalImage3.scale *3)
                                         orientation:(originalImage3.imageOrientation)]
                    target:self
                    action:@selector(about:)],
      
      ];
    
//    KxMenuItem *first = menuItems[0];
//    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.alignment = NSTextAlignmentCenter;

    [KxMenu showMenuInView:self.view
                  fromRect: CGRectMake(self.view.bounds.size.width - 105, 12, 100, 50)
                 menuItems:menuItems];
}

#pragma mark - 菜单

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

- (void) syncronize:(id)sender
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    
    
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/sync.do"];
    
    [ASIHTTPRequest setDefaultTimeOutSeconds:10];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];

    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSLog(@"username=====%@\n",username);
    [request setPostValue:username forKey:@"username"];
    
   
    [request startAsynchronous];
    

}
-(void)about:(id)sender{
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:[[AboutViewController alloc]init] animated:YES];

}


#pragma mark - other
- (void) saveImageData:(NSData *)imgData withName:(NSString *)imageName
{
    
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imgData writeToFile:fullPath atomically:NO];
}


#pragma  mark -数据同步结果
- (void)uploadRequestFinished:(ASIHTTPRequest *)request{
    //[ProgressHUD dismiss];
    NSLog(@"同步下来的数据======%@",[request responseString]);
    
    
    if (![@"[]" isEqualToString:[request responseString]]) {
        NSError *error = [request error];
        assert (!error);
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
        
        BOOL success=true;
//        for (NSDictionary *dic in jsonArray)
//        {
        
//        for (int i=0; i<1; i++) {

            NSDictionary *dic =(NSDictionary *)[jsonArray objectAtIndex:0];
        
        
            DriveCar *driverCar_DownLoad=[DriveCar createWithDict:dic];
            NSURL* url = [NSURL URLWithString:[driverCar_DownLoad.photoUp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData* data_DownLoad = [NSData dataWithContentsOfURL:url];//获取网咯图片数据
            


            driverCar_DownLoad.status=@"s";
            driverCar_DownLoad.imis= [Util getUsingUDID];
            driverCar_DownLoad.reporter=[Util getUserName];
            //driverCar_DownLoad.username=[Util getUserName];
        
          //  NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where serverId='%@'",driverCar_DownLoad.serverId ]toClass:[DriveCar class]];
            
         
            //根据同步下来的数据，跟新本机数据。
            
              
            NSMutableArray * dataArray_Local = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where serverId='%@'",driverCar_DownLoad.serverId ]toClass:[DriveCar class]];
            
            //如果本机没有该记录
            if ([dataArray_Local count]==0) {
                driverCar_DownLoad.photoUp=[NSString stringWithFormat:@"%@.jpg",[Util getTimeStamp]];
                driverCar_DownLoad.md5Up=[data_DownLoad MD5];
                [self saveImageData:data_DownLoad withName:driverCar_DownLoad.photoUp];
                
                success =[[Util getUsingLKDBHelper] insertToDB:driverCar_DownLoad];
                NSMutableArray * dataArray_Temp = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where serverId='%@'",driverCar_DownLoad.serverId ]toClass:[DriveCar class]];
                driverCar_DownLoad=(DriveCar *)[dataArray_Temp objectAtIndex:0];//得到id
                

                
                
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)driverCar_DownLoad.rowid] forKey:@"id"];
                
            
                _dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];
                [_tableVeiw reloadData];


            }
            else{
            
                //从服务器更新下来的数据，是最新的，除了图片。
                DriveCar * driverCarOld=(DriveCar *)[dataArray_Local objectAtIndex:0];
                driverCarOld.mileUp=driverCar_DownLoad.mileUp;
                
                //如果是第二个手机操作同步，需要把图片存一下。
                driverCarOld.photoUp=[NSString stringWithFormat:@"%@.jpg",[Util getTimeStamp]];
                driverCarOld.md5Up=[data_DownLoad MD5];
                [self saveImageData:data_DownLoad withName:driverCarOld.photoUp];

                
                success =[[Util getUsingLKDBHelper] insertToDB:driverCarOld];
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)driverCarOld.rowid] forKey:@"id"];


            }
            
            _upDown_Car_Button.titleLabel.text=@"下车";

            

            
            

            
            
           
            
//        }

        //
        
        if(!success){
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"数据同步失败"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"数据同步成功"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];;
            //self.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:@"select * from @t order by timeUp desc" toClass:[DriveCar class]];
            self.dataArray = [[Util getUsingLKDBHelper]  searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by timeUp desc",[Util getUserName] ]toClass:[DriveCar class]];
            
            [self.tableVeiw reloadData];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"没有要同步的数据"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    
    }
    [HUD hide:YES];
    

}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    
        [HUD hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:[NSString stringWithFormat:@"%@",[[request error] localizedDescription]]
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        

    
}



-(NSString *)getIdd{
    NSString *idd=[[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    
    return idd;;
}



@end
