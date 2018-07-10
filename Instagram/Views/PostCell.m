//
//  PostCell.m
//  Instagram
//
//  Created by Rucha Patki on 7/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) setCell {
    self.captionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    //image
    self.myImgView.file = self.post.image;
    
    NSDate *myDate = self.post.createdAt;
    NSLog(@"myDate: %@", myDate);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:myDate]];
    
    [self.myImgView loadInBackground];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
