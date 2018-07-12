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

    //set gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUser:)];
    
    [self.userImageView addGestureRecognizer:tapGestureRecognizer];
    [self.userImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGestureRecognizerLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUser:)];
    [self.usernameLabel addGestureRecognizer:tapGestureRecognizerLabel];
    [self.usernameLabel setUserInteractionEnabled:YES];
}

- (IBAction)didTapUser:(id)sender {
    [self.delegate postCell:self didTapUser:self.post];
}


-(void) setCell {
    self.captionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    self.lowUsernameLabel.text = self.post.author.username;
    //post image
    self.myImgView.file = self.post.image;
    [self.myImgView loadInBackground];
    //user image
    PFUser *user = self.post.author;
    PFFile *imageFile = user[@"userImage"];
    if(imageFile != nil){
        self.userImageView.file = imageFile;
        [self.userImageView loadInBackground];
    }
    
    //make profile images circular
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height /2;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 0;
    
    
    NSDate *myDate = self.post.createdAt;
    NSLog(@"myDate: %@", myDate);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:myDate]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapGestureRecognizer:(id)sender {
}
@end
