//
//  PostCell.h
//  Instagram
//
//  Created by Rucha Patki on 7/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface PostCell : UITableViewCell


@property (weak, nonatomic) IBOutlet PFImageView *myImgView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;


@end
