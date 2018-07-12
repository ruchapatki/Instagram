//
//  DetailViewController.m
//  Instagram
//
//  Created by Rucha Patki on 7/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *myImgView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLowLabel;

@property (weak, nonatomic) IBOutlet UIImageView *heartImage;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *heartTouchRecognizer;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
    
    UITapGestureRecognizer *heartTouchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHeart:)];
    [self.heartImage addGestureRecognizer:heartTouchRecognizer];
    [self.heartImage setUserInteractionEnabled:YES];
}

- (IBAction)didTapHeart:(id)sender {
    
    BOOL inArr = NO;
    for(PFUser *user in self.post.unlikedBy){
        if([self.post.author.objectId isEqualToString:user.objectId]){
            inArr = YES;
        }
    }
    if(!inArr){
        //in liked, need to unlike
        [self.post addUniqueObject:self.post.author forKey:@"unlikedBy"];
        self.heartImage.image = [UIImage imageNamed:@"favor-icon"];
    }
    else{
        //not yet liked, need to like
        [self.post addUniqueObject:self.post.author forKey:@"likedBy"];
        self.heartImage.image = [UIImage imageNamed:@"favor-icon-red"];
    }

    self.post.likeCount = @(self.post.likedBy.count - self.post.unlikedBy.count);
    [self.post saveInBackground];
    
    NSString *incompleteLikes = @" likes";
    self.likesLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:incompleteLikes];
}


- (void)setViews {
    self.captionLabel.text = self.post.caption;
    self.myImgView.file = self.post.image;
    self.usernameLabel.text = self.post.author.username;
    self.usernameLowLabel.text = self.post.author.username;
    NSString *incompleteLikes = @" likes";
    self.likesLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:incompleteLikes];
    
    //set correct heart image
    BOOL inArr = NO;
    for(PFUser *user in self.post.likedBy){
        if([self.post.author.objectId isEqualToString:user.objectId]){
            inArr = YES;
        }
    }
    if(inArr){
        self.heartImage.image = [UIImage imageNamed:@"favor-icon-red"];
    }
    else{
        self.heartImage.image = [UIImage imageNamed:@"favor-icon"];
    }
    
    
    //set timestamp
    NSDate *myDate = self.post.createdAt;
    NSLog(@"myDate: %@", myDate);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];
    self.timestampLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:myDate]];
    [self.myImgView loadInBackground];
    
    //set user image
    PFUser *user = self.post.author;
    PFFile *imageFile = user[@"userImage"];
    if(imageFile != nil){
        self.userImage.file = imageFile;
        [self.userImage loadInBackground];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
