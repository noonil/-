//
//  LoginViewController.h
//  KxMenuExample
//
//  Created by xuming on 15/5/25.
//  Copyright (c) 2015年 Konstantin Bukreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDViewController.h"

@interface LoginViewController : HUDViewController<UITextFieldDelegate>{

    
    long long expectedLength;
    long long currentLength;
}

@property(nonatomic, strong)IBOutlet UITextField *loginNameTxt;
@property(nonatomic, strong)IBOutlet UITextField *passWordTxt;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (IBAction)userPassword_DidEndOnExit:(id)sender;
-(IBAction)login:(id)sender;
- (IBAction)fogetPassword_TouchUpInside:(id)sender;

@end
