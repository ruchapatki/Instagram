//
//  ProfileGridViewController.m
//  Instagram
//
//  Created by Rucha Patki on 7/12/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ProfileGridViewController.h"
#import "PostCollectionViewCell.h"
#import "Post.h"
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface ProfileGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberPosts;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ProfileGridViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getPosts];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.postArray = [NSMutableArray new];
    
    [self getPosts];
    
    //refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    
    
    //collection view layout, spacing
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing*(postersPerLine - 1))/postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.userImage setUserInteractionEnabled:YES];
    [self.userImage addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    Post *post = self.postArray[indexPath.item];
    cell.post = post;
    [cell setCell];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.postArray.count;
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
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
        self.userImage.layer.masksToBounds = YES;
        self.userImage.layer.borderWidth = 0;
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
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
        self.userImage.layer.masksToBounds = YES;
        self.userImage.layer.borderWidth = 0;
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
            NSString *numPosts = [NSString stringWithFormat: @"%ld", (long)self.postArray.count];
            self.numberPosts.text = numPosts;
            
            [self.refreshControl endRefreshing];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"toDetail"]){
        PostCollectionViewCell *cell = sender;
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.post = cell.post;
    }
}


@end
