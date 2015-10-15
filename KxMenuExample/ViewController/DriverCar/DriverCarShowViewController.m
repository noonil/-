//
//  DriverCarShowViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/6/3.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "DriverCarShowViewController.h"
#import "DriveCar.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DriverCarListViewController.h"
#import "ProgressHUD.h"
#import "IdentifierValidator.h"
#import "MagnifyImg.h"
#import "CCLocationManager.h"
#import "NSData+MD5.h"

//#define blueColor [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1]

@interface DriverCarShowViewController (){
    NSString * upMessage;
    NSString * downMessage;
    NSString * status;
    BOOL isFullScreen;
    CGRect orginalFrameUPImg;
    CGRect orginalFrameDownImg;

}
@property (nonatomic,strong)NSString *location;

@end

@implementation DriverCarShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    UIImage *mm=[self scaleToSize:[UIImage imageNamed:@"del_pressed.png"] size:CGSizeMake(30, 30)];
    
    UIBarButtonItem *delButton = [[UIBarButtonItem alloc] initWithImage:mm style:UIBarButtonItemStylePlain target:self action:@selector(deleteRecord:)];
    
    
    self.navigationItem.rightBarButtonItem=delButton;
    
    
    
    _mailUpLabel.text=_driverCar.mileUp;
    _mailDownLabel.text=_driverCar.mileDown;
    

        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_driverCar.photoUp];
        NSData *imageData = [NSData dataWithContentsOfFile: fullPath];
        UIImage * img = [UIImage imageWithData: imageData];
        _upImgView.image=img;
    
  fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_driverCar.photoDown];
    imageData = [NSData dataWithContentsOfFile: fullPath];
    img = [UIImage imageWithData: imageData];
    _downImgView.image=img;
    
    
 
    
    upMessage=nil;
    downMessage=nil;
    orginalFrameUPImg=_upImgView.frame;
    orginalFrameDownImg=_downImgView.frame;
    
    

  
    
    
    
    
    

 



    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mm)];
    tap.delegate=self;
    _upImgView.userInteractionEnabled = YES;
    [self.upImgView addGestureRecognizer:tap];
    
    
    if ([_driverCar.status isEqualToString:@"s"]) {
        _modifyDownBtn.enabled=NO;
    }
    
    if (![_driverCar.status isEqualToString:@"s"]) {
    UITapGestureRecognizer *tapb  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nn)];
    tapb.delegate=self;
    _downImgView.userInteractionEnabled = YES;
    [self.downImgView addGestureRecognizer:tapb];
    }
    

    

    
    //如果是第二个手机，数据同步下来得数据，是没有经纬度的。那么再获取一次经纬度。
    if (_driverCar.locationUp==nil) {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            self.location =[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
            _driverCar.locationUp=_location;
            _driverCar.locationDown=_location;
            
        }];
    }

    
    

}
- (void)mm
{
    
    [MagnifyImg showImage:_upImgView];//调用方法
    
}

- (void)nn
{
    
    [MagnifyImg showImage:_downImgView];//调用方法
    
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


#pragma mark - 删除
-(void)deleteRecord:(id)sender{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
  //  HUD.delegate = self;

    
    //_tag=@"delete";
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/deleteTmtlesById.do"];
    
   // [ASIHTTPRequest setDefaultTimeOutSeconds:30];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    
    
    
    [request setPostValue:[NSString stringWithFormat:@"%@",_driverCar.serverId] forKey:@"id"];
    NSLog(@"delete serverId=%@\n",_driverCar.serverId);

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
        [HUD show:YES];
}

#pragma mark-  删除结果


-(void)delete{
    [[Util getUsingLKDBHelper] deleteToDB:_driverCar];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    DriverCarListViewController *rootViewController = [viewControllers objectAtIndex:0];
    //rootViewController.dataArray=[[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t  order by rowid desc" ] toClass:[DriveCar class]];
    rootViewController.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];
    
    [rootViewController.tableVeiw reloadData];
    
    
    //判断是否删得是单条记录
    if (_driverCar.mileDown ==nil) {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"id"];
    }
    
    
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{

    [self delete];
    
    
    NSString *delegateMessage=nil;
    if([@"Y" isEqualToString:[request responseString]] )
    {
        delegateMessage=@"删除成功.";
    }
    
    else {
        if([@"N1" isEqualToString:[request responseString]] ){
            
            delegateMessage =@"删除成功";//@"参数不完整";
        }
        else if([@"N2" isEqualToString:[request responseString]] ){
            
            delegateMessage =@"删除成功.";//@"这条信息完整，服务器端不能删除";
        }
        else if([@"N3" isEqualToString:[request responseString]] ){
            
            delegateMessage =@"删除成功";//@"没有上车信息";
        }
        
        else if([@"N4" isEqualToString:[request responseString]] ){
            
            delegateMessage =@"删除成功";//@"服务器端删除异常";
        }
        
    }
    
    HUD.labelText =delegateMessage;
    
    [self hidHUD];
    
    
    

    
    
    
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    [self delete];
    
    
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText =@"服务器端删除失败";
    [HUD hide:YES afterDelay:2];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(jumpToView) userInfo:nil repeats:NO];
    
    
    
    
}


//#pragma mark - 放大图片
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//
//
//         for (UITouch *touch in touches) {
//               NSLog(@"touch====%@", touch);
//           }
//    NSLog(@"_upImgView=====%@",_upImgView);
//    isFullScreen = !isFullScreen;
//    UIImageView *imageView=self.upImgView;
//    UITouch *touch = [touches anyObject];
//
//    CGPoint touchPoint = [touch locationInView:self.view];
//
//    CGPoint imagePoint = imageView.frame.origin;
//    //touchPoint.x ，touchPoint.y 就是触点的坐标
//
//    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
//    if(imagePoint.x <= touchPoint.x && imagePoint.x +imageView.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+imageView.frame.size.height >= touchPoint.y)
//    {
//        // 设置图片放大动画
//        [UIView beginAnimations:nil context:nil];
//        // 动画时间
//        [UIView setAnimationDuration:1];
//
//        if (isFullScreen) {
//            // 放大尺寸
//
//            imageView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height*2.8/4);
//        }
//        else {
//            // 缩小尺寸
//            imageView.frame = orginalFrameUPImg;
//        }
//
//        // commit动画
//        [UIView commitAnimations];
//
//    }
//
//
//
//}

#pragma mark - 数据上传

-(BOOL)isImgChanged:(NSData *)imgData md5:(NSString *)md5{
    

    NSString *md5_o=[imgData MD5];
//    NSLog(@"从新上传md5=%@\n",md5);
//    NSLog(@"从新上传图片md5=%@\n",md5_o);
    
    if ([md5_o isEqualToString:md5]) {
        return true;
    }
    else
        return false;
   // return [md5_o isEqualToString:md5];

}

- (IBAction)modifyUpCar_:(id)sender {
}

- (IBAction)upLoad_TouchDown:(id)sender {

    
    
    HUD = [MBProgressHUD  showHUDAddedTo:self.navigationController.view animated:YES] ;
  //  [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
    
  //  [HUD show:YES];
    
  //  HUD.delegate=self;

    
    self.location=nil;
    

    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self updata_Up];
    }
    );
    
}

-(void)updata_Up{
    if (_driverCar.locationUp==nil ) {
        
 
        HUD.labelText=@"经纬度没有获取到，请点击提交重试。";
        [self hidHUD];

    }


    
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_driverCar.photoUp];
    NSData * imageData = [NSData dataWithContentsOfFile: fullPath];
    
     NSString *md5_o=[imageData MD5];
    if (![md5_o isEqualToString:_driverCar.md5Up]) {
       
   

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"上车图片被篡改，不能提交"];
        });
        
        


    }
    else{
    
    
    
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/input.do"];
    
   // [ASIHTTPRequest setDefaultTimeOutSeconds:30];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    
    

    
    [request setPostValue:_driverCar.licpn forKey:@"licpn"];
    [request setPostValue:_driverCar.driver forKey:@"driver"];
    [request setPostValue:_driverCar.driver_phone forKey:@"driver_phone"];
    [request setPostValue:_driverCar.mileUp forKey:@"miles"];
    [request setPostValue:_driverCar.locationUp forKey:@"location"];
    [request setPostValue:_driverCar.timeUp forKey:@"time"];
    [request setPostValue:_driverCar.reporter forKey:@"reporter"];
    [request setPostValue:@"s" forKey:@"status"];
    [request setPostValue:_driverCar.imis forKey:@"imis"];
    [request setPostValue:_driverCar.photoUp forKey:@"photo"];
    [request setPostValue:_driverCar.serverId forKey:@"id"];
    [request setPostValue:_driverCar.memo forKey:@"memo"];
    [request setPostValue:@"N" forKey:@"isLocalTime"];
    
    
    
    [request setData:imageData withFileName:_driverCar.photoUp andContentType:@"image/png" forKey:@"file"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished_Up:)];
    [request setDidFailSelector:@selector(uploadRequestFailed_Up:)];
    
    NSLog(@"修改上车 ===\n licpn=%@\n driver=%@\n driver_phone=%@\n miles=%@\n location=%@\n time=%@\n reporter=%@\n status=%@\n imis=%@\n photo=%@\n serverId=%@\n memo=%@\n isLocalTime=%@\n ",_driverCar.licpn,_driverCar.driver,_driverCar.driver_phone,_driverCar.mileUp,_driverCar.locationUp,_driverCar.timeUp,_driverCar.reporter,_driverCar.status,_driverCar.imis,_driverCar.photoUp,_driverCar.serverId,_driverCar.memoUp,_driverCar.isLocalTime);
    
    
    [request startSynchronous];
    
    }
    
}

-(void)updata_Down{

    
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_driverCar.photoDown];
    NSData * imageData = [NSData dataWithContentsOfFile: fullPath];
    
    if (![self isImgChanged:imageData md5:_driverCar.md5Down]) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showAlert:@"下车图片被篡改，不能提交"];
        });
//        
//        [self showAlert:@"下车图片被篡改，不能提交"];
//        
//        [HUD hide:YES];
//        HUD=nil;
        

    }
    else{

    
    
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/input.do"];
    
   // [ASIHTTPRequest setDefaultTimeOutSeconds:30];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    
    
    [request setUseKeychainPersistence:YES];
    //上传下车数据
    [request setPostValue:_driverCar.licpn forKey:@"licpn"];
    [request setPostValue:_driverCar.driver forKey:@"driver"];
    [request setPostValue:_driverCar.driver_phone forKey:@"driver_phone"];
    [request setPostValue:_driverCar.mileDown forKey:@"miles"];
    [request setPostValue:_driverCar.locationDown forKey:@"location"];
    [request setPostValue:_driverCar.timeDown forKey:@"time"];
    [request setPostValue:_driverCar.reporter forKey:@"reporter"];
    [request setPostValue:@"e" forKey:@"status"];
    [request setPostValue:_driverCar.imis forKey:@"imis"];
    [request setPostValue:_driverCar.photoDown forKey:@"photo"];
    [request setPostValue:_driverCar.serverId forKey:@"id"];
    [request setPostValue:_driverCar.memoDown forKey:@"memo"];
    [request setPostValue:@"N" forKey:@"isLocalTime"];
    
    
    [request setData:imageData withFileName:_driverCar.photoDown andContentType:@"image/png" forKey:@"file"];
        [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished_Down:)];
    [request setDidFailSelector:@selector(uploadRequestFailed_Down:)];
    
    NSLog(@"修改下车===\n licpn=%@\n driver=%@\n driver_phone=%@\n miles=%@\n location=%@\n time=%@\n reporter=%@\n status=%@\n imis=%@\n photo=%@\n serverId=%@\n memo=%@\n isLocalTime=%@\n ",_driverCar.licpn,_driverCar.driver,_driverCar.driver_phone,_driverCar.mileDown,_driverCar.locationDown,_driverCar.timeDown,_driverCar.reporter,_driverCar.status,_driverCar.imis,_driverCar.photoDown,_driverCar.serverId,_driverCar.memoDown,_driverCar.isLocalTime);
    
    [request startAsynchronous];
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
    
//    [HUD hide:YES ];
//    [self jumpToView];
    
    
}



-(void)jumpToView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)uploadRequestFinished_Up:(ASIHTTPRequest *)request{
    

        
        
        if([@"Y" isEqualToString:[request responseString]] )
            
        {

            upMessage=@"上车上传成功";
            

          
            if (![_driverCar.status isEqualToString:@"s"]) {
                [self updata_Down];
            }
            
            
        }
        else if([@"N4" isEqualToString:[request responseString]] ){
            
            //upMessage =@"服务器端插入异常"; 、、一般是插入的id违法了唯一性。
            upMessage =@"上车上传成功";
            
            if (![_driverCar.status isEqualToString:@"s"]) {
                [self updata_Down];
            }
            else{
            
//                [self showAlert:upMessage];
//                [self jumpToView];
                
                HUD.labelText=upMessage;
                [self hidHUD];
            }
        }
    
        else{
            if([@"N1" isEqualToString:[request responseString]] ){
                
                upMessage =@"参数不完整";
            }
            else if([@"N2" isEqualToString:[request responseString]] ){
                
                upMessage =@"request不是Multipart类型";
            }
            
            

            
//            [self showAlert:upMessage];
//            [self jumpToView];
            HUD.labelText=upMessage;
            [self hidHUD];

            
        }
    

    
}




- (void)uploadRequestFailed_Up:(ASIHTTPRequest *)request{
    

 
        upMessage=@"上车上传失败";
        HUD.labelText =upMessage;

        [self hidHUD];

    
    
}



- (void)uploadRequestFinished_Down:(ASIHTTPRequest *)request{
   
    
    
    if([@"Y" isEqualToString:[request responseString]] )
        
    {
        
        downMessage=@"下车上传成功.";
  
        
        
        
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
            
            //downMessage =@"服务器端插入异常"; 、、一般是插入的id违法了唯一性。
            downMessage =@"下车上传成功";
        }
        
        
        
        
        
    }

    if([downMessage isEqualToString:@"下车上传成功."]){
        _driverCar.submitStatus=@"true";
        
         BOOL success =[[Util getUsingLKDBHelper] insertToDB:_driverCar];
        if(!success){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"更新上传状态失败。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];;
        }
        else{
            NSArray *viewControllers = self.navigationController.viewControllers;
            DriverCarListViewController *rootViewController = [viewControllers objectAtIndex:0];
            
            //rootViewController.dataArray=[[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t  order by rowid desc" ] toClass:[DriveCar class]];
            rootViewController.dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc",[Util getUserName] ]toClass:[DriveCar class]];
            
            [rootViewController.tableVeiw reloadData];
        
        }
    
    }
    
    HUD.labelText=[NSString stringWithFormat:@"%@,%@",upMessage,downMessage];
    [self hidHUD];

  
}


- (void)uploadRequestFailed_Down:(ASIHTTPRequest *)request{
    
    


    
    

    
    downMessage=@"下车上传失败";
    HUD.labelText=[NSString stringWithFormat:@"%@,%@",upMessage,downMessage];
    [self hidHUD];
    


    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 键盘隐藏





- (IBAction)modifyMilesTxt_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}


#pragma mark - 数据修改



//是否小数位<=2
//-(BOOL)isInsideTwo:(NSString *)miles{
//    NSRange range;
//    range = [miles rangeOfString:@"."];
//    NSUInteger xiaoshuCount=[miles length]-range.location-1;
//    if (range.location!=NSNotFound && xiaoshuCount>2) {
//        return false;
//    }
//    else
//        return true;
//}

-(void)loadModifyView{
    //NSLog(@"orgin=%@,size=%@",NSStringFromCGPoint(_modifyView.frame.origin), NSStringFromCGSize(_modifyView.frame.size));

    [[NSBundle mainBundle] loadNibNamed:@"ModifyView" owner:self options:nil];
    //NSLog(@"orgin2=%@,size2=%@",NSStringFromCGPoint(_modifyView.frame.origin), NSStringFromCGSize(_modifyView.frame.size));
    
    if ([status isEqualToString:@"s"]) {
        _mileLabel.text=@"上车里程";

    }
    else{
        _mileLabel.text=@"下车里程";
    }
    
    //添加隐藏按钮done http://blog.csdn.net/kylinbl/article/details/6694897
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, kTopBarHeight30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard:)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton,nil];
    
    [topView setItems:buttonsArray];
    [_modifyMilesTxt setInputAccessoryView:topView];
    _modifyMilesTxt.keyboardType=UIKeyboardTypeDecimalPad;
    
    
    
    

    _modifyView.backgroundColor=blueColor;
    CGRect r = _modifyView.frame;
    r.origin.x=self.view.frame.size.width/2-r.size.width/2;
    r.origin.y += 80;
    
    _modifyView.frame = r;
    
     UIWindow * window = [UIApplication sharedApplication].keyWindow ;
    [self.bkView addSubview:_modifyView];
     [window addSubview:self.bkView];
    
   // [self.view addSubview:_modifyView];
}

-(void)dismissKeyBoard:(id)sender
{
        [_modifyMilesTxt resignFirstResponder];
        

}

- (IBAction)modifyUpCar_TouchUpInside:(id)sender{
    status=@"s";
    //_mileLabel.text=@"上车里程";
    [self loadModifyView];
}



- (IBAction)modifyDownCar_TouchUpInside:(id)sender{
    status=@"e";
   // _mileLabel.text=@"下车里程";
    [self loadModifyView];
}


- (IBAction)submitModify_TouchUpInside:(id)sender{
    
    
    [_modifyMilesTxt resignFirstResponder];
    
    
    
    if (![IdentifierValidator isFloat:_modifyMilesTxt.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"公里数应填数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    if(![IdentifierValidator isInsideTwo:_modifyMilesTxt.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"公里数小数位最多两位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    };
    
    
    if([_modifyMilesTxt.text floatValue]>100000){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"公里数应<=10万" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    };
    
    
    
    // NSLog(@"status=%@,_modifyMilesTxt.text=%@,_mailUpLabel.text=%@,_mailDownLabel.text=%@",status,_modifyMilesTxt.text,_mailUpLabel.text,_mailDownLabel.text);
    
    if ([@"s"isEqualToString:status]&& _mailDownLabel.text != NULL && ([_modifyMilesTxt.text floatValue]>[_mailDownLabel.text floatValue])) {
        // NSLog(@"status=%@,_modifyMilesTxt.text=%@,_mailDownLabel.text=%@",status,_modifyMilesTxt.text,_mailDownLabel.text);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上车公里应<=下车公里" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else if ([@"e"isEqualToString:status]&& ([_modifyMilesTxt.text floatValue]<[_mailUpLabel.text floatValue])) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"下车公里应>=上车公里" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    
    
    
    {

    }
    
    
    [self uploadData:_driverCar.serverId mile:_modifyMilesTxt.text];
    
    
    

    
    
    
}

#pragma mark 修改本地数据
-(void)modifyLocalMile{
    //
    
    //NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t where rowid=%ld",(long)_driverCar.rowid ] toClass:[DriveCar class]];
    NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' and  rowid=%ld ",[Util getUserName],(long)_driverCar.rowid ]toClass:[DriveCar class]];
    
    
    _driverCar=[dataArray objectAtIndex:0 ];
    
    
    
    if ([@"s" isEqual:status]) {
        _mailUpLabel.text=_modifyMilesTxt.text;
        _driverCar.mileUp=_modifyMilesTxt.text;
    }
    else  if ([@"e" isEqual:status]) {
        _mailDownLabel.text=_modifyMilesTxt.text;
        _driverCar.mileDown=_modifyMilesTxt.text;
    }
    
    BOOL success =[[Util getUsingLKDBHelper] insertToDB:_driverCar];
    
    if(!success){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"本机更新数据失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];;
    }
    else{
        NSArray *viewControllers = self.navigationController.viewControllers;
        DriverCarListViewController *rootViewController = [viewControllers objectAtIndex:0];
        
        //rootViewController.dataArray=[[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat:@"select * from @t  order by rowid desc" ] toClass:[DriveCar class]];
        rootViewController.dataArray= [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where reporter='%@' order by rowid desc ",[Util getUserName] ]toClass:[DriveCar class]];
        
        
        [rootViewController.tableVeiw reloadData];
        
    }
}

- (IBAction)cancelModify_TouchUpInside:(id)sender {

    [self popToRootView];
}




#pragma mark - 向服务器申请修改

-(void)uploadData:(NSString *)idd  mile:(NSString *)miles{
    
  

    
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/updateInput.do"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request setStringEncoding:NSUTF8StringEncoding];

    
    
    
    [request setPostValue:idd forKey:@"uuid"];
    [request setPostValue:status forKey:@"status"];
    [request setPostValue:miles forKey:@"miles"];
    NSLog(@"修改\n serverid=%@\n status=%@\n miles=%@\n ",idd,status,miles);
    
    
   
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(modifyRequestFinished:)];
    [request setDidFailSelector:@selector(modifyRequestFailed:)];
    
    HUD=nil;
    
    HUD = [MBProgressHUD showHUDAddedTo:_modifyView animated:YES] ;
    [_modifyView addSubview:HUD];
   // HUD.delegate = self;
    [HUD show:YES];
    


    
    [request startAsynchronous];
    
}





//- (void)uploadRequestFinished:(ASIHTTPRequest *)request{
- (void)modifyRequestFinished:(ASIHTTPRequest *)request {

    

    NSString *message=nil;
    
    if([@"Y" isEqualToString:[request responseString]] )
        
    {

        [self modifyLocalMile];
        
        message=@"服务器端修改成功";
        

    }
    else if([@"N" isEqualToString:[request responseString]] ){


        message=@"经理已经审批，不能修改。";
        
        
    }
    else if([@"NS" isEqualToString:[request responseString]] ){


        message=@"没有上车信息";


    }
    else{
        message=@"可能是找不到上车信息";
    }

    HUD.labelText=message;

    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popToRootView) userInfo:nil repeats:NO];

    
    
}




- (void)modifyRequestFailed:(ASIHTTPRequest *)request {
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    
    [HUD hide:YES afterDelay:2];

    HUD.labelText = @"修改失败";
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popToRootView) userInfo:nil repeats:NO];
    
}

-(void)popToRootView{
    status=nil;
    [_modifyView removeFromSuperview];
    [self.bkView removeFromSuperview];
    
}


@end
