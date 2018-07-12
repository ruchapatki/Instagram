//
//  PostCollectionViewCell.m
//  Instagram
//
//  Created by Rucha Patki on 7/12/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PostCollectionViewCell.h"

@implementation PostCollectionViewCell

- (void)setCell {
    
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];

}

@end
