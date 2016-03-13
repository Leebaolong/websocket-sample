//
//  ChatViewController.m
//  ChatApp
//
//  Created by Atif Imran on 3/13/16.
//
//

#import "ChatViewController.h"
#import "LoginViewController.h"
#import "ChatCell.h"

@interface ChatViewController ()

@end

@implementation ChatViewController{
    SRWebSocket *_webSocket;
    NSMutableArray *_messages;    
}

- (void)setupSocketNetwork{
    _webSocket.delegate = nil;
    [_webSocket close];
    NSString* encodedUrl = [[NSString stringWithFormat:@"https://codingtest.meedoc.com/ws?username=%@", self.username] stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]]];
    NSLog(@"websocket starting connection...");
    _webSocket.delegate = self;
    [_webSocket open];
}

- (IBAction)sendMsg:(UIButton *)sender {
    NSString *msg = [self.msgField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(![msg isEqualToString:@""]){
        [_webSocket send:msg];
        [_messages addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:msg,@"message",@"1",@"isSent", nil]];
        [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_messages.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.myTableView scrollRectToVisible:self.myTableView.tableFooterView.frame animated:YES];
        self.msgField.text = @"";
    }
}

- (void)closeChat{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Confirm logout/close chat?" delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Nevermind", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [_webSocket close];
        _webSocket = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"socket connection established");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"socket connection failed! %@", error);
    _webSocket = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops! could not connect to the chat server. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"Msg from server: %@", message);
    [_messages addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:message,@"message",@"0",@"isSent", nil]];
    [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.myTableView scrollRectToVisible:self.myTableView.tableFooterView.frame animated:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"socket connection closed for :%@",reason);
    _webSocket = nil;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = nil;
    if(_messages.count>0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
        [self configureCell:cell atRowIndexPath:indexPath];
    }
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atRowIndexPath:(NSIndexPath*)iPath{
    if([cell isKindOfClass:[ChatCell class]]){
        ChatCell *ccell = (ChatCell*)cell;
        ccell.messageView.layer.cornerRadius = 4;
        NSMutableDictionary *msgData = [_messages objectAtIndex:[iPath row]];
        if([[msgData valueForKey:@"isSent"] isEqualToString:@"1"]){
            ccell.messageView.backgroundColor = [UIColor colorWithRed:72.0/256.0 green:207.0/256.0 blue:173.0/256.0 alpha:1];
            ccell.nameLabel.textAlignment = NSTextAlignmentRight;
            ccell.messageLabel.text = [msgData valueForKey:@"message"];
            ccell.nameLabel.text = @"Me";
        }else{
            NSError *error;
            NSData *data = [[msgData objectForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            ccell.messageView.backgroundColor = [UIColor colorWithRed:246.0/256.0 green:186.0/256.0 blue:66.0/256.0 alpha:1];
            ccell.nameLabel.textAlignment = NSTextAlignmentLeft;
            ccell.messageLabel.text = [jsonDict valueForKey:@"message"];
            ccell.nameLabel.text = [jsonDict valueForKey:@"sender"];
        }
    }
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sizeChange:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    self.myTableView.estimatedRowHeight = 100;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    _messages = [[NSMutableArray alloc] init];
    [self setupSocketNetwork];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [self logOffItem];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/256.0 green:163.0/256.0 blue:226.0/256.0 alpha:1];
}

- (void)sizeChange:(NSNotification*)notif{
    [self.myTableView reloadData];
}

- (UIBarButtonItem*)logOffItem{
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeChat) forControlEvents:UIControlEventTouchUpInside];
    close.frame = CGRectMake(0,0,28,28);
    return [[UIBarButtonItem alloc] initWithCustomView:close];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.msgField resignFirstResponder];
    [self sendMsg:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
