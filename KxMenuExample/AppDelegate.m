//
//  AppDelegate.m
//  kxmenu
//
//  Created by Kolyvan on 17.05.13.
//  Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Car.h"
#import "User.h"
#import "DriveCar.h"
#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import  "ASIFormDataRequest.h"
#import "NSString+JSONCategories.h"
#import "Reachability.h"


@interface AppDelegate ()


@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    self.viewController = [[ViewController alloc] init];
    //    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    //    self.window.rootViewController = nav;
    //    [self.window makeKeyAndVisible];
    
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        LoginViewController *login= [[LoginViewController alloc] init];
        self.window.rootViewController = login;
        [self.window makeKeyAndVisible];
    

    
  


    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //[self upLoadSpendData];
        //[self uploadFile];
        //[self Request_POST];
       // [self createDataBase];
       // [self testSendChinese];
        
       // [self serverId];
      //  [self md5Judge];

    });
    

    
    return YES;
}



-(void)md5Judge{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"documentsDirectory%@",documentsDirectory);
//    NSFileManager *fileManage = [NSFileManager defaultManager];
//    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"1436191386"];
//    NSArray *file = [fileManage subpathsOfDirectoryAtPath: myDirectory error:nil];
//    NSLog(@"md===========%@",file);
//    NSArray *files = [fileManage subpathsAtPath: myDirectory ];
//    NSLog(@"md2===========%@",files);
    
    
//
//    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"1436191386.jpg"];
//    NSData * imageData = [NSData dataWithContentsOfFile: fullPath];
//    //   _pressImgData = UIImageJPEGRepresentation(orangeImg2, 0.1);
//    NSString * md5=[Util md5FromData:imageData];
//    NSLog(@"md1======%@\n",md5);
//    
//    NSString * fullPath2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"1436192287.jpg"];
//    NSData * imageData2 = [NSData dataWithContentsOfFile: fullPath2];
//    //   _pressImgData = UIImageJPEGRepresentation(orangeImg2, 0.1);
//    NSString * md52=[Util md5FromData:imageData2];
//    NSLog(@"md2======%@\n",md52);
    
}


-(void)serverId
{


    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] ];
    NSLog(@"timeSp======:%@",timeSp); //时间戳的值
}
-(void)testSendChinese{
NSURL *url = [NSURL URLWithString: @"http://www.javaxp.net/assistant/request.jsp"];
 //   NSURL *url = [NSURL URLWithString: @" http://www.javaxp.net/assistant/request.jsp?a=%E4%B8%AD%E6%96%87"];

ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
[request setShouldAttemptPersistentConnection:NO];
[request setTimeOutSeconds:10];
[request setStringEncoding:NSUTF8StringEncoding];



//NSString *driverUtf8=[[NSString alloc] initWithData:[driCar.driver dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
//NSString *licpnUtf8=[[NSString alloc] initWithData:[driCar.licpn dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
//NSString *reporterUtf8=[[NSString alloc] initWithData:[driCar.reporter dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
NSString *memoUtf8=[[NSString alloc] initWithData:[@"西瓜" dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];


NSString *string = [NSString stringWithCString:[@"南瓜" UTF8String] encoding:NSUTF8StringEncoding];

[request setPostValue:memoUtf8 forKey:@"name"];

//NSLog(@"\n licpn=%@\n driver=%@\n driver_phone=%@\n miles=%@\n location=%@\n time=%@\n reporter=%@\n status=%@\n imis=%@\n photo=%@\n id=%@\n memo=%@\n isLocalTime=%@\n ",driCar.licpn,driCar.driver,driCar.driver_phone,driCar.mile,location,driCar.time,driCar.reporter,driCar.status,driCar.imis,driCar.photo,[NSString stringWithFormat:@"%ld",(long)driCar.rowid],driCar.memo,driCar.isLocalTime);


[request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFinished:)];

[request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    //[ProgressHUD dismiss];
    
    NSString * message=nil;
    
    
    if([@"Y" isEqualToString:[request responseString]] )
        
    {
        
        message=@"上传成功.";
        
        
        
        
    }
    else {
        if([@"N1" isEqualToString:[request responseString]] ){
            
            message =@"参数不完整";
        }

        
    }
    

    
}


//- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    
    int i;
    
    
}



-(void)upLoadSpendData{
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/miscExpense.do"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    //if you have your site secured by .htaccess
    
    [request setStringEncoding:NSUTF8StringEncoding];

    
    [request setPostValue:@"杨杰A" forKey:@"username"];
    [request setPostValue:@"1" forKey:@"expense"];
    [request setPostValue:@"苏A888888" forKey:@"licpn"];
    [request setPostValue:@"2015-05-31" forKey:@"time"];//@"2015-05-31 15:06:15"
    [request setPostValue:@"118.7715804329" forKey:@"longitude"];
    [request setPostValue:@"32.0511368085" forKey:@"latitude"];
    [request setPostValue:@"460012024007697T" forKey:@"imei"];
    
   // [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8;"];
    
    
    
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
}

-(void)uploadFile{
    NSURL *url = [NSURL URLWithString: @"http://222.45.43.97:9971/teamtmiles/input.do"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    //if you have your site secured by .htaccess
    
    NSString *time=[self getTime];

    [request setPostValue:@"苏A888888" forKey:@"licpn"];
    [request setPostValue:@"1" forKey:@"driver"];
    [request setPostValue:@"13851507753" forKey:@"driver_phone"];
    [request setPostValue:@"1" forKey:@"miles"];
    [request setPostValue:@"32.0511368085,118.7715804329" forKey:@"location"];
    [request setPostValue:@"2015-05-31 15:06:15" forKey:@"time"];
    [request setPostValue:@"1" forKey:@"reporter"];
    [request setPostValue:@"S" forKey:@"status"];
    [request setPostValue:@"460012024007697 T" forKey:@"imis"];
    [request setPostValue:@"1" forKey:@"photo"];
    [request setPostValue:@"1" forKey:@"id"];
    [request setPostValue:@"1" forKey:@"memo"];
    [request setPostValue:@"1" forKey:@"isLocalTime"];
    
//    NSString *fileName = [NSString stringWithFormat:@"ipodfile%@.jpg",self.fileID];
//    [request addPostValue:fileName forKey:@"name"];
    
    // Upload an image
    UIImage *image=[UIImage imageNamed:@"add.png"];
    NSData *imageData =  UIImagePNGRepresentation(image);
   // NSData *imageData = UIImageJPEGRepresentation([UIImage imageName:fileName])
    [request setData:imageData withFileName:@"mm.png" andContentType:@"image/png" forKey:@"file"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    
    [request startAsynchronous];
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSLog(@"Upload response %@", responseString);
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]);
}

//-----------------------------------------------------------------------------

-(void) uploadPhoto
{
    UIImage *dataImage =[UIImage imageNamed:@"add.png"];;

    [self uploadSeverWithImage:dataImage url:
                         @"http://222.45.43.97:9971/teamtmiles/input.do" fileName:@"mm" object:self selector:@selector(uploadPhotoResult) dataName:@"upload"];
     
}

-(void) uploadPhotoResult
{
    NSString *messageStr = [NSString stringWithFormat:@"上传成功!"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:messageStr
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}
-(void)uploadSeverWithImage:(UIImage *)image url:(NSString *)serverUrlAddress fileName:(NSString *) serverFileName object:(NSObject *) object_ selector:(SEL) selector_ dataName:(NSString *) dataName{
    __block NSObject *object = object_;
    __block SEL selector = selector_;
    NSString *end = @"\r\n";
    NSString  *twoHyphens = @"--";
    NSData *imgData=UIImageJPEGRepresentation(image, 0.9f);
    NSString *boundary = @"*****";
    NSURL *url_ = [[NSURL alloc]initWithString:[serverUrlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url_] ;
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [urlRequest addValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [urlRequest addValue: [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"%@%@%@", twoHyphens,boundary,end] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"%@",dataName,serverFileName,end] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: Content-Type: image/gif%@%@",end,end] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imgData]];
    [body appendData:[[NSString stringWithFormat:@"%@",end] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@%@%@%@", twoHyphens,boundary,twoHyphens,end] dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPBody:body];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init] ;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error){
        if ([data length]>0 && error==nil) {
            NSString *jsonstring=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSDictionary *resultDictionary = [jsonstring JSONValueCategorie];
            NSString *msg = [resultDictionary objectForKey:@"flag"];
            if (msg && [@"ok" isEqualToString:msg]) {
                [object performSelectorOnMainThread:selector withObject:nil waitUntilDone:YES];
            }
        }
    }];
}

//-----------------------------------------------------------------------------
- (void) Request_POST{
    
    NSString* urlString = [NSString stringWithFormat:@"http://222.45.43.97:9971/teamtmiles/input.do"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:@"1" forKey:@"licpn"];
    [request setPostValue:@"1" forKey:@"driver"];
    [request setPostValue:@"1" forKey:@"driver_phone"];
    [request setPostValue:@"1" forKey:@"miles"];
    [request setPostValue:@"1" forKey:@"location"];
    [request setPostValue:[self getTime] forKey:@"time"];
    [request setPostValue:@"1" forKey:@"reporter"];
    [request setPostValue:@"1" forKey:@"status"];
    [request setPostValue:@"1" forKey:@"imis"];
    //[request setPostValue:@"1" forKey:@"photo"];
    [request setPostValue:@"1" forKey:@"id"];
    [request setPostValue:@"1" forKey:@"memo"];
    [request setPostValue:@"1" forKey:@"isLocalTime"];
    //[request setFile: @"/Users/ben/Desktop/ben.jpg" forKey:@"photo"];
    UIImage *image=[UIImage imageNamed:@"add.png"];
    NSData *imageData =  UIImagePNGRepresentation(image);
    [request setData:imageData forKey:@"photo"];
   // [request addData:imageData withFileName:@"add.png" andContentType:@"image/png" forKey:@"photo"];


    
    [request setDelegate:self];
   // [request uploadProgressDelegate:self];
    request.showAccurateProgress=YES;
    [request setTimeOutSeconds:30.0f];//5s超时
    [request setCompletionBlock:^{
        NSLog(@"sucess");
        NSString* hexString = [request responseString];
        
        NSLog(@"%@",hexString);
        
        
    }];
    [request setFailedBlock:^{
        NSLog(@"Failed");
        NSString* hexString = [request responseString];
        
        NSLog(@"%@",hexString);
        
    }];
    
    [request startAsynchronous];
    
    
//    
//    ASIFormDataRequest_=[[ASIFormDataRequest alloc] initWithURL:url];
//        //要上传的图片
//        [ASIFormDataRequest_ setFile:stringImage forKey:@"file_pic_big"];
//        //上传结果委托
//        ASIFormDataRequest_.delegate=self;
//        isPoto=YES;
//        //上传进度委托
//        ASIFormDataRequest_.uploadProgressDelegate=self;
//        ASIFormDataRequest_.showAccurateProgress=YES;
//                                                                                                                                                                                                                                                                                                                                                     
//        //开始异步上传
//        [ASIFormDataRequest_ startSynchronous];
//        [ASIFormDataRequest_ release];
    
}

//- (void)requestFinished:(ASIFormDataRequest *)requestForm{
//    NSString *string=[requestForm responseString];
//    NSLog(@"string:%@",string);
//    NSMutableDictionary *_dic=[string json];
//    if ([[_dic objectForKey:@"status"] intValue]==1) {
//        if (isPoto==NO) {
//            //非图片上传
//        }else{
//            //图片上传
//            UtilMethod *utlMethod=[[UtilMethod alloc] init];
//            NSString *documemnt=[utlMethod documentFolderPath];
//            NSString *stringImage=[NSString stringWithFormat:@"%@%@",documemnt,@"/tmp_30.jpg"];
//            [utlMethod release];
//            //可以把30×30的图片显示到界面适当的位置上
//            
//        }
//        
//    }else{
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:[_dic objectForKey:@"info"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        
//    }
//    
//}

-(void)createDataBase
{
    LKDBHelper* globalHelper = [Util getUsingLKDBHelper];
   
    //清空表数据  clear table data
    [LKDBHelper clearTableData:[DriveCar class]];
    [LKDBHelper clearTableData:[User class]];
    [LKDBHelper clearTableData:[Car class]];
    ///删除所有表   delete all table
    [globalHelper dropAllTable];
    
//    Car *car=[[Car alloc]init];
//   // car.idd=@"car1";
//    car.licpn=@"苏A00001";
//    car.driver=@"许明";
//    car.driverPhone=@"138";
//    
//    User *user=[[User alloc]init];
//    //user.idd=@"user1";
//    user.username=@"许明oa";
//    user.password=@"123456";
//    
//    DriveCar *driverCar=[[DriveCar alloc]init];
//    //driverCar.idd=@"drivercar1";
//    driverCar.location=@"利奥";
//    driverCar.time=@"2015";
//    driverCar.status=@"s";
//    driverCar.imis=@"2334545642289545";
//    driverCar.memo=@"备注";
//
//
//    
//    BOOL success=[driverCar saveToDB] ;
//    
//    //更改主键继续插入   Insert the change after the primary key
//    //driverCar.idd = @"drivercar2";
//    //BOOL success =[globalHelper insertToDB:driverCar];
//    if(success){
//        NSLog(@"数据插入成功");
//
//    }
//    else
//        NSLog(@"数据插入失败");
//
//    //查询   search
//    NSMutableArray* searchResultArray = nil;
//    
//    NSLog(@"查询-------");
//    ///同步搜索 执行sql语句 把结果变为LKTest对象
//    ///Synchronous search executes the SQL statement put the results into a LKTest object
//    searchResultArray = [globalHelper searchWithSQL:@"select * from @t" toClass:[DriveCar class]];
//    for (id obj in searchResultArray) {
//        NSLog(@"%@",[obj printAllPropertys]);
//    }
//
//    
//    
//    
//    
    
    
    
   

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
   
    //return UIInterfaceOrientationMaskAll;
    return  UIInterfaceOrientationMaskPortrait;
    
}



-(NSString *)getTime{
    // 1.将网址初始化成一个OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"http://222.45.43.97:9971/teamtmiles/gettime.do"];
    // 如果网址中存在中文,进行URLEncode
    //NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingMacChineseSimp )];
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    //NSString *newUrlStr =LoginUrl(@"杨杰A",@"888888");
    
    
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data;
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (nil==data) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆不上了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
        
    }
    
    
    NSString* time = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return time;
    
}

@end
