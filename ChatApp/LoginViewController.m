//
//  LoginViewController.m
//  ChatApp
//
//  Created by Atif Imran on 3/13/16.
//
//

#import "LoginViewController.h"
#import "ChatViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (IBAction)login:(UIButton *)sender {
    [self joinChat];
}

- (void)joinChat{
    if(![self.usernameField.text isEqualToString:@""]){
        [self.usernameField resignFirstResponder];
        ChatViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatView"];
        controller.username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.usernameField.text = @"";
        self.barView.backgroundColor = [UIColor lightGrayColor];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        self.barView.backgroundColor = [UIColor redColor];
        [self.usernameField becomeFirstResponder];
    }
    self.barView.alpha = .4;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *txtField in self.view.subviews) {
        if([txtField isKindOfClass:[UITextField class]] && [txtField isFirstResponder])
            [txtField resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self joinChat];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
