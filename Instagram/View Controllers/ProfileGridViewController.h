//
//  ProfileGridViewController.h
//  Instagram
//
//  Created by Rucha Patki on 7/12/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "ParseUI.h"
#import "Post.h"

@interface ProfileGridViewController : UIViewController

@property (strong, nonatomic) Post *post;

@end
