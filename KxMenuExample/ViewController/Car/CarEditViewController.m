//
//  CarEditViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/5/22.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "CarsListViewController.h"
#import "CarEditViewController.h"
#import "Car.h"
#import "AppDelegate.h"
#import "IdentifierValidator.h"
#import "DriverCarEditViewController.h"
#import "CarSpendEcitViewController.h"
#import "CarListAddViewController.h"


@interface CarEditViewController ()

@end

@implementation CarEditViewController

@synthesize licpnTxt;
@synthesize driverTxt;
@synthesize driverPhoneTxt;
@synthesize submitBtn;
@synthesize cancelBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    [licpn setDelegate:self];
    

    
//    if (_car!=nil) {
//        licpnTxt.text=_car.licpn;
//        driverTxt.text=_car.driver;
//        driverPhoneTxt.text=_car.driverPhone;
//    }
    
    self.driverPhoneTxt.keyboardType=UIKeyboardTypeNumberPad;
    self.view.backgroundColor=blueColor;
}

#pragma mark - touch event

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)canelBunPressed:(id)sender
{

    
    [self willMoveToParentViewController:nil];
    [self.view.superview removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

 
}
- (IBAction)submitBunPressed:(id)sender
{

    NSString *licpn1=self.licpnTxt.text;
    NSString *driver1=self.driverTxt.text;
    NSString *driverPhone1=self.driverPhoneTxt.text;
    

    

    
    if ([licpn1 length] == 0)
    {
        [self showProgressHUDInfo:@"车牌号为空"];
        return;
    }
    
    if (![IdentifierValidator isValidateCarNo:licpn1]) {
        [self showProgressHUDInfo:@"车牌格式错误"];//[self showProgressHUDInfo:@"中文+字母(1)+数字或字母(5)格式"];
        return;
    }

    if ([driver1 isEqualToString:@""]) {
        [self showProgressHUDInfo:@"请输入开车人"];
        return;
    }
    
    if ([driverPhone1 isEqualToString:@""]) {
        [self showProgressHUDInfo:@"请输入电话"];
        return;
    }
    
    if (![IdentifierValidator isValidPhone:driverPhone1]) {
        [self showProgressHUDInfo:@"请输入正确的手机号"];
        return;
    }
    
    
   // NSString *sub1=[licpn1 substringWithRange:NSMakeRange(0,1)];
    //NSString *sub3=[licpn1 substringWithRange:NSMakeRange(2,5)];
    
    
    
    
    NSString *sub1=[licpn1 substringWithRange:NSMakeRange(0,1)];
    for (int i = 1; i<[licpn1 length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [licpn1 substringWithRange:NSMakeRange(i, 1)];
        if (![IdentifierValidator isFloat:s ]) {
            sub1= [NSString stringWithFormat:@"%@%@",sub1,[s uppercaseString]];
            
        }
        else
            sub1= [NSString stringWithFormat:@"%@%@",sub1,s ];
    }
    
    licpn1=sub1;
    
 
//    NSString  *sub2=[licpn1 substringWithRange:NSMakeRange(1,1)];
//    sub2=[sub2 uppercaseString];
//    licpn1=[NSString stringWithFormat:@"%@%@%@",sub1,sub2,sub3];
//    
    
    Car *car=[[Car alloc]init];
    car.licpn=licpn1;
    car.driver=driver1;
    car.driverPhone=driverPhone1;
    car.username=[[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    
  
    NSString *message=nil;
    
    if (_car!=nil) {
        car.rowid=_car.rowid;
        message=@"更新数据失败";

    }
    else {
        message=@"插入数据失败";

    }
    
    
    NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' and licpn='%@'",[Util getUserName],car.licpn ]toClass:[Car class]];
    
    if (_car==nil && [dataArray count]>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"车牌号已有"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    
    BOOL success =[[Util getUsingLKDBHelper] insertToDB:car];
    if(!success){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:message  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

    }
    else{
        if (_tag==1) {//如果是从carsList页面跳转过来
            
            //LKDBHelper *lkdHelper=[Util getUsingLKDBHelper];
            
            NSMutableArray * dataArray = [[Util getUsingLKDBHelper] searchWithSQL:[NSString stringWithFormat: @"select * from @t  where username='%@' order by rowid desc",[Util getUserName] ]toClass:[Car class]];
            
            CarsListViewController *carsList;

            UINavigationController *nav=(UINavigationController *)self.parentViewController;
            carsList=(CarsListViewController *)[nav.viewControllers objectAtIndex:1];
            
            carsList.dataArray=dataArray;
            [carsList.tableView reloadData];
        }
        else if(_tag==2){//如果是从上车下车页面跳转过来。
            
//            DriverCarEditViewController *driverCarEdit;
//            driverCarEdit=(DriverCarEditViewController *)self.parentViewController;
//            
//            for (UIView* next = [self.view superview]; next; next = next.superview) {
//                
//                UIResponder *nextResponder = [next nextResponder];
//                
//                if ([nextResponder isKindOfClass:[DriverCarEditViewController  class]]) {
//                    
//                    driverCarEdit= (DriverCarEditViewController *)nextResponder;
//                    
//                    break;
//                }
//            }
//            driverCarEdit.licpnTxt.text=car.licpn;
//            driverCarEdit.car=car;
            
            DriverCarEditViewController *driverCarEdit;
            
            
            CarListAddViewController *carListAddVC;
            carListAddVC=(CarListAddViewController *)self.parentViewController;
            UINavigationController *nav=(UINavigationController *)carListAddVC.parentViewController;
            driverCarEdit=(DriverCarEditViewController *)nav.childViewControllers[1];
            
            driverCarEdit.licpnTxt.text=car.licpn;
            driverCarEdit.car=car;
            
            {
                [self canelBunPressed:sender];
                
                [carListAddVC willMoveToParentViewController:nil];
                [carListAddVC.view.superview removeFromSuperview];
                [carListAddVC.view removeFromSuperview];
                [carListAddVC removeFromParentViewController];
            }

            
            return;
            
//            LKDBHelper *lkdHelper=[Util getUsingLKDBHelper];
//            NSMutableArray * dataArray = [lkdHelper searchWithSQL:@"select * from @t order by rowid" toClass:[Car class]];
            
//            carListAddVC.carListTableView.dataArray=dataArray;
//            [carListAddVC.carListTableView.tableView reloadData];
            
        }
        else if (_tag==3){//如果是从车停费页面跳转过来
            CarSpendEcitViewController *carSpendEditVC;
            carSpendEditVC=(CarSpendEcitViewController *)self.parentViewController;
            
            
//            for (UIView *view  in carSpendEditVC.view.subviews){
//                
//                [view removeFromSuperview];
//            }
//            
            
            NSArray *arr= [[NSBundle mainBundle] loadNibNamed:@"CarSpendEcitViewController" owner:carSpendEditVC options:nil] ;
            carSpendEditVC.view=[arr objectAtIndex:0];
            carSpendEditVC.view.backgroundColor=blueColor;
            carSpendEditVC.licpnTxt.text=car.licpn;
            carSpendEditVC.car=car;
       
        }

    }
    
    [self canelBunPressed:sender];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -键盘响应

- (void) keyboardWillShow:(NSNotification *)notify {
    //这里只写了关键代码，细节根据自己的情况来定，sv为弹出键盘的视图，UITextField
    
    CGFloat kbHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;//获取键盘高度，在不同设备上，以及中英文下是不同的，很多网友的解决方案都把它定死了。
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat screenHeight = self.view.superview.bounds.size.height;
    
    CGFloat viewBottom = self.view.frame.origin.y + self.view.frame.size.height;
    if (viewBottom + kbHeight < screenHeight) return;//若键盘没有遮挡住视图则不进行整个视图上移
    
    // 键盘会盖住输入框, 要移动整个view了
    CGFloat delta = viewBottom + kbHeight - screenHeight-200 ;
    
    
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:duration];
    CGRect rect=self.view.superview.frame;
    rect.origin.y=delta;
    self.view.superview.frame =rect;
    [UIView commitAnimations];
    
    //
    //    // masonry的地方了 mas_updateConstraints 更新superView的约束，这里利用第三方库进行了重新自动布局，如果你不是自动布局，这里换成你的视图上移动画即可
    //    [superView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view.mas_top).offset(-delta);
    //    }];
    //    [UIView animateWithDuration:duration animations:^void(void){
    //        // superView来重新布局
    //        [superView layoutIfNeeded];
    //    }];
}

- (void) keyboardWillHidden:(NSNotification *)notify {//键盘消失
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //还原
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:duration];
    self.view.frame = CGRectMake(0, 50, 250, 35);
    [UIView commitAnimations];
    
    //    [superView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view.mas_top);
    //    }];
    //    [UIView animateWithDuration:duration animations:^{
    //        [superView layoutIfNeeded];
    //    }];
    //    delta = 0.0f;
}


//-(void)bachBtnClicked
//{
//    [licpn resignFirstResponder];
//}

#pragma mark -
#pragma mark UITextFieldDelegate
//开始编辑：
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

//点击return按钮所做的动作：
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

//是否一次完全清除：
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

//编辑完成：
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (MBProgressHUD *)progressHUD
//{
//    if (!_progressHUD) {
//        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
//        _progressHUD.mode = MBProgressHUDModeIndeterminate;
//    }
//    return _progressHUD;
//}

- (void)showProgressHUDInfo:(NSString *)info
{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
    HUD.delegate=self;
    [self.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD setLabelText:info];
    [HUD show:YES];
    
    [HUD hide:YES afterDelay:2];
    
    
//    [self.view addSubview:self.progressHUD];
//    [self.progressHUD setLabelText:info];
//    [self.progressHUD show:YES];
//    [self.progressHUD hide:YES afterDelay:1];
}

@end
