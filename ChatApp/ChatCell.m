//
//  ChatCell.m
//  ChatApp
//
//  Created by Atif Imran on 3/13/16.
//
//

#import "ChatCell.h"

@implementation ChatCell

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.frame);
}


@end
