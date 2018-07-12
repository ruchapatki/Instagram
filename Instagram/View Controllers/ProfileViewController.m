//
//  ProfileViewController.m
//  Instagram
//
//  Created by Rucha Patki on 7/10/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.postArray = [NSMutableArray array];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self getPosts];
    
    //gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.userImage setUserInteractionEnabled:YES];
    [self.userImage addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)didTap:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.userImage.image = editedImage;
    PFFile *userImageFile = [PFFile fileWithData: UIImageJPEGRepresentation(editedImage, 1.0)];

    //Save user's profile image
    PFUser *myself = PFUser.currentUser;
    myself[@"userImage"] = userImageFile;
    [myself saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getPosts{
    //userid is self unless there's already post passed in
    NSString *userid = @"";
    NSString *incompleteHandle = @"@";
    
    if(self.post.author == nil){
        userid = PFUser.currentUser.objectId;
        self.usernameLabel.text = [incompleteHandle stringByAppendingString:PFUser.currentUser.username];
        PFUser *myself = PFUser.currentUser;
        PFFile *imageFile = myself[@"userImage"];
        if(imageFile != nil){
            self.userImage.file = imageFile;
            [self.userImage loadInBackground];
        }
    }
    else{
        userid = self.post.author.objectId;
        self.usernameLabel.text = [incompleteHandle stringByAppendingString:self.post.author.username];
        PFUser *user = self.post.author;
        PFFile *imageFile = user[@"userImage"];
        if(imageFile != nil){
            self.userImage.file = imageFile;
            [self.userImage loadInBackground];
        }
    }
    
    PFQuery *query = [Post query];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [self.postArray removeAllObjects];
            for(PFObject *object in posts){
                PFUser *currUser = object[@"author"];
                
                if([currUser.objectId isEqualToString:userid]){
                    [self.postArray addObject:object];
                }
            }
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.postArray[indexPath.row];
    cell.post = post;
    [cell setCell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postArray.count;
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
