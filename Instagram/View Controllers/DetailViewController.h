//
//  DetailViewController.h
//  Instagram
//
//  Created by Rucha Patki on 7/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Post *post;

@end
