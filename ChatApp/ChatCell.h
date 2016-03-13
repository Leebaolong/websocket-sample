//
//  ChatCell.h
//  ChatApp
//
//  Created by Atif Imran on 3/13/16.
//
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *messageView;

@end
