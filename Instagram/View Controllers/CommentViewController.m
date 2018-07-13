//
//  CommentViewController.m
//  Instagram
//
//  Created by Rucha Patki on 7/11/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;


@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setViews];

}

- (void)setViews {
    self.usernameLabel.text = self.post.author.username;
    self.captionLabel.text = self.post.caption;
    PFUser *user = self.post.author;
    PFFile *imageFile = user[@"userImage"];
    if(imageFile != nil){
        self.userImage.file = imageFile;
        [self.userImage loadInBackground];
    }
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.username = PFUser.currentUser.username;
    [cell setCell:self.post.comments[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.post.comments.count;
}

- (IBAction)didTapPost:(id)sender {
    if([self.commentTextField.text isEqualToString:@""] == NO){
        //add comment
        NSString *myUsername = PFUser.currentUser.username;
        NSString *incomplete = [myUsername stringByAppendingString:@": "];
        [self.post addUniqueObject:[incomplete stringByAppendingString:self.commentTextField.text] forKey:@"comments"];
        [self.post saveInBackground];
        [self.tableView reloadData];
        
        self.commentTextField.text = @"";
    }
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
