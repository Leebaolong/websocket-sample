//
//  LoginViewController.h
//  ChatApp
//
//  Created by Atif Imran on 3/13/16.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIView *barView;

- (IBAction)login:(UIButton *)sender;

@end
