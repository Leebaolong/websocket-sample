//
//  ChatViewController.h
//  ChatApp
//
//  Created by Atif Imran on 3/13/16.
//
//

#import <UIKit/UIKit.h>
#import <SRWebSocket.h>

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) NSString	*username;
@property (nonatomic, retain) IBOutlet UITableView	*myTableView;
@property (nonatomic, retain) IBOutlet UITextField	*msgField;
@property (nonatomic, retain) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressView;

- (IBAction)sendMsg:(UIButton *)sender;
- (void) setupSocketNetwork;

@end
