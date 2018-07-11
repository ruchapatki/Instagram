//
//  PostCell.h
//  Instagram
//
//  Created by Rucha Patki on 7/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"
#import "PostCell.h"

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell


@property (weak, nonatomic) IBOutlet PFImageView *myImgView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizerLabel;

@property (nonatomic, weak) id<PostCellDelegate> delegate;

@property (strong, nonatomic) Post *post;
-(void) setCell;


@end

@protocol PostCellDelegate

- (void)postCell:(PostCell *) postCell didTapUser: (Post *)post;

@end
