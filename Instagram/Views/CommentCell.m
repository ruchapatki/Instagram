//
//  CommentCell.m
//  Instagram
//
//  Created by Rucha Patki on 7/11/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCell:(NSString *)caption{
    NSUInteger splitter = [caption rangeOfString:@":"].location;
    NSString *result = [caption substringWithRange:NSMakeRange(0, splitter)];

    self.usernameLabel.text = result;
    self.commentLabel.text = [caption substringWithRange:NSMakeRange(splitter + 2, caption.length - result.length - 2)];
}


@end
