//
//  LoginViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/5/25.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DriverCarListViewController.h"
#import "View+MASAdditions.h"
#import "CCLocationManager.h"


#define LoginUrl(username,pwd) [NSURL URLWithString:[[NSString stringWithFormat:@"http://222.45.43.97:9971/teamtmiles/login.do?&username=%@&password=%@",username,pwd]stringByAddingPercentEscapesUsingEncoding:FStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]]
//#define blueColor [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7]



@interface LoginViewController (){
    CGFloat offset;
    CGFloat txtButtom;

}
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *password;
@end

@implementation LoginViewController


#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
   // UIButton*checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    
   // [self.view addSubview:checkbox];
    
   // checkbox.frame=CGRectMake(60,230,20,20);
    
//    [_checkBtn setImage:[UIImage imageNamed:@"open.png"]forState:UIControlStateNormal];
//    
//    //设置正常时图片为    check_off.png
//    
//    [_checkBtn setImage:[UIImage imageNamed:@"check_icon.png"]forState:UIControlStateSelected];
//    
//    //设置点击选中状态图片为check_on.png
    
    [_checkBtn addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    
    [_checkBtn setSelected:YES];//设置按钮得状态是否为选中（可在此根据具体情况来设置按钮得初始状态）
    _checkBtn.tag=1;
    
    
    
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _username = [userDefaults stringForKey:@"username"];
    _password = [userDefaults stringForKey:@"password"];
    
    _loginNameTxt.text = _username;
    _passWordTxt.text=_password;
     _passWordTxt.secureTextEntry = YES;
    
    
    
    
    // 监听键盘的即将显示事件. UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 监听键盘即将消失的事件. UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    

//    [self startLocation];

}

-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {

    }
    else
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        
    }
    
}

- (IBAction)fogetPassword_TouchUpInside:(id)sender;
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"如果您忘记密码，可以咨询管理员重置密码"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}


#pragma mark - 实现checkboxClick方法

-(void)checkboxClick:(UIButton*)btn{
    if (_checkBtn.tag==1) {
          //在此实现不打勾时的方法
        [_checkBtn setImage:[UIImage imageNamed:@"fangkuang.png"]forState:UIControlStateSelected];
        _checkBtn.tag=0;

    }
    else{
        //在此实现打勾时的方法
        [_checkBtn setImage:[UIImage imageNamed:@"open.png"]forState:UIControlStateSelected];
        _checkBtn.tag=1;

        
        
    }
    
   // btn.selected=!btn.selected;//每次点击都改变按钮的状态
    
    if(btn.selected){
        
    }else{
        
        //在此实现打勾时的方法
        
    }
    
    //在此实现不打勾时的方法
    
}


#pragma mark - 键盘隐藏

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

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) keyboardWillShow:(NSNotification *)notify {
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

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 登陆



//- (IBAction)userPassword_DidEndOnExit:(id)sender {
//    [sender resignFirstResponder];
//}

-(IBAction)login2:(id)sender{
    

    
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:[[DriverCarListViewController alloc] init]];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
}


-(IBAction)login:(id)sender{
    
 
    if (_checkBtn.tag==1) {
        
        _username=_loginNameTxt.text;
        _password=_passWordTxt.text;
        
        //将上述数据全部存储到NSUserDefaults中
        //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
        [[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"password"];
        
        //这里建议同步存储到磁盘中，但是不是必须的
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        //将上述数据全部存储到NSUserDefaults中
        //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"password"];
        
        //这里建议同步存储到磁盘中，但是不是必须的
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }

    
    
    
    // [NSURL URLWithString:[[NSString stringWithFormat:@"http://www.xxx.com/login.php?&usr=%@&pwd=%@",loginName,password]
    //                          stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingMacChineseSimp )]];
    
    
    // 1.将网址初始化成一个OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"%@?username=%@&password=%@",
                        @"http://222.45.43.97:9971/teamtmiles/login.do", _loginNameTxt.text, _passWordTxt.text];
    // 如果网址中存在中文,进行URLEncode
    //NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingMacChineseSimp )];
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    //NSString *newUrlStr =LoginUrl(@"杨杰A",@"888888");
    
    
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:newUrlStr];
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate=self;
    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
//    [self.view addSubview:HUD];
//    HUD.delegate = self;
//   // [HUD show:YES];

//    
//    NSData *data;
//    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    if (nil==data) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//        
//    }
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    NSString *resultStr = [jsonDict valueForKey:@"result"];
//    if ([resultStr isEqualToString:@"Y"]) {
//        
//        
//        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:[[DriverCarListViewController alloc] init]];
//        AppDelegate *app = [[UIApplication sharedApplication] delegate];
//        app.window.rootViewController = nav;
//        
//    }
//    else{
//        [self showOkayCancelAlert];
//    }
//    
    
    
}



#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    expectedLength = [response expectedContentLength];
//    currentLength = 0;
 //   HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    currentLength += [data length];
//    HUD.progress = currentLength / (float)expectedLength;

//        if (nil==data) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//    
//        }
    
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *resultStr = [jsonDict valueForKey:@"result"];
        if ([resultStr isEqualToString:@"Y"]) {
            
            HUD.labelText = @"登陆成功";
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
          
            
      
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(jumpToView) userInfo:nil repeats:NO];
            

            
    
  
    
        }
        else{
           // [self showOkayCancelAlert];
            
            HUD.labelText = @"用户名或密码错误";
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
           
        }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [HUD hide:YES afterDelay:1];

    
//   	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    HUD.mode = MBProgressHUDModeCustomView;
//    [HUD hide:YES afterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   // [HUD hide:YES];
    
   HUD.labelText = @"登陆失败";
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:1];
   
}


-(void)jumpToView{
    
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:[[DriverCarListViewController alloc] init]];
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//        // Load resources for iOS 6.1 or earlier
//        self.navigationController.navigationBar.tintColor = [UIColor brownColor];
//    } else {
//        // Load resources for iOS 7 or later
//       // self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
//         [[UINavigationBar appearance]setBarTintColor:blueColor];
//    }
    nav.navigationBar.barTintColor =  blueColor;

    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
}

- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"A Short Title Is Best", nil);
    NSString *message = NSLocalizedString(@"账号或密码错误.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
       // NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       // NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    //也可以这么写
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间提示" message:dateAndTime delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
}

//#pragma mark -get/set
//-(NSString *) username{
//    if (_username==nil) {
//        _username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
//    }
//    return _username;
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
