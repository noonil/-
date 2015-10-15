//
//  CarListAddViewController.m
//  KxMenuExample
//
//  Created by xuming on 15/7/13.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import "CarListAddViewController.h"
#import "CarEditViewController.h"

@interface CarListAddViewController ()

@end

@implementation CarListAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addChildViewController:self.carListVC];
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



- (IBAction)cancelButton_TouchDown:(UIButton *)sender {
    [self willMoveToParentViewController:nil];
    [self.view.superview removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
  
    
    
}

- (IBAction)addButton_TouchDown:(id)sender {
    CarEditViewController *carEditVC=[[CarEditViewController alloc]init];
    
    carEditVC.tag=2;
    self.bkView.frame=self.navigationController.view.frame;
    self.bkView.backgroundColor=KBackGroundColor;
    [self.bkView addSubview:carEditVC.view];
    
    
    CGRect r=self.view.frame;
    r.origin.y=kHeight64;
    r.size.height=carEditVC.view.frame.size.height;
    
    [self.view addSubview:self.bkView];
    [self addChildViewController:carEditVC];
    [carEditVC didMoveToParentViewController:self];
    
    
}
@end
