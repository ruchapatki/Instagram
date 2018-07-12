//
//  PostCollectionViewCell.h
//  Instagram
//
//  Created by Rucha Patki on 7/12/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Post.h"

@interface PostCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (strong, nonatomic) Post *post;

- (void)setCell;

@end
