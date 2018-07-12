//
//  CommentCell.h
//  Instagram
//
//  Created by Rucha Patki on 7/11/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (strong, nonatomic) Post *post;
-(void) setCell;


@end
